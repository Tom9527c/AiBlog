import { BadRequestException } from '@nestjs/common';

export const DEFAULT_SITE = {
  title: 'AiBlog', subtitle: '', logo: '', avatar: '', description: '', announcement: '',
  heroTitle: '记录生活，分享热爱', heroSubtitle: '', heroImage: '', footerText: '', icp: '', startDate: '',
  defaultTheme: 'system', effectsEnabled: true, showMusic: true, showAside: true,
  homeCards: [], socials: [], articlePageSize: 8, restrictedMediaValidationEnabled: false,
  pageHeaders: {} as Record<string, { enabled: boolean; title: string; subtitle: string; cover: string }>,
  essayTitle: '咸鱼的日常生活。', essaySubtitle: '随时随地，分享生活', essayCover: '',
  homeHeroTitle: '', homeHeroSubtitle: '',
  homeHeroEnabled: false, homeHeroSlides: [], homeHeroParallax: true,
  homeHeroAutoplay: false, homeHeroRandom: false, homeHeroInterval: 8,
  homeHeroFit: 'cover', homeHeroPosition: 'center', homeHeroOverlay: 25,
};

export function safeUrl(value: string, allowEmpty = true) {
  if (allowEmpty && !value) return true;
  return (value.startsWith('/') && !value.startsWith('//') && !/[\\\r\n]/.test(value)) || /^https?:\/\/[^\s]+$/i.test(value);
}

export function validateSettings(input: any) {
  if (!input || Array.isArray(input) || typeof input !== 'object') throw new BadRequestException('站点配置格式错误');
  const out: Record<string, any> = {};
  for (const [key, value] of Object.entries(input)) {
    if (!(key in DEFAULT_SITE)) throw new BadRequestException(`不支持的站点字段：${key}`);
    if (key === 'pageHeaders') {
      if (!value || Array.isArray(value) || typeof value !== 'object') throw new BadRequestException('页面头部配置格式错误');
      const pages = ['archives', 'articles', 'categories', 'tags', 'albums', 'bangumis', 'essays', 'links', 'collections', 'music', 'comments', 'notFound'];
      const headers = {};
      for (const [page, settings] of Object.entries(value)) {
        if (!pages.includes(page) || !settings || Array.isArray(settings) || typeof settings !== 'object') throw new BadRequestException('页面头部类型错误');
        const result = {};
        for (const [field, content] of Object.entries(settings)) {
          if (field === 'enabled') {
            if (typeof content !== 'boolean') throw new BadRequestException('头部开关必须为布尔值');
          } else if (['title', 'subtitle', 'cover'].includes(field)) {
            if (typeof content !== 'string' || content.length > 2000 || (field === 'cover' && !safeUrl(content))) throw new BadRequestException('头部文字或图片地址错误');
          } else throw new BadRequestException('不支持的头部字段');
          result[field] = content;
        }
        headers[page] = result;
      }
      out[key] = headers;
      continue;
    }
    const sample = DEFAULT_SITE[key];
    if (Array.isArray(sample)) {
      if (!Array.isArray(value) || value.length > 30) throw new BadRequestException(`${key} 最多 30 项`);
      const fields = key === 'socials' ? ['label', 'url'] : key === 'homeHeroSlides' ? ['image', 'mobileImage'] : ['title', 'description', 'image', 'url'];
      out[key] = value.map(row => {
        if (!row || typeof row !== 'object' || Array.isArray(row)) throw new BadRequestException('配置条目格式错误');
        const item = {};
        for (const field of fields) {
          if (typeof (row[field] ?? '') !== 'string' || (row[field] || '').length > 2000) throw new BadRequestException('配置条目过长');
          item[field] = row[field] || '';
          if (['url', 'image', 'mobileImage'].includes(field) && !safeUrl(item[field])) throw new BadRequestException('链接仅支持站内路径或 HTTP(S)');
        }
        if (key === 'homeHeroSlides') {
          for (const field of ['type', 'mobileType']) {
            if (row[field] === undefined) continue;
            if (!['image', 'video'].includes(row[field])) throw new BadRequestException('大屏素材类型仅支持图片或视频');
            item[field] = row[field];
          }
        }
        return item;
      });
    } else {
      if (typeof value !== typeof sample || (typeof value === 'string' && value.length > 5000)) throw new BadRequestException(`字段 ${key} 格式错误`);
      out[key] = value;
    }
  }
  for (const key of ['logo', 'avatar', 'heroImage', 'essayCover']) if (out[key] && !safeUrl(out[key])) throw new BadRequestException('图片地址错误');
  if (out.defaultTheme && !['system', 'light', 'dark'].includes(out.defaultTheme)) throw new BadRequestException('主题错误');
  if ('homeHeroFit' in out && !['cover', 'contain'].includes(out.homeHeroFit)) throw new BadRequestException('大屏图片适配方式错误');
  if ('homeHeroPosition' in out && !['center', 'top', 'bottom'].includes(out.homeHeroPosition)) throw new BadRequestException('大屏图片对齐方式错误');
  for (const [key, min, max] of [['homeHeroInterval', 3, 600], ['homeHeroOverlay', 0, 80], ['articlePageSize', 1, 100]] as const) {
    if (key in out && (!Number.isInteger(out[key]) || out[key] < min || out[key] > max)) throw new BadRequestException(`${key} 必须为 ${min} 至 ${max} 的整数`);
  }
  return out;
}
