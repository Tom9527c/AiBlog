import {
Link,
useParams,
useSearchParams
} from "react-router-dom";
import {
date,
Media,
Pager,
pathFor,
Status,
useLoad
} from "../../components";
import { list } from "../../services/content";

import { PageShell } from '../../components/page/PageShell';
export function Archives() {
  const [params, setParams] = useSearchParams();
  const { pageNumber } = useParams();
  const page = Math.max(1, Number(params.get("page") || pageNumber) || 1);
  const { year: routeYear, month: routeMonth } = useParams();
  const state = useLoad(
    () =>
      list("documents", {
        page,
        ...(routeYear ? { year: Number(routeYear) } : {}),
        ...(routeMonth ? { month: Number(routeMonth) } : {}),
      }),
    [page, routeYear, routeMonth],
  );
  let year = "";
  return (
    <PageShell
      title={
        routeYear
          ? `${routeYear}年${routeMonth ? `${Number(routeMonth)}月` : ""}归档`
          : "文章归档"
      }
      aside
    >
      <Status {...state} empty={!state.data?.items.length} />
      <div className="article-sort-title">
        文章总览 - {state.data?.total || 0}
      </div>
      <div className="article-sort">
        {state.data?.items.map((c) => {
          const next = String(
            new Date(c.publishedAt || c.createdAt).getFullYear(),
          );
          const show = year !== next;
          year = next;
          return (
            <div key={c.id}>
              {show && <h2 className="article-sort-item year">{next}</h2>}
              <div className="article-sort-item">
                <Link
                  className="article-sort-item-img"
                  to={pathFor("documents", c)}
                >
                  <Media src={c.cover} alt={c.title} />
                </Link>
                <div className="article-sort-item-info">
                  <time>{date(c.publishedAt || c.createdAt)}</time>
                  <Link
                    className="article-sort-item-title"
                    to={pathFor("documents", c)}
                  >
                    {c.title}
                    {c.locked ? " ♙" : ""}
                  </Link>
                </div>
              </div>
            </div>
          );
        })}
      </div>
      <Pager
        page={page}
        total={state.data?.total || 0}
        onChange={(p) => setParams({ page: String(p) })}
      />
    </PageShell>
  );
}
