import { useEffect, useMemo, useRef, useState } from 'react';
import { loadMusicLibrary, resolveMusicMedia, type MusicSnapshot, type MusicTrack } from './music-service';
import { lyricIndex, parseLyrics } from './lyrics';
export type PlayMode = 'loop' | 'single' | 'shuffle';
export const playModes: PlayMode[] = ['loop', 'single', 'shuffle'];
export const playModeLabels = { loop: '列表循环', single: '单曲循环', shuffle: '随机播放' };
export function musicTime(value: number) { const n = Number.isFinite(value) ? Math.max(0, Math.floor(value)) : 0; return `${Math.floor(n / 60)}:${String(n % 60).padStart(2, '0')}`; }
function release(url: string) { if (url.startsWith('blob:')) URL.revokeObjectURL(url); }
export function useMusicPlayback(revision: number) {
  const [library, setLibrary] = useState<MusicSnapshot | null>(null);
  const [loadError, setLoadError] = useState('');
  const [reload, setReload] = useState(0);
  const [index, setIndex] = useState(0);
  const [playing, setPlaying] = useState(false);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const [position, setPosition] = useState(0);
  const [duration, setDuration] = useState(0);
  const [volume, setVolume] = useState(.7);
  const lastVolume = useRef(.7);
  const [mode, setMode] = useState<PlayMode>('loop');
  const [lyric, setLyric] = useState('');
  const audio = useRef<HTMLAudioElement>(null);
  const request = useRef(0);
  const source = useRef('');
  const selected = useRef(0);
  const skipped = useRef(new Set<string>());
  const skipTimer = useRef<ReturnType<typeof setTimeout> | undefined>(undefined);
  const timeout = useRef<ReturnType<typeof setTimeout> | undefined>(undefined);
  const tracks = library?.tracks || [];
  const current = tracks[index];
  const lines = useMemo(() => parseLyrics(lyric), [lyric]);
  const activeLine = lyricIndex(lines, position);
  const clearTimers = () => { clearTimeout(skipTimer.current); clearTimeout(timeout.current); skipTimer.current = undefined; timeout.current = undefined; };
  const stop = () => {
    clearTimers(); request.current += 1;
    audio.current?.pause(); audio.current?.removeAttribute('src'); audio.current?.load();
    release(source.current); source.current = '';
  };
  useEffect(() => {
    let live = true;
    stop(); skipped.current.clear(); selected.current = 0;
    setLibrary(null); setLoadError(''); setIndex(0); setPlaying(false); setLoading(false); setError(''); setPosition(0); setDuration(0);
    loadMusicLibrary().then(data => { if (live) { setLibrary(data); setLyric(data.tracks[0]?.lyric || ''); } }).catch(e => { if (live) setLoadError(e.message || '歌单加载失败'); });
    const element = audio.current;
    return () => { live = false; clearTimers(); request.current += 1; element?.pause(); element?.removeAttribute('src'); element?.load(); release(source.current); source.current = ''; };
  }, [revision, reload]);
  useEffect(() => { if (audio.current) audio.current.volume = volume; if (volume > 0) lastVolume.current = volume; }, [volume]);
  const failed = (message: string) => {
    const failedIndex = selected.current;
    const failedTrack = tracks[failedIndex];
    if (failedTrack) skipped.current.add(failedTrack.id);
    stop(); setPlaying(false);
    const candidates = tracks.map((_, step) => (failedIndex + step + 1) % tracks.length).filter(i => !skipped.current.has(tracks[i].id));
    if (!candidates.length) { setLoading(false); setError(`${message}。当前歌单暂无可播放歌曲，已停止尝试。`); return; }
    const next = mode === 'shuffle' ? candidates[Math.floor(Math.random() * candidates.length)] : candidates[0];
    setLoading(true); setError(`「${failedTrack?.title || '当前歌曲'}」无法播放，即将跳过。`);
    const version = request.current;
    skipTimer.current = setTimeout(() => { if (request.current === version) void start(tracks[next], next, true); }, 350);
  };
  const rejected = (error: unknown) => {
    if ((error as { name?: string })?.name === 'NotAllowedError') {
      clearTimers(); audio.current?.pause(); setPlaying(false); setLoading(false); setError('浏览器未允许播放，请再次点击播放按钮');
    } else failed((error as Error)?.message || '音频播放失败');
  };
  const start = async (track: MusicTrack, selectedIndex: number, automatic = false) => {
    stop(); if (!automatic) skipped.current.clear();
    const version = request.current; selected.current = selectedIndex;
    setIndex(selectedIndex); setPlaying(false); setLoading(true); setError(''); setPosition(0); setDuration(track.duration); setLyric(track.lyric || '');
    timeout.current = setTimeout(() => { if (request.current === version) failed('音频加载超时'); }, 20000);
    try {
      const media = await resolveMusicMedia(track);
      if (version !== request.current || !audio.current) { release(media.url); return; }
      if (media.lyric) setLyric(media.lyric);
      if (!media.url) { failed(media.message || '当前歌曲暂无音源'); return; }
      source.current = media.url; audio.current.src = media.url;
      await audio.current.play();
      if (version === request.current) { clearTimeout(timeout.current); setLoading(false); }
    } catch (e) { if (version === request.current) rejected(e); }
  };
  const toggle = async () => {
    if (!current || !audio.current) return;
    if (loading) { stop(); skipped.current.clear(); setLoading(false); setError(''); return; }
    if (playing) { clearTimers(); audio.current.pause(); return; }
    if (!source.current) { await start(current, index); return; }
    const version = request.current;
    try { await audio.current.play(); } catch (e) { if (version === request.current) rejected(e); }
  };
  const advance = (direction: number) => {
    if (!tracks.length) return;
    let next = (selected.current + direction + tracks.length) % tracks.length;
    if (mode === 'shuffle' && tracks.length > 1) next = (selected.current + 1 + Math.floor(Math.random() * (tracks.length - 1))) % tracks.length;
    void start(tracks[next], next);
  };
  const seek = (value: number) => {
    if (!audio.current || !source.current || !Number.isFinite(value)) return;
    const target = Math.max(0, Math.min(value, duration || current?.duration || 0));
    audio.current.currentTime = target; setPosition(target);
  };
  useEffect(() => {
    const listener = (event: Event) => { const command = (event as CustomEvent).detail; if (command === 'next') advance(1); else if (command === 'previous') advance(-1); else if (command === 'toggle') void toggle(); };
    window.addEventListener('blog-player', listener);
    return () => window.removeEventListener('blog-player', listener);
  });
  const audioProps = {
    ref: audio, preload: 'none',
    onPlay: () => { setPlaying(true); setError(''); },
    onPause: () => setPlaying(false),
    onTimeUpdate: () => { const value = audio.current?.currentTime || 0; setPosition(value); if (value > 1) skipped.current.clear(); },
    onLoadedMetadata: () => { const value = audio.current?.duration; if (value && Number.isFinite(value)) setDuration(value); },
    onEnded: () => { setPlaying(false); if (mode === 'single' && current) void start(current, index); else advance(1); },
    onError: () => { if (source.current) failed('音频加载失败，可能已过期或受平台限制'); },
  };
  return { library, loadError, reload: () => setReload(v => v + 1), index, playing, loading, error, position, duration, volume, setVolume, lastVolume, mode, setMode, lyric, tracks, current, lines, activeLine, start, toggle, advance, seek, audioProps };
}
