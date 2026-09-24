import Comments from "../comments/Comments";
import { PageHeader } from '../../components/page/PageHeader';
import { lazy, Suspense, useCallback, useEffect, useRef, useState, type CSSProperties, type SyntheticEvent } from 'react';
import { Link, useLocation, useParams } from 'react-router-dom';
import { Gate, LoadedContent, Media, Status, pathFor, useBlog, useLoad } from '../../components';
import { detail } from '../../services/content';
import type { Content } from '../../types';
import { AlbumMedia, isAlbumVideo } from './components/AlbumMedia';
import { useAlbumFeed } from './useAlbumFeed';
import './album.css';

const AlbumLightbox = lazy(() => import('./components/AlbumLightbox'));
const groupTitles: Record<string, string> = { dailyPhoto: '日常生活', lovePic: '壁纸', wordScenery: '世界各地风景' };

function PhotoCard({ item, onOpen }: { item: Content; onOpen: (item: Content) => void }) {
  const width = Number(item.metadata?.width);
  const height = Number(item.metadata?.height);
  const [ratio, setRatio] = useState(width > 0 && height > 0 ? width / height : 4 / 3);
  function measure(event: SyntheticEvent) {
    const media = event.target;
    const w = media instanceof HTMLImageElement ? media.naturalWidth : media instanceof HTMLVideoElement ? media.videoWidth : 0;
    const h = media instanceof HTMLImageElement ? media.naturalHeight : media instanceof HTMLVideoElement ? media.videoHeight : 0;
    if (w > 0 && h > 0) setRatio(w / h);
  }
  const content = (full: Content) => <button type="button" className="photo-open" onClick={() => onOpen(full)} aria-label={`查看 ${full.title}`}>
    <AlbumMedia item={full} preview />
    {full.summary?.trim() && <span className="album-photo-caption">{full.summary}</span>}
    {isAlbumVideo(full) && <span className="album-video-badge">▶ 视频</span>}
  </button>;
  return <div className="album-item" style={{ '--photo-ratio': ratio } as CSSProperties} onLoadCapture={measure} onLoadedMetadataCapture={measure}>
    {item.locked ? <LoadedContent kind="photos" item={item}>{content}</LoadedContent> : content(item)}
  </div>;
}

function AlbumPage({ slug, group }: { slug?: string; group: string }) {
  const { site } = useBlog();
  const album = useLoad(() => slug ? detail('albums', slug) : Promise.resolve(null), [slug]);
  const isPhotos = Boolean(slug || groupTitles[group]);
  const enabled = !slug || Boolean(album.data && !album.data.locked);
  const feed = useAlbumFeed(isPhotos ? 'photos' : 'albums', enabled, album.data?.id, groupTitles[group] ? group : undefined);
  const sentinel = useRef<HTMLDivElement>(null);
  const [lightbox, setLightbox] = useState<number | null>(null);
  const [unlocked, setUnlocked] = useState<Record<number, Content>>({});
  const rememberUnlocked = useCallback((item: Content) => setUnlocked(previous => ({ ...previous, [item.id]: item })), []);
  const title = album.data?.title || groupTitles[group] || '相册集';
  const layout = ['grid', 'gallery'].includes(String(album.data?.metadata?.layout)) ? String(album.data?.metadata?.layout) : 'waterfall';

  useEffect(() => { document.title = `${title} | ${site.title || '博客'}`; }, [title, site.title]);
  useEffect(() => {
    if (!isPhotos || !enabled || !feed.hasMore || feed.loading || feed.error || lightbox !== null || !sentinel.current || typeof IntersectionObserver === 'undefined') return;
    const observer = new IntersectionObserver(entries => {
      if (entries.some(entry => entry.isIntersecting)) void feed.loadMore();
    }, { rootMargin: '320px 0px' });
    observer.observe(sentinel.current);
    return () => observer.disconnect();
  }, [isPhotos, enabled, feed.hasMore, feed.loading, feed.error, feed.loadMore, lightbox]);

  return <div id="content-inner" className={`layout hide-aside ${isPhotos ? 'album-detail-layout' : ''}`}>
    <div id="page">
      <PageHeader page="albums" title={title} detail={isPhotos} cover={!album.data?.locked ? album.data?.cover : ''} subtitle={!album.data?.locked ? album.data?.summary : ''} />
      <Status loading={Boolean(slug) && album.loading} error={album.error} retry={album.reload} />
      {album.data?.locked ? <Gate kind="albums" item={album.data} onUnlocked={album.reload} /> : enabled && <>
        <div id="album" className={isPhotos ? `album-photos photo-${layout}` : 'album-grid'} aria-label={isPhotos ? '相册内容' : '相册列表'}>
          {feed.items.map((item, index) => isPhotos ? <PhotoCard key={item.id} item={unlocked[item.id] || item} onOpen={full => {
            if (item.locked) setUnlocked(previous => ({ ...previous, [item.id]: full }));
            setLightbox(index);
          }} /> : <div className="album-item" key={item.id}>
            <Link to={pathFor('albums', item)}>
              <Media src={item.cover} alt={item.title} />
              <div className="album-content"><h2>{item.title} {item.locked ? '♙' : ''}</h2><p>{item.summary}</p></div>
            </Link>
          </div>)}
        </div>
        <div className="album-feed-status" ref={sentinel}>
          <Status loading={feed.loading} error={feed.error} retry={feed.loadMore} empty={!feed.items.length && !feed.loading && !feed.hasMore} />
          {!feed.loading && !feed.error && feed.hasMore && <button className="load-more" onClick={feed.loadMore}>加载更多</button>}
          {!feed.loading && !feed.error && !feed.hasMore && feed.items.length > 0 && <p className="album-end">已加载全部 {feed.items.length} 项</p>}
        </div>
        {album.data && <Comments targetKind="albums" targetId={album.data.id}/>}
      </>}
      {lightbox !== null && <Suspense fallback={<div className="album-viewer-loading" role="status">正在打开图片…<button onClick={() => setLightbox(null)}>取消</button></div>}>
        <AlbumLightbox items={feed.items.map(item => unlocked[item.id] || item)} index={lightbox} onView={setLightbox} onClose={() => setLightbox(null)} onResolved={rememberUnlocked} />
      </Suspense>}
    </div>
  </div>;
}

export function Albums() {
  const { slug } = useParams();
  const { pathname } = useLocation();
  const { revision } = useBlog();
  const group = pathname.split('/')[1];
  return <AlbumPage key={`${slug || group}:${revision}`} slug={slug} group={group} />;
}
export default Albums;
