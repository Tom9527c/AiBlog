import ReactMarkdown from "react-markdown";
import remarkGfm from "remark-gfm";
import { Media } from "../../../components";

export function commentUrl(value?: string) {
  return value && /^https?:\/\//i.test(value) ? value : "";
}
export function CommentBody({ body }: { body: string }) {
  return (
    <div className="comment-body">
      <ReactMarkdown
        remarkPlugins={[remarkGfm]}
        skipHtml
        components={{
          a: ({ href, children }) =>
            commentUrl(href) ? (
              <a
                href={commentUrl(href)}
                target="_blank"
                rel="nofollow ugc noopener noreferrer"
              >
                {children}
              </a>
            ) : (
              <span>{children}</span>
            ),
          img: ({ src, alt }) =>
            commentUrl(src) ? (
              <a
                href={commentUrl(src)}
                target="_blank"
                rel="nofollow ugc noopener noreferrer"
                aria-label={alt || "查看评论图片"}
              >
                <img
                  src={commentUrl(src)}
                  alt={alt || "评论图片"}
                  loading="lazy"
                  referrerPolicy="no-referrer"
                />
              </a>
            ) : /^\/blog-media\/\d+$/.test(src || "") ? (
              <Media src={src} alt={alt || "评论图片"} />
            ) : (
              <span>[图片链接无效]</span>
            ),
        }}
      >
        {body}
      </ReactMarkdown>
    </div>
  );
}
