import { api, detail, list, mediaUrl } from '../../services/api';
import type { Content } from '../../types';

export interface MusicTrack {
  id: string; provider: 'tencent' | 'manual'; mid?: string; title: string; artist: string;
  album: string; cover: string; duration: number; url: string; lyric: string; externalUrl: string;
  legacyId?: number;
}
export interface MusicSnapshot {
  version: 1; configured?: boolean; warning?: string; title: string; source: { provider: 'tencent' | 'manual'; id: string; url: string }; tracks: MusicTrack[];
}
export interface MusicMedia { url: string; lyric: string; message: string }
function manualTrack(item: Content): MusicTrack {
  return { id: `legacy:${item.id}`, legacyId: item.id, provider: 'manual', title: item.title,
    artist: String(item.metadata?.artist || ''), album: String(item.metadata?.album || ''), cover: item.cover,
    duration: Number(item.metadata?.duration) || 0, url: item.url, lyric: String(item.metadata?.lyrics || ''), externalUrl: '' };
}
export async function loadMusicLibrary(): Promise<MusicSnapshot> {
  let snapshot: MusicSnapshot = { version: 1, title: '我的音乐', source: { provider: 'manual', id: '', url: '' }, tracks: [] };
  const warnings: string[] = [];
  let libraryLoaded = false;
  try { snapshot = await api<MusicSnapshot>('/blog/public/music'); libraryLoaded = true; }
  catch { warnings.push('歌单音乐库暂时未能加载'); }
  const tracks: MusicTrack[] = [];
  let page = 1;
  let seen = 0;
  try {
    while (true) {
      const result = await list('music', { page, pageSize: 100 });
      tracks.push(...result.items.filter(item => !item.locked).map(manualTrack));
      seen += result.items.length;
      if (!result.items.length || seen >= result.total) break;
      page += 1;
    }
  } catch {
    if (!libraryLoaded && !tracks.length) throw new Error('音乐库暂时无法加载，请稍后重试');
    warnings.push('手动音乐未能完整加载');
  }
  return { ...snapshot, tracks: [...snapshot.tracks, ...tracks], ...(warnings.length ? { warning: `${warnings.join('；')}，已保留可用曲目。` } : {}) };
}
export async function resolveMusicMedia(track: MusicTrack): Promise<MusicMedia> {
  let result: MusicMedia;
  if (track.legacyId !== undefined) {
    const item = await detail('music', track.legacyId);
    if (item.locked) throw new Error('该曲目已锁定，请先登录或解锁后再收听');
    result = { url: item.url, lyric: String(item.metadata?.lyrics || ''), message: '' };
  } else if (track.provider === 'manual') result = { url: track.url, lyric: track.lyric, message: '' };
  else result = await api<MusicMedia>(`/blog/public/music/tracks/${encodeURIComponent(track.id)}/media`);
  return { ...result, url: result.url ? await mediaUrl(result.url) : '' };
}
