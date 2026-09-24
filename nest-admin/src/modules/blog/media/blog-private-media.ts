import { BadRequestException } from '@nestjs/common';
const markdown = new (require('markdown-it'))({ html: true });

export function assertManagedMedia(row: { cover: string; url: string; body: string; metadata: Record<string, any> }, mediaUrl = false) {
  const requireManaged = (value: string) => {
    if (value && !/^\/blog-media\/\d+$/.test(value)) throw new BadRequestException('受限内容的图片、音视频请使用博客上传文件');
  };
  requireManaged(row.cover);
  if (mediaUrl) requireManaged(row.url);
  for (const field of ['careersImage', 'mapDarkImage', 'donationImage', 'avatar', 'photo', 'personalityImage', 'mapImage', 'gameImage', 'technologyImage', 'musicImage']) requireManaged(row.metadata[field]);
  for (const field of ['cards', 'skillItems', 'comics']) {
    for (const entry of row.metadata[field] || []) requireManaged(entry.image);
  }
  for (const entry of row.metadata.media || []) {
    if (entry.type !== 'link') requireManaged(entry.url);
    requireManaged(entry.poster);
  }
  const inspect = (tokens: any[]) => {
    for (const token of tokens) {
      if (token.type === 'image') requireManaged(token.attrGet('src'));
      if (token.children) inspect(token.children);
    }
  };
  inspect(markdown.parse(row.body, {}));
  for (const match of row.body.matchAll(/<(img|video|audio|source|iframe|object|embed)\b([^>]*)>/gi)) {
    if (['iframe', 'object', 'embed'].includes(match[1].toLowerCase()) || /\bsrcset\s*=/i.test(match[2])) throw new BadRequestException('受限内容不支持外部嵌入或多源图片');
    for (const attribute of match[2].matchAll(/\b(?:src|poster|data)\s*=\s*(?:"([^"]*)"|'([^']*)'|([^\s>]+))/gi)) requireManaged(attribute[1] ?? attribute[2] ?? attribute[3]);
  }
  for (const match of row.body.matchAll(/url\(\s*['"]?([^)'"\s]+)['"]?\s*\)/gi)) requireManaged(match[1]);
}
