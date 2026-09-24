// Restore non-superadmin blog assignments to the snapshot made before bootstrap.
const fs=require('node:fs/promises'),mysql=require('mysql2/promise');
require('dotenv').config({path:['.env','.env.development'],override:true,quiet:true});
(async()=>{
 const before=JSON.parse(await fs.readFile(process.argv[2],'utf8'));
 const original=new Set(before.roles.map(row=>row.role_id+':'+row.menu_id));
 const db=await mysql.createConnection({host:process.env.DB_HOST,port:Number(process.env.DB_PORT),user:process.env.DB_USERNAME,password:process.env.DB_PASSWORD,database:process.env.DB_DATABASE});
 try {
  const [rows]=await db.query("SELECT rm.role_id,rm.menu_id FROM sys_role_menus rm JOIN sys_role r ON r.id=rm.role_id JOIN sys_menu m ON m.id=rm.menu_id WHERE r.value <> 'superadmin' AND (m.path LIKE '/blog%' OR m.permission LIKE 'blog:%')");
  await db.beginTransaction();let removed=0;
  for(const row of rows)if(!original.has(row.role_id+':'+row.menu_id)){await db.execute('DELETE FROM sys_role_menus WHERE role_id=? AND menu_id=?',[row.role_id,row.menu_id]);removed++;}
  await db.commit();console.log('Restored previous non-superadmin authority; removed generated grants:',removed);
 }catch(e){await db.rollback();throw e;}finally{await db.end();}
})().catch(e=>{console.error(e.code||e.message);process.exitCode=1});
