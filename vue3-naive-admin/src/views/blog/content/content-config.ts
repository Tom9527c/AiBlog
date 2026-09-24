import type { Content, Kind } from '@/service/api/blog';

export const names: Record<Kind, string> = {
  documents: '文档',
  categories: '分类',
  tags: '标签',
  albums: '相册',
  photos: '照片',
  bangumis: '追番',
  about: '关于本人',
  essays: '说说',
  links: '友链',
  moments: '朋友圈',
  comments: '评论',
  collections: '收藏',
  music: '音乐'
};
export const descriptions: Record<Kind, string> = {
  documents: '管理博客文章、分类、标签与访问权限',
  categories: '整理文章分类，让内容更容易被发现',
  tags: '用轻量标签补充内容的主题与颜色',
  albums: '管理相册与其中的图片、动图和视频',
  photos: '维护相册中的图片内容与媒体资源',
  bangumis: '维护番剧封面、观看状态、简介与播放互动数据',
  about: '编辑个人介绍、经历和展示卡片',
  essays: '发布短内容、随笔和即时想法',
  links: '维护博客中的友情链接与跳转地址',
  moments: '记录朋友圈动态和来源信息',
  comments: '查看、回复和管理访客评论',
  collections: '整理收藏内容与外部链接',
  music: '维护音乐信息、音频和歌词内容'
};
export const empty = (): Content => ({
  id: 0,
  title: '',
  slug: '',
  summary: '',
  body: '',
  format: 'markdown',
  cover: '',
  url: '',
  groupName: '',
  sort: 0,
  status: 'draft',
  accessMode: 'public',
  parentId: null,
  categoryId: null,
  tagIds: [],
  publishedAt: null,
  metadata: {},
  password: ''
});
export const states = [
  { label: '想看', value: 'wish' },
  { label: '在看', value: 'watching' },
  { label: '看过', value: 'finished' }
];
export const statuses = [
  { label: '草稿', value: 'draft' },
  { label: '发布', value: 'published' }
];
