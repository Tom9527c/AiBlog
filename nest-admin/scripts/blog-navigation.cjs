/* Original site's navigation skeleton; content remains backend-managed. */
const legacyNavigation = [['首页','/'],['文章','/archives/'],['分类','/categories/'],['标签','/tags/'],['相册','/album/'],['追番','/bangumis/'],['说说','/essay/'],['友链','/link/'],['朋友圈','/fcircle/'],['藏宝阁','/collect/'],['音乐','/music/'],['留言','/comments/'],['关于','/about/']];
function upgradeFlatNavigation(input) {
  const rows = [...input].sort((a,b)=>a.sort-b.sort || a.id-b.id);
  if (rows.length !== legacyNavigation.length || !rows.every((r,i)=>r.title===legacyNavigation[i][0] && r.path===legacyNavigation[i][1] && !r.parentId && !r.icon && r.sort===i && !!r.enabled && !r.external && !r.newWindow)) return null;
  const next=rows.map(r=>({...r,enabled:true}));
  const byPath=Object.fromEntries(next.map(r=>[r.path,r]));
  let id=Math.max(...next.map(r=>r.id));
  const create=(title,path,parentId,sort,icon='')=>{ const row={id:++id,title,path,parentId,sort,icon,enabled:true,external:false,newWindow:false};next.push(row);return row; };
  const articles=byPath['/archives/'],friends=byPath['/link/'],about=byPath['/about/'];
  const mine=create('我的','/music/',null,2);
  [articles,friends,mine,about].forEach((r,i)=>{r.sort=i;r.parentId=null;});
  const child=(path,parent,sort,title,icon)=>Object.assign(byPath[path],{parentId:parent.id,sort,title,icon:`anzhiyu-icon-${icon}`});
  Object.assign(byPath['/'],{enabled:false,sort:10}); // Site name already links home; keep the editable record.
  child('/categories/',articles,0,'分类','shapes');child('/tags/',articles,1,'标签','tags');
  child('/comments/',friends,0,'留言板','envelope');
  child('/fcircle/',friends,1,'朋友圈','user-group');byPath['/fcircle/'].enabled=false; // Available in admin; not in the original top menu.
  child('/music/',mine,0,'音乐馆','music');child('/bangumis/',mine,1,'追番页','bilibili');
  child('/album/',mine,2,'相册集','images');child('/collect/',mine,3,'藏宝阁','book-open');
  create('关于本人','/about/',about.id,0,'anzhiyu-icon-paper-plane');
  child('/essay/',about,1,'闲言碎语','lightbulb');
  create('随便逛逛','/random/',about.id,2,'anzhiyu-icon-shoe-prints1');
  [articles,friends,mine,about].forEach(r=>{r.path='';});
  return {rows:next.sort((a,b)=>a.sort-b.sort||a.id-b.id)};
}
function initialNavigation() {
 return upgradeFlatNavigation(legacyNavigation.map(([title,path],i)=>({id:i+1,title,path,parentId:null,icon:'',sort:i,enabled:true,external:false,newWindow:false}))).rows;
}
// Recognize the exact first grouped bootstrap format, preserving any user edits.
function navigationUpgrade(input) {
 const flat=upgradeFlatNavigation(input); if(flat) return flat;
 const oldPaths={'文章':'/archives/','友链':'/link/','我的':'/music/','关于':'/about/'};
 const prior=initialNavigation().map(r=>({...r,path:r.enabled&&!r.parentId?oldPaths[r.title]:r.path}));
 const signature=rows=>rows.map(r=>JSON.stringify([r.title,r.path,rows.find(p=>p.id===r.parentId)?.title||null,r.icon,r.sort,!!r.enabled,!!r.external,!!r.newWindow])).sort();
 if(JSON.stringify(signature(input))!==JSON.stringify(signature(prior))) return null;
 return {rows:input.map(r=>({...r,path:r.enabled&&!r.parentId?'':r.path}))};
}
async function insertNavigation(db, rows) {
 // Insert parents first and resolve auto-increment ids to avoid assuming an empty sequence.
 const ids=new Map();
 for (const row of [...rows.filter(r=>!r.parentId),...rows.filter(r=>r.parentId)]) {
  const [result]=await db.execute('INSERT INTO blog_menu(title,path,parentId,icon,sort,enabled,external,newWindow) VALUES (?,?,?,?,?,?,?,?)',[row.title,row.path,row.parentId?ids.get(row.parentId):null,row.icon,row.sort,row.enabled,row.external,row.newWindow]);
  ids.set(row.id,result.insertId);
 }
}
module.exports={legacyNavigation,navigationUpgrade,initialNavigation,insertNavigation};
