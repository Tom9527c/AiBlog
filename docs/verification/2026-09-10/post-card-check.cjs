const fs = require('node:fs');
const path = require('node:path');
const assert = require('node:assert/strict');
const { chromium } = require('/Users/tom/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules/playwright');
const root = path.resolve(__dirname, '../../..');
const { JSDOM } = require(root + '/blog-web/node_modules/jsdom');
const original = '/Users/tom/Downloads/Tom9527c.github.io-main';
const before = process.argv.includes('--before');
const cover = '<svg xmlns="http://www.w3.org/2000/svg" width="1200" height="600"><defs><linearGradient id="g" x2="0" y2="1"><stop stop-color="#7ec9f0"/><stop offset="1" stop-color="#f1f9fc"/></linearGradient></defs><path fill="url(#g)" d="M0 0h1200v600H0z"/><path fill="#ffffff88" d="M0 440 260 180 590 470 900 250 1200 520V600H0z"/></svg>';
const post = { id: 99001, title: 'uniapp-vue2 页面生成PDF', slug: 'card-parity', summary: '同内容测试摘要', body: '# 正文', cover: '/card-cover.svg', publishedAt: '2024-07-10T06:20:59Z', createdAt: '2024-07-10T06:20:59Z', updatedAt: '2024-07-10T07:15:02Z', isLatest: true, categoryId: 99002, tagIds: [99003], category: { id: 99002, title: '人类补完计划', slug: 'development' }, tags: [{ id: 99003, title: 'uniapp', slug: 'uniapp' }], locked: false, accessMode: 'public', metadata: {}, format: 'markdown', status: 'published' };
const selectors = { card: ':scope', cover: '.post_cover', badge: '.article-meta__categories', info: '.recent-post-info', tips: '.recent-post-info-top-tips', title: '.article-title', meta: '.article-meta-wrap', dates: '.post-meta-date', tags: '.article-meta.tags' };
async function geometry(card) {
  return card.evaluate((card, selectors) => {
    const origin = card.getBoundingClientRect();
    return Object.fromEntries(Object.entries(selectors).map(([key, selector]) => {
      const el = selector === ':scope' ? card : card.querySelector(selector);
      if (!el) return [key, null];
      const r = el.getBoundingClientRect(), s = getComputedStyle(el);
      return [key, { x: r.x-origin.x, y:r.y-origin.y, width:r.width, height:r.height, font:s.fontSize, family:s.fontFamily, weight:s.fontWeight, line:s.lineHeight, color:s.color, border:s.borderRadius }];
    }));
  }, selectors);
}
(async () => {
  const browser = await chromium.launch({ executablePath: '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome', headless: true });
  try {
    const context = await browser.newContext({ viewport: {width:1440,height:1000}, deviceScaleFactor:2, reducedMotion:'reduce' });
    const reference = await context.newPage();
    await reference.route('**/*', async route => {
      const url = new URL(route.request().url());
      if (url.pathname === '/card-cover.svg') return route.fulfill({contentType:'image/svg+xml',body:cover});
      if (url.hostname !== 'reference.local') return route.abort();
      let file = path.join(original, url.pathname === '/' ? 'index.html' : url.pathname);
      if (url.pathname.startsWith('/theme/')) file = root + '/blog-web/public' + url.pathname;
      if (!fs.existsSync(file)) return route.fulfill({status:404,body:''});
      let body = fs.readFileSync(file);
      if (file.endsWith('index.html')) {
        const d = new JSDOM(body.toString()).window.document;
        d.querySelectorAll('script,link[rel="stylesheet"]').forEach(e=>e.remove());
        for (const href of ['/css/index.css','/custom/css/elementUI.min.css','/custom/css/aurora.css','/theme/icon/iconfont.css']) {
          const l=d.createElement('link'); l.rel='stylesheet';l.href=href;d.head.appendChild(l);
        }
        const img=d.querySelector('#recent-posts > .recent-post-item .post_bg'); img.src='/card-cover.svg';img.removeAttribute('data-lazy-src');
        const style=d.createElement('style');style.textContent='*,*::before,*::after{animation:none!important;transition:none!important}#loading-box,#loader{display:none!important}';d.head.appendChild(style);
        body=Buffer.from(d.documentElement.outerHTML);
      }
      return route.fulfill({body,contentType:file.endsWith('.html')?'text/html':file.endsWith('.css')?'text/css':undefined});
    });
    const actual=await context.newPage(), errors=[];actual.on('pageerror',e=>errors.push(e.message));
    await actual.route('**/card-cover.svg',route=>route.fulfill({contentType:'image/svg+xml',body:cover}));
    await actual.route('**/api/blog/public/**',route=>{
      const pathname=new URL(route.request().url()).pathname;
      const data = pathname.endsWith('/content/documents') ? {items:[post,{...post,id:99004,isLatest:false}],total:2,page:1,pageSize:12}
        : pathname.endsWith('/content/categories') ? {items:[post.category],total:1,page:1,pageSize:100}
        : pathname.endsWith('/content/tags') ? {items:post.tags,total:1,page:1,pageSize:100}
        : pathname.endsWith('/content/documents/card-parity') ? post : null;
      return data ? route.fulfill({json:{code:200,data}}) : route.continue();
    });
    await Promise.all([reference.goto('http://reference.local/',{waitUntil:'networkidle'}),actual.goto('http://localhost:5174/',{waitUntil:'networkidle'})]);
    await actual.locator('.recent-post-list > .recent-post-item .post_bg').first().waitFor();
    // Original cover transitions use !important; disable them inline so measurements
    // capture settled breakpoints rather than intermediate animation frames.
    for(const page of [actual,reference])await page.evaluate(()=>{
      document.querySelectorAll('*').forEach(el=>{
        el.style.setProperty('transition','none','important');
        el.style.setProperty('animation','none','important');
      });
    });
    // Move the card clear of viewport-fixed widgets for unobstructed card screenshots.
    const records=[];
    const fonts=[];
    for (const [page, selector] of [[actual,'.recent-post-list > .recent-post-item .article-title'],[reference,'#recent-posts > .recent-post-item .article-title']]) {
      const cdp=await context.newCDPSession(page);
      await cdp.send('DOM.enable');await cdp.send('CSS.enable');
      const {root}=await cdp.send('DOM.getDocument');
      const {nodeId}=await cdp.send('DOM.querySelector',{nodeId:root.nodeId,selector});
      fonts.push(await cdp.send('CSS.getPlatformFontsForNode',{nodeId}));
      await cdp.detach();
    }
    for (const width of [360,390,768,769,1024,1200,1201,1440,1920]) {
      for (const page of [actual,reference]) {await page.setViewportSize({width,height:1000});await page.evaluate(()=>document.fonts.ready);}
      const current=actual.locator('.recent-post-list > .recent-post-item').first();
      const target=reference.locator('#recent-posts > .recent-post-item').first();
      for (const state of ['normal','hover','dark']) {
        for (const [page,card] of [[actual,current],[reference,target]]) {
          await page.evaluate(theme=>document.documentElement.dataset.theme=theme,state==='dark'?'dark':'light');
          await card.evaluate(e=>window.scrollTo({top:e.getBoundingClientRect().top+scrollY-100,behavior:'instant'}));await page.mouse.move(1,1);if(state==='hover')await card.hover();
        }
        await actual.waitForTimeout(100);
        records.push({width,state,actual:await geometry(current),reference:await geometry(target)});
        const prefix=before?'before-':'';
        if([390,1024,1440].includes(width)) {
          await current.screenshot({path:path.join(__dirname,`${prefix}card-actual-${width}-${state}.png`)});
          await target.screenshot({path:path.join(__dirname,`card-reference-${width}-${state}.png`)});
        }
      }
    }
    fs.writeFileSync(path.join(__dirname,`${before?'before-':''}card-measurements.json`),JSON.stringify({records,errors,fonts},null,2));
    console.log(JSON.stringify({fonts,cards:records.filter(r=>r.state==='normal').map(r=>({width:r.width,actual:r.actual.card,reference:r.reference.card}))},null,2));
    if(!before) {
      assert.deepEqual(fonts[0],fonts[1],'title uses the same rendered fonts as the original');
      for(const r of records)for(const name of ['card','cover','badge','info','tips','title','meta','dates','tags']) {
        assert.ok(r.actual[name],`missing ${name}`);
        for(const dim of ['x','y','width','height'])assert.ok(Math.abs(r.actual[name][dim]-r.reference[name][dim])<=1.1,`${r.width}/${r.state} ${name}.${dim}: ${r.actual[name][dim]} != ${r.reference[name][dim]}`);
        for(const prop of ['font','family','weight','line','border'])assert.equal(r.actual[name][prop],r.reference[name][prop],`${r.width}/${r.state} ${name}.${prop}`);
      }
      assert.equal(errors.length,0);
      await actual.goto('http://localhost:5174/posts/card-parity.html',{waitUntil:'networkidle'});
      await actual.locator('#article-container').waitFor();
      await actual.goto('http://localhost:5174/',{waitUntil:'networkidle'});
      await actual.locator('.recent-post-list > .recent-post-item').first().waitFor();
      assert.equal(await actual.locator('.recent-post-list > .recent-post-item').first().getByText('未读',{exact:true}).count(),0,'read article remains read after returning');
      const live=await context.newPage();live.on('pageerror',e=>errors.push(e.message));
      await live.goto('http://localhost:5174/',{waitUntil:'networkidle'});
      const payload=await (await live.request.get('http://localhost:5174/api/blog/public/content/documents?pageSize=2')).json();
      const data=payload.data??payload;
      for(const item of data.items) {
        assert.equal(typeof item.isLatest,'boolean');assert.ok(Array.isArray(item.tags));
        assert.ok(item.category===null || typeof item.category.title==='string');
      }
      fs.writeFileSync(path.join(__dirname,'card-live-check.json'),JSON.stringify({total:data.total,items:data.items.map(({id,category,tags,isLatest,cover,publishedAt,updatedAt})=>({id,category,tags,isLatest,coverConfigured:!!cover,publishedAt,updatedAt}))},null,2));
      if(data.items.length) {
        const card=live.locator('.recent-post-list > .recent-post-item').first();
        await card.waitFor();
        await card.evaluate(e=>window.scrollTo({top:e.getBoundingClientRect().top+scrollY-100,behavior:'instant'}));
        await live.mouse.move(1,1);
        await card.screenshot({path:path.join(__dirname,'card-live-1440-normal.png')});
      }
      assert.equal(errors.length,0);
      console.log(`PASS: same-content card geometry/typography in ${records.length} states, read persistence and live API`);
    }
  } finally { await browser.close(); }
})().catch(e=>{console.error(e);process.exitCode=1});
