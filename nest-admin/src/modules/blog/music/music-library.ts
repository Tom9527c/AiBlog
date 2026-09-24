import { BadRequestException } from '@nestjs/common';
export interface MusicTrack { id: string; provider: 'tencent' | 'manual'; mid?: string; title: string; artist: string; album: string; cover: string; duration: number; url: string; lyric: string; externalUrl: string; }
export interface MusicSnapshot { version: 1; title: string; source: { provider: 'tencent' | 'manual'; id: string; url: string }; tracks: MusicTrack[]; }
export interface MusicPreview { token: string; baseRevision: number; createdAt: string; snapshot: MusicSnapshot; diff: ReturnType<typeof playlistDiff>; }
export interface MusicLibraryState { revision: number; snapshot: MusicSnapshot | null; previousSnapshot: MusicSnapshot | null; pending: MusicPreview | null; lastAttemptAt: string | null; lastSuccessAt: string | null; lastError: string; consecutiveFailures: number; operationId?: string; }
export const emptyLibrary = (): MusicLibraryState => ({ revision: 0, snapshot: null, previousSnapshot: null, pending: null, lastAttemptAt: null, lastSuccessAt: null, lastError: '', consecutiveFailures: 0 });
export const emptySnapshot = (): MusicSnapshot => ({ version: 1, title: '音乐馆', source: { provider: 'manual', id: '', url: '' }, tracks: [] });
export function playlistId(input: unknown): string {
  if (typeof input !== 'string') throw new BadRequestException('请输入 QQ 音乐歌单链接或 ID');
  if (/^\d{1,15}$/.test(input.trim())) return input.trim();
  try {
    const u = new URL(input.trim());
    if (u.hostname !== 'y.qq.com' || !['http:', 'https:'].includes(u.protocol) || u.username || u.password || u.port) throw new Error();
    const id = u.searchParams.get('id') || /\/playlist\/(\d+)/.exec(u.pathname)?.[1];
    if (id && /^\d{1,15}$/.test(id)) return id;
  } catch { /* Validation below. */ }
  throw new BadRequestException('仅支持 y.qq.com 歌单链接或数字歌单 ID');
}
function text(v: unknown, max: number, label: string, required = false): string {
  if (v === undefined || v === null) v = '';
  if (typeof v !== 'string' || v.length > max || (required && !v.trim())) throw new BadRequestException(`${label}格式错误或长度超限`);
  return v as string;
}
export function musicUrl(value: unknown, label: string): string {
  const v = text(value, 2048, label);
  if (!v) return '';
  try {
    const u = new URL(v);
    if (!['https:', 'http:'].includes(u.protocol) || u.username || u.password) throw new Error();
    return v;
  } catch { throw new BadRequestException(`${label}需要完整的 HTTP(S) 地址`); }
}
export function normalizeSnapshot(input: any): MusicSnapshot {
  if (!input || typeof input !== 'object' || JSON.stringify(input).length > 1048576 || Buffer.byteLength(JSON.stringify(input)) > 1048576) throw new BadRequestException('歌单不能超过 1 MiB');
  if (input.version !== 1 || !Array.isArray(input.tracks) || input.tracks.length > 1000) throw new BadRequestException('歌单格式错误（version=1，最多 1000 首）');
  if (!['tencent', 'manual'].includes(input.source?.provider)) throw new BadRequestException('歌单来源错误');
  const source = { provider: input.source.provider, id: text(input.source.id, 30, '来源 ID'), url: musicUrl(input.source.url, '来源链接') };
  if (source.provider === 'tencent') { source.id = playlistId(source.id); source.url = `https://y.qq.com/n/ryqq/playlist/${source.id}`; }
  const ids = new Set<string>();
  const tracks = input.tracks.map((t: any): MusicTrack => {
    if (!t || !['tencent', 'manual'].includes(t.provider)) throw new BadRequestException('曲目来源错误');
    const id = text(t.id, 100, '曲目标识', true);
    if (!/^(tencent|manual):[A-Za-z0-9_-]+$/.test(id) || !id.startsWith(t.provider + ':')) throw new BadRequestException('曲目标识格式错误');
    if (ids.has(id)) throw new BadRequestException('歌单存在重复曲目标识');
    ids.add(id);
    const mid = t.provider === 'tencent' ? text(t.mid, 40, 'QQ 曲目标识', true) : undefined;
    if (mid && (!/^[A-Za-z0-9]+$/.test(mid) || id !== `tencent:${mid}`)) throw new BadRequestException('QQ 曲目标识不匹配');
    const duration = t.duration ?? 0;
    if (typeof duration !== 'number' || !Number.isFinite(duration) || duration < 0 || duration > 86400) throw new BadRequestException('时长格式错误');
    return { id, provider: t.provider, ...(mid ? { mid } : {}), title: text(t.title, 300, '歌名', true), artist: text(t.artist, 500, '歌手'), album: text(t.album, 300, '专辑'), cover: musicUrl(t.cover, '封面'), duration, url: musicUrl(t.url, '音频'), lyric: text(t.lyric, 50000, '歌词'), externalUrl: mid ? `https://y.qq.com/n/ryqq/songDetail/${mid}` : musicUrl(t.externalUrl, '歌曲链接') };
  });
  return { version: 1, title: text(input.title, 200, '歌单名', true), source, tracks };
}
export function playlistDiff(before: MusicSnapshot | null, after: MusicSnapshot) {
  const old = new Map((before?.tracks || []).map(t => [t.id, t]));
  const next = new Set(after.tracks.map(t => t.id));
  return { added: after.tracks.filter(t => !old.has(t.id)), removed: [...old.values()].filter(t => !next.has(t.id)), changed: after.tracks.filter(t => old.has(t.id) && JSON.stringify(t) !== JSON.stringify(old.get(t.id))), suspicious: Boolean(before?.tracks.length && (after.tracks.length === 0 || after.tracks.length < before.tracks.length * .7)) };
}
