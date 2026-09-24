import { useEffect, useRef, useState } from "react";
import { useBlog } from "../../../components";
import { api } from "../../../services/api";
import { CommentBody, commentUrl } from "./CommentBody";
import { CommentIcon } from "./CommentIcon";
export interface CommentIdentity {
  nickname: string;
  email: string;
  website: string;
}
export interface CommentTarget {
  targetId?: number;
  targetKind: "documents" | "essays" | "albums" | "about";
}
export function CommentComposer({
  target,
  identity,
  onIdentity,
  reply,
  onCancel,
  onSubmitted,
  draft, onDraft,
}: {
  draft?:string;
  onDraft?:(value:string)=>void;
  target: CommentTarget;
  identity: CommentIdentity;
  onIdentity: (value: CommentIdentity) => void;
  reply?: { id: number; name: string };
  onCancel?: () => void;
  onSubmitted: (message: string) => void;
}) {
  const { session } = useBlog();
  const [localBody, setLocalBody] = useState(""),
    [busy, setBusy] = useState(false),
    [error, setError] = useState("");
  const body=draft ?? localBody;
  const setBody=onDraft || setLocalBody;
  const [preview, setPreview] = useState(false),
    [panel, setPanel] = useState<"emoji" | "image" | null>(null),
    [imageUrl, setImageUrl] = useState("");
  const textarea = useRef<HTMLTextAreaElement>(null),
    submitting = useRef(false);
  useEffect(() => {
    if (reply) textarea.current?.focus({ preventScroll: true });
  }, [reply?.id]);
  function insert(value: string) {
    const start = textarea.current?.selectionStart ?? body.length,
      end = textarea.current?.selectionEnd ?? body.length;
    setBody((body.slice(0, start) + value + body.slice(end)).slice(0, 5000));
    setPanel(null);
    setPreview(false);
    requestAnimationFrame(() => {
      textarea.current?.focus({ preventScroll: true });
      textarea.current?.setSelectionRange(
        start + value.length,
        start + value.length,
      );
    });
  }
  return (
    <form
      className={`comment-composer${reply ? " comment-composer-inline" : ""}`}
      aria-label={reply ? `回复 ${reply.name}` : "发表评论"}
      onSubmit={async (e) => {
        e.preventDefault();
        if (submitting.current || !body.trim()) return;
        submitting.current = true;
        setBusy(true);
        setError("");
        try {
          await api("/blog/public/comments", {
            method: "POST",
            body: JSON.stringify({
              body,
              ...identity,
              ...(reply ? { parentId: reply.id } : {}),
              metadata: target.targetId ? target : {},
            }),
          });
          setBody("");
          setPreview(false);
          setPanel(null);
          onSubmitted("评论已提交，审核通过后会公开显示。");
        } catch (e) {
          setError((e as Error).message);
        } finally {
          submitting.current = false;
          setBusy(false);
        }
      }}
    >
      <div className="comment-editor">
        {preview ? (
          <div className="comment-preview">
            <CommentBody body={body || "还没有输入内容。"} />
          </div>
        ) : (
          <textarea
            ref={textarea}
            aria-label="评论内容"
            title={reply ? `回复 @${reply.name}` : "评论内容"}
            required
            maxLength={5000}
            placeholder={reply ? `回复 @${reply.name}：` : "一切向好，生活向阳"}
            value={body}
            onChange={(e) => setBody(e.target.value)}
            disabled={busy}
          />
        )}
        <div className="comment-toolbar">
          <button
            type="button"
            aria-label="插入表情"
            title="表情"
            aria-expanded={panel === "emoji"}
            disabled={busy}
            onClick={() => setPanel(panel === "emoji" ? null : "emoji")}
          >
            <CommentIcon name="smile" />
          </button>
          <button
            type="button"
            aria-label="插入图片链接"
            title="图片链接"
            aria-expanded={panel === "image"}
            disabled={busy}
            onClick={() => setPanel(panel === "image" ? null : "image")}
          >
            <CommentIcon name="image" />
          </button>
          {!!body && (
            <button
              type="button"
              className="comment-preview-toggle"
              disabled={busy}
              aria-pressed={preview}
              onClick={() => setPreview(!preview)}
            >
              {preview ? "编辑" : "预览"}
            </button>
          )}
        </div>
        <span className="comment-counter">{body.length}/5000</span>
      </div>
      {panel === "emoji" && (
        <div className="comment-emoji" aria-label="表情列表">
          {[
            "😊",
            "😄",
            "🥰",
            "😘",
            "🤔",
            "😭",
            "😂",
            "😎",
            "🥳",
            "👍",
            "❤️",
            "🎉",
            "🌸",
            "✨",
            "🍑",
            "☕",
          ].map((emoji) => (
            <button key={emoji} type="button" onClick={() => insert(emoji)}>
              {emoji}
            </button>
          ))}
        </div>
      )}
      {panel === "image" && (
        <div className="comment-image-input">
          <input
            type="url"
            aria-label="图片地址"
            placeholder="图片或 GIF 的 https:// 链接"
            value={imageUrl}
            onChange={(e) => setImageUrl(e.target.value)}
          />
          <button
            type="button"
            disabled={!commentUrl(imageUrl)}
            onClick={() => {
              insert(`![图片](<${imageUrl.replace(/[<>\n\r]/g, "")}>)`);
              setImageUrl("");
            }}
          >
            插入
          </button>
        </div>
      )}
      <div
        className={`comment-composer-bottom${session ? " is-signed-in" : ""}`}
      >
        {!session ? (
          <div className="comment-identity">
            <label>
              <span>昵称</span>
              <input
                aria-label="昵称"
                autoComplete="nickname"
                placeholder="必填"
                required
                maxLength={50}
                value={identity.nickname}
                onChange={(e) =>
                  onIdentity({ ...identity, nickname: e.target.value })
                }
                disabled={busy}
              />
            </label>
            <label>
              <span>邮箱</span>
              <input
                aria-label="邮箱（不公开）"
                autoComplete="email"
                type="email"
                placeholder="选填 · 不公开"
                maxLength={254}
                value={identity.email}
                onChange={(e) =>
                  onIdentity({ ...identity, email: e.target.value })
                }
                disabled={busy}
              />
            </label>
            <label>
              <span>网址</span>
              <input
                aria-label="个人网址"
                autoComplete="url"
                type="url"
                placeholder="选填"
                maxLength={500}
                value={identity.website}
                onChange={(e) =>
                  onIdentity({ ...identity, website: e.target.value })
                }
                disabled={busy}
              />
            </label>
          </div>
        ) : (
          <span className="comment-signed-in">
            {session.nickName || session.username} · 评论审核后公开
          </span>
        )}
        <button
          type="submit"
          className="comment-submit"
          aria-label="发送评论"
          disabled={
            busy || !body.trim() || (!session && !identity.nickname.trim())
          }
        >
          {busy ? "提交中…" : "发送"}
        </button>
      </div>
      {reply && (
        <div className="comment-cancel">
          <button type="button" disabled={busy} onClick={onCancel}>
            取消回复
          </button>
        </div>
      )}
      {error && (
        <p className="comment-error" role="alert">
          {error}
        </p>
      )}
    </form>
  );
}
