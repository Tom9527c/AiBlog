import type { PageHeaderKey, PageHeaderSettings, Site } from '../../types';
export function pageHeaderKey(pathname: string): PageHeaderKey | undefined {
  const path = pathname.split('/').filter(Boolean)[0] || '';
  if (!path || path === 'about' || path === 'page' || path === 'random') return undefined;
  return ({ archives:'archives', posts:'articles', categories:'categories', tags:'tags', album:'albums', dailyPhoto:'albums', lovePic:'albums', wordScenery:'albums', bangumis:'bangumis', essay:'essays', fcircle:'essays', link:'links', collect:'collections', collections:'collections', music:'music', comments:'comments' } as Record<string,PageHeaderKey>)[path] || 'notFound';
}
export const pageLabels: Record<PageHeaderKey,string> = {archives:'文章归档',articles:'文章',categories:'分类',tags:'标签',albums:'相册集',bangumis:'追番列表',essays:'即刻短文',links:'友人帐',collections:'藏宝阁',music:'音乐馆',comments:'留言板',notFound:'页面不存在'};
export function pageHeaderSettings(site: Partial<Site>, page: PageHeaderKey): PageHeaderSettings {
  return {
    enabled: true,
    title: page === 'essays' ? site.essayTitle ?? '咸鱼的日常生活。' : '',
    subtitle: page === 'essays' ? site.essaySubtitle ?? '随时随地，分享生活' : page === 'collections' ? '包含 影视/小说/游戏/音乐 等 持续更新中...' : '',
    cover: page === 'essays' ? site.essayCover || '' : '',
    ...site.pageHeaders?.[page],
  };
}
