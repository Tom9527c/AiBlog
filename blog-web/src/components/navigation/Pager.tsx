import { Fragment, useEffect, useState } from "react";

export const ARTICLE_PAGE_SIZE = 8;
export function articlePageSize(value: number | undefined) {
  return Number.isInteger(value) && value! >= 1 && value! <= 100 ? value! : ARTICLE_PAGE_SIZE;
}
export function articlePage(value: string | undefined | null) {
  const page = Number(value);
  return Number.isSafeInteger(page) && page > 0 ? page : 1;
}

export function Pager({ page, total, onChange, pageSize = 12, showSinglePage = false }: {
  page: number; total: number; onChange: (page: number) => void; pageSize?: number; showSinglePage?: boolean;
}) {
  const pages = Math.ceil(total / pageSize);
  const [jump, setJump] = useState("");
  useEffect(() => setJump(""), [page]);
  if (!pages || (pages === 1 && !showSinglePage)) return null;
  const visible = [...new Set([1, page - 1, page, page + 1, pages])].filter(p => p >= 1 && p <= pages).sort((a, b) => a - b);
  const go = (target: number) => {
    if (!Number.isSafeInteger(target)) return;
    const next = Math.max(1, Math.min(pages, target));
    if (next !== page) onChange(next);
  };
  return <nav id="pagination" aria-label="分页">
    {page > 1 && <button aria-label="上一页" title="上一页" onClick={() => go(page - 1)}>‹</button>}
    {visible.map((p, i) => <Fragment key={p}>
      {i > 0 && p - visible[i - 1] > 1 && <span className="pagination-gap" aria-hidden="true">…</span>}
      <button aria-label={`第 ${p} 页`} className={p === page ? "current" : undefined} aria-current={p === page ? "page" : undefined} onClick={() => go(p)}>{p}</button>
    </Fragment>)}
    {page < pages && <button aria-label="下一页" title="下一页" onClick={() => go(page + 1)}>›</button>}
    <form className="pagination-jump" noValidate onSubmit={event => {
      event.preventDefault();
      if (jump.trim()) go(Number(jump));
    }}>
      <input aria-label="跳转页码" title={`输入页码（1–${pages}）`} type="number" inputMode="numeric" min={1} max={pages} step={1} value={jump} onChange={event => setJump(event.target.value)} />
      <button type="submit" aria-label="跳转到指定页" title="跳转到指定页">»</button>
    </form>
  </nav>;
}
