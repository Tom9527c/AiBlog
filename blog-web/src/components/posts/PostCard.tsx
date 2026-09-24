import { Link, useNavigate } from 'react-router-dom';
import { Media } from '../media/Media';
import { useReadPost } from '../../hooks/useReadPost';
import { pathFor } from '../../utils/path';
import type { Content, TaxonomySummary } from '../../types';
import { TagVisual } from '../../views/taxonomy/components/TagVisual';

export function cardDate(value: string | null | undefined) {
  if (!value) return '';
  const date = new Date(value);
  if (Number.isNaN(date.getTime())) return '';
  return `${date.getFullYear()}-${String(date.getMonth()+1).padStart(2,'0')}-${String(date.getDate()).padStart(2,'0')}`;
}
const termPath = (kind: 'categories' | 'tags', term: TaxonomySummary) => `/${kind}/${encodeURIComponent(term.slug || term.id)}`;

export function PostCard({ item, category: fallbackCategory }: { item: Content; category?: TaxonomySummary }) {
  const read = useReadPost(item.id);
  const navigate = useNavigate();
  const path = pathFor('documents', item);
  const category = item.category === undefined ? fallbackCategory : item.category;
  const published = item.publishedAt || item.createdAt;
  const updated = item.updatedAt || published;
  return (
    <article className="recent-post-item" onClick={event => {
      if ((event.target as HTMLElement).closest('a,button') || window.getSelection()?.toString()) return;
      navigate(path);
    }}>
      <Link className="post_cover left" to={path} title={item.title}>
        <Media className="post_bg" src={item.cover} alt={item.title} />
      </Link>
      {category && <div className="article-meta__categories__box">
        <Link className="article-meta__categories" to={termPath('categories', category)}>{category.title}</Link>
      </div>}
      <div className="recent-post-info">
        <div className="recent-post-info-top">
          <div className="recent-post-info-top-tips">
            {item.isLatest && <span className="newPost">最新</span>}
            {!read && <Link className="unvisited-post" to={path} title={item.title}>未读</Link>}
            {item.locked && <span className="restricted-post">
              <i className="anzhiyufont anzhiyu-icon-lock" aria-hidden="true" />
              {item.accessMode === 'login' ? '登录可见' : '密码可见'}
            </span>}
          </div>
          <Link className="article-title" to={path} title={item.title}>{item.title}</Link>
        </div>
        <div className="article-meta-wrap">
          <span className="post-meta-date">
            <i className="anzhiyufont anzhiyu-icon-calendar-alt" aria-hidden="true" />
            <span className="article-meta-label">发表于</span>
            <time className="post-meta-date-created" dateTime={published || undefined} title={`发表于 ${cardDate(published)}`}>{cardDate(published)}</time>
            <span className="article-meta-separator" />
            <i className="anzhiyufont anzhiyu-icon-history" aria-hidden="true" />
            <span className="article-meta-label">更新于</span>
            <time className="post-meta-date-updated" dateTime={updated || undefined} title={`更新于 ${cardDate(updated)}`}>{cardDate(updated)}</time>
          </span>
          {!!item.tags?.length && <span className="article-meta tags">
            {item.tags.map(tag => <Link key={tag.id} className="article-meta__tags" to={termPath('tags', tag)}>
              <TagVisual term={tag} />
            </Link>)}
          </span>}
        </div>
        {item.summary && <div className="content">{item.summary}</div>}
      </div>
    </article>
  );
}
