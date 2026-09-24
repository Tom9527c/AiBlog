import { unified } from 'unified';
import remarkParse from 'remark-parse';
import type { Content } from '../../types';
import { essayMedia } from './model';
const parser = unified().use(remarkParse);
const marks = {image:'[图片]',video:'[视频]',audio:'[音乐]',link:'[链接]'};
export function publicEssays(items: Content[], now = Date.now()) {
  return items.filter(item => item.accessMode === 'public' && !item.locked && item.status === 'published' && (!item.publishedAt || Date.parse(item.publishedAt) <= now));
}
/** Text-only projection: preserve inline media positions and append separately stored attachments. */
export function essayBroadcast(item: Content): string {
  const seen = new Set<string>();
  function html(value: string): string {
    // Inert template parsing never inserts media or scripts into the live document.
    const template = document.createElement('template');
    template.innerHTML = value;
    const visit = (node: Node): string => {
      if (node.nodeType === Node.TEXT_NODE) return node.textContent || '';
      if (!(node instanceof Element)) return Array.from(node.childNodes).map(visit).join('');
      const tag = node.tagName.toLowerCase();
      if (['script','style','iframe','object','embed','source'].includes(tag)) return '';
      if (['img','video','audio'].includes(tag)) {
        const src = node.getAttribute('src') || node.querySelector('source')?.getAttribute('src');
        if (src) seen.add(src);
        return tag === 'img' ? marks.image : tag === 'video' ? marks.video : marks.audio;
      }
      if (tag === 'br') return ' ';
      const text = Array.from(node.childNodes).map(visit).join('');
      return ['p','div','li','h1','h2','h3','blockquote'].includes(tag) ? `${text} ` : text;
    };
    return visit(template.content);
  }
  const source = item.body?.trim() || item.summary?.trim() || item.title || '';
  let text: string;
  if (item.format === 'html') text = html(source);
  else {
    const root = parser.parse(source);
    const definitions = new Map<string,string>();
    function collect(node: any) { if (node.type === 'definition') definitions.set(node.identifier,node.url); node.children?.forEach(collect); }
    collect(root);
    function visit(node: any): string {
      if (node.type === 'definition') return '';
      if (node.type === 'image' || node.type === 'imageReference') {
        const src = node.url || definitions.get(node.identifier);
        if (src) seen.add(src);
        return marks.image;
      }
      if (node.type === 'html') return html(node.value);
      if (node.type === 'break') return ' ';
      if (typeof node.value === 'string') return node.value;
      const result = (node.children || []).map(visit).join('');
      return ['paragraph','heading','listItem','code'].includes(node.type) ? `${result} ` : result;
    }
    text = visit(root);
  }
  const attachments = essayMedia(item).filter(entry => !seen.has(entry.url)).map(entry => marks[entry.type]).join('');
  return `${text.trim()}${attachments}`.replace(/\s+/g,' ').trim();
}
