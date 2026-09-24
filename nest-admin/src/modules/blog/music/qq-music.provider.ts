import { BadGatewayException, Injectable } from '@nestjs/common';
import axios from 'axios';
import { MusicSnapshot, MusicTrack, normalizeSnapshot, playlistId } from './music-library';

/** QQ transport is deliberately isolated: replace this adapter when upstream changes. */
@Injectable()
export class QQMusicProvider {
  readonly version = 'qq-dissinfo-v1';
  private readonly headers = { 'User-Agent': 'Mozilla/5.0', Referer: 'https://y.qq.com/' };
  private async cgi(module: string, method: string, param: Record<string, unknown>, signal?: AbortSignal) {
    const { data } = await axios.get('https://u.y.qq.com/cgi-bin/musicu.fcg', {
      params: { format: 'json', data: JSON.stringify({ comm: { ct: 24, cv: 0, uin: 0, format: 'json' }, req_0: { module, method, param } }) },
      headers: this.headers, timeout: 8000, maxContentLength: 5 * 1024 * 1024, maxRedirects: 0, signal,
    });
    if (data?.code !== 0 || data?.req_0?.code !== 0 || !data.req_0.data || (data.req_0.data.code !== undefined && data.req_0.data.code !== 0)) throw new BadGatewayException('QQ 音乐接口返回异常，请稍后重试');
    return data.req_0.data;
  }
  async playlist(source: string): Promise<MusicSnapshot> {
    const id = playlistId(source);
    const signal = AbortSignal.timeout(20000);
    const tracks: MusicTrack[] = [];
    const ids = new Set<string>();
    let total: number | undefined;
    let title = '';
    try {
      for (let offset = 0; offset <= 1000; offset += 100) {
        const data = await this.cgi('music.srfDissInfo.DissInfo', 'CgiGetDiss', { disstid: Number(id), dirid: 0, tag: 1, song_begin: offset, song_num: 100, userinfo: 0, orderlist: 1, onlysonglist: 0 }, signal);
        const count = data.dirinfo?.songnum;
        if (!Number.isInteger(count) || count < 0 || count > 1000 || !Array.isArray(data.songlist)) throw new BadGatewayException('QQ 歌单格式异常或超过 1000 首');
        if (total !== undefined && count !== total) throw new BadGatewayException('同步期间歌单发生变化，请重试');
        total = count;
        title = data.dirinfo.title;
        for (const song of data.songlist) {
          if (!song?.mid || ids.has(song.mid)) throw new BadGatewayException('QQ 歌单曲目标识缺失或重复，未更新原歌单');
          ids.add(song.mid);
          tracks.push({ id: `tencent:${song.mid}`, provider: 'tencent', mid: song.mid, title: song.title || song.name, artist: (song.singer || []).map((s: any) => s.name).join(' / '), album: song.album?.name || '', cover: song.album?.mid ? `https://y.gtimg.cn/music/photo_new/T002R500x500M000${song.album.mid}.jpg` : '', duration: song.interval || 0, url: '', lyric: '', externalUrl: `https://y.qq.com/n/ryqq/songDetail/${song.mid}` });
        }
        if (tracks.length === total && !data.hasmore) break;
        if (!data.songlist.length || !data.hasmore || tracks.length > total) throw new BadGatewayException('QQ 接口未返回完整歌单，已保留原数据');
      }
      if (tracks.length !== total) throw new BadGatewayException('QQ 接口未返回完整歌单，已保留原数据');
      return normalizeSnapshot({ version: 1, title, source: { provider: 'tencent', id, url: `https://y.qq.com/n/ryqq/playlist/${id}` }, tracks });
    } catch (e) {
      if (e instanceof BadGatewayException) throw e;
      throw new BadGatewayException('QQ 歌单获取失败或超时，已保留原数据；可重试或导入 JSON');
    }
  }
  async media(track: MusicTrack) {
    const results = await Promise.allSettled([
      this.cgi('vkey.GetVkeyServer', 'CgiGetVkey', { guid: '2796982635', songmid: [track.mid], songtype: [0], uin: '0', loginflag: 0, platform: '20' }),
      axios.get('https://c.y.qq.com/lyric/fcgi-bin/fcg_query_lyric_new.fcg', { params: { songmid: track.mid, format: 'json', nobase64: 1, g_tk: 5381 }, headers: this.headers, timeout: 8000, maxContentLength: 256000, maxRedirects: 0 }),
    ]);
    let url = track.url || '';
    let lyric = track.lyric || '';
    if (results[0].status === 'fulfilled') {
      const data = results[0].value;
      const purl = data.midurlinfo?.[0]?.purl;
      const host = data.sip?.find((s: string) => s.startsWith('https://')) || data.sip?.[0];
      if (!url && purl && host) {
        try {
          const candidate = new URL(purl, host);
          if (/\.(qq\.com|qqmusic\.qq\.com)$/.test(candidate.hostname) && ['http:', 'https:'].includes(candidate.protocol)) { candidate.protocol = 'https:'; url = candidate.href; }
        } catch { /* No valid platform audio URL. */ }
      }
    }
    if (!lyric && results[1].status === 'fulfilled') {
      const data = results[1].value.data;
      if (data?.retcode === 0 || data?.code === 0) lyric = typeof data.lyric === 'string' ? data.lyric.slice(0, 50000) : '';
    }
    return { url, lyric, message: url ? '' : 'QQ 音乐暂未提供可播放音源，可能需要登录或会员，请前往 QQ 音乐收听。' };
  }
}
