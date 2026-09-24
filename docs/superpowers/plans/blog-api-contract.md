# Blog API contract

API base defaults to `/api`; Vite proxies to Nest at localhost:3000 and rewrites `/api` to the configured Nest prefix (initially inspect actual prefix). Existing response envelope `{code:200,data:...,msg:string}`. Failures may be HTTP errors or envelope non-200. All dates ISO strings. IDs numeric.

## Types

`Kind = 'documents'|'categories'|'tags'|'albums'|'photos'|'bangumis'|'about'|'essays'|'links'|'moments'|'collections'|'music'|'comments'`.

`Content = {id:number,title:string,slug:string,summary:string,body:string,format:'markdown'|'html',cover:string,url:string,groupName:string,sort:number,status:'draft'|'published',accessMode:'public'|'login'|'password',parentId:number|null,categoryId:number|null,tagIds:number[],publishedAt:string|null,createdAt:string,updatedAt:string,metadata:Record<string,unknown>,locked?:boolean}`. `password` is WRITE ONLY, optional on update means preserve. `passwordHash` NEVER returned. `parentId`: photo->album, reply->comment. Comment `metadata.targetKind` / `metadata.targetId` identify article or null for guestbook. Resource-specific metadata: bangumis `{state:'wish'|'watching'|'finished',progress:number,total:number,rating:number}`, music `{artist:string,lyrics:string}`, about `{skills:string[],socials:{label:string,url:string}[]}`, photos `{width:number,height:number}`. Covers and URLs of restricted resources are not exposed while locked. Upload support uses managed upload endpoints; content body supports inserted media.

`Menu = {id:number,parentId:number|null,title:string,path:string,icon:string,sort:number,enabled:boolean,external:boolean,newWindow:boolean}`. API returns flat array; render tree by parentId. Paths map original routes: /, /archives/, /categories/, /tags/, /album/, /bangumis/, /about/, /essay/, /link/, /fcircle/, /comments/, /collect/, /music/, /dailyPhoto/, /lovePic/, /wordScenery/; documents /posts/:slug.html; albums /album/:slug; taxonomy /categories/:slug and /tags/:slug.

`Site = {title:string,subtitle:string,logo:string,avatar:string,description:string,announcement:string,heroTitle:string,heroSubtitle:string,heroImage:string,footerText:string,icp:string,startDate:string,defaultTheme:'light'|'dark'|'system',effectsEnabled:boolean,showMusic:boolean,showAside:boolean,homeCards:{title:string,description:string,image:string,url:string}[],socials:{label:string,url:string}[]}`. All fields editable in backend. Initial values are minimal empty setup defaults, not old personal data.

## Public

- GET `/blog/public/site` -> Site
- GET `/blog/public/menus` -> Menu[] (only enabled including ancestors)
- GET `/blog/public/stats` -> `{documents:number,categories:number,tags:number,comments:number}`
- GET `/blog/public/content/:kind?page=1&pageSize=12&keyword=&categoryId=&tagId=&parentId=&groupName=&state=&year=&month=` -> `{items:Content[],total:number,page:number,pageSize:number}`. Published only. List never includes body; locked=true where applicable; snippets search title/explicit summary only. Optional year (1970–9999) and month (1–12, requires year) filter by publication date, falling back to creation date, before pagination.
- GET `/blog/public/content/:kind/:slugOrId` -> Content. Locked result returns 200 with safe metadata and locked=true, no body/url/metadata media.
- POST `/blog/public/content/:kind/:id/unlock` `{password:string}` -> `{token:string,expiresIn:number}`.
- Content requests use Authorization Bearer (optional) and `X-Blog-Unlock` (JSON mapping `'kind:id'` to token, e.g. `{"documents:1":"..."}`) to unlock relevant content/parent. Store unlock grants in sessionStorage; never send passwords on reads.
- GET `/blog/public/session` requires existing token -> `{id:number,username:string,nickName:string,avatar:string}`. POST `/blog/public/logout` revokes current token.
- POST `/blog/public/comments` requires login -> create pending comment `{body:string,parentId?:number,metadata:{targetKind?:Kind,targetId?:number}}`; body plain text, no HTML execution.
- GET `/blog/public/media/:id` authenticated resource serving (upload returns URI placeholder `/blog-media/:id`, front client resolves authenticated blob through API before displaying). Details finalized with backend; never embed permanently public restricted upload URLs.

## Admin

All calls require AiBlog token AND resource permissions `blog:<resource>:list/create/update/delete` (site uses list/update; menus CRUD; resource kind strings are plural).

- GET/PUT `/blog/admin/site` -> Site (PUT accepts partial Site).
- GET `/blog/admin/menus` -> Menu[]; POST `/blog/admin/menus` -> Menu; PUT/DELETE `/blog/admin/menus/:id` -> Menu/void. Reject cycles and parent removal while children exist.
- GET `/blog/admin/content/:kind` same query + `status`, response same page type, body omitted.
- GET `/blog/admin/content/:kind/:id` full Content (no password/hash).
- POST `/blog/admin/content/:kind` Content fields -> Content.
- PUT `/blog/admin/content/:kind/:id` partial Content -> Content.
- DELETE `/blog/admin/content/:kind/:id` -> void (reject deleting referenced taxonomy/album or comment with children).
- POST multipart `/blog/admin/upload` with field `file`, Authorization -> `{id:number,url:string,name:string}`; `url` is managed `/blog-media/:id` placeholder usable in cover, url or Markdown images. Limits and allowlist validated by backend.

## Authentication

Reuse POST `/auth/login` `{username,password,captchaId,code}` -> `{access_token}`; GET `/auth/captcha/img` -> inspect existing response to adapt. Store token compatible with AiBlog `SOY_token` storage wrapper (inspect @sa/utils implementation). Same-origin deployment enables shared token; no cross-origin localStorage assumption. Existing register/email-code/reset endpoints may be reused, respecting backend mail setup. Do not fabricate mock authenticated users.
