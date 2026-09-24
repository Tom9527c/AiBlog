import { useEffect, useLayoutEffect, useRef, useState } from 'react';
import { Link, useSearchParams } from 'react-router-dom';
import { ContentBody, LoadedContent, Status, useBlog, useLoad } from '../../components';
import { detail, list } from '../../services/api';
import { Comments } from '../comments/Comments';
import { PageShell } from '../../components/page/PageShell';
import { EssayMedia } from './components/EssayMedia';
import { essayDate, essayMedia } from './model';
import type { Content } from '../../types';
import './essay.css';

/** Positions in reading order, placing each following card in the shortest column. */
function Masonry({ children, count }: { children: React.ReactNode; count: number }) {
  const ref = useRef<HTMLDivElement>(null);
  useLayoutEffect(() => {
    const root = ref.current;
    if (!root) return;
    let frame = 0;
    const layout = () => {
      const columns = window.innerWidth <= 768 ? 1 : window.innerWidth <= 1100 ? 2 : 3;
      const gap = columns === 1 ? 16 : root.clientWidth * .02;
      const width = (root.clientWidth - gap * (columns - 1)) / columns;
      const heights = Array(columns).fill(0);
      Array.from(root.children).forEach(child => {
        const card = child as HTMLElement;
        card.style.width = `${width}px`;
        const column = heights.indexOf(Math.min(...heights));
        card.style.transform = `translate(${column * (width + gap)}px, ${heights[column]}px)`;
        heights[column] += card.offsetHeight + 16;
      });
      root.style.height = `${Math.max(...heights, 0)}px`;
      root.dataset.ready = 'true';
    };
    const schedule = () => { cancelAnimationFrame(frame); frame = requestAnimationFrame(layout); };
    const observer = new ResizeObserver(schedule);
    observer.observe(root);
    Array.from(root.children).forEach(child => observer.observe(child));
    window.addEventListener('resize', schedule);
    layout();
    return () => { observer.disconnect(); cancelAnimationFrame(frame); window.removeEventListener('resize', schedule); };
  }, [count, children]);
  return <div ref={ref} className="essay-waterfall">{children}</div>;
}
export function EssayCard({ item, onComment, expanded = false }: { item: Content; onComment: (id:number) => void; expanded?: boolean }) {
  const date = new Date(essayDate(item));
  const dateLabel = Number.isFinite(date.getTime()) ? `${date.getFullYear()}-${date.getMonth() + 1}-${date.getDate()}` : '';
  const media = essayMedia(item);
  const tags = Array.isArray(item.metadata.tags) ? item.metadata.tags as string[] : [];
  return <>
    {item.sort > 0 && <span className="essay-pin">置顶</span>}
    <div className="essay-text"><ContentBody item={{...item,body:item.body || item.summary || item.title}} /></div>
    {media.length > 0 && <div className="essay-media-list">{media.map((entry,index) => <EssayMedia key={`${index}-${entry.url}`} item={entry} />)}</div>}
    {tags.length > 0 && <div className="essay-tags">{tags.map(tag => <span key={tag}># {tag}</span>)}</div>}
    <div className="essay-bottom">
      <div className="essay-info">
        <time dateTime={Number.isFinite(date.getTime()) ? date.toISOString() : undefined} title={Number.isFinite(date.getTime()) ? date.toLocaleString('zh-CN') : ''}><i className="anzhiyufont anzhiyu-icon-clock" /> {dateLabel}</time>
        {Boolean(item.metadata.location) && <span title="地点">⌖ {String(item.metadata.location)}</span>}
        {Boolean(item.metadata.mood) && <span title="心情">{String(item.metadata.mood)}</span>}
        {Boolean(item.metadata.weather) && <span title="天气">{String(item.metadata.weather)}</span>}
        {Boolean(item.metadata.source) && <span>{String(item.metadata.source)}</span>}
      </div>
      <div className="essay-card-actions">
        <button title="评论这条短文" aria-label="评论这条短文" aria-expanded={expanded} onClick={() => onComment(item.id)}><i className="anzhiyufont anzhiyu-icon-message" /><span>评论{item.commentCount === undefined ? "" : ` ${item.commentCount}`}</span></button>
      </div>
    </div>
  </>;
}
function EssayDiscussionCard({ item, expanded, single, onComment }: { item: Content; expanded: boolean; single: boolean; onComment: (id: number) => void }) {
  // Keep an opened thread mounted when collapsed so main/reply drafts stay with their essay.
  const [visited, setVisited] = useState(expanded);
  useEffect(() => { if (expanded) setVisited(true); }, [expanded]);
  return <>
    <EssayCard item={item} onComment={onComment} expanded={expanded} />
    {(single || expanded || visited) && <div className="essay-comments" hidden={!single && !expanded}>
      <Comments targetKind="essays" targetId={item.id} compact={!single} />
      {!single && <Link className="essay-discussion-link" to={`/essay/?id=${item.id}#post-comment`}>查看全部讨论</Link>}
    </div>}
  </>;
}
export function EssayPage() {
  const { revision } = useBlog();
  const [params] = useSearchParams();
  const selectedId = params.get('id');
  const [commentId, setCommentId] = useState<number | undefined>();
  const state = useLoad(async () => selectedId ? {items:[await detail('essays',selectedId)],total:1,page:1,pageSize:30} : list('essays',{pageSize:30}), [selectedId,revision]);
  useEffect(() => { setCommentId(undefined); }, [selectedId]);
  function comment(id:number) {
    if (selectedId) document.getElementById('post-comment')?.scrollIntoView({behavior:'smooth',block:'start'});
    else setCommentId(previous => previous === id ? undefined : id);
  }
  const cards = state.data?.items.map(item => {
    const render = (full: Content) => <EssayDiscussionCard item={full} single={Boolean(selectedId)} expanded={Boolean(selectedId) || commentId === item.id} onComment={comment} />;
    return <article id={`essay-${item.id}`} className="essay-card" key={`${selectedId ? 'detail' : 'list'}-${item.id}`}>
      {item.locked ? <LoadedContent kind="essays" item={item}>{render}</LoadedContent> : render(item)}
    </article>;
  });
  return <PageShell title="即刻短文">
    <div id="essay_page" className={`essay-page${selectedId ? ' essay-page-single' : ''}`}>
      {selectedId && <Link className="essay-back" to="/essay/">← 查看全部短文</Link>}
      <Status {...state} retry={state.reload} empty={!state.data?.items.length} />
      {selectedId ? <div className="essay-single">{cards}</div> : <Masonry count={state.data?.items.length || 0}>{cards}</Masonry>}
      {!selectedId && <div className="essay-limit">- 只展示最近30条短文 -</div>}
    </div>
  </PageShell>;
}
