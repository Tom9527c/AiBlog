import { BadRequestException, ConflictException, Injectable, NotFoundException } from '@nestjs/common';
import { randomUUID } from 'node:crypto';
import { MusicLibraryState, MusicSnapshot, emptySnapshot, normalizeSnapshot, playlistDiff, playlistId } from './music-library';
import { MusicLibraryStore } from './music-library.store';
import { QQMusicProvider } from './qq-music.provider';
@Injectable()
export class MusicLibraryService {
  constructor(private readonly store: MusicLibraryStore, private readonly qq: QQMusicProvider) {}
  private mediaCache = new Map<string, { expires: number; promise: Promise<{ url: string; lyric: string; message: string }> }>();
  private checkRevision(state: MusicLibraryState, revision: number) {
    if (!Number.isInteger(revision) || revision !== state.revision) throw new ConflictException('歌单已被其他操作更新，请刷新后重试');
  }
  private visible(state: MusicLibraryState) { const { operationId, ...data } = state; return data; }
  async admin() { return this.visible(await this.store.read()); }
  async publicSnapshot() { const snapshot = (await this.store.read()).snapshot; return { ...(snapshot || emptySnapshot()), configured: snapshot !== null }; }
  async preview(source: string, revision: number) {
    const id = playlistId(source);
    const operationId = randomUUID();
    await this.store.update(s => { this.checkRevision(s, revision); s.operationId = operationId; s.pending = null; s.lastAttemptAt = new Date().toISOString(); });
    let snapshot: MusicSnapshot;
    try { snapshot = await this.qq.playlist(id); }
    catch (e) {
      return this.visible(await this.store.update(s => {
        this.checkRevision(s, revision);
        if (s.operationId !== operationId) throw new ConflictException('已有更新的同步操作，请刷新');
        s.lastError = e?.getStatus ? e.message.slice(0, 300) : 'QQ 歌单获取失败，已保留原数据；可重试或导入 JSON';
        s.consecutiveFailures += 1;
        delete s.operationId;
      }));
    }
    return this.visible(await this.store.update(s => {
      this.checkRevision(s, revision);
      if (s.operationId !== operationId) throw new ConflictException('已有更新的同步操作，请刷新');
      this.setPreview(s, snapshot);
      s.lastSuccessAt = new Date().toISOString(); s.lastError = ''; s.consecutiveFailures = 0;
      delete s.operationId;
    }));
  }
  private setPreview(state: MusicLibraryState, snapshot: MusicSnapshot) {
    state.pending = { token: randomUUID(), baseRevision: state.revision, createdAt: new Date().toISOString(), snapshot, diff: playlistDiff(state.snapshot, snapshot) };
  }
  async importSnapshot(input: unknown, revision: number) {
    const snapshot = normalizeSnapshot(input);
    return this.visible(await this.store.update(s => { this.checkRevision(s, revision); delete s.operationId; this.setPreview(s, snapshot); }));
  }
  async apply(token: string, revision: number) {
    const result = await this.store.update(s => {
      this.checkRevision(s, revision);
      if (!s.pending || typeof token !== 'string' || s.pending.token !== token || s.pending.baseRevision !== revision) throw new ConflictException('预览已更新，请重新预览后确认');
      if (Date.now() - Date.parse(s.pending.createdAt) > 86400000) throw new BadRequestException('预览已过期，请重新同步或导入');
      s.previousSnapshot = s.snapshot;
      s.snapshot = s.pending.snapshot; s.pending = null; s.revision += 1; delete s.operationId;
    });
    this.mediaCache.clear();
    return this.visible(result);
  }
  async media(id: string) {
    const state = await this.store.read();
    const track = state.snapshot?.tracks.find(t => t.id === id);
    if (!track) throw new NotFoundException('歌曲不在当前歌单中');
    if (track.provider === 'manual') return { url: track.url, lyric: track.lyric, message: track.url ? '' : '这首歌尚未配置音频，可通过歌曲链接收听。' };
    const key = `${state.revision}:${id}`;
    const cached = this.mediaCache.get(key);
    if (cached && cached.expires > Date.now()) return cached.promise;
    // Bound both cached entries and failed lookups; concurrent listeners share one request.
    for (const [k, entry] of this.mediaCache) if (entry.expires <= Date.now()) this.mediaCache.delete(k);
    if (this.mediaCache.size >= 1000) this.mediaCache.delete(this.mediaCache.keys().next().value);
    const promise = this.qq.media(track);
    this.mediaCache.set(key, { expires: Date.now() + 60000, promise });
    promise.catch(() => this.mediaCache.delete(key));
    return promise;
  }
}
