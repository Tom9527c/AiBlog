import { useEffect, useRef, useState } from 'react';
import { Link } from 'react-router-dom';
import { Media, useBlog } from '../../../components';
import type { Content } from '../../../types';
import { useMusicPlayback, musicTime, playModes, playModeLabels } from '../useMusicPlayback';
import '../floating-player.css';
export function FloatingPlayer({ track }: { track: Content | null }) {
  const { revision } = useBlog();
  const p = useMusicPlayback(revision);
  const [open, setOpen] = useState(false);
  const [showLyrics, setShowLyrics] = useState(true);
  const root = useRef<HTMLDivElement>(null);
  const handled = useRef<Content | null>(null);
  const total = p.duration || p.current?.duration || 0;
  const activeText = p.lines[p.activeLine]?.text || (p.lyric && !p.lines.length ? p.lyric.split('\n').find(Boolean) : '') || (p.playing ? '纯音乐，请欣赏' : '让音乐，陪你一会儿');
  useEffect(() => {
    if (!track || track === handled.current || !p.library) return;
    const index = p.tracks.findIndex(item => item.legacyId === track.id);
    handled.current = track;
    if (index >= 0) void p.start(p.tracks[index], index);
  }, [track, p.library]);
  useEffect(() => {
    const command = (e: Event) => { if ((e as CustomEvent).detail === 'open') setOpen(v => !v); };
    const outside = (e: PointerEvent) => { if (!root.current?.contains(e.target as Node)) setOpen(false); };
    const escape = (e: KeyboardEvent) => { if (e.key === 'Escape') setOpen(false); };
    window.addEventListener('blog-player', command); document.addEventListener('pointerdown', outside); document.addEventListener('keydown', escape);
    return () => { window.removeEventListener('blog-player', command); document.removeEventListener('pointerdown', outside); document.removeEventListener('keydown', escape); };
  }, []);
  return <div ref={root} id="nav-music" className={`floating-player${p.playing ? ' is-playing' : ''}${open ? ' is-expanded' : ''}`} aria-label="浮动音乐播放器">
    <audio {...p.audioProps} />
    <div className="floating-capsule">
      <button className="floating-disc" aria-label={p.loading ? '取消加载' : p.playing ? '暂停' : '播放'} disabled={!p.current} onClick={() => void p.toggle()}>
        {p.current?.cover ? <Media src={p.current.cover} alt={`${p.current.title}封面`} className="floating-art" /> : <span className="floating-art floating-art-empty">♫</span>}
        <span className="floating-play-icon" aria-hidden="true">{p.loading ? '•••' : p.playing ? 'Ⅱ' : '▶'}</span>
      </button>
      <button className="floating-title" aria-label={open ? '收起播放器' : '展开播放器'} aria-expanded={open} aria-controls="floating-music-panel" onClick={() => setOpen(v => !v)}>{p.current?.title || '音乐随行'}</button>
      {showLyrics && <button className="floating-lyric" title={activeText} aria-label="查看歌词与播放进度" onClick={() => setOpen(v => !v)}>{activeText}</button>}
    </div>
    {open && <section id="floating-music-panel" className="floating-panel" aria-label="音乐播放控制">
      <header><div><strong>{p.current?.title || '音乐随行'}</strong><small>{p.current?.artist || '选择一首喜欢的歌'}</small></div><button aria-label="关闭播放器面板" onClick={() => setOpen(false)}>×</button></header>
      <p className="floating-panel-lyric">{activeText}</p>
      <input className="floating-range" aria-label="播放进度" type="range" min="0" max={total || 1} step="0.1" value={Math.min(p.position, total || 1)} disabled={!p.current || p.loading || !total} onChange={e => p.seek(Number(e.target.value))} style={{ '--fill': `${total ? Math.min(100, p.position / total * 100) : 0}%` } as React.CSSProperties} />
      <div className="floating-time"><span>{musicTime(p.position)} / {musicTime(total)}</span><button aria-pressed={showLyrics} onClick={() => setShowLyrics(v => !v)}>{showLyrics ? '隐藏浮球歌词' : '显示浮球歌词'}</button></div>
      <div className="floating-controls"><button aria-label="上一首" disabled={!p.current} onClick={() => p.advance(-1)}>◀❘</button><button aria-label="下一首" disabled={!p.current} onClick={() => p.advance(1)}>❘▶</button><button className="floating-mode" aria-label={`播放模式：${playModeLabels[p.mode]}`} onClick={() => p.setMode(playModes[(playModes.indexOf(p.mode) + 1) % playModes.length])}>{playModeLabels[p.mode]}</button><button aria-label={p.volume ? '静音' : '取消静音'} onClick={() => p.setVolume(p.volume ? 0 : p.lastVolume.current)}>{p.volume ? '♪' : '×'}</button><input className="floating-range floating-volume" aria-label="音量" type="range" min="0" max="1" step="0.01" value={p.volume} onChange={e => p.setVolume(Number(e.target.value))} style={{ '--fill': `${p.volume * 100}%` } as React.CSSProperties}/></div>
      {p.loadError && <p role="alert">{p.loadError} <button onClick={p.reload}>重试加载</button></p>}
      {p.library?.warning && <p role="status">{p.library.warning} <button onClick={p.reload}>重试加载</button></p>}
      <div className="floating-queue" aria-label="浮球播放列表">{p.tracks.map((song, i) => <button key={song.id} aria-current={p.index === i ? 'true' : undefined} aria-label={`播放 ${song.title} — ${song.artist}`} onClick={() => void p.start(song, i)}><span>{String(i + 1).padStart(2, '0')}</span><span>{song.title}</span><small>{song.artist || '未知歌手'}</small></button>)}</div>
      {!p.library && !p.loadError && <p>正在加载歌单…</p>}{p.library && !p.tracks.length && <p>还没有可播放的音乐</p>}
      <Link className="floating-room-link" to="/music/">打开音乐馆 ↗</Link>
    </section>}
    {p.error && <div className="floating-error" role="alert">{p.error}</div>}
  </div>;
}
