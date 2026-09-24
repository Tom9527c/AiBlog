import { useState } from 'react';
import { useBlog, useLoad, Status, Media, LoadedContent, Pager } from '../../components';
import { PageShell } from '../../components/page/PageShell';
import { list } from '../../services/content';
import { safeUrl } from '../../services/api';

export function LinksPage() {
  const { revision } = useBlog();
  const [page, setPage] = useState(1);
  const entries = useLoad(() => list('links', { page }), [revision, page]);
  const groups = [...new Set(entries.data?.items.map(item => item.groupName).filter(Boolean) || [])];
  return <PageShell title="友人帐">
    <Status {...entries} empty={!entries.data?.items.length} />
    <div className="flink">
      {(groups.length ? groups : ['']).map(group => <section key={group}>
        <h2>{group}</h2>
        <div className="flink-list">
          {entries.data?.items.filter(item => item.groupName === group).map(item => <div className="flink-list-item" key={item.id}>
            {item.locked ? <LoadedContent kind="links" item={item} /> : <a href={safeUrl(item.url)} target="_blank" rel="noopener noreferrer">
              <Media src={item.cover} alt={item.title} />
              <div className="flink-item-name">{item.title}</div>
              <div className="flink-item-desc">{item.summary}</div>
            </a>}
          </div>)}
        </div>
      </section>)}
    </div>
    <Pager page={page} total={entries.data?.total || 0} onChange={setPage} />
  </PageShell>;
}

import './links.css';
