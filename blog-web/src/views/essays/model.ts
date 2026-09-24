import type { Content } from '../../types';
export interface EssayMediaItem { type: 'image' | 'video' | 'audio' | 'link'; url: string; title?: string; artist?: string; poster?: string }
function typeFor(url: string): EssayMediaItem['type'] {
  const path = url.split(/[?#]/)[0];
  return /\.(mp4|webm|mov)$/i.test(path) ? 'video' : /\.(mp3|m4a|ogg|wav)$/i.test(path) ? 'audio' : /\.(jpe?g|png|gif|webp|avif)$/i.test(path) ? 'image' : 'link';
}
export function essayMedia(item: Content): EssayMediaItem[] {
  const media = (Array.isArray(item.metadata?.media) ? item.metadata.media : []) as EssayMediaItem[];
  const result = [...media];
  if (item.cover && !result.some(row => row.url === item.cover)) result.push({type:'image', url:item.cover});
  if (item.url && !result.some(row => row.url === item.url)) result.push({type:typeFor(item.url),url:item.url});
  return result;
}
export function essayDate(item: Content) { return String(item.metadata?.occurredAt || item.publishedAt || item.createdAt); }
