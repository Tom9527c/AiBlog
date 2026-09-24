import { BlogContent } from '../blog.entity';

export function commentTargetSummary(kind: string, row: BlogContent) {
  const source = kind === 'essays' ? row.body || row.summary || row.title : row.title || row.summary;
  const title = String(source || '')
    .replace(/<[^>]*>/g, ' ')
    .replace(/!?\[([^\]]*)\]\([^)]*\)/g, '$1')
    .replace(/(?:^|\n)\s{0,3}#{1,6}\s/g, ' ')
    .replace(/[*_`~]/g, '').replace(/\s+/g, ' ').trim();
  return {
    title: Array.from(title).slice(0, kind === 'essays' ? 50 : 200).join('') || (kind === 'essays' ? '图片 / 媒体短文' : '未命名内容'),
    slug: row.slug,
    date: row.metadata?.occurredAt || row.publishedAt || row.createdAt,
  };
}

// Input is already filtered to approved, published comments on readable essays.
export function visibleEssayCommentCounts(rows: Pick<BlogContent, 'id' | 'parentId' | 'metadata'>[]) {
  const roots = new Map(rows.filter(row => !row.parentId).map(row => [row.id, Number(row.metadata.targetId)]));
  const counts = new Map<number, number>();
  for (const row of rows) {
    const id = Number(row.metadata.targetId);
    if (!row.parentId || roots.get(row.parentId) === id) counts.set(id, (counts.get(id) || 0) + 1);
  }
  return counts;
}
