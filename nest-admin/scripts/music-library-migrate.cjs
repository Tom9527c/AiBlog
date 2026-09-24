/* Additive, repeatable music library migration. Does not modify existing music. */
const mysql = require('mysql2/promise');
require('dotenv').config({ path: ['.env.development', '.env'], override: false, quiet: true });
(async () => {
 const db = await mysql.createConnection({ host: process.env.DB_HOST, port: Number(process.env.DB_PORT), user: process.env.DB_USERNAME, password: process.env.DB_PASSWORD, database: process.env.DB_DATABASE });
 try {
  await db.query('CREATE TABLE IF NOT EXISTS blog_music_library (id INT NOT NULL PRIMARY KEY, state JSON NOT NULL) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4');
  console.log('Music library schema ready; existing music preserved.');
 } finally { await db.end(); }
})().catch(e => { console.error('Migration failed:', e.code || e.message); process.exitCode = 1; });
