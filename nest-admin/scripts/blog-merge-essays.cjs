/* Repeatable consolidation. Legacy rows remain untouched; IDs are recorded even if a migrated essay is later deleted. */
const fs = require('node:fs/promises');
const path = require('node:path');
const mysql = require('mysql2/promise');
require('dotenv').config({ path: ['.env', '.env.development'], override: true, quiet: true });
async function main() {
 const db = await mysql.createConnection({host:process.env.DB_HOST,port:Number(process.env.DB_PORT),user:process.env.DB_USERNAME,password:process.env.DB_PASSWORD,database:process.env.DB_DATABASE});
 try {
  const [[lock]] = await db.query("SELECT GET_LOCK('blog-merge-essays', 10) acquired");
  if (!lock.acquired) throw new Error('另一个迁移正在运行');
  const snapshot = {};
  for (const table of ['blog_essay','blog_moment','blog_media_reference','blog_menu','sys_menu','sys_role_menus']) {
   [snapshot[table]] = await db.query(`SELECT * FROM ${table}`);
  }
  const backup = path.join(process.cwd(), '.blog-backups', `essays-before-${new Date().toISOString().replace(/[:.]/g,'-')}.json`);
  await fs.mkdir(path.dirname(backup),{recursive:true});
  await fs.writeFile(backup, JSON.stringify(snapshot,null,2),{mode:0o600});
  await db.query('CREATE TABLE IF NOT EXISTS blog_essay_migration (momentId INT PRIMARY KEY, essayId INT NOT NULL UNIQUE) ENGINE=InnoDB');
  await db.beginTransaction();
  const [rows] = await db.query('SELECT m.* FROM blog_moment m LEFT JOIN blog_essay_migration x ON x.momentId=m.id WHERE x.momentId IS NULL FOR UPDATE');
  for (const row of rows) {
   const fields = Object.keys(row).filter(k => k !== 'id');
   let slug = row.slug;
   const [[existing]] = await db.execute('SELECT COUNT(*) total FROM blog_essay WHERE slug=?',[slug]);
   if (existing.total) slug = `moment-${row.id}-${require('node:crypto').randomUUID()}`;
   const values = fields.map(k => k === 'slug' ? slug : ['metadata','tagIds'].includes(k) ? (typeof row[k] === 'string' ? row[k] : JSON.stringify(row[k])) : row[k]);
   const [result] = await db.execute(`INSERT INTO blog_essay (${fields.map(k=>'`'+k+'`').join(',')}) VALUES (${fields.map(()=>'?').join(',')})`,values);
   await db.execute('INSERT INTO blog_essay_migration(momentId,essayId) VALUES (?,?)',[row.id,result.insertId]);
   await db.execute("INSERT IGNORE INTO blog_media_reference(mediaId,kind,contentId) SELECT mediaId,'essays',? FROM blog_media_reference WHERE kind='moments' AND contentId=?",[result.insertId,row.id]);
   // Active references move to the unified source so archived public rows cannot expose media after access changes.
   await db.execute("DELETE FROM blog_media_reference WHERE kind='moments' AND contentId=?",[row.id]);
  }
  const [[essayMenu]] = await db.query("SELECT id FROM sys_menu WHERE name='blog_essays' AND type=1 LIMIT 1");
  const [[momentMenu]] = await db.query("SELECT id FROM sys_menu WHERE name='blog_moments' AND type=1 LIMIT 1");
  if (!essayMenu) throw new Error('请先运行 blog:migrate 初始化菜单');
  await db.execute("UPDATE sys_menu SET title='即刻短文' WHERE id=?",[essayMenu.id]);
  if (momentMenu) {
   await db.execute('INSERT IGNORE INTO sys_role_menus(role_id,menu_id) SELECT role_id,? FROM sys_role_menus WHERE menu_id=?',[essayMenu.id,momentMenu.id]);
   for (const action of ['list','create','update','delete']) {
    await db.execute(`INSERT IGNORE INTO sys_role_menus(role_id,menu_id) SELECT rm.role_id,dst.id FROM sys_role_menus rm JOIN sys_menu src ON src.id=rm.menu_id JOIN sys_menu dst ON dst.permission=? WHERE src.permission=?`,[`blog:essays:${action}`,`blog:moments:${action}`]);
   }
   await db.execute('UPDATE sys_menu SET hide_in_menu=1 WHERE id=?',[momentMenu.id]);
  }
  await db.query("UPDATE blog_menu SET path='/essay/',title=CASE WHEN title IN ('朋友圈','说说','闲言碎语') THEN '即刻短文' ELSE title END WHERE path IN ('/essay/','/fcircle/')");
  // Retain the old editable menu record but avoid duplicate navigation destinations.
  await db.query("UPDATE blog_menu SET enabled=0 WHERE id IN (SELECT id FROM (SELECT m.id FROM blog_menu m JOIN blog_menu first ON first.path=m.path AND first.id<m.id WHERE m.path='/essay/') duplicates)");
  await db.commit();
  const [[counts]] = await db.query('SELECT (SELECT COUNT(*) FROM blog_essay) essays,(SELECT COUNT(*) FROM blog_moment) legacyMoments,(SELECT COUNT(*) FROM blog_essay_migration) migrated');
  console.log(JSON.stringify({inserted:rows.length,...counts,backup}));
 } catch(error) {await db.rollback();console.error(error.message);process.exitCode=1;}
 finally {await db.query("SELECT RELEASE_LOCK('blog-merge-essays')");await db.end();}
}
main();
