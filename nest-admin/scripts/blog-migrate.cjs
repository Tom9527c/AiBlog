/* Incremental, repeatable blog setup; never resets existing application tables. */
const fs = require('node:fs/promises');
const path = require('node:path');
const mysql = require('mysql2/promise');
const { initialNavigation, insertNavigation } = require('./blog-navigation.cjs');
const { legacyParentGrantRoles } = require('./blog-migration-permissions.cjs');
require('dotenv').config({ path: ['.env', '.env.development'], override: true, quiet: true });
const modules = [
  ['site','站点管理'],['menus','菜单管理'],['documents','文档管理'],['categories','分类管理'],['tags','标签管理'],
  ['albums','相册管理'],['bangumis','追番管理'],['about','关于本人管理'],['essays','即刻短文'],
  ['links','友链管理'],['moments','朋友圈管理'],['comments','评论管理'],['collections','收藏管理'],['music','音乐管理']
];
const tableNames = ['document','category','tag','album','photo','bangumi','about','essay','link','moment','collection','music','comment'];
async function main() {
 const db = await mysql.createConnection({host:process.env.DB_HOST,port:Number(process.env.DB_PORT),user:process.env.DB_USERNAME,password:process.env.DB_PASSWORD,database:process.env.DB_DATABASE,multipleStatements:false});
 try {
  const [oldMenus] = await db.execute("SELECT * FROM sys_menu WHERE path LIKE '/blog%' OR name LIKE 'blog%'");
  const [oldRoles] = await db.query('SELECT * FROM sys_role_menus WHERE menu_id IN (SELECT id FROM sys_menu WHERE path LIKE ? OR name LIKE ?)', ['/blog%','blog%']);
  const backupDir = path.join(process.cwd(), '.blog-backups');
  await fs.mkdir(backupDir, {recursive:true});
  const backupPath = path.join(backupDir, 'menus-before-'+new Date().toISOString().replace(/[:.]/g,'-')+'.json');
  await fs.writeFile(backupPath, JSON.stringify({menus:oldMenus,roles:oldRoles},null,2), {mode:0o600});
  for (const name of tableNames) await db.query(`CREATE TABLE IF NOT EXISTS blog_${name} (
   id INT NOT NULL AUTO_INCREMENT PRIMARY KEY, title VARCHAR(200) NOT NULL, slug VARCHAR(200) NOT NULL UNIQUE,
   summary TEXT NOT NULL, body LONGTEXT NOT NULL, format VARCHAR(12) NOT NULL DEFAULT 'markdown', cover TEXT NOT NULL, url TEXT NOT NULL,
   groupName VARCHAR(100) NOT NULL DEFAULT '', sort INT NOT NULL DEFAULT 0, status VARCHAR(12) NOT NULL DEFAULT 'draft',
   accessMode VARCHAR(12) NOT NULL DEFAULT 'public', passwordHash VARCHAR(255) NOT NULL DEFAULT '', accessVersion INT NOT NULL DEFAULT 1,
   parentId INT NULL, categoryId INT NULL, tagIds JSON NOT NULL, metadata JSON NOT NULL, authorId INT NULL, publishedAt DATETIME NULL,
   createdAt DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), updatedAt DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
   INDEX idx_published_sort (status,sort,publishedAt), INDEX idx_parent (parentId), INDEX idx_category (categoryId)
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci`);
  await db.query('CREATE TABLE IF NOT EXISTS blog_site (id INT NOT NULL AUTO_INCREMENT PRIMARY KEY, settings JSON NOT NULL) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4');
  await db.query(`CREATE TABLE IF NOT EXISTS blog_menu (id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,parentId INT NULL,title VARCHAR(100) NOT NULL,path VARCHAR(1000) NOT NULL,icon VARCHAR(100) NOT NULL DEFAULT '',sort INT NOT NULL DEFAULT 0,enabled TINYINT NOT NULL DEFAULT 1,external TINYINT NOT NULL DEFAULT 0,newWindow TINYINT NOT NULL DEFAULT 0) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4`);
  await db.query(`CREATE TABLE IF NOT EXISTS blog_media (id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,name VARCHAR(255) NOT NULL,filename VARCHAR(100) NOT NULL,mime VARCHAR(100) NOT NULL,size INT NOT NULL,uploaderId INT NOT NULL,createdAt DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4`);
  await db.query(`CREATE TABLE IF NOT EXISTS blog_media_reference (id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,mediaId INT NOT NULL,kind VARCHAR(30) NOT NULL,contentId INT NOT NULL,UNIQUE KEY media_ref (mediaId,kind,contentId)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4`);
  await db.query('CREATE TABLE IF NOT EXISTS blog_music_library (id INT NOT NULL PRIMARY KEY, state JSON NOT NULL) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4');
  await db.beginTransaction();
  await db.execute('INSERT IGNORE INTO blog_site (id,settings) VALUES (1,?)',[JSON.stringify({title:'AiBlog'})]);
  const [[{total}]] = await db.query('SELECT COUNT(*) total FROM blog_menu');
  // Seed the navigational skeleton exactly once; subsequent runs preserve edited menus.
  if (!total) {
   await insertNavigation(db, initialNavigation());
  }
  const [parents] = await db.execute("SELECT id FROM sys_menu WHERE path='/blog' ORDER BY id LIMIT 1");
  let parentId = parents[0]?.id;
  if (!parentId) { const [res] = await db.execute("INSERT INTO sys_menu(parent_id,type,name,path,title,component,status,hide_in_menu,icon,icon_type,`order`,is_ext,i18n_key,route_name) VALUES(0,0,'blog','/blog','博客管理','layout.base',1,0,'mdi:book-open-page-variant',0,3,0,'route.blog','blog')"); parentId=res.insertId; }
  else await db.execute("UPDATE sys_menu SET name='blog',title='博客管理',i18n_key='route.blog',route_name='blog',component='layout.base',is_ext=0,hide_in_menu=0,status=1,href=NULL,type=0 WHERE id=?",[parentId]);
  // A role's old external-link access must never become content administration.
  // Only the existing superadministrator receives bootstrap permissions.
  const roleIds = new Set();
  const [roles] = await db.query('SELECT id,value,status FROM sys_role');
  roles.filter(row=>row.value==='superadmin' && row.status===1).forEach(row=>roleIds.add(row.id));
  for (const old of oldMenus.filter(row=>['blog_zym','blog_zym-href'].includes(row.name))) {
   await db.execute('DELETE FROM sys_role_menus WHERE menu_id=?',[old.id]);
   await db.execute('DELETE FROM sys_menu WHERE id=?',[old.id]);
  }
  async function grant(id) { for (const roleId of roleIds) await db.execute('INSERT IGNORE INTO sys_role_menus(role_id,menu_id) VALUES(?,?)',[roleId,id]); }
  await grant(parentId);
  // Preserve deliberately assigned management access on repeated runs.
  // Only roles with the old parent but no management child grant are cleaned up.
  for (const roleId of legacyParentGrantRoles(parentId, oldMenus, oldRoles, roles)) {
   await db.execute('DELETE FROM sys_role_menus WHERE role_id=? AND menu_id=?', [roleId,parentId]);
  }
  for (let i=0;i<modules.length;i++) {
   const [resource,title]=modules[i]; const name='blog_'+resource;
   const [existing]=await db.execute('SELECT id FROM sys_menu WHERE name=? LIMIT 1',[name]);
   let menuId=existing[0]?.id;
   if (!menuId) { const [res]=await db.execute('INSERT INTO sys_menu(parent_id,type,name,path,title,component,status,hide_in_menu,icon,icon_type,`order`,is_ext,i18n_key,route_name) VALUES(?,1,?,?,?,?,1,0,?,0,?,0,?,?)',[parentId,name,'/blog/'+resource,title,'view.'+name,'mdi:book-edit-outline',i+1,'route.'+name,name]);menuId=res.insertId; }
   await grant(menuId);
   for (const action of resource==='site'?['list','update']:['list','create','update','delete']) {
    const permission=`blog:${resource}:${action}`;
    const [exists]=await db.execute('SELECT id FROM sys_menu WHERE permission=? LIMIT 1',[permission]);
    let id=exists[0]?.id;
    if (!id) {const [res]=await db.execute('INSERT INTO sys_menu(parent_id,type,name,title,permission,status,hide_in_menu,`order`,is_ext) VALUES(?,2,?,?,?,1,1,0,0)',[menuId,name+'_'+action,title+'-'+action,permission]);id=res.insertId;}
    await grant(id);
   }
  }
  // Photos are managed inside albums; retain their action permissions under that page.
  const [albumPages] = await db.execute("SELECT id FROM sys_menu WHERE name='blog_albums' AND type=1");
  const [photoPages] = await db.execute("SELECT id FROM sys_menu WHERE name='blog_photos' AND type=1");
  if (albumPages[0]) for (const page of photoPages) {
   await db.execute('UPDATE sys_menu SET parent_id=? WHERE parent_id=?',[albumPages[0].id,page.id]);
   await db.execute('DELETE FROM sys_role_menus WHERE menu_id=?',[page.id]);
   await db.execute('DELETE FROM sys_menu WHERE id=?',[page.id]);
  }
  await db.commit();
  const [[counts]]=await db.query("SELECT (SELECT COUNT(*) FROM sys_menu WHERE path LIKE '/blog%') adminMenus,(SELECT COUNT(*) FROM blog_menu) publicMenus");
  console.log('Blog migration complete:',JSON.stringify(counts),'Menu backup:',backupPath);
 } catch(error) { await db.rollback(); console.error('Blog migration failed:',error.code||error.message);process.exitCode=1; } finally { await db.end(); }
}
main();
