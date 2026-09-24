import {
Link
} from "react-router-dom";
import {
date,
Media,
Status,
useBlog,
useLoad
} from "../../../components";
import { api,safeUrl } from "../../../services/api";
import { list } from "../../../services/content";

export function Aside() {
  const { site } = useBlog();
  const stats = useLoad(() =>
    api<{
      documents: number;
      categories: number;
      tags: number;
      comments: number;
    }>("/blog/public/stats"),
  );
  const comments = useLoad(() => list("comments", { pageSize: 5 }));
  return (
    <aside id="aside-content" className="aside-content">
      <div className="card-widget card-info">
        <div className="author_top card-content">
        <div className="author-info__sayhi" id="author-info__sayhi">欢迎来访</div>
        <Link className="author-info-avatar" to="/about/" aria-label="关于本人">
          <Media src={site.avatar} alt={site.title} className="avatar-img" />
        </Link>
        <div className="author-info__description">
        <p>{site.description}</p>
        <div className="site-data">
          {[
            ["documents", "文章", "/archives/"],
            ["categories", "分类", "/categories/"],
            ["tags", "标签", "/tags/"],
          ].map(([key, label, path]) => (
            <Link key={key} to={path}>
              {label}
              <strong>{stats.data?.[key as "documents"] || 0}</strong>
            </Link>
          ))}
        </div>
        </div>
        <div className="author-info__bottom-group">
        <div className="author-info__name">{site.title}</div>
        <div className="socials card-info-social-icons">
          {site.socials?.map((s) => (
            <a
              key={s.label}
              href={safeUrl(s.url)}
              target="_blank"
              rel="noreferrer"
            >
              {s.label}
            </a>
          ))}
        </div>
        </div>
        </div>
      </div>
      <div className="card-widget">
        <h3>✦ 公告</h3>
        <p>{site.announcement || "欢迎来访，祝你阅读愉快。"}</p>
      </div>
      <div className="card-widget">
        <h3>最新评论</h3>
        <Status {...comments} empty={!comments.data?.items.length} />
        {comments.data?.items.map((c) => (
          <Link className="aside-comment" key={c.id} to="/comments/">
            {c.summary || c.title}
            <small>{date(c.createdAt)}</small>
          </Link>
        ))}
      </div>
    </aside>
  );
}
