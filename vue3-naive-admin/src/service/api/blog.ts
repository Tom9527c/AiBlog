import { request } from '@/service/request';
import { getAuthorization } from '@/service/request/shared';
import { getServiceBaseURL } from '@/utils/service';
export const kinds = [
  'documents',
  'categories',
  'tags',
  'albums',
  'photos',
  'bangumis',
  'about',
  'essays',
  'links',
  'moments',
  'comments',
  'collections',
  'music'
] as const;
export type Kind = (typeof kinds)[number];
export interface Content {
  id: number;
  title: string;
  slug: string;
  summary: string;
  body: string;
  format: 'markdown' | 'html';
  cover: string;
  url: string;
  groupName: string;
  sort: number;
  status: 'draft' | 'published';
  accessMode: 'public' | 'login' | 'password';
  parentId: number | null;
  categoryId: number | null;
  tagIds: number[];
  publishedAt: string | null;
  metadata: Record<string, any>;
  password?: string;
  createdAt?: string;
  updatedAt?: string;
  moderationStatus?: CommentModeration;
  commentTarget?: { title: string; slug?: string; date?: string } | null;
}
export type CommentModeration = 'pending' | 'approved' | 'rejected';
export interface CommentCounts { pending: number; approved: number; rejected: number }
export interface AdminCommentsResult { items: Content[]; total: number; page: number; pageSize: number; counts: CommentCounts }
export interface Menu {
  id: number;
  parentId: number | null;
  title: string;
  path: string;
  icon: string;
  sort: number;
  enabled: boolean;
  external: boolean;
  newWindow: boolean;
}
export interface PageHeaderSettings { enabled: boolean; title: string; subtitle: string; cover: string }
export type PageHeaderKey = 'archives' | 'articles' | 'categories' | 'tags' | 'albums' | 'bangumis' | 'essays' | 'links' | 'collections' | 'music' | 'comments' | 'notFound';
export interface Site {
  pageHeaders?: Partial<Record<PageHeaderKey, Partial<PageHeaderSettings>>>;
  essayTitle?: string;
  essaySubtitle?: string;
  essayCover?: string;
  title: string;
  subtitle: string;
  logo: string;
  avatar: string;
  description: string;
  announcement: string;
  heroTitle: string;
  heroSubtitle: string;
  heroImage: string;
  homeHeroTitle: string;
  homeHeroSubtitle: string;
  homeHeroEnabled: boolean;
  homeHeroSlides: { image: string; mobileImage: string; type?: 'image' | 'video'; mobileType?: 'image' | 'video' }[];
  homeHeroParallax: boolean;
  homeHeroAutoplay: boolean;
  homeHeroRandom: boolean;
  homeHeroInterval: number;
  homeHeroFit: 'cover' | 'contain';
  homeHeroPosition: 'center' | 'top' | 'bottom';
  homeHeroOverlay: number;
  footerText: string;
  icp: string;
  startDate: string;
  defaultTheme: 'light' | 'dark' | 'system';
  effectsEnabled: boolean;
  showMusic: boolean;
  showAside: boolean;
  restrictedMediaValidationEnabled?: boolean;
  articlePageSize?: number;
  homeCards: { title: string; description: string; image: string; url: string }[];
  socials: { label: string; url: string }[];
}
export async function api<T>(
  path: string,
  // eslint-disable-next-line default-param-last
  method: 'get' | 'post' | 'put' | 'delete' = 'get',
  data?: unknown,
  params?: Record<string, unknown>
): Promise<T> {
  const result = await request<T>({
    url: `/blog/admin/${path}`,
    method,
    data,
    params,
    ...(data instanceof FormData ? { timeout: 120000 } : path === 'music-library/preview' ? { timeout: 30000 } : {}),
    // Override the JSON default so Axios preserves files and the browser supplies the multipart boundary.
    headers: data instanceof FormData ? { 'Content-Type': 'multipart/form-data' } : undefined
  });
  if (result.error) throw new Error('操作失败，请检查接口提示');
  return result.data as T;
}
export const list = (kind: Kind, params: Record<string, unknown> = {}) =>
  api<{ items: Content[]; total: number }>(`content/${kind}`, 'get', undefined, params);
export const listAdminComments = (params: Record<string, unknown> = {}) =>
  api<AdminCommentsResult>('comments', 'get', undefined, params);
export const moderateComments = (ids: number[], status: CommentModeration, reason?: string) =>
  api<{ updated: number }>('comments/moderate', 'post', { ids, status, ...(reason ? { reason } : {}) });
export const replyToComment = (id: number, body: string) =>
  api<Content>(`comments/${id}/reply`, 'post', { body });
export async function options(kind: Kind) {
  const rows: Content[] = [];
  for (let page = 1; ; page += 1) {
    // Fetch sequentially because total is provided by the previous page.
    // eslint-disable-next-line no-await-in-loop
    const result = await list(kind, { page, pageSize: 100 });
    rows.push(...result.items);
    if (rows.length >= result.total || !result.items.length) break;
  }
  return rows.map(row => ({ label: row.title || `#${row.id}`, value: row.id }));
}
export async function upload(file: File) {
  const data = new FormData();
  data.append('file', file);
  return api<{ id: number; url: string; name: string; mime: string }>('upload', 'post', data);
}
export async function mediaUrl(value: string) {
  if (!value.startsWith('/blog-media/')) return value;
  const { baseURL } = getServiceBaseURL(
    import.meta.env,
    import.meta.env.DEV && import.meta.env.VITE_HTTP_PROXY === 'Y'
  );
  const response = await fetch(`${baseURL}/blog/public/media/${value.split('/').pop()}`, {
    headers: { Authorization: getAuthorization() || '' }
  });
  if (!response.ok) throw new Error('媒体加载失败');
  return URL.createObjectURL(await response.blob());
}
