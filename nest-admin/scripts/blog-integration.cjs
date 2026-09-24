const assert = require('node:assert/strict');
const fs = require('node:fs/promises');
const path = require('node:path');
const crypto = require('node:crypto');
const mysql = require('mysql2/promise');
const Redis = require('ioredis');
const argon2 = require('argon2');
require('dotenv').config({path:['.env','.env.development'],override:true,quiet:true});
const base = process.env.BLOG_TEST_URL || 'http://localhost:3000';
const run = 'blog_test_'+Date.now();
let checks = 0;
function check(value, label) { assert.ok(value,label); checks++; console.log('PASS',label); }
async function main() {
 const db=await mysql.createConnection({host:process.env.DB_HOST,port:Number(process.env.DB_PORT),user:process.env.DB_USERNAME,password:process.env.DB_PASSWORD,database:process.env.DB_DATABASE});
 const redis=new Redis({host:process.env.REDIS_HOST,port:Number(process.env.REDIS_PORT),password:process.env.REDIS_PASSWORD,db:Number(process.env.REDIS_DB)});
 const users=[], records=[], tokens=[], media=[], menus=[], testRoles=[], testPermissions=[];
 async function request(route,method='GET',body,token,grants,extraHeaders={}) {
  const headers={}; if(token)headers.Authorization='Bearer '+token;if(grants)headers['X-Blog-Unlock']=JSON.stringify(grants);
  Object.assign(headers,extraHeaders);
  if(body && !(body instanceof FormData))headers['Content-Type']='application/json';
  const response=await fetch(base+route,{method,headers,body:body ? body instanceof FormData?body:JSON.stringify(body):undefined});
  const result=await response.json();return {http:response.status,...result};
 }
 async function ok(...args) { const r=await request(...args);assert.equal(r.code,200,`${args[1]||'GET'} ${args[0]}: ${r.message}`);return r.data; }
 async function account(role) {
  const password=crypto.randomBytes(18).toString('hex'), username=run+'_'+users.length;
  const [insert]=await db.execute('INSERT INTO user(username,password,status) VALUES(?,?,1)',[username,await argon2.hash(password)]);users.push(insert.insertId);
  await db.execute('INSERT INTO sys_user_roles(user_id,role_id) SELECT ?,id FROM sys_role WHERE value=?',[insert.insertId,role]);
  const captcha=await ok('/auth/captcha/img');
  const code=await redis.get('captcha:img:'+captcha.id);
  const login=await ok('/auth/login','POST',{username,password,captchaId:captcha.id,code});
  tokens.push(login.access_token);return login.access_token;
 }
 async function create(kind,data,admin) {const item=await ok('/blog/admin/content/'+kind,'POST',{title:run+' 验证内容',slug:run+'_'+kind+'_'+records.length,status:'published',...data},admin);records.push([kind,item.id]);return item;}
 try {
  const admin=await account('superadmin'), reader=await account('user');
  const editorRole=run+'_editor';
  const [roleInsert]=await db.execute('INSERT INTO sys_role(name,value,status) VALUES(?,?,1)',[editorRole,editorRole]);testRoles.push(roleInsert.insertId);
  const [permInsert]=await db.execute("INSERT INTO sys_menu(type,name,title,permission,status) VALUES(2,?,?,?,1)",[run+'_perm','test essay permission','blog:essays:create']);testPermissions.push(permInsert.insertId);
  await db.execute('INSERT INTO sys_role_menus(role_id,menu_id) VALUES(?,?)',[roleInsert.insertId,permInsert.insertId]);
  const editor=await account(editorRole);
  await create('essays',{body:'editor-owned'},editor);
  await db.execute('UPDATE sys_role SET status=0 WHERE id=?',[roleInsert.insertId]);
  check((await request('/blog/admin/content/essays','POST',{title:'blocked',slug:run+'_blocked'},editor)).code!==200,'disabled role cannot create content');
  await db.execute('UPDATE sys_role SET status=1 WHERE id=?',[roleInsert.insertId]);
  await db.execute('UPDATE sys_menu SET status=0 WHERE id=?',[permInsert.insertId]);
  check((await request('/blog/admin/content/essays','POST',{title:'blocked',slug:run+'_blocked'},editor)).code!==200,'disabled permission cannot create content');
  await db.execute('UPDATE sys_menu SET status=1 WHERE id=?',[permInsert.insertId]);
  check((await ok('/blog/public/session','GET',null,reader)).username.startsWith(run),'existing captcha/login and shared account session');
  const site=await ok('/blog/public/site');check(site.title && Array.isArray((await ok('/blog/public/menus'))),'site and database navigation');
  check((await request('/blog/admin/site')).code!==200,'anonymous admin requests denied');
  check((await request('/blog/admin/site','PUT',{title:'should not write'},reader)).code!==200,'ordinary reader cannot write site');
  const open=await create('documents',{body:'public article'},admin);
  const login=await create('documents',{body:'secret-login-body',accessMode:'login'},admin);
  const protectedDoc=await create('documents',{body:'secret-password-body',accessMode:'password',password:'view-password'},admin);
  const draft=await create('documents',{body:'draft-body',status:'draft'},admin);
  check((await ok('/blog/public/content/documents/'+open.id)).body==='public article','public document anonymous detail');
  const locked=await ok('/blog/public/content/documents/'+login.id);check(locked.locked && !('body' in locked),'login document anonymous body withheld');
  check((await ok('/blog/public/content/documents/'+login.id,'GET',null,reader)).body==='secret-login-body','verified reader can read login document');
  check((await request('/blog/public/content/documents/'+login.id,'GET',null,'invalid-token')).code!==200,'invalid token rejected');
  check((await request('/blog/public/content/documents/'+draft.id)).code!==200,'draft not accessible by detail URL');
  const list=await ok('/blog/public/content/documents?keyword='+run);
  check(list.items.length>=3 && list.items.every(item=>!('body' in item)&&!('passwordHash' in item)),'list never returns content body or password hash');
  check((await ok('/blog/public/content/documents?keyword=secret-password-body')).total===0,'search cannot match protected body');
  const archived=await create('documents',{publishedAt:'2020-04-15T04:00:00.000Z'},admin);
  const archiveMonth=await ok('/blog/public/content/documents?keyword='+run+'&year=2020&month=4');
  check(archiveMonth.total===1 && archiveMonth.items[0].id===archived.id,'archive month filters before pagination');
  check((await ok('/blog/public/content/documents?keyword='+run+'&year=2020&month=5')).total===0,'archive excludes other months');
  check((await request('/blog/public/content/documents?month=4')).code!==200,'archive month requires year');
  check((await request('/blog/public/content/documents/'+protectedDoc.id+'/unlock','POST',{password:'wrong'})).code!==200,'wrong content password rejected');
  const unlock=await ok('/blog/public/content/documents/'+protectedDoc.id+'/unlock','POST',{password:'view-password'});
  const grants={['documents:'+protectedDoc.id]:unlock.token};
  check((await ok('/blog/public/content/documents/'+protectedDoc.id,'GET',null,null,grants)).body==='secret-password-body','correct password grants anonymous read');
  await ok('/blog/admin/content/documents/'+protectedDoc.id,'PUT',{password:'changed-password'},admin);
  check((await ok('/blog/public/content/documents/'+protectedDoc.id,'GET',null,null,grants)).locked,'changed password invalidates old grant');
  const category=await create('categories',{},admin),tag=await create('tags',{},admin);
  await ok('/blog/admin/content/documents/'+open.id,'PUT',{categoryId:category.id,tagIds:[tag.id]},admin);
  check((await ok('/blog/public/content/documents?categoryId='+category.id+'&tagId='+tag.id)).items.some(x=>x.id===open.id),'classification/tag query uses saved relations');
  check((await request('/blog/admin/content/categories/'+category.id,'DELETE',null,admin)).code!==200,'referenced category deletion denied');
  const album=await create('albums',{accessMode:'password',password:'album-password'},admin);
  const upload=new FormData();upload.append('file',new Blob([Buffer.from('iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVQIHWP4z8DwHwAFgAI/ScLbtAAAAABJRU5ErkJggg==','base64')],{type:'image/png'}),'test.png');
  const uploaded=await ok('/blog/admin/upload','POST',upload,admin);media.push(uploaded.id);
  await db.execute('UPDATE sys_menu SET permission=? WHERE id=?',['blog:site:update',permInsert.insertId]);
  check((await request('/blog/admin/site','PUT',{logo:uploaded.url},editor)).code!==200,'site editor cannot claim another uploader orphan media');
  await db.execute('UPDATE sys_menu SET permission=? WHERE id=?',['blog:essays:create',permInsert.insertId]);
  const photo=await create('photos',{parentId:album.id,url:uploaded.url},admin);
  const publicAlbum=await create('albums',{},admin);
  await create('photos',{parentId:publicAlbum.id,body:'![outside](https://example.com/photo.jpg)'},admin);
  const validationBefore = (await ok('/blog/admin/site','GET',null,admin)).restrictedMediaValidationEnabled === true;
  try {
    await ok('/blog/admin/site','PUT',{restrictedMediaValidationEnabled:true},admin);
    check((await request('/blog/admin/content/albums/'+publicAlbum.id,'PUT',{accessMode:'login'},admin)).code!==200,'enabled media validation checks existing photo body media');
    await ok('/blog/admin/site','PUT',{restrictedMediaValidationEnabled:false},admin);
    check((await request('/blog/admin/content/albums/'+publicAlbum.id,'PUT',{accessMode:'login'},admin)).code===200,'disabled media validation permits external media in restricted albums');
  } finally {
    await ok('/blog/admin/site','PUT',{restrictedMediaValidationEnabled:validationBefore},admin);
  }
  check((await request('/blog/admin/content/essays','POST',{title:'attempt',slug:run+'_media_attack',cover:uploaded.url},editor)).code!==200,'limited editor cannot republish another resource private media');
  check((await request('/blog/public/content/photos?parentId='+album.id)).code!==200,'locked album blocks photo listing');
  check((await ok('/blog/public/content/photos/'+photo.id)).locked,'direct photo URL respects parent album');
  check((await fetch(base+'/blog/public/media/'+uploaded.id)).status===403,'raw managed media is not public');
  const albumGrant=await ok('/blog/public/content/albums/'+album.id+'/unlock','POST',{password:'album-password'});
  const ag={['albums:'+album.id]:albumGrant.token};
  check((await ok('/blog/public/content/photos?parentId='+album.id,'GET',null,null,ag)).items[0].url===uploaded.url,'album grant reveals photo');
  check((await fetch(base+'/blog/public/media/'+uploaded.id,{headers:{'X-Blog-Unlock':JSON.stringify(ag)}})).status===200,'album grant serves private media');
  const comment=await ok('/blog/public/comments','POST',{body:'pending test comment',nickname:'Integration Guest',email:'private@example.com',metadata:{targetKind:'documents',targetId:open.id}});records.push(['comments',comment.id]);
  const blankEmail=await ok('/blog/public/comments','POST',{body:'blank optional email',nickname:'Blank Email',email:'',metadata:{targetKind:'documents',targetId:open.id}});records.push(['comments',blankEmail.id]);
  check(blankEmail.status==='pending','blank optional email accepted');
  check(comment.status==='pending','new guest comments await moderation');
  const deniedReply=await request('/blog/public/comments','POST',{body:'reply to hidden parent',nickname:'Reply Guest',parentId:comment.id,metadata:{targetKind:'documents',targetId:open.id}});
  if(deniedReply.data?.id)records.push(['comments',deniedReply.data.id]);
  check(deniedReply.code!==200,'reply creation rejects unmoderated parent');
  check(!(await ok('/blog/public/comments?targetKind=documents&targetId='+open.id)).items.some(x=>x.id===comment.id),'pending comments invisible publicly');
  await ok('/blog/admin/comments/moderate','POST',{ids:[comment.id],status:'approved'},admin);
  const publicComments=await ok('/blog/public/comments?targetKind=documents&targetId='+open.id);
  const approvedComment=publicComments.items.find(x=>x.id===comment.id);
  check(approvedComment?.body==='pending test comment' && !('authorEmail' in approvedComment.metadata),'approved comments appear without private email');
  const genericComment=await ok('/blog/public/content/comments/'+comment.id);
  check(!('authorEmail' in genericComment.metadata) && !('votes' in genericComment.metadata),'generic comment detail omits contact and voter data');
  const queue=await ok('/blog/admin/comments?moderation=pending&targetKind=documents','GET',null,admin);
  check(queue.items.some(item=>item.id===blankEmail.id) && queue.counts.pending>=1,'admin pending queue and counts include guest');
  const emailSearch=await ok('/blog/admin/comments?keyword=private%40example.com','GET',null,admin);
  check(emailSearch.items.some(item=>item.id===comment.id),'admin search includes private guest email');
  const adminReply=await ok('/blog/admin/comments/'+comment.id+'/reply','POST',{body:'admin reply'},admin,null,{'User-Agent':'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 Chrome/140.0 Safari/537.36'});records.push(['comments',adminReply.id]);
  check(adminReply.metadata.isOwner===true && adminReply.metadata.browser.startsWith('Chrome ') && adminReply.metadata.os.startsWith('macOS ') && adminReply.metadata.location==='本地/内网','admin reply stores trusted identity, environment and local attribution');
  const visitor=crypto.randomUUID();
  const reaction=await request('/blog/public/comments/'+comment.id+'/reaction','POST',{value:1},null,null,{'X-Comment-Visitor':visitor});
  check(reaction.code===200 && reaction.data.likes===1 && reaction.data.myVote===1,'stable visitor reactions persist');
  const votedList=await request('/blog/public/comments?targetKind=documents&targetId='+open.id,'GET',null,null,null,{'X-Comment-Visitor':visitor});
  check(votedList.data.items.find(item=>item.id===comment.id).myVote===1,'visitor vote survives list refresh');
  const reply=await ok('/blog/public/comments','POST',{body:'approved-thread guest reply',nickname:'Reply Guest',parentId:comment.id,metadata:{targetKind:'documents',targetId:open.id}});records.push(['comments',reply.id]);
  await ok('/blog/admin/comments/moderate','POST',{ids:[reply.id],status:'approved'},admin);
  const thread=await ok('/blog/public/comments?targetKind=documents&targetId='+open.id);
  check(thread.items.find(item=>item.id===comment.id)?.replies.some(item=>item.id===reply.id),'approved reply appears beneath root');
  check(thread.commentCount>=2,'comment count includes replies');
  for(const kind of ['bangumis','essays','links','collections','music']) {
   const item=await create(kind,{body:'body '+kind},admin);
   await ok('/blog/admin/content/'+kind+'/'+item.id,'PUT',{title:'updated '+kind},admin);
   check((await ok('/blog/public/content/'+kind+'/'+item.id)).title==='updated '+kind,kind+' create/update/detail round trip');
  }
  const essayMedia = [{type:'image',url:uploaded.url,title:'GIF / 图片'}, {type:'video',url:'https://example.com/video.mp4'}, {type:'audio',url:'https://example.com/song.mp3',title:'歌曲',artist:'歌手'}, {type:'link',url:'https://example.com/share',title:'分享页面'}];
  const essay=await create('essays',{body:'多媒体短文正文',metadata:{media:essayMedia,occurredAt:'2026-08-20T01:00:00.000Z',location:'深圳 · 海边',mood:'开心 😊',weather:'晴 ☀️',tags:['旅行'],source:'相机'},sort:1},admin);
  const feed=(await ok('/blog/public/content/essays?keyword='+run)).items.find(row=>row.id===essay.id);
  check(feed.body==='多媒体短文正文' && feed.metadata.media.length===4 && feed.metadata.location==='深圳 · 海边','essay feed returns mixed media, body, occurrence and place');
  const publicTicker=(await ok('/blog/public/content/essays?accessMode=public&keyword='+run,'GET',null,admin));
  check(publicTicker.items.some(row=>row.id===essay.id) && publicTicker.items.every(row=>row.accessMode==='public'),'ticker query selects only public essays');
  check(feed.metadata.mood==='开心 😊' && feed.metadata.weather==='晴 ☀️','essay mood and weather survive save and public projection');
  await ok('/blog/admin/content/essays/'+essay.id,'PUT',{status:'draft'},admin);
  check(!(await ok('/blog/public/content/essays?keyword='+run)).items.some(row=>row.id===essay.id),'essay draft is excluded from feed');
  await ok('/blog/admin/content/essays/'+essay.id,'PUT',{status:'published',publishedAt:'2099-01-01T00:00:00.000Z'},admin);
  check(!(await ok('/blog/public/content/essays?keyword='+run)).items.some(row=>row.id===essay.id),'scheduled essay is excluded before release');
  await ok('/blog/admin/content/essays/'+essay.id,'PUT',{publishedAt:'2026-01-01T00:00:00.000Z',accessMode:'password',password:'essay-password',metadata:{media:[essayMedia[0]],occurredAt:'2026-08-20T01:00:00.000Z',location:'海边'}},admin);
  const lockedEssay=(await ok('/blog/public/content/essays?keyword='+run)).items.find(row=>row.id===essay.id);
  check(lockedEssay.locked && !lockedEssay.body && !lockedEssay.metadata.media,'locked essay withholds body and structured media');
  check(!(await ok('/blog/public/content/essays?accessMode=public&keyword='+run,'GET',null,admin)).items.some(row=>row.id===essay.id),'public ticker excludes password essay even for administrators');
  const essayGrant=await ok('/blog/public/content/essays/'+essay.id+'/unlock','POST',{password:'essay-password'});
  check((await ok('/blog/public/content/essays/'+essay.id,'GET',null,null,{['essays:'+essay.id]:essayGrant.token})).metadata.media[0].url===uploaded.url,'essay unlock reveals structured media');
  const essayComment=await ok('/blog/public/comments','POST',{body:'essay comment',nickname:'Essay Guest',metadata:{targetKind:'essays',targetId:essay.id}},null,{['essays:'+essay.id]:essayGrant.token});records.push(['comments',essayComment.id]);
  check(essayComment.status==='pending','essay comments target unlocked short posts and await moderation');
  check((await request('/blog/admin/content/moments','POST',{title:'obsolete entry'},admin)).code!==200,'obsolete moment writes rejected after consolidation');
  const about=await ok('/blog/admin/about','GET',null,admin);
  check(about && typeof about.metadata === 'object', 'about singleton configuration available');
  check((await request('/blog/admin/about','PUT',{title:'blocked'},reader)).code!==200,'ordinary reader cannot change personal page');
  const menu=await ok('/blog/admin/menus','POST',{title:'test nav',path:'/test-nav',enabled:true},admin);menus.push(menu.id);
  const child=await ok('/blog/admin/menus','POST',{title:'test child',path:'/test-child',parentId:menu.id},admin);menus.push(child.id);
  check((await request('/blog/admin/menus/'+menu.id,'PUT',{parentId:child.id},admin)).code!==200,'menu cycle rejected');
  await ok('/blog/admin/menus/'+menu.id,'PUT',{enabled:false},admin);
  check(!(await ok('/blog/public/menus')).some(x=>x.id===child.id),'disabled parent hides descendant navigation');
  const future=await create('documents',{body:'future body',publishedAt:new Date(Date.now()+3600000).toISOString()},admin);
  check((await request('/blog/public/content/documents/'+future.id)).code!==200,'scheduled detail unavailable before publication');
  check(!(await ok('/blog/public/content/documents?keyword='+run)).items.some(x=>x.id===future.id),'scheduled item omitted from public list');
  check((await request('/blog/admin/content/bangumis','POST',{title:'bad metadata',metadata:{state:'invalid'}},admin)).code!==200,'malformed resource metadata rejected');
  await ok('/blog/public/logout','POST',null,reader);
  check((await request('/blog/public/content/documents/'+login.id,'GET',null,reader)).code!==200,'logout revokes content access');
  console.log('Integration complete:',checks,'checks passed.');
 } finally {
  for(const id of menus.reverse()) await db.execute('DELETE FROM blog_menu WHERE id=?',[id]);
  const tables={documents:'document',categories:'category',tags:'tag',albums:'album',photos:'photo',bangumis:'bangumi',about:'about',essays:'essay',links:'link',moments:'moment',collections:'collection',music:'music',comments:'comment'};
  for(const [kind,id] of records.reverse()) {await db.execute('DELETE FROM blog_'+tables[kind]+' WHERE id=?',[id]);await db.execute('DELETE FROM blog_media_reference WHERE kind=? AND contentId=?',[kind,id]);}
  for(const id of media) {const [rows]=await db.execute('SELECT filename FROM blog_media WHERE id=?',[id]);if(rows[0])await fs.unlink(path.join(process.cwd(),'.blog-private',rows[0].filename)).catch(()=>{});await db.execute('DELETE FROM blog_media WHERE id=?',[id]);}
  for(const id of users){await db.execute('DELETE FROM sys_login_log WHERE user_id=?',[id]);await db.execute('DELETE FROM sys_user_roles WHERE user_id=?',[id]);await db.execute('DELETE FROM user WHERE id=?',[id]);await redis.del('auth:permission:'+id,'auth:token:'+id);}
  for(const id of testRoles) { await db.execute('DELETE FROM sys_role_menus WHERE role_id=?',[id]);await db.execute('DELETE FROM sys_role WHERE id=?',[id]); }
  for(const id of testPermissions)await db.execute('DELETE FROM sys_menu WHERE id=?',[id]);
  for(const token of tokens)await redis.del('token:blacklist:'+token);
  await redis.quit();await db.end();console.log('Isolated test data cleaned.');
 }
}
main().catch(error=>{console.error(error.message);process.exitCode=1});
