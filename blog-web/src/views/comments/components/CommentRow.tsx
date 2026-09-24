import { useEffect, useState, type ReactNode } from "react";
import { api } from "../../../services/api";
import { useBlog } from "../../../components/context";
import { CommentAvatar } from "./CommentAvatar";
import { CommentBody, commentUrl } from "./CommentBody";
import { CommentEnvironment } from "./CommentEnvironment";
import { CommentIcon } from "./CommentIcon";
import { visitor, nameOf, type Comment } from "../comment-model";

export function CommentRow({
  item,
  onReply,
  activeReply,
  renderComposer,
}: {
  item: Comment;
  onReply: (c: Comment) => void;
  activeReply: number | null;
  renderComposer: (c: Comment) => ReactNode;
}) {
  const { notify } = useBlog();
  const [vote, setVote] = useState({
    likes: item.likes || 0,
    dislikes: item.dislikes || 0,
    myVote: item.myVote || 0,
  });
  const [busy, setBusy] = useState(false);
  useEffect(
    () =>
      setVote({
        likes: item.likes || 0,
        dislikes: item.dislikes || 0,
        myVote: item.myVote || 0,
      }),
    [item.id, item.likes, item.dislikes, item.myVote],
  );
  const meta = item.metadata;
  async function react(value: number) {
    if (busy) return;
    setBusy(true);
    try {
      setVote(
        await api(`/blog/public/comments/${item.id}/reaction`, {
          method: "POST",
          headers: { "x-comment-visitor": visitor() },
          body: JSON.stringify({ value: vote.myVote === value ? 0 : value }),
        }),
      );
    } catch (e) {
      notify((e as Error).message);
    } finally {
      setBusy(false);
    }
  }
  return (
    <article className="comment-entry" id={`comment-${item.id}`}>
      <div className="comment-avatar">
        <CommentAvatar
          src={String(meta.authorAvatar || "")}
          name={nameOf(item)}
        />
      </div>
      <div className="comment-main">
        <div className="comment-byline">
          <div className="comment-author-line">
            {commentUrl(String(meta.authorWebsite || "")) ? (
              <a
                className="comment-author"
                href={commentUrl(String(meta.authorWebsite))}
                rel="nofollow ugc noopener noreferrer"
                target="_blank"
              >
                {nameOf(item)}
              </a>
            ) : (
              <span className="comment-author">{nameOf(item)}</span>
            )}
            {meta.isOwner === true && (
              <span className="comment-owner">博主</span>
            )}
            <time dateTime={item.createdAt}>
              {item.createdAt?.slice(0, 10)}
            </time>
          </div>
          <div className="comment-actions">
            <button
              type="button"
              title="赞同"
              aria-label={`赞同 ${nameOf(item)} 的评论`}
              aria-pressed={vote.myVote === 1}
              disabled={busy}
              onClick={() => react(1)}
            >
              <CommentIcon name="up" />
              {vote.likes > 0 && <span>{vote.likes}</span>}
            </button>
            <button
              type="button"
              title="不赞同"
              aria-label={`不赞同 ${nameOf(item)} 的评论`}
              aria-pressed={vote.myVote === -1}
              disabled={busy}
              onClick={() => react(-1)}
            >
              <CommentIcon name="down" />
              {vote.dislikes > 0 && <span>{vote.dislikes}</span>}
            </button>
            <button
              type="button"
              title="回复"
              aria-label={`回复 ${nameOf(item)}`}
              onClick={() => onReply(item)}
            >
              <CommentIcon name="reply" />
              {!!item.replies?.length && <span>{item.replies.length}</span>}
            </button>
          </div>
        </div>
        {!!meta.replyToName && (
          <p className="comment-reply-to">回复 @{String(meta.replyToName)}：</p>
        )}
        <CommentBody body={item.body || ""} />
        <CommentEnvironment metadata={meta} />
        {activeReply === item.id && renderComposer(item)}
        {!!item.replies?.length && (
          <div className="comment-replies">
            {item.replies.map((reply) => (
              <CommentRow
                key={reply.id}
                item={reply}
                onReply={onReply}
                activeReply={activeReply}
                renderComposer={renderComposer}
              />
            ))}
          </div>
        )}
      </div>
    </article>
  );
}
