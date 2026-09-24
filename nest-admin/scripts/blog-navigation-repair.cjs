/* Run from nest-admin: node scripts/blog-navigation-repair.cjs [--apply]. */
const fs=require('node:fs/promises');
const path=require('node:path');
const mysql=require('mysql2/promise');
const {navigationUpgrade}=require('./blog-navigation.cjs');
require('dotenv').config({path:['.env','.env.development'],override:true,quiet:true});
async function main(){
 const db=await mysql.createConnection({host:process.env.DB_HOST,port:Number(process.env.DB_PORT),user:process.env.DB_USERNAME,password:process.env.DB_PASSWORD,database:process.env.DB_DATABASE});
 try {
  await db.beginTransaction();
  const [rows]=await db.query('SELECT * FROM blog_menu ORDER BY sort,id FOR UPDATE');
  const plan=navigationUpgrade(rows);
  if(!plan){await db.rollback();console.log('Skipped: menus are already grouped or have been customized.');return;}
  console.log(JSON.stringify({before:rows.length,after:plan.rows.length,groups:plan.rows.filter(r=>r.enabled&&!r.parentId).map(r=>r.title)}));
  if(!process.argv.includes('--apply')){await db.rollback();return;}
  const dir=path.join(process.cwd(),'.blog-backups');await fs.mkdir(dir,{recursive:true});
  const backup=path.join(dir,'navigation-before-'+new Date().toISOString().replace(/[:.]/g,'-')+'.json');
  await fs.writeFile(backup,JSON.stringify(rows,null,2),{mode:0o600});
  // Allocate inserted group ids through MySQL, preserving all existing ids.
  const existing=new Set(rows.map(r=>r.id)),ids=new Map(rows.map(r=>[r.id,r.id]));
  const added=plan.rows.filter(r=>!existing.has(r.id));
  for(const row of [...added.filter(r=>!r.parentId),...added.filter(r=>r.parentId)]){
   const [res]=await db.execute('INSERT INTO blog_menu(title,path,parentId,icon,sort,enabled,external,newWindow) VALUES (?,?,?,?,?,?,?,?)',[row.title,row.path,row.parentId?ids.get(row.parentId):null,row.icon,row.sort,row.enabled,row.external,row.newWindow]);ids.set(row.id,res.insertId);
  }
  for(const row of plan.rows.filter(r=>existing.has(r.id))) await db.execute('UPDATE blog_menu SET title=?,path=?,parentId=?,icon=?,sort=?,enabled=?,external=?,newWindow=? WHERE id=?',[row.title,row.path,row.parentId?ids.get(row.parentId):null,row.icon,row.sort,row.enabled,row.external,row.newWindow,row.id]);
  await db.commit();console.log('Applied. Backup:',backup);
 }catch(e){await db.rollback();console.error(e.code||e.message);process.exitCode=1;}finally{await db.end();}
}
main();
