import { Media, useMedia } from '../../../components/media/Media';
import type { Content } from '../../../types';
import { useEffect, useRef } from 'react';
export function isAlbumVideo(item: Content) {
  return item.metadata?.mediaType === 'video' || /\.(mp4|webm|mov)(?:[?#]|$)/i.test(item.url || item.cover);
}
function AlbumVideo({ item, preview, active }: { item: Content; preview: boolean; active: boolean }) {
  const url = useMedia(item.url || item.cover);
  const video = useRef<HTMLVideoElement>(null);
  useEffect(() => { if (!active && video.current && !video.current.paused) video.current.pause(); }, [active]);
  return url ? <video ref={video} key={url} src={url} aria-label={item.title} controls={!preview} muted={preview} playsInline preload="metadata" className="album-video" />
    : <div className="media-placeholder" aria-label={`${item.title} 加载中`}>视频加载中…</div>;
}
export function AlbumMedia({ item, preview = false, active = true }: { item: Content; preview?: boolean; active?: boolean }) {
  return isAlbumVideo(item) ? <AlbumVideo item={item} preview={preview} active={active} /> : <Media src={item.url || item.cover} alt={item.title} />;
}
