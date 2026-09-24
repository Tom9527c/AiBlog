/* Local QA; reference runs its original DOM/CSS without external scripts or business media. */
const fs=require('node:fs');const path=require('node:path');const assert=require('node:assert/strict');
const {chromium}=require(process.env.PLAYWRIGHT_PATH||'/Users/tom/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules/playwright');
const root=path.resolve(__dirname,'../../..');const {JSDOM}=require(root+'/blog-web/node_modules/jsdom');const out=__dirname;
const selectors=['#nav','#site-name','#menus > .menus_items','#nav-right','#bbTimeList','#home_top','#bannerGroup','#random-banner','.banners-title','.topGroup','.todayCard','#recent-posts','.recent-post-list'];
async function boxes(p){return p.evaluate(ss=>Object.fromEntries(ss.map(s=>{const e=document.querySelector(s),r=e?.getBoundingClientRect(),c=e&&getComputedStyle(e);return[s,{x:r?.x,y:r?.y,w:r?.width,h:r?.height,font:c?.fontSize,display:c?.display,visibility:c?.visibility,padding:c?.padding}]})),selectors)}
(async()=>{
 const browser=await chromium.launch({executablePath:'/Applications/Google Chrome.app/Contents/MacOS/Google Chrome',headless:true});
 try {
 const context=await browser.newContext({viewport:{width:1440,height:900},deviceScaleFactor:1,reducedMotion:'reduce'});
 const ref=await context.newPage();
 const reference='/Users/tom/Downloads/Tom9527c.github.io-main';
 const source=new JSDOM(fs.readFileSync(reference+'/index.html','utf8')).window.document;
 const skillFiles={Java:'java.jpg',Docker:'docker.png',Photoshop:'photoshop.png',Node:'node.svg',Webpack:'webpack.png',Pinia:'pinia.svg',Python:'python.png',Vite:'vite.svg',Flutter:'flutter.png',Vue:'vue.png',CSS3:'css3.png',JS:'javascript.png',HTML:'html.png',Git:'git.webp',Apifox:'apifox.png'}; const localSkills=Object.fromEntries(Object.entries(skillFiles).map(([k,v])=>[k,{local:'/theme/skills/'+v}]));
 await ref.route('**/*',async route=>{
   const url=new URL(route.request().url());if(url.hostname!=='reference.local') return route.abort();
   let file=path.join(reference,url.pathname==='/'?'index.html':decodeURIComponent(url.pathname));
   if(url.pathname.startsWith('/theme/')) file=root+'/blog-web/public'+url.pathname;
   if(!fs.existsSync(file)||fs.statSync(file).isDirectory())return route.fulfill({status:404,body:''});
   let body=fs.readFileSync(file);
   if(file.endsWith('index.html')){
     const d=new JSDOM(body.toString()).window.document;d.querySelectorAll('script,link[rel="stylesheet"]').forEach(e=>e.remove());
     for(const href of ['/css/index.css','/custom/css/elementUI.min.css','/custom/css/aurora.css','/theme/icon/iconfont.css']){const l=d.createElement('link');l.rel='stylesheet';l.href=href;d.head.appendChild(l);}
     d.querySelector('#nav')?.classList.add('show');
     d.querySelectorAll('#skills-tags-group-all img').forEach(img=>{const label=img.getAttribute('alt');const item=localSkills[label]; if(item)img.src=item.local; else if(img.dataset.lazySrc?.startsWith('data:'))img.src=img.dataset.lazySrc; img.classList.add('loaded');});
     const style=d.createElement('style');style.textContent='#loading-box,#loader {display:none!important} *,*::before,*::after {animation:none!important;transition:none!important}';d.head.appendChild(style);body=Buffer.from(d.documentElement.outerHTML);
   }
   await route.fulfill({body,contentType:file.endsWith('.html')?'text/html':file.endsWith('.css')?'text/css':file.endsWith('.woff2')?'font/woff2':undefined});
 });
 await ref.goto('http://reference.local/',{waitUntil:'networkidle'});
 const page=await context.newPage();const errors=[];page.on('pageerror',e=>errors.push(e.message));
 await page.goto('http://localhost:5174/',{waitUntil:'networkidle'});await page.evaluate(()=>document.fonts.ready);
 await page.locator('#menus > .menus_items > .menus_item').first().waitFor({state:'attached'});
 await page.waitForFunction(()=>!document.querySelector('#blog-container [role="status"]'));
 const menus=await page.request.get('http://localhost:5174/api/blog/public/menus');fs.writeFileSync(out+'/menus-after.json',JSON.stringify(await menus.json(),null,2));
 const measurements=[];
 for(const width of [360,390,768,1024,1440,1920]){
   await ref.setViewportSize({width,height:900});await page.setViewportSize({width,height:900});await ref.evaluate(w=>document.querySelector('#nav').classList.toggle('hide-menu',w<=768),width);await page.waitForTimeout(200);
   measurements.push({width,reference:await boxes(ref),actual:await boxes(page),overflow:await page.evaluate(()=>document.documentElement.scrollWidth>innerWidth)});
   if([390,1440].includes(width)){
     if(width===1440){await ref.locator('#menus .menus_item').first().hover();await page.locator('#menus .menus_item').first().hover();}
     await ref.screenshot({path:out+`/reference-${width}.png`});await page.screenshot({path:out+`/actual-${width}.png`});
   }
 }
 fs.writeFileSync(out+'/responsive-measurements.json',JSON.stringify({measurements,errors},null,2));
 console.log(JSON.stringify(measurements.map(x=>({width:x.width,overflow:x.overflow,nav:x.actual['#menus > .menus_items'],home:x.actual['#home_top'],referenceHome:x.reference['#home_top']})),null,2));

 const checks=[];
 const check=(name,value)=>{assert.ok(value,name);checks.push(name);};
 for(const m of measurements){check(`no page overflow at ${m.width}`,!m.overflow);check(`menu visibility at ${m.width}`,m.actual['#menus > .menus_items'].visibility===(m.width<=768?'hidden':'visible')); if(m.width>768)check(`centered menu at ${m.width}`,Math.abs(m.actual['#menus > .menus_items'].x+m.actual['#menus > .menus_items'].w/2-m.width/2)<1);}
 await page.setViewportSize({width:1440,height:900});
 await page.mouse.move(5,300);
 const group=page.getByRole('button',{name:'文章',exact:true});await group.focus();await group.press('ArrowDown');
 check('keyboard opens first child',await page.getByRole('link',{name:'分类',exact:true}).evaluate(e=>document.activeElement===e));
 await page.keyboard.press('Escape');check('Escape returns to group',await group.evaluate(e=>document.activeElement===e));
 await page.getByRole('button',{name:'搜索',exact:true}).click();check('search opens',await page.getByRole('dialog',{name:'搜索文章'}).isVisible());await page.keyboard.press('Escape');
 await page.getByRole('button',{name:'控制台',exact:true}).click();check('console opens',await page.getByRole('dialog',{name:'控制台'}).isVisible());
 await page.getByRole('button',{name:'☾ 深色模式',exact:true}).click();check('dark theme',await page.locator('html').getAttribute('data-theme')==='dark');await page.keyboard.press('Escape');
 await page.mouse.move(1,60);await page.screenshot({path:out+'/actual-dark.png'});
 await page.getByRole('button',{name:'控制台',exact:true}).click();await page.getByRole('button',{name:'☀ 浅色模式',exact:true}).click();await page.keyboard.press('Escape');
 await page.getByRole('button',{name:'更多推荐',exact:true}).click();check('more recommendations reveals posts',await page.locator('.topGroup.recommendations-visible').count()===1);check('recommendation cards are actually visible',await page.locator('.topGroup > .recent-post-item').first().isVisible());await page.mouse.move(1,10);check('leaving recommendation restores card',await page.locator('.topGroup.recommendations-visible').count()===0);
 await page.evaluate(()=>window.scrollTo({top:300,behavior:'instant'}));await page.waitForTimeout(120);check('sticky header while scrolling down',await page.locator('#page-header.nav-fixed').count()===1);check('scroll-down title',await page.locator('.nav-page-title').isVisible());check('sticky header remains in viewport',Math.abs((await page.locator('#nav').boundingBox()).y)<1);
 await page.evaluate(()=>window.scrollTo({top:30,behavior:'instant'}));await page.waitForTimeout(120);check('scroll up restores menu',await page.locator('#page-header.nav-visible').count()===1);
 await page.evaluate(()=>window.scrollTo({top:0,behavior:'instant'}));
 await page.setViewportSize({width:390,height:900});await page.getByRole('button',{name:'打开菜单'}).click();check('mobile drawer opens',await page.locator('#sidebar').isVisible());
 await page.locator('#sidebar').getByRole('link',{name:'分类',exact:true}).click();await page.waitForURL('**/categories/');check('mobile child routes and closes drawer',await page.locator('#sidebar').count()===0);
 await page.goto('http://localhost:5174/random/',{waitUntil:'networkidle'});await page.waitForURL('**/posts/**');check('random post route works',page.url().includes('/posts/'));
 check('no runtime exceptions',errors.length===0);
 // Matching content is injected only into browser responses. Nothing is persisted.
 const unwrap = json => json.data === undefined ? json : json.data;
 const liveSite = unwrap(await (await page.request.get('http://localhost:5174/api/blog/public/site')).json());
 const livePosts = unwrap(await (await page.request.get('http://localhost:5174/api/blog/public/content/documents')).json());
 const categoryNames=[...source.querySelectorAll('.categoryButtonText')].map(e=>e.textContent.trim());
 const categories=categoryNames.map((title,index)=>({...livePosts.items[0],id:900+index,title,slug:`fixture-category-${index}`,sort:index}));
 const fixturePosts=[...source.querySelectorAll('#recent-posts > .recent-post-item .article-title')].slice(0,6).map((e,index)=>({...livePosts.items[0],id:1000+index,title:e.textContent.trim(),slug:`fixture-post-${index}`,cover:'/qa-cover.svg',categoryId:categories[index%categories.length].id}));
 const fixtureSite={...liveSite,title:'Tom',heroTitle:[...source.querySelectorAll('#random-banner .banners-title-big')].map(e=>e.textContent.trim()).join('\n'),heroSubtitle:source.querySelector('#random-banner .banners-title-small').textContent.trim(),heroImage:'',avatar:'/theme/skills/vue.png',effectsEnabled:false,homeCards:[{title:source.querySelector('.todayCard-title').textContent.trim(),description:'推荐',image:'/qa-cover.svg',url:'/archives/'}]};
 const cover='<svg xmlns="http://www.w3.org/2000/svg" width="1200" height="600" viewBox="0 0 1200 600"><defs><linearGradient id="g"><stop stop-color="#8da9c4"/><stop offset="1" stop-color="#dbe4e9"/></linearGradient></defs><path fill="url(#g)" d="M0 0h1200v600H0z"/><path fill="#66829b" d="M0 520 280 170 600 510 860 240 1200 600H0z"/><circle fill="#f0dfb6" cx="920" cy="110" r="50"/></svg>';
 for(const target of [page,ref])await target.route('**/qa-cover.svg',route=>route.fulfill({contentType:'image/svg+xml',body:cover}));
 await page.route('**/api/blog/public/**',async route=>{
   const pathname=new URL(route.request().url()).pathname;
   let data;
   if(pathname.endsWith('/site'))data=fixtureSite;
   if(pathname.endsWith('/content/documents'))data={items:fixturePosts,total:6,page:1,pageSize:10};
   if(pathname.endsWith('/content/categories'))data={items:categories,total:categories.length,page:1,pageSize:100};
   if(pathname.endsWith('/content/essays'))data={items:[{...fixturePosts[0],title:'同内容视觉对照'}],total:1,page:1,pageSize:5};
   if(data)return route.fulfill({json:{code:200,data}});
   return route.continue();
 });
 await page.goto('http://localhost:5174/',{waitUntil:'networkidle'});
 await ref.evaluate(titles=>{
   document.querySelector('#bber-talk .li-style').textContent='同内容视觉对照';
   for(const img of document.querySelectorAll('.todayCard-cover,.post_cover img')){img.src='/qa-cover.svg';img.classList.add('loaded');}
   document.querySelectorAll('.topGroup .article-title').forEach((e,i)=>{if(titles[i])e.textContent=titles[i];});
 },fixturePosts.map(p=>p.title));
 const fixtureMeasurements=[];
 for(const width of [390,1440]){
   await page.setViewportSize({width,height:900});await ref.setViewportSize({width,height:900});await ref.evaluate(w=>document.querySelector('#nav').classList.toggle('hide-menu',w<=768),width);
   await page.mouse.move(1,600);await ref.mouse.move(1,600);await page.waitForTimeout(200);
   if(width===1440){await ref.locator('#menus .menus_item').first().hover();await page.locator('#menus .menus_item').first().hover();}
   await page.screenshot({path:out+`/fixture-actual-${width}.png`,clip:{x:0,y:0,width,height:width===1440?500:320}});
   await ref.screenshot({path:out+`/fixture-reference-${width}.png`,clip:{x:0,y:0,width,height:width===1440?500:320}});
   fixtureMeasurements.push({width,actual:await boxes(page),reference:await boxes(ref)});
   if(width===390){check('mobile keeps original random shortcut',await page.getByRole('button',{name:'随机文章',exact:true}).isVisible());check('mobile rail cover has full height',(await page.locator('.topGroup .post_cover').first().boundingBox()).height===100);}
 }
 fs.writeFileSync(out+'/fixture-measurements.json',JSON.stringify(fixtureMeasurements,null,2));
 await page.emulateMedia({reducedMotion:'no-preference'});
 const motion=await page.locator('.tags-group-wrapper').evaluate(e=>({name:getComputedStyle(e).animationName,duration:getComputedStyle(e).animationDuration}));
 check('original ribbon animation runs for 60 seconds',motion.name==='rowup'&&motion.duration==='60s');
 await page.getByRole('button',{name:'更多推荐',exact:true}).click();await page.keyboard.press('Escape');
 check('Escape restores recommendation focus',await page.getByRole('button',{name:'更多推荐',exact:true}).evaluate(e=>document.activeElement===e));
 check('fixtures have no runtime exceptions',errors.length===0);
 fs.writeFileSync(out+'/browser-checks.json',JSON.stringify({checks,errors},null,2));console.log('PASS',checks.length,'browser checks');
 console.log('pageerrors',errors);
 }finally{await browser.close();}
})().catch(e=>{console.error(e);process.exitCode=1});
