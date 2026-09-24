import { useState } from 'react';
import { useBlog, useLoad, Status, Pager } from '../../components';
import { PageShell } from '../../components/page/PageShell';
import { list } from '../../services/content';
import { CollectionPage } from './components/CollectionPage';

export function CollectionsPage() {
  const { revision } = useBlog();
  const [page, setPage] = useState(1);
  const entries = useLoad(() => list('collections', { page }), [revision, page]);
  return <PageShell title="藏宝阁">
    <Status {...entries} empty={!entries.data?.items.length} />
    <CollectionPage items={entries.data?.items || []} />
    <Pager page={page} total={entries.data?.total || 0} onChange={setPage} />
  </PageShell>;
}

import './collections.css';
