import { PageHeader } from '../../components/page/PageHeader';
import { useEffect, useState } from "react";
import { Link, useParams } from "react-router-dom";
import { ContentBody, Gate, Media, Status, useBlog, useLoad, useMedia } from "../../components";
import { articleNeighbors, detail, list } from "../../services/content";
import { useMarkPostRead } from "../../hooks/useReadPost";
import { pathFor } from "../../utils/path";
import { Comments } from "../comments/Comments";
import { ShareDialog } from "../../components/extra/extras";
import type { Content, TaxonomySummary } from "../../types";
import { TagVisual } from "../taxonomy/components/TagVisual";

function Icon({ name }: { name: string }) {
  return <i className={`anzhiyufont anzhiyu-icon-${name}`} aria-hidden="true" />;
}
function articleDate(value?: string | null) {
  if (!value) return "";
  const date = new Date(value);
  return Number.isNaN(date.getTime()) ? "" : `${date.getFullYear()}-${date.getMonth() + 1}-${date.getDate()}`;
}
function wordCount(item: Content) {
  const text = item.body.replace(/<[^>]*>/g, " ").replace(/!\[[^\]]*\]\([^)]*\)/g, "").replace(/\[([^\]]+)\]\([^)]*\)/g, "$1");
  return (text.match(/[\p{Script=Han}]|[\p{L}\p{N}]+/gu) || []).length;
}

function ArticleHero({ item, category, tags }: { item: Content; category?: TaxonomySummary; tags: TaxonomySummary[] }) {
  const words = item.locked ? 0 : wordCount(item);
  return <div className="article-shared-header">
    <PageHeader page="articles" title={item.title} detail cover={item.locked ? "" : item.cover} />
    <div className="article-shared-meta">
      <div id="post-firstinfo"><div className="meta-firstline">
        <span className="post-meta-original">原创</span>
        {category && <Link className="post-category" to={`/categories/${encodeURIComponent(category.slug)}/`}>{category.title}</Link>}
        <span className="article-meta tags">{tags.map(tag => <Link className="article-meta__tags" key={tag.id} to={`/tags/${encodeURIComponent(tag.slug)}/`}><TagVisual term={tag} /></Link>)}</span>
      </div></div>
      <div id="post-meta">
        <div className="meta-firstline">
          <span><Icon name="calendar-days" /> 发表于 <time dateTime={item.publishedAt || item.createdAt}>{articleDate(item.publishedAt || item.createdAt)}</time></span>
          {item.updatedAt && <span><Icon name="history" /> 更新于 <time dateTime={item.updatedAt}>{articleDate(item.updatedAt)}</time></span>}
        </div>
        {!item.locked && <div className="meta-secondline">
          <span><Icon name="file-word" /> 字数总计: {words}</span>
          <span><Icon name="clock" /> 阅读时长: {Math.max(1, Math.ceil(words / 300))}分钟</span>
        </div>}
      </div>
    </div>
  </div>;
}

type Heading = { id: string; text: string; level: number };
function ArticleAside({ headings, active, recent }: { headings: Heading[]; active: string; recent: Content[] }) {
  const { site } = useBlog();
  return <aside id="aside-content" className="aside-content">
    <div className="card-widget card-info article-author">
      <div className="author_top card-content">
        <div className="author-info__sayhi" id="author-info__sayhi">欢迎来访</div>
        <Link className="author-info-avatar" to="/about/" aria-label="关于本人"><Media src={site.avatar} alt={site.title} className="avatar-img" /></Link>
        <div className="author-info__description">{site.description}</div>
      </div>
    </div>
    <div className="card-widget card-announcement">
      <div className="item-headline"><Icon name="bullhorn" /><span>公告</span></div>
      <p>{site.announcement || "欢迎来访，祝你阅读愉快。"}</p>
    </div>
    <div className="sticky_layout">
      {headings.length > 0 && <nav className="card-widget" id="card-toc" aria-label="文章目录">
        <div className="item-headline"><Icon name="bars" /><span>文章目录</span></div>
        <div className="toc-content"><ol className="toc">{headings.map(heading => <li className={`toc-item toc-level-${heading.level}`} key={heading.id}>
          <a className={`toc-link${active === heading.id ? " active" : ""}`} href={`#${heading.id}`} aria-current={active === heading.id ? "location" : undefined} style={{ paddingLeft: `${Math.max(0, heading.level - 2) * 12 + 8}px` }}>{heading.text}</a>
        </li>)}</ol></div>
      </nav>}
      {recent.length > 0 && <div className="card-widget card-recent-post">
        <div className="item-headline"><Icon name="history" /><span>最近发布</span></div>
        <div className="aside-list">{recent.slice(0, 5).map(post => <div className="aside-list-item" key={post.id}>
          <Link className="thumbnail" to={pathFor("documents", post)} tabIndex={-1} aria-hidden="true"><Media src={post.cover} /></Link>
          <div className="content"><Link className="title" to={pathFor("documents", post)}>{post.title}</Link><time>{articleDate(post.publishedAt || post.createdAt)}</time></div>
        </div>)}</div>
      </div>}
    </div>
  </aside>;
}

function ArticleFooter({ item, tags, recommendations }: { item: Content; tags: TaxonomySummary[]; recommendations: Content[] }) {
  const { site, notify } = useBlog();
  const [share, setShare] = useState(false);
  const neighbors = useLoad(() => articleNeighbors(item.id), [item.id]);
  const copyLink = () => navigator.clipboard.writeText(window.location.href).then(() => notify("链接已复制")).catch(() => notify("复制失败，请从地址栏复制链接"));
  return <>
    <div className="post-copyright">
      <div className="copyright-cc-box"><Icon name="copyright" /></div>
      <div className="post-copyright__author_box">
        <Link className="post-copyright__author_img" to="/about/" aria-label="关于作者"><Media src={site.avatar} alt={site.title} /></Link>
        <div className="post-copyright__author_name">{site.title}</div>
        <div className="post-copyright__author_desc">{site.description}</div>
      </div>
      <div className="post-copyright__post__info"><span className="post-copyright__original">原创</span><button className="post-copyright-title" onClick={copyLink}>{item.title}</button></div>
      <div className="article-share"><button aria-label="二维码分享文章" title="使用手机访问这篇文章" onClick={() => setShare(true)}><Icon name="qrcode" /></button><button aria-label="复制文章链接" title="复制链接" onClick={copyLink}><Icon name="link" /></button></div>
      <div className="post-copyright__notice"><span className="post-copyright-info">本博客所有文章除特别声明外，均采用 <a href="https://creativecommons.org/licenses/by-nc-sa/4.0/" target="_blank" rel="noreferrer">CC BY-NC-SA 4.0</a> 许可协议。转载请注明来自 {site.title}！</span></div>
    </div>
    {tags.length > 0 && <div className="article-bottom-tags">{tags.map(tag => <Link key={tag.id} to={`/tags/${encodeURIComponent(tag.slug)}/`}><TagVisual term={tag} /></Link>)}</div>}
    {(neighbors.data?.previous || neighbors.data?.next) && <nav className="article-pagination" aria-label="相邻文章">
      {([['previous', '上一篇'], ['next', '下一篇']] as const).map(([key, label]) => {
        const post = neighbors.data?.[key];
        return post && <Link key={key} className={`${key}-post`} to={pathFor("documents", post)}>
          <Media src={post.cover} /><div className="pagination-info"><small>{label}</small><strong>{post.title}</strong></div>
        </Link>;
      })}
    </nav>}
    {recommendations.length > 0 && <section className="relatedPosts" aria-label="相关文章">
      <div className="headline"><Icon name="thumbs-up" /> 喜欢这篇文章的人也看了</div>
      <div className="relatedPosts-list">{recommendations.slice(0, 6).map(post => <div key={post.id}><Link to={pathFor("documents", post)}>
        <Media src={post.cover} className="cover" /><div className="content is-center"><div className="date"><Icon name="calendar-days" /> {articleDate(post.publishedAt || post.createdAt)}</div><div className="title">{post.title}</div></div>
      </Link></div>)}</div>
    </section>}
    {share && <ShareDialog onClose={() => setShare(false)} />}
  </>;
}

export function Article() {
  const { slug = "" } = useParams();
  const { site, revision } = useBlog();
  const state = useLoad(() => detail("documents", slug.replace(/\.html$/, "")), [slug, revision]);
  const item = state.data;
  const recent = useLoad(() => list("documents", { pageSize: 6 }), [revision]);
  const taxonomy = useLoad(async () => {
    if (!item) return { category: undefined, tags: [] };
    const [category, tags] = await Promise.all([
      item.categoryId ? detail("categories", item.categoryId).catch(() => undefined) : undefined,
      Promise.all((item.tagIds || []).map(id => detail("tags", id).catch(() => undefined))),
    ]);
    return { category, tags: tags.filter((tag): tag is Content => Boolean(tag)) };
  }, [item?.id, item?.updatedAt, revision]);
  const [headings, setHeadings] = useState<Heading[]>([]);
  const [active, setActive] = useState("");
  useMarkPostRead(item);
  useEffect(() => {
    if (item) document.title = `${item.title} | ${site.title}`;
  }, [item, site.title]);
  useEffect(() => {
    const nodes = item && !item.locked ? Array.from(document.querySelectorAll<HTMLElement>("#article-container h1,#article-container h2,#article-container h3,#article-container h4")) : [];
    setHeadings(nodes.map(node => ({ id: node.id, text: node.textContent || "", level: Number(node.tagName[1]) })));
    setActive(nodes[0]?.id || "");
    const observer = new IntersectionObserver(entries => {
      entries.forEach(entry => { if (entry.isIntersecting) setActive(entry.target.id); });
    }, { rootMargin: "-80px 0px -60% 0px" });
    nodes.forEach(node => observer.observe(node));
    return () => observer.disconnect();
  }, [item]);
  const age = item ? Math.floor((Date.now() - new Date(item.updatedAt || item.publishedAt || item.createdAt).getTime()) / 86400000) : 0;
  return <div className="article-detail">
    {item && <ArticleHero item={item} category={taxonomy.data?.category} tags={taxonomy.data?.tags || []} />}
    <div id="content-inner" className={`layout article-layout${!site.showAside ? " hide-aside" : ""}`}>
      <div id="post">
        <Status {...state} />
        {item && (item.locked ? <Gate kind="documents" item={item} onUnlocked={state.reload} /> : <>
          {headings.length > 0 && <details className="article-mobile-toc"><summary>文章目录</summary><nav aria-label="手机文章目录">{headings.map(heading => <a key={heading.id} href={`#${heading.id}`} onClick={event => { const menu = event.currentTarget.closest("details"); if (menu) menu.open = false; }}>{heading.text}</a>)}</nav></details>}
          {age > 180 && <div className="post-outdate-notice"><Icon name="triangle-exclamation" /> 距离上次更新已经 {age} 天了，文章内容可能已经过时。</div>}
          <ContentBody item={item} />
          <ArticleFooter item={item} tags={taxonomy.data?.tags || []} recommendations={(recent.data?.items || []).filter(post => post.id !== item.id)} />
          <Comments targetId={item.id} />
        </>)}
      </div>
      {site.showAside && <ArticleAside headings={headings} active={active} recent={recent.data?.items || []} />}
    </div>
  </div>;
}
export default Article;
