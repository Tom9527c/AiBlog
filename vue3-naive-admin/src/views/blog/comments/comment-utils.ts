type SourceMetadata = { targetKind?: string; targetId?: number | string; targetSlug?: string };

const names: Record<string, string> = {
  guestbook: '留言板', documents: '文章', essays: '即刻短文', albums: '相册', about: '关于'
};

export function sourceLabel(metadata: SourceMetadata = {}) {
  const kind = metadata.targetKind || 'guestbook';
  const name = names[kind] || kind;
  return metadata.targetId ? `${name} #${metadata.targetId}` : name;
}

export function sourceHref(metadata: SourceMetadata = {}) {
  const kind = metadata.targetKind || 'guestbook';
  if (kind === 'guestbook') return '/comments/';
  if (kind === 'about') return '/about/';
  if (kind === 'essays' && metadata.targetId) return `/essay/?id=${encodeURIComponent(metadata.targetId)}`;
  if (kind === 'documents' && metadata.targetSlug) return `/posts/${encodeURIComponent(metadata.targetSlug)}.html`;
  if (kind === 'albums' && metadata.targetSlug) return `/album/${encodeURIComponent(metadata.targetSlug)}`;
  return undefined;
}

export function publicSourceUrl(path: string | undefined, location: Pick<Location, 'origin' | 'hostname' | 'port'>, configuredOrigin?: string) {
  if (!path) return undefined;
  // The integrated gateway serves /admin and the public blog on one origin. Direct
  // local admin development (8080) has a separate public Vite server (5174).
  const local = ['localhost', '127.0.0.1'].includes(location.hostname) && location.port === '8080';
  const origin = configuredOrigin || (local ? `${location.origin.replace(/:8080$/, '')}:5174` : location.origin);
  return new URL(path, origin).href;
}

type CommentSource = {
  id: number;
  metadata: SourceMetadata;
  commentTarget?: { title: string; slug?: string; date?: string } | null;
};
export function commentSourceTitle(row: CommentSource) {
  if (row.commentTarget) return row.commentTarget.title;
  return row.metadata?.targetId ? '内容已删除或不可用' : sourceLabel(row.metadata);
}
export function commentSourcePath(row: CommentSource) {
  if (row.metadata?.targetId && !row.commentTarget) return undefined;
  const path = sourceHref({ ...row.metadata, targetSlug: row.commentTarget?.slug });
  return path ? `${path}#post-comment` : undefined;
}
