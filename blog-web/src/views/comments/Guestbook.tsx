import { useState } from "react";
import { useBlog } from "../../components";
import { PageShell } from "../../components/page/PageShell";
import Comments from "./Comments";
import "./guestbook.css";
export function Guestbook() {
  const { site } = useBlog();
  const [open, setOpen] = useState(false);
  return (
    <PageShell title="留言板" aside>
      <div className="guestbook-card">
        <div className={`guestbook-envelope ${open ? "is-open" : ""}`}>
          <div className="guestbook-envelope-back" aria-hidden="true" />
          <div className="guestbook-letter" id="guestbook-letter">
            <img
              className="guestbook-letter-art"
              src="https://npm.elemecdn.com/hexo-butterfly-envelope/lib/violet.jpg"
              alt=""
              onError={(e) => {
                e.currentTarget.style.display = "none";
              }}
            />
            <h2>来自{site.title || "博主"}的留言：</h2>
            <div className="guestbook-letter-message">
              <p>有什么想问的？</p>
              <p>有什么想说的？</p>
              <p>有什么想吐槽的？</p>
              <p>哪怕只是路过，也可以在这里留下足迹哦～</p>
            </div>
            <div className="guestbook-letter-decoration" aria-hidden="true">
              ✦ ─── ❦ ─── ✦
            </div>
            <p className="guestbook-letter-sign">
              每一份留言，都会被认真收藏。
            </p>
          </div>
          <div className="guestbook-envelope-front" aria-hidden="true" />
          <button
            className="guestbook-envelope-toggle"
            aria-expanded={open}
            aria-controls="guestbook-letter"
            onClick={() => setOpen(!open)}
          >
            {open ? "收起信笺" : "点击打开这封信"}{" "}
            <span aria-hidden="true">{open ? "⌄" : "♡"}</span>
          </button>
        </div>
        <Comments />
      </div>
    </PageShell>
  );
}
