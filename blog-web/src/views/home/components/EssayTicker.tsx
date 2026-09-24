import { useEffect, useMemo, useState } from 'react';
import { Link } from 'react-router-dom';
import type { Content } from '../../../types';
import { essayBroadcast, publicEssays } from '../../essays/broadcast';
import { list } from '../../../services/content';
/** Ask the server to filter before pagination; include all published public short posts. */
export async function loadPublicEssays() {
  const items: Content[] = [];
  for (let page = 1; ; page += 1) {
    const result = await list('essays',{page,pageSize:100,accessMode:'public'});
    items.push(...result.items);
    if (!result.items.length || items.length >= result.total) break;
  }
  return { items };
}
export function EssayTicker({items, fallback}: {items: Content[]; fallback: string}) {
  const rows = useMemo(()=>publicEssays(items).map(item=>({id:item.id,text:essayBroadcast(item)})).filter(row=>row.text),[items]);
  const [index,setIndex] = useState(0);
  const [hovered,setHovered] = useState(false);
  const [focused,setFocused] = useState(false);
  useEffect(()=>{ setIndex(rows.length ? Math.floor(Math.random()*rows.length) : 0); },[rows]);
  useEffect(()=>{
    if (rows.length < 2 || hovered || focused) return;
    const timer = window.setInterval(()=>{
      if (document.hidden) return;
      setIndex(previous=>(previous + 1 + Math.floor(Math.random()*(rows.length-1))) % rows.length);
    },5000);
    return ()=>clearInterval(timer);
  },[rows,hovered,focused]);
  const current = rows[index % (rows.length || 1)];
  const href = current ? `/essay/?id=${current.id}` : '/essay/';
  return <div id="bbTimeList" className="bbTimeList container" aria-label="即刻短文播报" onMouseEnter={()=>setHovered(true)} onMouseLeave={()=>setHovered(false)} onFocus={()=>setFocused(true)} onBlur={event=>{if (!event.currentTarget.contains(event.relatedTarget)) setFocused(false);}}>
    <i className="anzhiyufont anzhiyu-icon-jike bber-logo fontbold" title="即刻短文" aria-hidden="true" />
    <div className="essay_bar_swiper_container" id="bbtalk">
      <div id="bber-talk"><Link key={current?.id || 'empty'} className="li-style essay-ticker-slide" to={href} title={current?.text || fallback}>{current?.text || fallback}</Link></div>
    </div>
    <Link className="bber-gotobb anzhiyufont anzhiyu-icon-circle-arrow-right" to={href} title="查看全文" aria-label="查看这条即刻短文" />
  </div>;
}
