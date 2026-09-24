import type { MusicSnapshot, MusicTrack } from '@/service/api/music';

export const MAX_IMPORT_BYTES = 1024 * 1024;
export const DEFAULT_MUSIC_SOURCE = 'https://y.qq.com/n/ryqq/playlist/9766739035';
export function emptySnapshot(): MusicSnapshot {
  return { version: 1, title: '我的音乐馆', source: { provider: 'manual', id: '', url: '' }, tracks: [] };
}
function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === 'object' && value !== null && !Array.isArray(value);
}
function isProvider(value: unknown) { return value === 'manual' || value === 'tencent'; }
export function safeMusicUrl(value: string) {
  if (!value) return true;
  try { return ['https:', 'http:'].includes(new URL(value).protocol); } catch { return false; }
}
export function parseSnapshot(text: string): MusicSnapshot {
  if (new TextEncoder().encode(text).byteLength > MAX_IMPORT_BYTES) throw new Error('JSON 文件不能超过 1 MB');
  let value: unknown;
  try { value = JSON.parse(text); } catch { throw new Error('JSON 格式不正确'); }
  if (!isRecord(value) || value.version !== 1 || typeof value.title !== 'string' || !value.title.trim() ||
      !isRecord(value.source) || !isProvider(value.source.provider) || typeof value.source.id !== 'string' ||
      typeof value.source.url !== 'string' || !Array.isArray(value.tracks)) throw new Error('音乐库格式不正确，请导入完整的版本 1 快照');
  if (!safeMusicUrl(value.source.url)) throw new Error('歌单链接必须使用 HTTP 或 HTTPS');
  const ids = new Set<string>();
  for (const raw of value.tracks) {
    if (!isRecord(raw) || typeof raw.id !== 'string' || !raw.id.trim() || !isProvider(raw.provider) ||
        ['title', 'artist', 'album', 'cover', 'url', 'lyric', 'externalUrl'].some(key => typeof raw[key] !== 'string') ||
        !(raw.title as string).trim() || (raw.mid !== undefined && typeof raw.mid !== 'string')) {
      throw new Error('曲目格式不正确，请检查标识、名称和必填字段');
    }
    if (ids.has(raw.id)) throw new Error(`曲目标识重复：${raw.id}`);
    ids.add(raw.id);
    if (typeof raw.duration !== 'number' || !Number.isFinite(raw.duration) || raw.duration < 0) throw new Error('曲目时长必须是非负数字');
    if (['cover', 'url', 'externalUrl'].some(key => !safeMusicUrl(raw[key] as string))) throw new Error('封面、音源和官方链接必须使用 HTTP 或 HTTPS');
  }
  return value as unknown as MusicSnapshot;
}
export function updateTrack(snapshot: MusicSnapshot, track: MusicTrack): MusicSnapshot {
  const tracks = snapshot.tracks.some(item => item.id === track.id)
    ? snapshot.tracks.map(item => item.id === track.id ? { ...track } : { ...item })
    : [...snapshot.tracks.map(item => ({ ...item })), { ...track }];
  return { ...snapshot, source: { ...snapshot.source }, tracks };
}
export function removeTrack(snapshot: MusicSnapshot, id: string): MusicSnapshot {
  return { ...snapshot, source: { ...snapshot.source }, tracks: snapshot.tracks.filter(track => track.id !== id).map(track => ({ ...track })) };
}
export function previewIsExpired(createdAt: string, now = Date.now()) {
  const created = Date.parse(createdAt);
  return !Number.isFinite(created) || now >= created + 24 * 60 * 60 * 1000;
}

export function serializeSnapshot(snapshot: MusicSnapshot): string {
  return JSON.stringify(snapshot);
}
