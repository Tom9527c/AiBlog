import { copyImage, downloadImage } from "../extra/extras";
export type ContextTarget = { x: number; y: number; image?: string; link?: string };
type Props = { context: ContextTarget; traditional: boolean; notify: (message: string) => void; random: () => Promise<void>; toggleTheme: () => void; onShare: () => void; onTraditional: () => void; onSearch: () => void };
export function ContextMenu({ context, traditional, notify, random, toggleTheme, onShare, onTraditional, onSearch }: Props) {
  return (
        <div
          id="rightMenu"
          style={{ left: context.x, top: context.y, display: "block" }}
        >
          <div className="rightMenu-group">
            {context.image && (
              <>
                <button
                  className="rightMenu-item"
                  onClick={() =>
                    copyImage(context.image!)
                      .then(() => notify("已复制图片"))
                      .catch((e) => notify(e.message))
                  }
                >
                  复制图片
                </button>
                <button
                  className="rightMenu-item"
                  onClick={() =>
                    downloadImage(context.image!)
                      .then(() => notify("图片已下载"))
                      .catch(() =>
                        notify("该图片禁止跨域下载，请在新窗口打开后保存"),
                      )
                  }
                >
                  下载图片
                </button>
                <a
                  className="rightMenu-item"
                  href={context.image}
                  target="_blank"
                  rel="noreferrer"
                >
                  新窗口打开图片
                </a>
              </>
            )}
            {context.link && (
              <a
                className="rightMenu-item"
                href={context.link}
                target="_blank"
                rel="noreferrer"
              >
                新窗口打开链接
              </a>
            )}
            {[
              ["后退", () => history.back()],
              ["前进", () => history.forward()],
              ["刷新", () => window.location.reload()],
              [
                "回到顶部",
                () => window.scrollTo({ top: 0, behavior: "smooth" }),
              ],
              [
                "复制选中文字",
                () =>
                  navigator.clipboard
                    .writeText(window.getSelection()?.toString() || "")
                    .then(() => notify("已复制")),
              ],
              [
                "复制本页链接",
                () =>
                  navigator.clipboard
                    .writeText(window.location.href)
                    .then(() => notify("已复制链接")),
              ],
              ["二维码分享", () => onShare()],
              [
                traditional ? "切换简体" : "切換繁體",
                () => onTraditional(),
              ],
              ["搜索文章", () => onSearch()],
              ["随机文章", random],
              [
                "播放 / 暂停",
                () =>
                  window.dispatchEvent(
                    new CustomEvent("blog-player", { detail: "toggle" }),
                  ),
              ],
              [
                "上一首",
                () =>
                  window.dispatchEvent(
                    new CustomEvent("blog-player", { detail: "previous" }),
                  ),
              ],
              [
                "下一首",
                () =>
                  window.dispatchEvent(
                    new CustomEvent("blog-player", { detail: "next" }),
                  ),
              ],
              ["切换主题", toggleTheme],
            ].map(([label, fn]) => (
              <button
                key={String(label)}
                className="rightMenu-item"
                onClick={() => void (fn as () => unknown)()}
              >
                {String(label)}
              </button>
            ))}
          </div>
        </div>
  );
}
