import { BadRequestException } from '@nestjs/common';
import { ABOUT_SECTIONS, ABOUT_TEXT_FIELDS, ABOUT_URL_FIELDS } from '../site/blog-about';
import { safeUrl } from '../site/blog-settings';

type Rule = (value: any) => boolean;
const text: Rule = v => typeof v === 'string' && v.length <= 5000;
const url: Rule = v => text(v) && safeUrl(v);
const count: Rule = v => Number.isInteger(v) && v >= 0 && v <= 1000000;
const statistic: Rule = v => Number.isInteger(v) && v >= 0 && v <= 1000000000000;
const rows = (fields: Record<string, Rule>): Rule => value => Array.isArray(value) && value.length <= 100 && value.every(row =>
  row && !Array.isArray(row) && typeof row === 'object' && Object.keys(row).every(key => fields[key] && fields[key](row[key])));
const rules: Record<string, Record<string, Rule>> = {
  documents: {}, categories: {}, tags: { color: v => typeof v === 'string' && (/^#[a-f\d]{3,8}$/i.test(v) || /^rgba?\([\d.,%\s]+\)$/.test(v)) },
  albums: { layout: v => ['waterfall', 'grid', 'gallery'].includes(v) }, photos: { width: count, height: count, mediaType: v => ['image', 'video'].includes(v) },
  bangumis: {
    state: v => ['wish', 'watching', 'finished'].includes(v),
    progress: count,
    total: count,
    rating: v => typeof v === 'number' && v >= 0 && v <= 10,
    region: v => typeof v === 'string' && v.length <= 100,
    type: v => typeof v === 'string' && v.length <= 100,
    plays: statistic,
    followers: statistic,
    coins: statistic,
    danmaku: statistic,
  },
  about: {
    ...Object.fromEntries(ABOUT_TEXT_FIELDS.map(key => [key, text])),
    ...Object.fromEntries(ABOUT_URL_FIELDS.map(key => [key, url])),
    pursuitWords: v => Array.isArray(v) && v.length <= 16 && v.every(text),
    skillItems: rows({ name: text, image: url, color: v => typeof v === 'string' && (v === '' || /^#[a-f\d]{3,8}$/i.test(v)) }),
    comics: rows({ title: text, image: url, url }),
    sections: v => v && !Array.isArray(v) && typeof v === 'object' && Object.entries(v).every(([key, value]) => (ABOUT_SECTIONS as readonly string[]).includes(key) && typeof value === 'boolean'),
    birthYear: v => Number.isInteger(v) && v >= 1900 && v <= new Date().getFullYear(),
    name: text, role: text, location: text, career: text, profession: text, currentJob: text,
    personality: text, personalityCode: text,
    profileTags: v => Array.isArray(v) && v.length <= 16 && v.every(text),
    skills: v => Array.isArray(v) && v.length <= 100 && v.every(text),
    socials: rows({ label: text, url }),
    experiences: rows({ title: text, description: text, date: text }),
    cards: rows({ title: text, description: text, image: url, url }),
    donationText: text, donationImage: url, photo: url, mapImage: url, gameImage: url, technologyImage: url, musicImage: url
  },
  essays: {
    mood: v => typeof v === 'string' && v.length <= 50, weather: v => typeof v === 'string' && v.length <= 50,
    source: text, location: v => typeof v === 'string' && v.length <= 200,
    occurredAt: v => v === '' || (typeof v === 'string' && /^\d{4}-\d\d-\d\dT.+(?:Z|[+-]\d\d:\d\d)$/.test(v) && Number.isFinite(Date.parse(v))),
    tags: v => Array.isArray(v) && v.length <= 10 && v.every(tag => typeof tag === 'string' && tag.length > 0 && tag.length <= 30),
    media: v => Array.isArray(v) && v.length <= 30 && v.every(item =>
      item && typeof item === 'object' && !Array.isArray(item) &&
      ['image', 'video', 'audio', 'link'].includes(item.type) && typeof item.url === 'string' && item.url.length > 0 && url(item.url) &&
      Object.entries(item).every(([key, value]) => ({ type: text, url, title: text, artist: text, poster: url }[key]?.(value)))),
  }, links: {}, moments: { source: text },
  collections: {
    category: v => typeof v === 'string' && v.length <= 100,
    icon: v => typeof v === 'string' && v.length <= 40,
    rating: v => Number.isInteger(v) && v >= 0 && v <= 5,
  },
  music: { artist: text, lyrics: v => typeof v === 'string' && v.length <= 30000 },
  comments: { targetKind: v => ['', 'documents', 'albums', 'essays', 'about'].includes(v), targetId: v => Number.isInteger(v) && v > 0,
    authorName: text, authorAvatar: url, authorEmail: v => typeof v === 'string' && v.length <= 254,
    authorWebsite: v => typeof v === 'string' && v.length <= 2000 && (!v || /^https?:\/\//i.test(v) && safeUrl(v)),
    isOwner: v => typeof v === 'boolean', browser: v => typeof v === 'string' && v.length <= 100,
    os: v => typeof v === 'string' && v.length <= 100, location: v => typeof v === 'string' && v.length <= 100, replyToName: text,
    moderationStatus: v => ['pending', 'approved', 'rejected'].includes(v), moderationReason: text,
    votes: v => v && !Array.isArray(v) && typeof v === 'object' && Object.entries(v).every(([key, value]) => /^[A-Za-z0-9_-]{43}$/.test(key) && [1, -1].includes(value as number)),
  },
};

export function validateMetadata(kind: string, input: any): Record<string, any> {
  if (!input || Array.isArray(input) || typeof input !== 'object' || !rules[kind]) throw new BadRequestException('扩展信息格式错误');
  const result = {};
  for (const [key, value] of Object.entries(input)) {
    if (value === null || value === undefined) continue;
    if (!rules[kind][key] || !rules[kind][key](value)) throw new BadRequestException(`扩展字段 ${key} 格式错误`);
    result[key] = value;
  }
  return result;
}
