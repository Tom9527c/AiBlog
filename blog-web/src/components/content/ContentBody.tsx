import { lazy, Suspense, useEffect, useMemo, useRef, useState } from "react";
import type { SlideImage } from "yet-another-react-lightbox";
import ReactMarkdown, { type Components } from "react-markdown";
import remarkGfm from "remark-gfm";
import DOMPurify from "dompurify";
import "../../styles/lightbox.css";
import { mediaUrl, safeUrl } from "../../utils/url";
import type { Content } from "../../types";
import { Media } from "../media/Media";
import { useBlog } from "../context";
const ImageLightbox = lazy(() => import("../media/Lightbox"));

export function ContentBody({ item }: { item: Content }) {
  const ref = useRef<HTMLDivElement>(null);
  const [lightbox, setLightbox] = useState<{ slides: SlideImage[]; index: number } | null>(null);
  const { notify, revision } = useBlog();
  useEffect(() => { setLightbox(null); }, [item.id, item.body, item.format, revision]);
  function openImage(image: HTMLImageElement) {
    const images = Array.from(ref.current?.querySelectorAll<HTMLImageElement>('img') || [])
      .filter(img => safeUrl(img.currentSrc || img.src));
    const index = images.indexOf(image);
    if (index < 0) return;
    image.tabIndex = 0;
    image.focus({ preventScroll: true });
    setLightbox({ index, slides: images.map(img => ({
      src: img.currentSrc || img.src,
      alt: img.alt,
      width: img.naturalWidth || undefined,
      height: img.naturalHeight || undefined,
    })) });
  }
  // Stable component types keep loaded images mounted during reading-progress updates.
  const markdownComponents = useMemo<Components>(() => ({
    img: ({ src, alt }) => (
      <Media
        src={typeof src === "string" ? src : ""}
        alt={alt}
      />
    ),
    a: ({ href, children }) => (
      <a href={safeUrl(href)} target="_blank" rel="noopener noreferrer">
        {children}
      </a>
    ),
  }), []);
  useEffect(() => {
    const el = ref.current;
    if (!el) return;
    const cleanups: (() => void)[] = [];
    el.querySelectorAll('img').forEach(img => { img.tabIndex = 0; });
    el.querySelectorAll("h1,h2,h3,h4").forEach((h, i) => {
      h.id = `heading-${i}`;
      const anchor = document.createElement("a");
      anchor.className = "header-anchor";
      anchor.href = `#${h.id}`;
      anchor.title = "跳转到此标题";
      anchor.setAttribute("aria-label", "标题链接");
      const icon = document.createElement("i");
      icon.className = "anzhiyufont anzhiyu-icon-link";
      icon.setAttribute("aria-hidden", "true");
      anchor.append(icon);
      h.append(anchor);
      cleanups.push(() => anchor.remove());
    });
    el.querySelectorAll("pre").forEach((pre) => {
      const lines = (pre.textContent || "").replace(/\n$/, "").split("\n").length;
      pre.dataset.lineNumbers = Array.from({ length: lines }, (_, i) => String(i + 1)).join("\n");
      cleanups.push(() => { delete pre.dataset.lineNumbers; });
      const wrap = document.createElement("div");
      wrap.className = "code-tools";
      const language = document.createElement("span");
      language.className = "code-language";
      language.textContent = pre.querySelector("code")?.className.match(/language-([\w+-]+)/)?.[1]?.toUpperCase() || "PLAINTEXT";
      const copy = document.createElement("button");
      copy.textContent = "复制";
      copy.setAttribute("aria-label", "复制代码");
      copy.onclick = () => {
        navigator.clipboard
          .writeText(pre.textContent || "")
          .then(() => notify("已复制代码"))
          .catch(() => notify("复制失败"));
      };
      const fold = document.createElement("button");
      fold.textContent = "收起";
      fold.onclick = () => {
        pre.hidden = !pre.hidden;
        fold.textContent = pre.hidden ? "展开" : "收起";
      };
      wrap.append(language, copy, fold);
      pre.before(wrap);
      cleanups.push(() => wrap.remove());
    });
    let active = true;
    const controller = new AbortController();
    el.querySelectorAll<HTMLImageElement>("img[data-managed-src]").forEach(
      (img) => {
        mediaUrl(img.dataset.managedSrc!, controller.signal)
          .then((url) => {
            if (!active) {
              if (url.startsWith("blob:")) URL.revokeObjectURL(url);
              return;
            }
            img.src = url;
            cleanups.push(() => URL.revokeObjectURL(url));
          })
          .catch(() => {});
      },
    );
    return () => {
      active = false;
      controller.abort();
      cleanups.forEach((f) => f());
    };
  }, [item.id, item.body, item.format, revision]);
  const sanitized = DOMPurify.sanitize(item.body || "", {
    FORBID_TAGS: ["iframe", "form", "style", "script", "audio", "video"],
    FORBID_ATTR: ["style", "srcset"],
  }).replace(/src="(\/blog-media\/\d+)"/g, 'data-managed-src="$1"');
  // Preserve resolved blob URLs and focus: replacing innerHTML remounts its images.
  const htmlBody = useMemo(() => <div dangerouslySetInnerHTML={{ __html: sanitized }} />, [sanitized]);
  return (
    <>
      <div
        id="article-container"
        ref={ref}
        onClick={(e) => {
          if (e.target instanceof HTMLImageElement && safeUrl(e.target.currentSrc || e.target.src)) {
            e.preventDefault();
            openImage(e.target);
          }
        }}
        onLoadCapture={e => { if (e.target instanceof HTMLImageElement) e.target.tabIndex = 0; }}
        onKeyDown={e => {
          if (e.target instanceof HTMLImageElement && (e.key === 'Enter' || e.key === ' ')) {
            e.preventDefault();
            openImage(e.target);
          }
        }}
      >
        {item.format === "html" ? (
          htmlBody
        ) : (
          <ReactMarkdown
            remarkPlugins={[remarkGfm]}
            components={markdownComponents}
          >
            {item.body || ""}
          </ReactMarkdown>
        )}
      </div>
      {lightbox && (
        <Suspense fallback={<div className="article-viewer-loading" role="status">正在打开图片…<button onClick={() => setLightbox(null)}>取消</button></div>}>
          <ImageLightbox slides={lightbox.slides} index={lightbox.index} close={() => setLightbox(null)} />
        </Suspense>
      )}
    </>
  );
}
