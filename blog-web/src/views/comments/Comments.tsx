import { useEffect, useRef, useState } from "react";
import { Pager, Status, useBlog, useLoad } from "../../components";
import { api } from "../../services/api";
import {
  CommentComposer,
  type CommentIdentity,
  type CommentTarget,
} from "./components/CommentComposer";
import { CommentIcon } from "./components/CommentIcon";
import { CommentRow } from "./components/CommentRow";
import { visitor, nameOf, type Comment, type CommentPage, type Target } from "./comment-model";
import "./comments.css";
export function Comments({
  targetId,
  targetKind = "documents",
  compact = false,
}: {
  targetId?: number;
  targetKind?: Target;
  compact?: boolean;
}) {
  // Remount the scope when navigating between content, so drafts/replies never cross targets.
  return (
    <CommentThread
      key={`${targetKind}:${targetId || "guestbook"}`}
      targetId={targetId}
      targetKind={targetKind}
      compact={compact}
    />
  );
}
function CommentThread({
  targetId,
  targetKind,
  compact,
}: {
  targetId?: number;
  targetKind: Target;
  compact: boolean;
}) {
  const { session, login, revision } = useBlog();
  const section = useRef<HTMLElement>(null);
  useEffect(() => {
    if (compact || window.location.hash !== '#post-comment') return;
    const frame = requestAnimationFrame(() => section.current?.scrollIntoView?.({ block: 'start' }));
    return () => cancelAnimationFrame(frame);
  }, [targetId, targetKind, compact]);
  const [page, setPage] = useState(1),
    [order, setOrder] = useState("latest");
  const state = useLoad(
    () =>
      api<CommentPage>(
        `/blog/public/comments?${new URLSearchParams({ page: String(page), pageSize: compact ? "3" : "10", order, ...(targetId ? { targetKind, targetId: String(targetId) } : {}) })}`,
        { headers: { "x-comment-visitor": visitor() } },
      ),
    [page, order, targetId, targetKind, revision, compact],
  );
  const [identity, setIdentity] = useState<CommentIdentity>({
    nickname: "",
    email: "",
    website: "",
  });
  const [reply, setReply] = useState<Comment | null>(null);
  const [drafts,setDrafts]=useState<Record<number,string>>({});
  const [notice, setNotice] = useState("");
  const target: CommentTarget = { targetKind, targetId };
  const replyTo = (comment: Comment) =>
    setReply((previous) => (previous?.id === comment.id ? null : comment));
  const renderComposer = (comment: Comment) => (
    <CommentComposer
      key={comment.id}
      target={target}
      identity={identity}
      onIdentity={setIdentity}
      draft={drafts[comment.id] || ""}
      onDraft={value=>setDrafts(previous=>({...previous,[comment.id]:value}))}
      reply={{ id: comment.id, name: nameOf(comment) }}
      onCancel={() => setReply(null)}
      onSubmitted={(message) => {
        setNotice(message);
        setReply(previous=>previous?.id===comment.id?null:previous);
      }}
    />
  );
  return (
    <section ref={section} id={compact ? `essay-comments-${targetId}` : "post-comment"} className={`blog-comments${compact ? " blog-comments-compact" : ""}`}>
      <div className="comment-section-heading">
        <h2>
          <CommentIcon name="reply" /> 评论
        </h2>
        <span>
          {session ? (
            `你好，${session.nickName || session.username}`
          ) : (
            <>
              <span title="无需登录；留言审核后公开，邮箱仅站点管理者可见。">
                匿名评论
              </span>{" "}
              <button type="button" onClick={login}>
                登录
              </button>
            </>
          )}
        </span>
      </div>
      <CommentComposer
        target={target}
        identity={identity}
        onIdentity={setIdentity}
        onSubmitted={setNotice}
      />
      {notice && (
        <p className="comment-notice" role="status">
          {notice}
        </p>
      )}
      <div className="comment-list-heading">
        <h3>{state.data?.commentCount ?? 0} 条评论</h3>
        <div>
          <select
            aria-label="评论排序"
            value={order}
            onChange={(e) => {
              setOrder(e.target.value);
              setPage(1);
            }}
          >
            <option value="latest">最新</option>
            <option value="oldest">最早</option>
            <option value="popular">热门</option>
          </select>
          <button
            type="button"
            title="刷新评论"
            aria-label="刷新评论"
            disabled={state.loading}
            onClick={state.reload}
          >
            <CommentIcon name="refresh" />
          </button>
        </div>
      </div>
      <Status loading={state.loading} />
      {state.error && (
        <div className="comment-error" role="alert">
          <p>{state.error}</p>
          <button type="button" onClick={state.reload}>
            重新加载评论
          </button>
        </div>
      )}
      {!state.loading && !state.error && !state.data?.items.length && (
        <div className="comment-empty">
          <CommentIcon name="reply" />
          <p>还没有评论，来留下第一份问候吧。</p>
        </div>
      )}
      {state.data?.items.map((item) => (
        <CommentRow
          key={item.id}
          item={compact ? { ...item, replies: item.replies?.slice(0, 1) } : item}
          onReply={replyTo}
          activeReply={reply?.id || null}
          renderComposer={renderComposer}
        />
      ))}
      {!compact && <Pager
        page={page}
        total={state.data?.total || 0}
        pageSize={10}
        onChange={setPage}
      />}
    </section>
  );
}
export default Comments;
