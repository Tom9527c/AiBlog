import {
Link,
useParams,
useSearchParams
} from "react-router-dom";
import {
Gate,
Pager,
pathFor,
PostCard,
Status,
useBlog,
useLoad
} from "../../components";
import { articlePage,articlePageSize } from "../../components/navigation/Pager";
import { useArticlePageScroll } from "../../hooks/useArticlePageScroll";
import { detail,list } from "../../services/content";
import type { Content,Page } from "../../types";
import { CategoryCover } from "./components/CategoryCover";
import { TagVisual } from "./components/TagVisual";
import { tagStyle } from "../taxonomy/tag-color";

import { PageShell } from '../../components/page/PageShell';
export function Taxonomy({ kind }: { kind: "categories" | "tags" }) {
  const { site } = useBlog();
  const pageSize = articlePageSize(site.articlePageSize);
  const { slug } = useParams();
  const [params, setParams] = useSearchParams();
  const { pageNumber } = useParams();
  const page = articlePage(params.get("page") || pageNumber);
  const taxonomy = useLoad<Content | Page>(
    () => (slug ? detail(kind, slug) : list(kind, { pageSize: 100 })),
    [kind, slug],
  );
  const selected =
    taxonomy.data && "id" in taxonomy.data ? taxonomy.data : null;
  const posts = useLoad(
    () =>
      selected
        ? list("documents", {
            page,
            pageSize,
            [kind === "tags" ? "tagId" : "categoryId"]: selected.id,
          })
        : Promise.resolve(null),
    [selected?.id, page, kind, pageSize],
  );
  const articleListRef = useArticlePageScroll(page, posts.data);
  return (
    <PageShell
      title={selected?.title || (kind === "tags" ? "标签" : "分类")}
      aside={!!slug}
      headerCover={selected && !selected.locked ? selected.cover : ''}
      headerSubtitle={selected && !selected.locked ? selected.summary : ''}
      headerDetail={!!slug}
    >
      <Status {...taxonomy} />
      {taxonomy.data && "items" in taxonomy.data && (
        <>
          <Status empty={!taxonomy.data.items.length} />
          <div
            className={kind === "tags" ? "tag-cloud-list" : "category-lists"}
          >
            {taxonomy.data.items.map((c) => (
              <Link
                key={c.id}
                to={pathFor(kind, c)}
                className={kind === "categories" ? "category-card" : "tag-chip"}
                style={
                  kind === "tags" ? tagStyle(c) : {}
                }
              >
                {kind === "categories" ? <>
                  <CategoryCover src={c.locked ? "" : c.cover} title={c.title} />
                  <div className="category-card__text"><strong>{c.title}</strong>{c.summary && <small>{c.summary}</small>}<span className="category-card__arrow" aria-hidden="true">↗</span></div>
                </> : <TagVisual term={c} />}
              </Link>
            ))}
          </div>
        </>
      )}
      {selected &&
        (selected.locked ? (
          <Gate kind={kind} item={selected} onUnlocked={taxonomy.reload} />
        ) : (
          <>
            <Status {...posts} empty={!posts.data?.items.length} />
            <div className="recent-post-list" ref={articleListRef}>
              {posts.data?.items.map((c) => <PostCard key={c.id} item={c} />)}
            </div>
            <Pager
              showSinglePage
              pageSize={pageSize}
              page={page}
              total={posts.data?.total || 0}
              onChange={(p) => setParams({ page: String(p) })}
            />
          </>
        ))}
    </PageShell>
  );
}
