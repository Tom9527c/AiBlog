import { Link } from "react-router-dom";
import { Media, pathFor } from "../../../components";
import type { Content } from "../../../types";

export function TopPost({ item }: { item: Content }) {
  return (
    <article className="recent-post-item">
      <div className="post_cover left_radius">
        <Link to={pathFor("documents", item)} title={item.title}>
          <span className="recent-post-top-text">荐</span>
          <Media className="post_bg" src={item.cover} alt={item.title} />
        </Link>
      </div>
      <div className="recent-post-info">
        <Link className="article-title" to={pathFor("documents", item)} title={item.title}>
          {item.title}
        </Link>
      </div>
    </article>
  );
}

