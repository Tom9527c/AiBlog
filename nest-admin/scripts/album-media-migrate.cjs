/* Move legacy photo permissions under albums and remove only the obsolete navigation entry. */
const mysql = require('mysql2/promise');
require('dotenv').config({ path: [`.env.${process.env.NODE_ENV || 'development'}`, '.env'], quiet: true });
async function main() {
  const db = await mysql.createConnection({host:process.env.DB_HOST,port:Number(process.env.DB_PORT),user:process.env.DB_USERNAME,password:process.env.DB_PASSWORD,database:process.env.DB_DATABASE});
  try {
    await db.beginTransaction();
    const [albums] = await db.query("SELECT id FROM sys_menu WHERE name='blog_albums' AND type=1");
    const [photos] = await db.query("SELECT id FROM sys_menu WHERE name='blog_photos' AND type=1");
    if (!albums[0]) throw new Error('请先运行博客初始化');
    for (const photo of photos) {
      await db.execute('UPDATE sys_menu SET parent_id=? WHERE parent_id=?',[albums[0].id,photo.id]);
      await db.execute('DELETE FROM sys_role_menus WHERE menu_id=?',[photo.id]);
      await db.execute('DELETE FROM sys_menu WHERE id=?',[photo.id]);
    }
    await db.commit();
    console.log('Album media menu merged; existing photo records and permissions preserved.');
  } catch (error) { await db.rollback(); throw error; }
  finally { await db.end(); }
}
main().catch(error=>{ console.error(error.code || error.message); process.exitCode=1; });
