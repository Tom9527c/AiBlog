/* Run before starting a production build with DB_SYNCHRONIZE=false. Never deletes files or rows. */
const mysql = require('mysql2/promise');
require('dotenv').config({ path: [`.env.${process.env.NODE_ENV || 'development'}`, '.env'], quiet: true });

async function main() {
  const db = await mysql.createConnection({ host: process.env.DB_HOST, port: Number(process.env.DB_PORT), user: process.env.DB_USERNAME, password: process.env.DB_PASSWORD, database: process.env.DB_DATABASE });
  try {
    const columns = {
      visibility: "varchar(16) NOT NULL DEFAULT 'public'", source: "varchar(24) NOT NULL DEFAULT 'general'",
      storage_key: 'varchar(500) NULL', provider: 'varchar(20) NULL', blog_media_id: 'int NULL', mime: 'varchar(100) NULL', storage_profile: 'text NULL', previous_locations: 'longtext NULL',
    };
    const [existing] = await db.query('SHOW COLUMNS FROM tool_storage');
    for (const [name, type] of Object.entries(columns)) {
      if (!existing.some(row => row.Field === name)) await db.query(`ALTER TABLE tool_storage ADD COLUMN \`${name}\` ${type}`);
    }
    const [indices] = await db.query('SHOW INDEX FROM tool_storage');
    if (!indices.some(row => row.Column_name === 'blog_media_id' && !row.Non_unique)) await db.query('CREATE UNIQUE INDEX idx_tool_storage_blog_media ON tool_storage(blog_media_id)');
    await db.query(`INSERT IGNORE INTO tool_storage (name,fileName,ext_name,path,type,size,user_id,visibility,source,storage_key,provider,blog_media_id,mime,created_at,updated_at)
      SELECT LEFT(m.name,200),LEFT(m.name,200),SUBSTRING_INDEX(m.name,'.',-1),CONCAT('/blog-media/',m.id),
        CASE WHEN m.mime LIKE 'image/%' THEN 'image' WHEN m.mime LIKE 'video/%' THEN 'video' ELSE 'music' END,
        CONCAT(m.size,' B'),m.uploaderId,'private','blog',CONCAT('legacy-blog-private/',m.filename),'local',m.id,m.mime,m.createdAt,m.createdAt
      FROM blog_media m LEFT JOIN tool_storage s ON s.blog_media_id=m.id WHERE s.id IS NULL`);
    const [parents] = await db.query("SELECT id FROM sys_menu WHERE name='tools_storage_local' LIMIT 1");
    if (parents[0]) {
      await db.query("UPDATE sys_menu SET title='文件管理' WHERE id=?", [parents[0].id]);
      const [found] = await db.query("SELECT id FROM sys_menu WHERE permission='tool:storage:migrate'");
      if (!found.length) await db.query("INSERT INTO sys_menu(parent_id,type,name,title,permission,status,hide_in_menu,`order`,is_ext) VALUES(?,2,'tools_storage_migrate','迁移博客媒体','tool:storage:migrate',1,1,0,0)", [parents[0].id]);
    }
    const [[counts]] = await db.query("SELECT COUNT(*) files, SUM(source='blog') blogFiles FROM tool_storage");
    console.log('Unified storage migration complete:', counts);
  } finally { await db.end(); }
}
main().catch(error => { console.error('Storage migration failed:', error.code || error.message); process.exitCode = 1; });
