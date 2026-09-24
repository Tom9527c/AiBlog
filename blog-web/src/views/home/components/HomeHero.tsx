import { useEffect, useRef, useState, type CSSProperties, type PointerEvent } from 'react';
import { mediaUrl } from '../../../utils/url';
import type { Site } from '../../../types';

export function heroSlides(site: Site) {
  return (site.homeHeroSlides || []).filter(slide => slide.image || slide.mobileImage);
}

function useMediaQuery(query: string) {
  const [matches, setMatches] = useState(() => window.matchMedia?.(query).matches ?? false);
  useEffect(() => {
    const media = window.matchMedia?.(query);
    if (!media) return;
    const update = () => setMatches(media.matches);
    update();
    media.addEventListener('change', update);
    return () => media.removeEventListener('change', update);
  }, [query]);
  return matches;
}

function HeroImage({ src, active, video, motion, onError, onReady }: { src: string; active: boolean; video: boolean; motion: boolean; onError: () => void; onReady: () => void }) {
  const [url, setUrl] = useState('');
  const [loaded, setLoaded] = useState('');
  const player = useRef<HTMLVideoElement>(null);
  const [blocked, setBlocked] = useState(false);
  const failure = useRef(onError);
  failure.current = onError;
  useEffect(() => { if (active && url && loaded === url) onReady(); }, [active, url, loaded, onReady]);
  useEffect(() => {
    const controller = new AbortController();
    let resolved = '';
    mediaUrl(src, controller.signal).then(value => {
      resolved = value;
      if (controller.signal.aborted) {
        if (value.startsWith('blob:')) URL.revokeObjectURL(value);
      } else if (value) setUrl(value);
      else failure.current();
    }).catch(() => { if (!controller.signal.aborted) failure.current(); });
    return () => {
      controller.abort();
      if (resolved.startsWith('blob:')) URL.revokeObjectURL(resolved);
    };
  }, [src]);
  useEffect(() => {
    const element = player.current;
    if (!element || !url) return;
    let alive = true;
    if (active && motion) {
      element.play().catch(() => { if (alive) setBlocked(true); });
    } else element.pause();
    return () => { alive = false; element.pause(); };
  }, [url, active, motion]);
  if (video) return url ? <video ref={player} className={`home-hero__image${loaded === url ? ' is-loaded' : ''}`}
    src={url} muted loop playsInline autoPlay={active && motion} preload="auto"
    controls={active && (blocked || !motion)} aria-label="大屏背景视频"
    onLoadedData={() => setLoaded(url)} onError={onError} /> : null;
  return url ? <img className={`home-hero__image${loaded === url ? ' is-loaded' : ''}`}
    src={url} alt="" aria-hidden="true" fetchPriority={active ? 'high' : 'auto'}
    onLoad={() => setLoaded(url)} onError={onError} /> : null;
}

export function HomeHero({ site }: { site: Site }) {
  const slides = heroSlides(site);
  if (!site.homeHeroEnabled || !slides.length) return null;
  return <HeroScreen key={JSON.stringify([slides, site.homeHeroRandom])} site={site} slides={slides} />;
}

function HeroScreen({ site, slides }: { site: Site; slides: { image: string; mobileImage: string; type?: 'image' | 'video'; mobileType?: 'image' | 'video' }[] }) {
  const [index, setIndex] = useState(() => site.homeHeroRandom ? Math.floor(Math.random() * slides.length) : 0);
  const [previous, setPrevious] = useState<number | null>(null);
  const [failed, setFailed] = useState(false);
  const [ready, setReady] = useState<string | null>(null);
  const [visible, setVisible] = useState(!document.hidden);
  const mobile = useMediaQuery('(max-width: 768px)');
  const reducedMotion = useMediaQuery('(prefers-reduced-motion: reduce)');
  const finePointer = useMediaQuery('(hover: hover) and (pointer: fine)');
  const root = useRef<HTMLElement>(null);
  const frame = useRef(0);
  const fit = site.homeHeroFit || 'cover';
  const parallax = site.homeHeroParallax !== false && !reducedMotion && finePointer && !mobile && fit === 'cover';
  const autoplay = !!site.homeHeroAutoplay && slides.length > 1 && !reducedMotion && visible;
  const interval = Math.max(3, Math.min(600, site.homeHeroInterval || 8)) * 1000;
  const activeSource = mobile ? slides[index].mobileImage || slides[index].image : slides[index].image || slides[index].mobileImage;
  const activeKey = `${index}-${activeSource}`;

  function select(next: number) {
    if (next === index) return;
    setPrevious(index);
    setIndex(next);
    setFailed(false);
    setReady(null);
  }
  useEffect(() => {
    const update = () => setVisible(!document.hidden);
    document.addEventListener('visibilitychange', update);
    return () => document.removeEventListener('visibilitychange', update);
  }, []);
  useEffect(() => {
    if (!autoplay || (ready !== activeKey && !failed)) return;
    const timer = window.setTimeout(() => {
      // Pick a different index even when the random source repeats.
      const next = site.homeHeroRandom
        ? (index + 1 + Math.floor(Math.random() * (slides.length - 1))) % slides.length
        : (index + 1) % slides.length;
      select(next);
    }, interval);
    return () => window.clearTimeout(timer);
  }, [autoplay, index, interval, site.homeHeroRandom, slides.length, ready, activeKey, failed]);
  useEffect(() => () => cancelAnimationFrame(frame.current), []);
  useEffect(() => {
    const element = root.current;
    if (!element) return;
    let scrollFrame = 0;
    const update = () => {
      scrollFrame = 0;
      const rect = element.getBoundingClientRect();
      const navHeight = document.getElementById('page-header')?.getBoundingClientRect().height ?? 0;
      const progress = Math.max(0, Math.min(1, -rect.top / Math.max(1, rect.height - navHeight)));
      element.style.setProperty('--hero-scroll-opacity', String(1 - progress));
    };
    const schedule = () => {
      if (!scrollFrame) scrollFrame = requestAnimationFrame(update);
    };
    update();
    window.addEventListener('scroll', schedule, { passive: true });
    window.addEventListener('resize', schedule);
    const observer = typeof ResizeObserver === 'undefined' ? null : new ResizeObserver(schedule);
    observer?.observe(element);
    return () => {
      cancelAnimationFrame(scrollFrame);
      observer?.disconnect();
      window.removeEventListener('scroll', schedule);
      window.removeEventListener('resize', schedule);
    };
  }, []);
  function resetPosition() {
    cancelAnimationFrame(frame.current);
    root.current?.style.setProperty('--hero-x', '0px');
    root.current?.style.setProperty('--hero-y', '0px');
  }
  useEffect(resetPosition, [parallax]);
  function move(event: PointerEvent<HTMLElement>) {
    if (!parallax || event.pointerType === 'touch') return;
    const rect = event.currentTarget.getBoundingClientRect();
    const x = (event.clientX - rect.left) / rect.width - 0.5;
    const y = (event.clientY - rect.top) / rect.height - 0.5;
    cancelAnimationFrame(frame.current);
    frame.current = requestAnimationFrame(() => {
      root.current?.style.setProperty('--hero-x', `${x * -28}px`);
      root.current?.style.setProperty('--hero-y', `${y * -20}px`);
    });
  }
  const imageSource = (i: number) => mobile ? slides[i].mobileImage || slides[i].image : slides[i].image || slides[i].mobileImage;
  const mediaType = (i: number) => {
    const slide = slides[i];
    return (mobile && slide.mobileImage) || !slide.image ? slide.mobileType : slide.type;
  };
  const layers = previous === null ? [index] : [previous, index];
  return <section id="home-hero" ref={root} className={`home-hero${parallax ? ' home-hero--parallax' : ''}`}
    aria-label="首页大屏" onPointerMove={move} onPointerLeave={resetPosition}
    style={{ '--hero-fit': fit, '--hero-position': site.homeHeroPosition || 'center',
      '--hero-overlay': Math.max(0, Math.min(80, site.homeHeroOverlay ?? 25)) / 100 } as CSSProperties}>
    <div className="home-hero__scene">
      <div className="home-hero__background">
      {layers.map(i => <HeroImage key={`${i}-${imageSource(i)}-${mediaType(i)}`} src={imageSource(i)} active={i === index}
        video={mediaType(i) === 'video'} motion={!reducedMotion && visible}
        onReady={() => { if (i === index) setReady(activeKey); }}
        onError={() => { if (i === index) setFailed(true); }} />)}
      </div>
      <div className="home-hero__shade" />
    </div>
    <div className="home-hero__text">
      {site.homeHeroTitle && <h1>{site.homeHeroTitle}</h1>}
      {site.homeHeroSubtitle && <p>{site.homeHeroSubtitle}</p>}
      {ready !== activeKey && !failed && previous === null && <small role="status" className="home-hero__loading">正在加载封面…</small>}
      {failed && <small role="status">素材暂时无法加载，可以继续向下浏览</small>}
    </div>
    <button className="home-hero__down" aria-label="向下浏览文章" onClick={() => {
      if (!root.current) return;
      const navHeight = document.getElementById('page-header')?.getBoundingClientRect().height ?? 0;
      // Explicit coordinates avoid stacking global scroll-padding with scroll-margin.
      const top = window.scrollY + root.current.getBoundingClientRect().bottom - navHeight;
      window.scrollTo({ top: Math.max(0, top), behavior: reducedMotion ? 'instant' : 'smooth' });
    }}><svg viewBox="0 0 24 24" width="32" height="32" aria-hidden="true"><path d="m5 9 7 7 7-7" fill="none" stroke="currentColor" strokeWidth="3" strokeLinecap="round" strokeLinejoin="round" /></svg></button>
  </section>;
}
