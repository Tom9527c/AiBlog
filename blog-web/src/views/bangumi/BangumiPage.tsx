import { useState } from 'react';
import { useBlog, useLoad, Status, Media, LoadedContent, Pager } from '../../components';
import { PageShell } from '../../components/page/PageShell';
import { list } from '../../services/content';
import { safeUrl } from '../../services/api';

const states = [['wish', '想看'], ['watching', '在看'], ['finished', '看过']] as const;

function metric(value: unknown) {
  const number = Number(value);
  if (!Number.isFinite(number) || value === null || value === undefined || value === '') return '—';
  if (number >= 100000000) return `${(number / 100000000).toFixed(1).replace(/\.0$/, '')}亿`;
  if (number >= 10000) return `${(number / 10000).toFixed(1).replace(/\.0$/, '')}万`;
  return number.toLocaleString('zh-CN');
}

function episodes(progress: unknown, total: unknown) {
  const current = Number(progress);
  const count = Number(total);
  if (!Number.isFinite(count) || count <= 0) return current > 0 ? `第${current}话` : '—';
  return current >= count ? `全${count}话` : `${current}/${count}话`;
}

export function BangumiPage() {
  const { revision } = useBlog();
  const [page, setPage] = useState(1);
  const [tab, setTab] = useState('watching');
  const entries = useLoad(() => list('bangumis', { page, state: tab }), [revision, page, tab]);
  const counts = useLoad(() => Promise.all(states.map(([state]) => list('bangumis', { state, pageSize: 1 }))), [revision]);

  return <PageShell title="追番列表" aside>
    <div className="bangumi-slogan">生命不息，追番不止！</div>
    <div className="bangumi-tabs">
      {states.map(([value, label], index) => <button key={value} className={`bangumi-tab ${tab === value ? 'bangumi-active' : ''}`} onClick={() => { setTab(value); setPage(1); }}>
        {label} ({counts.data?.[index]?.total || 0})
      </button>)}
    </div>
    <Status {...entries} empty={!entries.data?.items.length} />
    <div className="resource-list bangumis">
      {entries.data?.items.map(item => <article key={item.id} className="bangumi-item">
        <Media src={item.cover} alt={item.title} />
        <div className="bangumi-content">
          <div className="bangumi-heading"><h2>{item.title}</h2></div>
          <div className="bangumi-meta">
            <span><b>集数</b>{episodes(item.metadata.progress, item.metadata.total)}</span>
            <span><b>{String(item.metadata.type || '番剧')}</b>{String(item.metadata.region || '—')}</span>
            <span><b>总播放</b>{metric(item.metadata.plays)}</span>
            <span><b>追番人数</b>{metric(item.metadata.followers)}</span>
            <span><b>硬币数</b>{metric(item.metadata.coins)}</span>
            <span><b>弹幕总数</b>{metric(item.metadata.danmaku)}</span>
            <span><b>评分</b>{metric(item.metadata.rating)}</span>
          </div>
          <p className="bangumi-summary">简介：{item.summary || '暂无简介'}</p>
          {item.locked ? <LoadedContent kind="bangumis" item={item} /> : item.url && <a href={safeUrl(item.url)} target="_blank" rel="noreferrer">查看详情 →</a>}
        </div>
      </article>)}
    </div>
    <Pager page={page} total={entries.data?.total || 0} onChange={setPage} />
  </PageShell>;
}

import './bangumi.css';
