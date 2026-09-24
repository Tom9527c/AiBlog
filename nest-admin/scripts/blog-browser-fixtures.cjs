const mysql=require('mysql2/promise'),fs=require('node:fs/promises'),path=require('node:path');
require('dotenv').config({path:['.env','.env.development'],override:true,quiet:true});
const stateFile=path.join(process.cwd(),'.blog-backups','browser-fixtures.json');
(async()=>{
 const db=await mysql.createConnection({host:process.env.DB_HOST,port:Number(process.env.DB_PORT),user:process.env.DB_USERNAME,password:process.env.DB_PASSWORD,database:process.env.DB_DATABASE});
 try {
  if(process.argv[2]==='cleanup'){
   const state=JSON.parse(await fs.readFile(stateFile,'utf8'));
   for(const [table,id] of state.rows.reverse())await db.execute('DELETE FROM '+table+' WHERE id=?',[id]);
   if(state.userId){
    await db.execute('DELETE FROM sys_login_log WHERE user_id=?',[state.userId]);
    await db.execute('DELETE FROM sys_user_roles WHERE user_id=?',[state.userId]);
    await db.execute('DELETE FROM user WHERE id=?',[state.userId]);
   }
   await fs.unlink(stateFile);console.log('Browser fixtures cleaned.');return;
  }
  if(process.argv[2]==='account'){
   const state=JSON.parse(await fs.readFile(stateFile,'utf8'));
   if(state.userId)await db.execute('UPDATE user SET dept_id=(SELECT id FROM sys_dept ORDER BY id LIMIT 1) WHERE id=?',[state.userId]);
   const username='blogqa'+Date.now().toString().slice(-9),password=require('node:crypto').randomBytes(8).toString('hex');
   if(state.userId){
    await db.execute('UPDATE user SET username=?,password=? WHERE id=?',[username,await require('argon2').hash(password),state.userId]);
    console.log(JSON.stringify({username,password}));return;
   }
   const [result]=await db.execute('INSERT INTO user(username,password,status) VALUES(?,?,1)',[username,await require('argon2').hash(password)]);
   state.userId=result.insertId;
   await fs.writeFile(stateFile,JSON.stringify(state),{mode:0o600});
   await db.execute('UPDATE user SET dept_id=(SELECT id FROM sys_dept ORDER BY id LIMIT 1) WHERE id=?',[state.userId]);
   await db.execute("INSERT INTO sys_user_roles(user_id,role_id) SELECT ?,id FROM sys_role WHERE value='superadmin' AND status=1",[state.userId]);
   console.log(JSON.stringify({username,password}));return;
  }
  try{await fs.access(stateFile);throw new Error('Existing fixtures need cleanup first');}catch(e){if(e.code!=='ENOENT')throw e;}
  const rows=[];
  async function add(table,values){
   const item={title:'浏览器验收样例',slug:'qa-browser-'+table,summary:'仅用于本地验收，完成后清理。',body:'',format:'markdown',cover:'',url:'',groupName:'',sort:0,status:'published',accessMode:'public',passwordHash:'',accessVersion:1,parentId:null,categoryId:null,tagIds:'[]',metadata:'{}',publishedAt:new Date(Date.now()-60000),...values};
   const [r]=await db.query('INSERT INTO ?? SET ?',[table,item]);rows.push([table,r.insertId]);return r.insertId;
  }
  const category=await add('blog_category',{title:'验收分类'}),tag=await add('blog_tag',{title:'React'});
  const body='# 阅读与排版\n\n这是本地浏览器验收样例，用于检查文章布局、目录锚点和代码复制。\n\n## 代码示例\n\n```javascript\nconst message = "Hello, AiBlog";\nconsole.log(message);\n```\n\n## 响应式布局\n\n手机与桌面均应支持阅读、主题切换和访问控制。\n\n'+('测试段落用于验证阅读进度和目录跟随。\n\n'.repeat(24));
  const doc=await add('blog_document',{title:'React 博客阅读体验验收',body,categoryId:category,tagIds:JSON.stringify([tag])});
  const hash=await require('argon2').hash('qa-view-password');
  const locked=await add('blog_document',{title:'密码可见内容验收',slug:'qa-browser-password',body:'# 解锁成功\n\n只有正确访问密码才能获得这段正文。',accessMode:'password',passwordHash:hash});
  const login=await add('blog_document',{title:'登录可见内容验收',slug:'qa-browser-login',body:'此正文需要真实登录才能读取。',accessMode:'login'});
  const about=await add('blog_about',{title:'关于页面验收',body:'关于页面布局与动画测试。',metadata:JSON.stringify({skills:['React','TypeScript'],experiences:[{title:'测试经历',date:'2026',description:'用于验证时间线'}],cards:[{title:'测试卡片',description:'用于验证卡片排版',url:'/archives/',image:''}],socials:[],donationText:'测试打赏展示',donationImage:''})});
  const album=await add('blog_album',{title:'相册页面验收'});
  for(const [table,values] of [['blog_bangumi',{title:'追番页面验收',metadata:JSON.stringify({state:'watching',progress:3,total:12,rating:8})}],['blog_essay',{title:'说说页面验收',body:'这是一条仅用于本地验收的短文。'}],['blog_link',{title:'示例友链',url:'https://example.com'}],['blog_moment',{title:'朋友圈页面验收',body:'用于验证动态详情。'}],['blog_collection',{title:'示例收藏',url:'https://example.com'}]])await add(table,values);
  await fs.mkdir(path.dirname(stateFile),{recursive:true});await fs.writeFile(stateFile,JSON.stringify({rows}),{mode:0o600});
  console.log('Temporary browser fixtures ready:',JSON.stringify({document:doc,password:locked,login,about,album}));
 }finally{await db.end();}
})().catch(e=>{console.error(e.code||e.message);process.exitCode=1});
