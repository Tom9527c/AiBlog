import { useEffect, useRef, useState } from 'react';
import { useLocation } from 'react-router-dom';
import { Media, useBlog } from '../../components';
import { safeUrl } from '../../services/api';
import { useMusicPlayback, musicTime as time, playModes as modes, playModeLabels as labels } from './useMusicPlayback';
import { pageHeaderSettings } from '../../components/page/page-header';
import { PageHeader } from '../../components/page/PageHeader';
import './music.css';

function Icon({ name }: { name: 'play' | 'pause' | 'previous' | 'next' | 'volume' | 'muted' | 'loop' | 'single' | 'shuffle' | 'music' }) {
  const paths = {
    play: <path d="m8 5 11 7-11 7Z" fill="currentColor" stroke="none"/>,
    pause: <path d="M7 5h4v14H7zm7 0h4v14h-4z" fill="currentColor" stroke="none"/>,
    previous: <><path d="m18 5-10 7 10 7Z" fill="currentColor" stroke="none"/><path d="M5 5v14"/></>,
    next: <><path d="m6 5 10 7-10 7Z" fill="currentColor" stroke="none"/><path d="M19 5v14"/></>,
    volume: <><path d="M4 9h4l5-4v14l-5-4H4Z"/><path d="M17 8a6 6 0 0 1 0 8m3-11a10 10 0 0 1 0 14"/></>,
    muted: <><path d="M4 9h4l5-4v14l-5-4H4Z"/><path d="m17 9 5 6m0-6-5 6"/></>,
    loop: <><path d="m17 2 4 4-4 4M3 11V9a3 3 0 0 1 3-3h15M7 22l-4-4 4-4m14-1v2a3 3 0 0 1-3 3H3"/></>,
    single: <><path d="m17 2 4 4-4 4M3 11V9a3 3 0 0 1 3-3h15M7 22l-4-4 4-4m14-1v2a3 3 0 0 1-3 3H3M11 10l2-1v6"/></>,
    shuffle: <><path d="M3 5h3c5 0 7 14 12 14h3m-4-4 4 4-4 3M3 19h3c2 0 4-3 5-5m2-4c2-4 3-5 5-5h3m-4-3 4 3-4 4"/></>,
    music: <><path d="M9 18V5l11-2v13M9 8l11-2"/><ellipse cx="6" cy="18" rx="3" ry="2"/><ellipse cx="17" cy="16" rx="3" ry="2"/></>,
  };
  return <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.6" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">{paths[name]}</svg>;
}
export function Music() {
  const { site, revision } = useBlog();
  const location = useLocation();
  const heading = pageHeaderSettings(site, 'music');
  const pageTitle = heading.enabled ? heading.title || '音乐馆' : '音乐馆';
  const player = useMusicPlayback(revision);
  const { library, loadError, index, playing, loading, error, position, duration, volume, setVolume, lastVolume, mode, setMode, lyric, tracks, current, lines, activeLine, start, toggle, advance, seek } = player;
  const [tab, setTab] = useState<'list' | 'lyrics'>('list');
  const lyricContainer = useRef<HTMLDivElement>(null);
  const backdrop = current?.cover;
  useEffect(() => { document.title = `${pageTitle} | ${site?.title || '博客'}`; }, [site?.title, pageTitle]);
  useEffect(() => {
    const container = lyricContainer.current;
    if (!container) return;
    const align = (smooth: boolean) => {
      if (!container.clientHeight) return;
      // The first/last line also need room to reach the middle of the viewport.
      container.style.setProperty('--lyrics-half-height', `${container.clientHeight / 2}px`);
      const row = container.querySelector<HTMLElement>('[aria-current="true"]');
      if (!row) { container.scrollTo?.({ top: 0, behavior: 'instant' }); return; }
      // Both rects use viewport coordinates; offsetTop values may have different parents.
      const top = container.scrollTop + row.getBoundingClientRect().top - container.getBoundingClientRect().top
        - container.clientHeight / 2 + row.getBoundingClientRect().height / 2;
      container.scrollTo?.({ top: Math.max(0, top), behavior: smooth && !window.matchMedia?.('(prefers-reduced-motion: reduce)').matches ? 'smooth' : 'instant' });
    };
    align(true);
    const observer = typeof ResizeObserver === 'undefined' ? null : new ResizeObserver(() => align(false));
    observer?.observe(container);
    return () => observer?.disconnect();
  }, [activeLine, lines, tab, current?.id]);
  useEffect(() => {
    const listener = (event: Event) => { if ((event as CustomEvent).detail === 'open') setTab('list'); };
    window.addEventListener('blog-player', listener);
    return () => window.removeEventListener('blog-player', listener);
  }, []);
  const query = new URLSearchParams(location.search);
  const requestedId = query.get('id');
  const requestedServer = query.get('server');
  const mismatch = library && ((requestedId && requestedId !== library.source.id) || (requestedServer && requestedServer !== library.source.provider));
  return <>{heading.enabled && <div className="music-page-cover"><PageHeader page="music" title="音乐馆" /></div>}<section className="music-library" aria-label="音乐馆">
    <div className="music-atmosphere" aria-hidden="true">{backdrop && <Media src={backdrop} alt="" className="music-atmosphere-image" />}</div>
    <audio {...player.audioProps} />
    <header className="music-heading"><div><span className="music-eyebrow">MUSIC LIBRARY</span>{heading.enabled ? <span className="music-room-label">播放列表</span> : <h1>音乐馆<span>让音乐，陪你一会儿</span></h1>}</div><span className="music-library-source">{tracks.some(t => t.provider === 'tencent') ? (tracks.some(t => t.provider === 'manual') ? 'QQ 音乐 + 手动音乐' : 'QQ 音乐') : '私人歌单'}<i/> {tracks.length} 首音乐</span></header>
    {mismatch && <p className="music-notice" role="status">此链接的歌单或平台尚未配置，正在显示当前配置的歌单：{library.title}。</p>}
    {library?.warning && <p className="music-notice" role="status">{library.warning} <button onClick={player.reload}>重试加载</button></p>}
    {loadError && <p className="music-notice" role="alert">{loadError} <button onClick={player.reload}>重新加载</button></p>}
    <div className="music-mobile-tabs" role="tablist" aria-label="音乐视图"><button role="tab" aria-selected={tab === 'list'} aria-controls="music-queue" onClick={() => setTab('list')}>播放列表</button><button role="tab" aria-selected={tab === 'lyrics'} aria-controls="music-now-playing" onClick={() => setTab('lyrics')}>正在播放</button></div>
    <div className={`music-body music-tab-${tab}`}>
      <section id="music-queue" className="music-queue" aria-label="播放列表"><div className="music-queue-heading"><h2>{library?.title || '我的歌单'}</h2><span>歌曲 / 歌手</span></div>
        <div className="music-track-list">{!library && !loadError && <p className="music-empty">正在加载歌单…</p>}{library && !tracks.length && <p className="music-empty">歌单还空着，等一首喜欢的歌。</p>}
        {tracks.map((track, i) => <button key={track.id} className={`music-track${i === index ? ' is-current' : ''}`} aria-label={`播放 ${track.title} — ${track.artist}`} aria-current={i === index ? 'true' : undefined} onClick={() => void start(track, i)}><span className="music-track-number">{i === index ? <Icon name={playing ? 'volume' : 'music'}/> : String(i + 1).padStart(2, '0')}</span><span className="music-track-title">{track.title}</span><span className="music-track-artist">{track.artist || '未知歌手'}</span><span className="music-track-duration">{track.duration ? time(track.duration) : '—'}</span></button>)}
        </div><div className="music-queue-caption">{library?.source.provider === 'tencent' ? '收藏的旋律，在这里相遇' : '把喜欢的歌，留在这里'}</div>
      </section>
      <section id="music-now-playing" className="music-now-playing" aria-label="正在播放"><div className="music-song-card"><div className="music-cover">{current?.cover ? <Media src={current.cover} alt={`${current.title} 专辑封面`}/> : <div className="music-cover-placeholder"><Icon name="music"/></div>}</div><div className="music-song-meta"><span className="music-eyebrow">{playing ? 'NOW PLAYING' : 'READY TO PLAY'}</span><h2>{current?.title || '等待一首好歌'}</h2><p>{current?.artist || '音乐是生活的另一种语言'}</p>{current?.album && <small>{current.album}</small>}</div></div>
        <div className="music-lyrics" ref={lyricContainer} aria-label="歌词">{lines.length ? <div className="music-lyric-lines">{lines.map((line, i) => <p key={`${line.time}-${i}`} aria-current={activeLine === i ? 'true' : undefined}>{line.text}</p>)}</div> : <p className="music-lyrics-empty">{lyric.trim() || (current ? '点击播放，让旋律与歌词一起流动' : '歌单中的故事，即将在这里响起')}</p>}</div>

      </section>
    </div>
        {error && <div className="music-playback-error" role="alert"><p>{error}</p>{current?.externalUrl && <a href={safeUrl(current.externalUrl)} target="_blank" rel="noreferrer">在 QQ 音乐收听</a>}</div>}
    <footer className="music-player-bar"><div className="music-transport"><button aria-label="上一首" disabled={!current} onClick={() => advance(-1)}><Icon name="previous"/></button><button className="music-play-button" aria-label={loading ? '取消加载' : playing ? '暂停' : '播放'} disabled={!current} onClick={() => void toggle()}>{loading ? <span className="music-loading"/> : <Icon name={playing ? 'pause' : 'play'}/>}</button><button aria-label="下一首" disabled={!current} onClick={() => advance(1)}><Icon name="next"/></button></div>
      <div className="music-progress"><div className="music-progress-label"><span>{current ? `${current.title} — ${current.artist || '未知歌手'}` : '选择一首喜欢的音乐'}</span><span>{time(position)} <i>/</i> {time(duration || current?.duration || 0)}</span></div><input type="range" aria-label="播放进度" min="0" max={duration || current?.duration || 1} step="0.1" value={Math.min(position, duration || current?.duration || 1)} onChange={e => seek(Number(e.target.value))} disabled={!current} style={{ '--music-progress': `${position / (duration || current?.duration || 1) * 100}%` } as React.CSSProperties}/></div>
      <div className="music-player-options"><button aria-label={`播放模式：${labels[mode]}`} title={labels[mode]} onClick={() => setMode(modes[(modes.indexOf(mode) + 1) % modes.length])}><Icon name={mode}/></button><button aria-label={volume ? '静音' : '取消静音'} onClick={() => setVolume(volume ? 0 : lastVolume.current)}><Icon name={volume ? 'volume' : 'muted'}/></button><input type="range" aria-label="音量" aria-valuetext={`${Math.round(volume * 100)}%`} style={{ '--music-progress': `${volume * 100}%` } as React.CSSProperties} min="0" max="1" step="0.01" value={volume} onChange={e => setVolume(Number(e.target.value))}/></div>
    </footer>
  </section></>;
}
export default Music;
