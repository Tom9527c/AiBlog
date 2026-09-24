import { useEffect, useState } from "react";
import { Link } from "react-router-dom";
import { list } from "../../../services/api";
import { Modal, Status, useLoad, pathFor } from "../../../components";

export function SearchDialog({ onClose }: { onClose: () => void }) {
  const [keyword, setKeyword] = useState("");
  const [query, setQuery] = useState("");
  const [page, setPage] = useState(1);
  useEffect(() => {
    const t = setTimeout(() => {
      setQuery(keyword);
      setPage(1);
    }, 300);
    return () => clearTimeout(t);
  }, [keyword]);
  const state = useLoad(
    () =>
      query.trim()
        ? list("documents", { keyword: query, page, pageSize: 10 })
        : Promise.resolve(null),
    [query, page],
  );
  return (
    <Modal title="搜索文章" onClose={onClose}>
      <input
        autoFocus
        className="search-input"
        placeholder="输入关键词，发现更多…"
        aria-label="搜索关键词"
        value={keyword}
        onChange={(e) => setKeyword(e.target.value)}
      />
      {query && <Status {...state} empty={!state.data?.items.length} />}
      <div className="search-results">
        {state.data?.items.map((c) => (
          <Link key={c.id} to={pathFor("documents", c)} onClick={onClose}>
            <h3>
              {c.title} {c.locked ? "♙" : ""}
            </h3>
            <p>{c.summary}</p>
          </Link>
        ))}
      </div>
      {state.data && (
        <div className="lightbox-controls">
          <button disabled={page === 1} onClick={() => setPage((p) => p - 1)}>
            上一页
          </button>
          <small>共 {state.data.total} 篇</small>
          <button
            disabled={page * 10 >= state.data.total}
            onClick={() => setPage((p) => p + 1)}
          >
            下一页
          </button>
        </div>
      )}
    </Modal>
  );
}
