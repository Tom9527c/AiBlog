import { useState } from 'react';
import { Media, useMedia } from '../../../components/media/Media';
import { Lightbox } from '../../../components/media/Lightbox';
import { safeUrl } from '../../../services/api';
import type { EssayMediaItem } from '../model';
export function EssayMedia({ item }: { item: EssayMediaItem }) {
  const source = useMedia(item.type === 'video' || item.type === 'audio' ? item.url : '');
  const poster = useMedia(item.poster || '');
  const [expanded, setExpanded] = useState('');
  const [failed, setFailed] = useState(false);
  if (item.type === 'image') return <div className="essay-image">
    <button type="button" aria-label={item.title ? `放大图片：${item.title}` : '放大图片'} onClick={event => { const img = event.currentTarget.querySelector('img'); if (img) setExpanded(img.src); }}>
      <Media src={item.url} alt={item.title || '短文配图'} />
    </button>
    {expanded && <Lightbox slides={[{src:expanded,alt:item.title}]} close={() => setExpanded('')} />}
  </div>;
  if (item.type === 'link') return <a className="essay-link" href={safeUrl(item.url)} target="_blank" rel="noopener noreferrer"><i className="anzhiyufont anzhiyu-icon-link" /><span>{item.title || item.url}</span><span aria-hidden="true">↗</span></a>;
  return <div className={`essay-player essay-player-${item.type}`}>
    {(item.title || item.artist) && <div className="essay-track">{item.type === 'audio' && <span aria-hidden="true">♫ </span>}<strong>{item.title}</strong>{item.artist && <span> · {item.artist}</span>}</div>}
    {source ? item.type === 'video' ? <video src={source} poster={poster || undefined} controls playsInline preload="metadata" aria-label={item.title || '短文视频'} onError={() => setFailed(true)} /> : <audio src={source} controls preload="metadata" aria-label={item.title || '短文音乐'} onError={() => setFailed(true)} /> : <span className="essay-media-loading">正在加载媒体…</span>}
    {failed && <p role="status">暂时无法播放，<a href={safeUrl(item.url)} target="_blank" rel="noopener noreferrer">打开原链接</a></p>}
  </div>;
}
