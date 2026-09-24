import { api } from './blog';

export interface MusicTrack {
  id: string;
  provider: 'tencent' | 'manual';
  mid?: string;
  title: string;
  artist: string;
  album: string;
  cover: string;
  duration: number;
  url: string;
  lyric: string;
  externalUrl: string;
}
export interface MusicSnapshot {
  version: 1;
  title: string;
  source: { provider: 'tencent' | 'manual'; id: string; url: string };
  tracks: MusicTrack[];
}
export interface MusicPreview {
  token: string;
  baseRevision: number;
  createdAt: string;
  snapshot: MusicSnapshot;
  diff: { added: MusicTrack[]; removed: MusicTrack[]; changed: MusicTrack[]; suspicious: boolean };
}
export interface MusicState {
  revision: number;
  snapshot: MusicSnapshot | null;
  previousSnapshot?: MusicSnapshot | null;
  pending: MusicPreview | null;
  lastAttemptAt: string | null;
  lastSuccessAt: string | null;
  lastError: string;
  consecutiveFailures: number;
}
export const getMusicLibrary = () => api<MusicState>('music-library');
export const previewMusicLibrary = (source: string, revision: number) =>
  api<MusicState>('music-library/preview', 'post', { source, revision });
export const importMusicLibrary = (snapshot: MusicSnapshot, revision: number) =>
  api<MusicState>('music-library/import', 'post', { snapshot, revision });
export const applyMusicLibrary = (token: string, revision: number) =>
  api<MusicState>('music-library/apply', 'post', { token, revision });
