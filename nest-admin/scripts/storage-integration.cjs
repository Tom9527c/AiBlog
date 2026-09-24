const assert = require('node:assert/strict');
const crypto = require('node:crypto');
const fs = require('node:fs/promises');
const path = require('node:path');
const mysql = require('mysql2/promise');
const Redis = require('ioredis');
const argon2 = require('argon2');
require('dotenv').config({ path: ['.env.development', '.env'], quiet: true });
const base = process.env.BLOG_TEST_URL || 'http://localhost:3000';
const run = 'storage_test_' + Date.now();
const png = Buffer.from('iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAusB9Wl6r9sAAAAASUVORK5CYII=', 'base64');
async function main() {
  assert.equal(process.env.OSS_TYPE || 'local', 'local', 'Integration test requires local storage');
  const db = await mysql.createConnection({host:process.env.DB_HOST,port:Number(process.env.DB_PORT),user:process.env.DB_USERNAME,password:process.env.DB_PASSWORD,database:process.env.DB_DATABASE});
  const redis = new Redis({host:process.env.REDIS_HOST,port:Number(process.env.REDIS_PORT),password:process.env.REDIS_PASSWORD,db:Number(process.env.REDIS_DB)});
  const users = [], extraPaths = [], docs = [], albums = [], photos = [], testRoles = [];
  let checks = 0;
  const check = (condition, label) => { assert.ok(condition, label); console.log('PASS', label); checks++; };
  async function api(route, method='GET', body, token) {
    const headers = token ? { Authorization: 'Bearer ' + token } : {};
    if (body && !(body instanceof FormData)) headers['Content-Type'] = 'application/json';
    return (await fetch(base + route, {method,headers,body:body ? body instanceof FormData ? body : JSON.stringify(body) : undefined})).json();
  }
  async function ok(...args) { const r = await api(...args); assert.equal(r.code, 200, r.message); return r.data; }
  async function account(role) {
    const password = crypto.randomBytes(18).toString('hex'), username = run + '_' + users.length;
    const [insert] = await db.execute('INSERT INTO user(username,password,status) VALUES(?,?,1)', [username, await argon2.hash(password)]);
    users.push(insert.insertId);
    await db.execute('INSERT INTO sys_user_roles(user_id,role_id) SELECT ?,id FROM sys_role WHERE value=?', [insert.insertId,role]);
    const captcha = await ok('/auth/captcha/img');
    const login = await ok('/auth/login', 'POST', {username,password,captchaId:captcha.id,code:await redis.get('captcha:img:'+captcha.id)});
    return login.access_token;
  }
  function file() { const data = new FormData(); data.append('file', new Blob([png], {type:'image/png'}), run+'.png'); return data; }
  try {
    const admin = await account('superadmin'), reader = await account('user');
    const uploaded = await ok('/blog/admin/upload','POST',file(),admin);
    const list = await ok('/tools/storage/list?source=blog&name='+run, 'GET', null, admin);
    check(list.total===1 && list.list[0].visibility==='private', 'blog upload appears in unified management');
    const managed = list.list[0];
    check(!('storageProfile' in managed) && !('storageKey' in managed) && managed.path==='', 'private listing exposes no credentials or object location');
    const [[row]] = await db.execute('SELECT * FROM tool_storage WHERE id=?', [managed.id]);
    check(row.provider==='local' && row.storage_key.startsWith('storage/blog-private/'), 'blog upload uses shared local configuration');
    check((await fetch(base+'/'+row.storage_key)).status===404, 'private object cannot be read through static server');
    check((await fetch(base+'/blog/public/media/'+uploaded.id)).status===403, 'unpublished blog object denied anonymously');
    const preview = await fetch(base+`/tools/storage/${managed.id}/preview`, {headers:{Authorization:'Bearer '+admin}});
    check(preview.status===200 && Buffer.from(await preview.arrayBuffer()).equals(png), 'storage administrator can preview original bytes');
    check((await api(`/tools/storage/${managed.id}/preview`, 'GET', null, reader)).code!==200, 'ordinary reader cannot use admin preview');
    const doc = await ok('/blog/admin/content/documents','POST',{title:run,slug:run,status:'published',accessMode:'login',cover:uploaded.url},admin);docs.push(doc.id);
    check((await api('/tools/storage/delete','POST',{ids:[managed.id]},admin)).code!==200, 'referenced blog file cannot be deleted');
    const refs = await ok('/tools/storage/list?source=blog&name='+run,'GET',null,admin);
    check(refs.list[0].references.some(ref=>ref.kind==='documents' && ref.contentId===doc.id), 'management shows reference location');
    check((await fetch(base+'/blog/public/media/'+uploaded.id,{headers:{Authorization:'Bearer '+reader}})).status===200,'blog login permission still permits authenticated read');
    await ok('/tools/upload/delete','DELETE',{fileNames:[row.storage_key.split('/').pop()]},admin);
    check((await fetch(base+`/tools/storage/${managed.id}/preview`,{headers:{Authorization:'Bearer '+admin}})).status===200,'ordinary upload delete route cannot bypass blog reference protection');
    const publicUrl = await ok('/tools/upload','POST',file(),admin);
    check((await fetch(base+publicUrl)).status===200,'general upload retains public URL');
    const general = await ok('/tools/storage/list?source=general&name='+run,'GET',null,admin);
    check(general.total===1 && general.list[0].provider==='local','general upload also enters unified records');
    check((await api(`/tools/storage/${managed.id}/migrate`,'POST',null,reader)).code!==200,'migration requires management permission');
    // Exercise legacy metadata and verified migration without touching existing user media.
    const oldName = crypto.randomUUID(); const oldPath = path.join(process.cwd(),'.blog-private',oldName); extraPaths.push(oldPath);
    await fs.writeFile(oldPath,png,{mode:0o600});
    const [legacy] = await db.execute('INSERT INTO blog_media(name,filename,mime,size,uploaderId) VALUES(?,?,?,?,?)',[run+'_legacy.png',oldName,'image/png',png.length,users[0]]);
    const [legacyFile] = await db.execute("INSERT INTO tool_storage(name,fileName,ext_name,path,type,size,user_id,source,visibility,provider,storage_key,blog_media_id,mime) VALUES(?,?,?,?,'image',?,?,'blog','private','local',?,?,'image/png')",[run+'_legacy',run+'_legacy.png','png','/blog-media/'+legacy.insertId,String(png.length),users[0],'legacy-blog-private/'+oldName,legacy.insertId]);
    check((await ok(`/tools/storage/${legacyFile.insertId}/migrate`,'POST',null,admin)).migrated,'legacy file migrates to active storage');
    check((await fs.readFile(oldPath)).equals(png),'migration retains original file');
    const [[migratedRow]] = await db.execute('SELECT previous_locations FROM tool_storage WHERE id=?', [legacyFile.insertId]);
    check(JSON.parse(migratedRow.previous_locations)[0].storageKey==='legacy-blog-private/'+oldName,'migration records recovery location');
    const legacyRead=await fetch(base+'/blog/public/media/'+legacy.insertId,{headers:{Authorization:'Bearer '+admin}});
    check(legacyRead.status===200 && Buffer.from(await legacyRead.arrayBuffer()).equals(png),'legacy blog ID resolves identical bytes after migration');
    check(!(await ok(`/tools/storage/${legacyFile.insertId}/migrate`,'POST',null,admin)).migrated,'repeated migration is idempotent');
    await ok('/blog/admin/content/documents/'+doc.id,'DELETE',null,admin);docs.pop();
    await ok('/tools/storage/delete','POST',{ids:[managed.id]},admin);
    check((await fetch(base+'/blog/public/media/'+uploaded.id,{headers:{Authorization:'Bearer '+admin}})).status===404,'unreferenced deletion removes blog media mapping');
    const [role] = await db.execute("INSERT INTO sys_role(name,value,status) VALUES(?,?,1)", [run+'_album',run+'_album']); testRoles.push(role.insertId);
    await db.execute("INSERT INTO sys_role_menus(role_id,menu_id) SELECT ?,id FROM sys_menu WHERE permission IN ('blog:albums:list','blog:albums:create','blog:albums:update')",[role.insertId]);
    const albumEditor = await account(run+'_album');
    const album = await ok('/blog/admin/content/albums','POST',{title:run+'_album',slug:run+'_album',status:'published',accessMode:'login'},albumEditor); albums.push(album.id);
    const fixtures = [
      {name:run+'.gif', mime:'image/gif', bytes:Buffer.from('R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7','base64'), type:'image'},
      {name:run+'.mp4', mime:'video/mp4', bytes:Buffer.from([0,0,0,24,...Buffer.from('ftypisom'),0,0,0,0,...Buffer.from('isommp42')]), type:'video'}
    ];
    for(const fixture of fixtures) {
      const form=new FormData(); form.append('file',new Blob([fixture.bytes],{type:fixture.mime}),fixture.name);
      const media=await ok('/blog/admin/upload','POST',form,albumEditor);
      check(media.mime===fixture.mime,'upload returns verified '+fixture.mime);
      const photo=await ok('/blog/admin/content/photos','POST',{parentId:album.id,title:fixture.name,url:media.url,status:'published',metadata:{mediaType:'image'}},albumEditor);photos.push(photo.id);
      check(photo.metadata.mediaType===fixture.type,'album update permission creates child and infers '+fixture.type);
      await ok('/blog/admin/content/photos/'+photo.id,'PUT',{summary:'test caption',sort:10},albumEditor);
      check((await fetch(base+'/blog/public/media/'+media.id)).status===403,'album login rule protects '+fixture.type);
    }
    const adminPhotos=await ok('/blog/admin/content/photos?parentId='+album.id,'GET',null,albumEditor);
    check(adminPhotos.total===2,'album list permission lists child media without photo permissions');
    check((await api('/blog/public/content/photos?parentId='+album.id)).code!==200,'locked album denies anonymous media list');
    const publicPhotos=await ok('/blog/public/content/photos?parentId='+album.id,'GET',null,reader);
    check(publicPhotos.items.some(item=>item.metadata.mediaType==='video'),'public album response carries video type');
    check((await api('/blog/admin/content/photos','POST',{parentId:album.id,title:'denied',url:'/x.gif'},reader)).code!==200,'reader cannot change album media');
    for(const id of [...photos]) await ok('/blog/admin/content/photos/'+id,'DELETE',null,albumEditor);
    photos.length=0;
    check((await ok('/blog/admin/content/photos?parentId='+album.id,'GET',null,albumEditor)).total===0,'album update permission removes child media');
    const [photoMenus]=await db.query("SELECT id FROM sys_menu WHERE name='blog_photos' AND type=1");
    check(photoMenus.length===0,'standalone photo management menu removed');
    console.log('Storage integration complete:', checks, 'checks passed');
  } finally {
    for (const id of photos) { await db.execute("DELETE FROM blog_media_reference WHERE kind='photos' AND contentId=?",[id]); await db.execute('DELETE FROM blog_photo WHERE id=?',[id]); }
    for (const id of albums) { await db.execute("DELETE FROM blog_media_reference WHERE kind='albums' AND contentId=?",[id]); await db.execute('DELETE FROM blog_album WHERE id=?',[id]); }
    for (const id of docs) { await db.execute("DELETE FROM blog_media_reference WHERE kind='documents' AND contentId=?",[id]); await db.execute('DELETE FROM blog_document WHERE id=?',[id]); }
    for (const uid of users) {
      const [files] = await db.execute('SELECT storage_key FROM tool_storage WHERE user_id=?',[uid]);
      for (const file of files) if(file.storage_key) {
        const relative = file.storage_key.startsWith('legacy-blog-private/') ? '.blog-private/'+file.storage_key.split('/').pop() : file.storage_key.startsWith('upload/') ? 'public/'+file.storage_key : file.storage_key;
        await fs.rm(path.join(process.cwd(),relative),{force:true});
      }
      await db.execute('DELETE FROM tool_storage WHERE user_id=?',[uid]);
      await db.execute('DELETE FROM blog_media WHERE uploaderId=?',[uid]);
      await db.execute('DELETE FROM sys_login_log WHERE user_id=?',[uid]);
      await db.execute('DELETE FROM sys_user_roles WHERE user_id=?',[uid]);
      await db.execute('DELETE FROM user WHERE id=?',[uid]);
      await redis.del('auth:permission:'+uid,'auth:token:'+uid);
    }
    for(const id of testRoles) { await db.execute('DELETE FROM sys_role_menus WHERE role_id=?',[id]); await db.execute('DELETE FROM sys_role WHERE id=?',[id]); }
    for(const item of extraPaths) await fs.rm(item,{force:true});
    await redis.quit();await db.end();console.log('Isolated storage test data cleaned.');
  }
}
main().catch(error=>{console.error(error.message);process.exitCode=1});
