export type Kind =
  | "documents"
  | "categories"
  | "tags"
  | "albums"
  | "photos"
  | "bangumis"
  | "about"
  | "essays"
  | "links"
  | "moments"
  | "collections"
  | "music"
  | "comments";

export interface TaxonomySummary {
  id: number;
  title: string;
  slug: string;
  cover?: string;
  locked?: boolean;
  metadata?: Record<string, unknown>;
}

export interface Content {
  commentCount?: number;
  id: number;
  title: string;
  slug: string;
  summary: string;
  body: string;
  format: "markdown" | "html";
  cover: string;
  url: string;
  groupName: string;
  sort: number;
  status: string;
  accessMode: "public" | "login" | "password";
  parentId: number | null;
  categoryId: number | null;
  tagIds: number[];
  publishedAt: string | null;
  createdAt: string;
  updatedAt: string;
  metadata: Record<string, unknown>;
  locked?: boolean;
  category?: TaxonomySummary | null;
  tags?: TaxonomySummary[];
  isLatest?: boolean;
}

export interface Page {
  items: Content[];
  total: number;
  page: number;
  pageSize: number;
}

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
  homeHeroTitle?: string;
  homeHeroSubtitle?: string;
  homeHeroEnabled?: boolean;
  homeHeroSlides?: { image: string; mobileImage: string; type?: 'image' | 'video'; mobileType?: 'image' | 'video' }[];
  homeHeroParallax?: boolean;
  homeHeroAutoplay?: boolean;
  homeHeroRandom?: boolean;
  homeHeroInterval?: number;
  homeHeroFit?: 'cover' | 'contain';
  homeHeroPosition?: 'center' | 'top' | 'bottom';
  homeHeroOverlay?: number;
  footerText: string;
  icp: string;
  startDate: string;
  defaultTheme: "light" | "dark" | "system";
  effectsEnabled: boolean;
  showMusic: boolean;
  showAside: boolean;
  articlePageSize?: number;
  homeCards: { title: string; description: string; image: string; url: string }[];
  socials: { label: string; url: string }[];
}

export interface Session {
  id: number;
  username: string;
  nickName: string;
  avatar: string;
}
