import { useEffect,useRef,useState } from "react";
import {
Link,
useParams,
useSearchParams
} from "react-router-dom";
import {
Media,
Pager,
pathFor,
PostCard,
Status,
useBlog,
useLoad
} from "../../components";
import { articlePage,articlePageSize } from "../../components/navigation/Pager";
import { useArticlePageScroll } from "../../hooks/useArticlePageScroll";
import { safeUrl } from "../../services/api";
import { list } from "../../services/content";
import type { Content } from "../../types";
import { EssayTicker,loadPublicEssays } from './components/EssayTicker';

import { Aside } from './components/Aside';
import { SkillRibbon } from './components/SkillRibbon';
import { TopPost } from './components/TopPost';
const emptyEssays: Content[] = [];

export function Home() {
  const { site, revision } = useBlog();
  const pageSize = articlePageSize(site.articlePageSize);
  const [params, setParams] = useSearchParams();
  const { pageNumber } = useParams();
  const page = articlePage(params.get("page") || pageNumber);
  const category = Number(params.get("categoryId")) || 0;
  const posts = useLoad(
    () =>
      list("documents", {
        page,
        pageSize,
        ...(category ? { categoryId: category } : {}),
      }),
    [page, category, pageSize],
  );
  const articleListRef = useArticlePageScroll(page, posts.data);
  const cats = useLoad(() => list("categories", { pageSize: 100 }), []);
  const essays = useLoad(loadPublicEssays, [revision]);
  const [slide, setSlide] = useState(0);
  const [showRecommendations, setShowRecommendations] = useState(false);
  const topGroupRef = useRef<HTMLDivElement>(null);
  const recommendationButtonRef = useRef<HTMLButtonElement>(null);
  useEffect(() => {
    const t = setInterval(() => setSlide((v) => v + 1), 5000);
    return () => clearInterval(t);
  }, []);
  useEffect(() => {
    if (showRecommendations) {
      topGroupRef.current?.querySelector<HTMLAnchorElement>(".recent-post-item a")?.focus();
    }
  }, [showRecommendations]);
  useEffect(() => {
    const mobile = window.matchMedia?.('(max-width: 768px)');
    if (!mobile) return;
    const restoreCover = () => {
      if (mobile.matches) setShowRecommendations(false);
    };
    restoreCover();
    mobile.addEventListener('change', restoreCover);
    return () => mobile.removeEventListener('change', restoreCover);
  }, []);
  const card = site.homeCards?.[slide % (site.homeCards.length || 1)];
  return (
    <>
      <EssayTicker items={essays.data?.items || emptyEssays} fallback={site.announcement || "欢迎来到博客"} />
      <div id="home_top">
        <div className="swiper_container_card">
          <div id="bannerGroup">
            <div id="random-banner" className="home-hero">
              <div className="banners-title">
                {(site.heroTitle || site.title || "记录生活").split("\n").map((line) => (
                  <div className="banners-title-big" key={line}>{line}</div>
                ))}
                <div className="banners-title-small">
                  {site.heroSubtitle || site.subtitle || "记录生活，分享热爱"}
                </div>
              </div>
              {site.heroImage ? <Media src={site.heroImage} alt="首页封面" /> : <SkillRibbon />}
              <Link id="random-hover" className="random-hover" to="/random/">
                <i className="anzhiyufont anzhiyu-icon-paper-plane" aria-hidden="true" />
                <span className="bannerText">随便逛逛 <i className="anzhiyufont anzhiyu-icon-arrow-right" aria-hidden="true" /></span>
              </Link>
            </div>
            <div className="categoryGroup">
              {!cats.data?.items.length && (
                <div className="category-empty">
                  <div>新的灵感，即将启程<small>内容发布后，在这里发现更多主题</small></div>
                  <Link to="/categories/">探索分类 →</Link>
                </div>
              )}
              {cats.data?.items.slice(0, 3).map((c, i) => (
                <div className="categoryItem" key={c.id}>
                  <Link className={`categoryButton ${["blue", "red", "green"][i]}`} to={pathFor("categories", c)}>
                    <span className="categoryButtonText">{c.title}</span>
                    <i className={`anzhiyufont ${["anzhiyu-icon-dove", "anzhiyu-icon-fire", "anzhiyu-icon-book"][i]}`} aria-hidden="true" />
                  </Link>
                </div>
              ))}
            </div>
          </div>
          <div
            className={`topGroup ${showRecommendations ? "recommendations-visible" : ""}`}
            ref={topGroupRef}
            onMouseLeave={() => setShowRecommendations(false)}
            onKeyDown={(event) => {
              if (event.key === "Escape" && showRecommendations) {
                event.preventDefault();
                setShowRecommendations(false);
                recommendationButtonRef.current?.focus();
              }
            }}
          >
            {posts.data?.items.slice(0, 6).map((item) => <TopPost item={item} key={item.id} />)}
            <a
              className={`todayCard ${showRecommendations ? "hide" : ""}`}
              id="todayCard"
              href={card ? safeUrl(card.url) : "/archives/"}
              inert={showRecommendations ? true : undefined}
              tabIndex={showRecommendations ? -1 : undefined}
            >
              <div className="todayCard-info">
                <div className="todayCard-tips">{card?.description || "推荐"}</div>
                <div className="todayCard-title">{card?.title || site.description || "发现更多文章"}</div>
              </div>
              <Media className="todayCard-cover" src={card?.image} alt={card?.title || "推荐封面"} />
            </a>
            <div className="banner-button-group" aria-hidden={showRecommendations}>
              <button ref={recommendationButtonRef} className="banner-button" type="button" tabIndex={showRecommendations ? -1 : 0} aria-expanded={showRecommendations} aria-controls="todayCard" onClick={() => setShowRecommendations(true)}>
                <i className="anzhiyufont anzhiyu-icon-arrow-circle-right" aria-hidden="true" />
                <span className="banner-button-text">更多推荐</span>
              </button>
            </div>
          </div>
        </div>
      </div>
      <div
        id="content-inner"
        className={`layout ${!site.showAside ? "hide-aside" : ""}`}
      >
        <div id="recent-posts" className="recent-posts">
          <div id="categoryBar">
            <div className="category-bar" id="category-bar">
              <div id="catalog-bar">
                <div id="catalog-list">
                  <button className={!category ? "selected" : ""} onClick={() => setParams({})}>首页</button>
                  {cats.data?.items.map((c) => (
                    <button key={c.id} className={category === c.id ? "selected" : ""} onClick={() => setParams({ categoryId: String(c.id) })}>{c.title}</button>
                  ))}
                </div>
              </div>
              <Link className="category-bar-more" to="/categories/">更多 <i className="anzhiyufont anzhiyu-icon-angle-right" aria-hidden="true" /></Link>
            </div>
          </div>
          <Status {...posts} empty={!posts.data?.items.length} />
          <div className="recent-post-list" ref={articleListRef}>
            {posts.data?.items.map((p) => (
              <PostCard item={p} category={cats.data?.items.find((c) => c.id === p.categoryId)} key={p.id} />
            ))}
          </div>
          <Pager
            showSinglePage
            pageSize={pageSize}
            page={page}
            total={posts.data?.total || 0}
            onChange={(p) => {
              setParams({
                page: String(p),
                ...(category ? { categoryId: String(category) } : {}),
              });
            }}
          />
        </div>
        {site.showAside && <Aside />}
      </div>
    </>
  );
}
