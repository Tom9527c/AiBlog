import { useState } from "react";
import { useMedia } from "../../../components/media/Media";

export function CategoryCover({ src, title }: { src?: string; title: string }) {
  const url = useMedia(src || "");
  const [failedUrl, setFailedUrl] = useState("");
  return <div className={`category-cover${!url || failedUrl === url ? " category-cover--fallback" : ""}`}>
    {url && failedUrl !== url
      ? <img src={url} alt={`${title}封面`} loading="lazy" onError={() => setFailedUrl(url)} />
      : <i className="anzhiyufont anzhiyu-icon-book" aria-hidden="true" />}
  </div>;
}
