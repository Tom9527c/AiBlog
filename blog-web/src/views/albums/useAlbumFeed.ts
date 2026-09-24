import { useCallback, useEffect, useRef, useState } from 'react';
import { list } from '../../services/content';
import type { Content, Kind } from '../../types';

/** Commit page numbers only after success, so retry never skips a page. */
export function useAlbumFeed(kind: Kind, enabled: boolean, parentId?: number, groupName?: string) {
  const [items, setItems] = useState<Content[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const [hasMore, setHasMore] = useState(true);
  const page = useRef(0);
  const pending = useRef(false);
  const generation = useRef(0);

  const loadMore = useCallback(async () => {
    if (!enabled || pending.current || !hasMore) return;
    pending.current = true;
    const requestGeneration = generation.current;
    setLoading(true);
    setError('');
    try {
      const next = page.current + 1;
      const result = await list(kind, {
        page: next, pageSize: 24,
        ...(parentId ? { parentId } : {}),
        ...(groupName ? { groupName } : {}),
      });
      if (generation.current !== requestGeneration) return;
      page.current = next;
      setItems(previous => {
        const ids = new Set(previous.map(item => item.id));
        return [...previous, ...result.items.filter(item => !ids.has(item.id))];
      });
      setHasMore(result.items.length > 0 && next * result.pageSize < result.total);
    } catch (reason) {
      if (generation.current === requestGeneration)
        setError(reason instanceof Error ? reason.message : '加载失败，请重试');
    } finally {
      if (generation.current === requestGeneration) {
        pending.current = false;
        setLoading(false);
      }
    }
  }, [kind, enabled, parentId, groupName, hasMore]);

  // The owning gallery is keyed by route and authorization revision.
  useEffect(() => {
    const current = generation.current;
    // StrictMode replays setup before this microtask; only the live setup fetches.
    void Promise.resolve().then(() => {
      if (enabled && current === generation.current) void loadMore();
    });
    return () => { generation.current += 1; pending.current = false; };
    // Do not restart page one when hasMore changes.
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [enabled, kind, parentId, groupName]);

  return { items, loading, error, hasMore, loadMore };
}
