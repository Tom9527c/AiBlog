import { useState } from "react";
import { Link } from "react-router-dom";
import { useMedia } from "../../../components/media/Media";
import type { Content, TaxonomySummary } from "../../../types";
import { tagStyle } from "../tag-color";

function TagCover({ term }: { term: TaxonomySummary }) {
  const url = useMedia(term.locked ? "" : term.cover || "");
  const [failedUrl, setFailedUrl] = useState("");
  return url && failedUrl !== url
    ? <img className="tag-cover" src={url} alt={`${term.title}封面`} loading="lazy" onError={() => setFailedUrl(url)} />
    : <i className="anzhiyufont anzhiyu-icon-hashtag" aria-hidden="true" />;
}
export function TagVisual({ term }: { term: TaxonomySummary }) {
  return <span className="tag-visual" style={tagStyle(term)}>
    <span className="tag-visual__hash" aria-hidden="true">#</span>
    <span>{term.title}</span>
  </span>;
}
export function TagBanner({ term }: { term: Content }) {
  return <header className="tag-banner" style={tagStyle(term)}>
    <div className="tag-banner__cover"><TagCover term={term} /></div>
    <div className="tag-banner__text">
      <Link to="/tags/">全部标签 ›</Link>
      <h1>{term.title}</h1>
      {term.summary && <p>{term.summary}</p>}
    </div>
  </header>;
}
