import { useEffect, useState } from "react";
import { mediaUrl } from "../../utils/url";
import { useBlog } from "../context";

export function useMedia(src: string) {
  const { revision } = useBlog();
  const [url, setUrl] = useState("");
  useEffect(() => {
    const c = new AbortController();
    let value = "";
    setUrl("");
    if (src)
      mediaUrl(src, c.signal)
        .then((v) => {
          value = v;
          if (!c.signal.aborted) setUrl(v);
          else if (v.startsWith("blob:")) URL.revokeObjectURL(v);
        })
        .catch(() => {});
    return () => {
      c.abort();
      if (value.startsWith("blob:")) URL.revokeObjectURL(value);
    };
  }, [src, revision]);
  return url;
}
export function Media({
  src,
  alt = "",
  className = "",
  onClick,
}: {
  src?: string;
  alt?: string;
  className?: string;
  onClick?: (url: string) => void;
}) {
  const url = useMedia(src || "");
  return url ? (
    <img
      src={url}
      alt={alt}
      className={className}
      loading="lazy"
      onClick={() => onClick?.(url)}
    />
  ) : (
    <span
      className={`media-placeholder ${className}`}
      aria-label={alt || "暂无图片"}
    >
      ✦
    </span>
  );
}
