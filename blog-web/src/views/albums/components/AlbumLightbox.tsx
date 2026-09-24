import { useEffect, useMemo, useState } from 'react';
import { useEvents, type GenericSlide } from 'yet-another-react-lightbox';
import { Lightbox } from '../../../components/media/Lightbox';
import { LoadedContent } from '../../../components';
import { AlbumMedia, isAlbumVideo } from './AlbumMedia';
import type { Content } from '../../../types';


interface AlbumSlide extends GenericSlide {
  type: 'album-image' | 'album-video' | 'album-locked';
  item: Content;
}
declare module 'yet-another-react-lightbox' {
  interface SlideTypes {
    'album-image': AlbumSlide;
    'album-video': AlbumSlide;
    'album-locked': AlbumSlide;
  }
}

function ViewerMedia({ item, active, onResolved }: { item: Content; active: boolean; onResolved?: (item: Content) => void }) {
  const { publish } = useEvents();
  const [status, setStatus] = useState<'loading' | 'complete' | 'playing' | 'error'>('loading');
  useEffect(() => { onResolved?.(item); }, [item, onResolved]);
  useEffect(() => {
    if (active) publish(`active-slide-${status}`);
  }, [active, status, publish]);
  return <div className="album-lightbox-media"
    onLoadCapture={() => setStatus('complete')}
    onLoadedDataCapture={() => setStatus('complete')}
    onLoadedMetadataCapture={() => setStatus('complete')}
    onPlayCapture={() => setStatus('playing')}
    onPauseCapture={() => setStatus('complete')}
    onEndedCapture={() => setStatus('complete')}
    onErrorCapture={() => setStatus('error')}
  ><AlbumMedia item={item} active={active} /></div>;
}

export default function AlbumLightbox({ items, index, onClose, onView, onResolved }: {
  items: Content[];
  index: number;
  onClose: () => void;
  onView: (index: number) => void;
  onResolved: (item: Content) => void;
}) {
  const slides = useMemo(() => items.map((item): AlbumSlide => ({
    type: item.locked ? 'album-locked' : isAlbumVideo(item) ? 'album-video' : 'album-image',
    item,
    description: item.locked ? undefined : item.summary?.trim(),
  })), [items]);
  return <Lightbox
    open index={index} close={onClose} slides={slides}
    zoom={{ supports: ['album-image'], maxZoom: 4, scrollToZoom: true }}
    on={{ view: ({ index: next }) => onView(next) }}
    render={{
      slide: ({ slide, offset }) => 'item' in slide ? slide.item.locked
        ? <LoadedContent kind="photos" item={slide.item}>
            {item => <ViewerMedia item={item} active={offset === 0} onResolved={onResolved} />}
          </LoadedContent>
        : <ViewerMedia key={slide.item.id} item={slide.item} active={offset === 0} />
        : undefined,
      thumbnail: ({ slide }) => 'item' in slide
        ? slide.item.locked ? <span aria-label="内容已锁定">♙</span>
          : isAlbumVideo(slide.item) ? <span aria-label="视频">▶</span>
            : <AlbumMedia item={slide.item} preview />
        : undefined,
    }}
  />;
}
