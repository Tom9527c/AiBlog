# vue3-naive-admin（博客管理后台）

这是 AiBlog 的 Vue 3 管理后台，负责账号和权限管理、博客内容编辑、站点设置、评论审核、音乐曲库和系统工具。代码保留了 Vue3NaiveAdmin / SoybeanAdmin 的通用后台能力；当前仓库的博客功能集中在 `src/views/blog`。访客浏览网站使用同级的 `../blog-web`，接口由 `../nest-admin` 提供。

**推荐阅读顺序：**先看下文的「初学者的第一次修改」及「后台博客管理」；遇到具体文件时用页面中的路径或编辑器搜索定位。首次联调看 [../docs/blog-setup.md](../docs/blog-setup.md)。

> 本文依据当前仓库的代码说明文件职责。通用模板的英文介绍保存在 [README.en_US.md](README.en_US.md)；博客页面的简短目录约定见 [src/views/blog/README.md](src/views/blog/README.md)。


## 初学者的第一次修改：先画出一条线

后台页面通常按这条线工作：`src/views/.../index.vue` 的事件和状态 → `src/service/api/<业务>.ts` 的函数 → `src/service/request/index.ts` → 后端 Controller → Service → 数据库。页面从 API 拿到结果后更新 `ref`/`computed`，Vue 再更新模板。看到“请求成功但页面没变”时，先确认结果是否写回当前 `ref`，是否重新加载了列表，再检查后端。

新同事可以先完成一次不改数据结构的改动：在后台追番列表上调整一个文案。用 `/blog/bangumis` 找到 [bangumis/index.vue](src/views/blog/bangumis/index.vue)，它引用通用 [ContentManager.vue](src/views/blog/content/components/ContentManager.vue)。标题文案来自 [content-config.ts](src/views/blog/content/content-config.ts) 的 `names.bangumis`，追番字段来自 [BangumiFields.vue](src/views/blog/bangumis/components/BangumiFields.vue)。改完在同源 `/admin/` 打开页面检查。这样可以认识“入口 → 通用容器 → 专用字段”的关系。

### 先记住三个容易混淆的入口

- `/blog/music` 是后台 Vue 页面；`/blog/public/music` 是 Nest 的公开曲库 API；前台 `/music/` 是 React 访客页面。这三个地址代表不同层，看到 404 时先判断是哪一层。
- [src/views/blog/menus/index.vue](src/views/blog/menus/index.vue) 编辑访客网站的导航条；[src/views/system/menu/index.vue](src/views/system/menu/index.vue) 管理后台权限菜单。前者对应 `blog_menu`，后者关系到 `sys_menu` 的角色授权，不能互换。
- 博客 `content/index.ts` 导出**可复用的内容管理组件**；每个 `documents/index.vue`、`bangumis/index.vue` 是路由页面，传入相应 `kind`。页面文件内容很少是合理的：复杂列表和表单已经在 `content/components/` 中。

## 后台博客管理：输入、保存、刷新

### 通用内容管理器

1. 路由进入某业务的 `index.vue`，把 `kind` 传给 [ContentManager.vue](src/views/blog/content/components/ContentManager.vue)。组件从 [content-config.ts](src/views/blog/content/content-config.ts) 取得名称、描述、默认表单和状态选项。
2. `load()` 用 [src/service/api/blog.ts](src/service/api/blog.ts) 的 `list(kind, params)` 请求 `GET /blog/admin/content/:kind`。列表是 `rows`，总数是 `total`；页码、每页条数、关键词、发布状态、分类、父项、标签和追番状态决定请求参数。搜索时页码归 1；`kind` 改变时清空筛选并重新读取。
3. `edit(id)`：有 ID 时请求 `GET /blog/admin/content/:kind/:id`，新增时复制 `empty()` 默认数据。编辑前把密码字段清空，记下此前的访问模式，用于判断改成密码访问时是否必须填写新密码；关系选项通过 `options('categories')`、`options('tags')` 等按页读取。
4. 字段组由 `BasicFields`、`PublishingFields`、`RelationFields`、`MediaFields`、`DisplayFields`、`BodyFields` 等组件分担。追番/音乐等专用字段放在各自模块；别把单一业务字段直接写回通用容器。
5. `validateForm()` 检查标题、照片所属相册和访问密码等基本条件。`saveData()` 去掉空 slug/密码，按内容类型移除不适用字段；`save()` 依据 ID 选择 `POST`/`PUT /blog/admin/content/:kind`。成功后刷新列表；失败时保留当前编辑状态并显示提示。删除调用 `DELETE`，若当前页仅剩一项则回退一页再加载。

| 页面入口 | `kind` 或专门请求 | 定制代码从哪里找 |
| --- | --- | --- |
| `documents` | `documents` | `content/` 的基础、正文、分类和标签字段 |
| `categories` / `tags` | `categories` / `tags` | `content/` 字段与 `table-columns.ts` |
| `albums` | `albums`，照片关联 `photos` | `albums/components/album-media-manager.vue`、`PhotoFields.vue` |
| `bangumis` | `bangumis` | `bangumis/components/BangumiFields.vue`，元数据中的观看状态等 |
| `collections` | `collections` | `collections/components/CollectionFields.vue` |
| `essays` / `links` | `essays` / `links` | `essays/components/` 或通用字段组 |
| `music` | 普通内容 `music`，另有曲库 API | `music/components/MusicFields.vue`、`music/music-library.ts`、`music/index.vue` |
| `comments` | 独立评论管理接口 | `comments/index.vue` 和 `comments/components/` |
| `about` / `site` | 单例 `about` / `site` | 专门的 `use-about-settings.ts` / `use-site-settings.ts`，不按普通分页列表保存 |

### 站点设置和关于页为什么要单独看

- [site/index.vue](src/views/blog/site/index.vue) 用 `useSiteSettings` 的 `load/save/restore/trackUpload` 管理表单；`GET/PUT /blog/admin/site` 是独立接口。Hook 把上次成功保存的 JSON 放在 `snapshot`，当前 `form` 与快照不同才是 `dirty`；上传未完成、没有更新权限或正在保存时不能再次保存。
- `save()` 会复制当前表单，**删除 `pageHeaders` 再提交**，因为页面头部设置在独立弹窗保存。请求失败时保留用户已输入的内容，成功后才用后端响应更新快照；不要在失败分支调用 `restore()`。
- [about/index.vue](src/views/blog/about/index.vue) 调用 `useAboutSettings` 请求 `GET/PUT /blog/admin/about`。Hook 初始化资料数组和 `sections`，验证标题、密码访问，再保存。`onBeforeRouteLeave` 和 `beforeunload` 提醒未保存的内容；新增字段如果没加入初始化结构，空数据的老站点可能渲染失败。
- [site/components/HomeCards.vue](src/views/blog/site/components/HomeCards.vue)、`SocialLinks.vue`、`home-hero-settings.vue` 负责专门的嵌套设置；[about/modules/about-fields.ts](src/views/blog/about/modules/about-fields.ts) 定义标签和分组。服务端分别通过 `site/blog-settings.ts` 与 `site/blog-about.ts` 规范化，字段新增时要跨前后端同时核对默认值。

### 评论和音乐的特殊流程

- 评论管理不走通用 `content/:kind` 表格：页面通过 `listAdminComments` 获取分页、各审核状态计数，用 `moderateComments` 批量改为待审/通过/拒绝，用 `replyToComment` 回复。列表、展开回复、详情选中分别在 `comment-table.vue`、`comment-replies.vue`、`detail-selection.ts`。前台提交后不会立即在公开评论显示，因为后端需要审核。
- 音乐存在两套数据：普通 `music` 内容走 `ContentManager`；整个歌单快照走 `GET /blog/admin/music-library`。`music/index.vue` 负责预览、导入 JSON、差异确认和应用；[music-library.ts](src/views/blog/music/music-library.ts) 检查版本、URL、重复 ID、非负时长和文件大小。预览返回 `pending.token` 与 `baseRevision`，应用时提交 token 和 revision，避免覆盖别人已更新的歌单；预览超过 24 小时需重新生成。
- 公共请求层的 `api(path, method, data)` 自动在路径前加 `/blog/admin/`。例如 `api('site', 'put', form)` 才是 `PUT /blog/admin/site`；浏览器走同源网关时 Network 显示 `/api/blog/admin/site`。

## 权限和路由：页面看不见时先检查什么

1. [src/router/elegant/routes.ts](src/router/elegant/routes.ts) 定义路由元数据，`imports.ts` 将 `view.blog_*` 映射到文件；后台菜单由服务端接口返回。生成文件有 `Generated by elegant-router` 标记，新增或重命名页面先看 [packages/scripts/src/commands/router.ts](packages/scripts/src/commands/router.ts) 和 `pnpm gen-route`，再核对生成后的路由名称和动态菜单。
2. [src/store/modules/auth/index.ts](src/store/modules/auth/index.ts) 保存登录后的用户、Token 和角色/权限；[src/store/modules/route/index.ts](src/store/modules/route/index.ts) 根据静态/动态模式注册路由和菜单；[src/router/guard/route.ts](src/router/guard/route.ts) 在访问时处理登录与未授权跳转。
3. [blog-auth.ts](src/hooks/business/blog-auth.ts) 的 `hasAuth('blog:bangumis:update')` 用于让表单禁用/隐藏；它要求已经登录且用户拥有该权限，`superadmin` 可通过。后端 [../nest-admin/src/modules/blog/blog-auth.service.ts](../nest-admin/src/modules/blog/blog-auth.service.ts) 仍在每个管理接口执行 `permit()`。
4. 看不到某项菜单时，先查后台角色权限和 `sys_menu`、服务端 `/auth/account/menus`/路由数据，再查前端 `routes.ts` 的 name、`imports.ts` 的 `view.*` 键，最后查页面内部 `hasAuth`；不要只把按钮写成常显。

请求返回有两层状态：`src/service/request/index.ts` 按 `.env` 的成功码解析 `{ code, data }` 并处理过期、登出和提示；`src/service/api/blog.ts` 再把请求包装为业务函数。`api()` 遇到 `result.error` 会抛异常；页面通常 `try/catch` 后显示自己的错误文案。修改接口的错误信息要看后端实际响应码、请求层和页面捕获的位置。

## 练习：新增一个已有数据字段

**例子：给追番管理新增“推荐理由”字段，存到 `metadata.recommendation`。**这是本项目已有 `bangumis` 内容类型上的字段，不需要新增路由和内容表。

1. 在 [BangumiFields.vue](src/views/blog/bangumis/components/BangumiFields.vue) 中增加与现有 `metadata` 字段同样的表单绑定，优先沿用本文件的校验、布局和权限样式。用空字符串作为老内容的显示默认值。
2. 打开 [ContentManager.vue](src/views/blog/content/components/ContentManager.vue) 的 `edit()` 和 `saveData()`，确认编辑时初始化的 `metadata` 不会覆盖此字段，保存时传递完整 `metadata`；避免新增字段只存在组件局部 `ref`，导致请求体里没有它。

   ```vue
   <NFormItemGi label="推荐理由">
     <NInput v-model:value="form.metadata.recommendation" maxlength="200" show-count />
   </NFormItemGi>
   ```

   将这段放在 `BangumiFields.vue` 现有的 `NGrid` 内；老条目的 `metadata` 里可能没有该键，打开编辑时应在 `ContentManager.edit()` 的追番默认值对象中加 `recommendation: ''`。这个片段只是表单字段，不会自己新增后端校验。
3. 查看后端 [../nest-admin/src/modules/blog/content/blog-metadata.ts](../nest-admin/src/modules/blog/content/blog-metadata.ts) 的 `bangumis` 校验是否允许此键、长度上限如何；必要时添加后端验证，再看前台 [../blog-web/src/views/bangumi/BangumiPage.tsx](../blog-web/src/views/bangumi/BangumiPage.tsx) 是否需要展示。
4. 以有权限账户打开 `/admin/blog/bangumis`：编辑旧条目（字段空）、保存新值、刷新后重新打开、切换到无更新权限账户确认只读。检查 Network 请求体与响应 `metadata` 是否一致。
5. 运行 `pnpm typecheck`、`pnpm build:blog`，同时按涉及的后端/前台项目运行各自的类型检查和构建。浏览器检查专门覆盖“保存后重新加载”，类型检查无法发现服务端剔除 `metadata` 键的问题。

**新增全新页面时**，先决定是既有 `Kind` 的另一种视图，还是新内容类型。前者新建 `src/views/blog/<模块>/index.vue`、`components/`，添加路由及后端菜单权限；后者还要扩展 `Kind`、通用配置、接口 DTO、后端实体和 `CONTENT_ENTITIES`、数据库迁移、前台 `Kind`/路由。确认不需要跨模块复用的组件都留在新模块目录下。

## 出现问题时的排查顺序

| 现象 | 检查顺序 |
| --- | --- |
| 管理页面路由进不去 | URL 与 `routes.ts` → `imports.ts` 是否有页面映射 → 登录后动态路由 → 后端菜单权限 → 网关 `/admin/` 回退 |
| 请求 401 / 403 | Network 的 `Authorization` → `SOY_token` 所在 origin → `auth/index.ts` → 后端 `BlogAuthService.permit()` 和角色菜单授权 |
| 列表空而数据库有内容 | Network 的 `kind`/筛选参数/页码 → `ContentManager.load()` → `BlogService.list()` → 内容状态与发布时刻 |
| 按保存无反应 | `hasAuth(...:update)`、`canSave`/`dirty`、上传计数 → 前端验证错误 → 请求是否发出 → 后端 DTO/元数据校验 |
| 保存返回成功，重新进入又丢值 | 请求体中的字段 → 后端 `validateMetadata`/`validateSettings` → 响应字段 → 前端 `accept()` 快照更新 |
| 音乐预览失败 | `source` 是否合规 → QQ 来源接口 / 网络 → 服务端 `lastError` → `revision` 冲突或预览过期 |
| 图片选了但无法保存 | 上传请求是否完成 → `trackUpload` 计数 → `/blog/admin/upload` 的 25 MB 和格式限制 → 存储服务配置 |

修改完成后，从**具体业务入口**检查列表、打开编辑、保存、重新加载、只读账户和失败重试。不要用修改后的 README 行数替代实际操作验证。

## 从哪里开始

```text
index.html → src/main.ts → src/App.vue
                         ├─ src/plugins      全局资源和插件
                         ├─ src/store        Pinia 状态
                         ├─ src/router       页面路由和守卫
                         └─ src/locales      国际化
登录 → 动态菜单/权限 → src/views/blog/<模块>/index.vue
页面 → src/service/api → src/service/request → nest-admin
```

- 页面入口放在 `src/views/<业务>/<模块>/index.vue`；私有组件放在该模块的 `components/`，页面状态、纯函数和配置放在同模块的 `modules/` 或对应命名的 `.ts` 文件。
- `src/views/blog/components` 只放多个博客页面共用的编辑控件；后台各业务都复用的组件放在 `src/components`。
- `src/service/api` 描述业务接口，`src/service/request` 处理统一认证、响应、错误和续期。权限展示判断见 `src/hooks/business/blog-auth.ts`；接口权限仍由后端校验。
- 模块入口优先保持页面组织和交互，表单字段、表格列、媒体预览、弹窗等放入自己的组件或配置文件。

## 安装、运行与构建

需要 Node.js ≥ 18.12、pnpm ≥ 8.7，工作区依赖通过 [pnpm-workspace.yaml](pnpm-workspace.yaml) 中的 `packages/*` 解析。按 AiBlog 根目录的联调环境运行时，先启动 Nest、MySQL 和 Redis；详见 [../docs/blog-setup.md](../docs/blog-setup.md)。

```bash
pnpm install
pnpm dev             # test 模式；Vite 默认监听 0.0.0.0:8080
pnpm dev:blog        # blog 模式；端口 8080，不自动打开浏览器
pnpm typecheck       # vue-tsc --noEmit --skipLibCheck
pnpm build:blog      # /admin/ 同源部署的产物，输出 dist/
pnpm build           # prod 模式
pnpm build:test      # test 模式
pnpm preview         # 预览已有构建，默认端口 9725
```

根目录运行 `npm run dev` 时，统一入口是 `http://localhost:5173/`，后台位于 `http://localhost:5173/admin/`，API 位于 `http://localhost:5173/api/`。`dev:blog` 单独启动在 8080，但登录共享依赖同源的 `localStorage`，联调应从 5173 访问。生产部署参见 [../deploy/nginx-blog.conf](../deploy/nginx-blog.conf)。`pnpm lint` 会带 `--fix` 改写文件；只是检查文档时不要将它当作只读命令。

### 环境变量与部署文件

| 文件 | 作用 |
| --- | --- |
| [.env](.env) | 通用标题、路由模式、权限路由、请求成功/登出/续期代码、超时、存储前缀和代理开关。 |
| [.env.test](.env.test) | 默认 `pnpm dev` / `build:test` 的本地后端地址。 |
| [.env.prod](.env.prod) | `pnpm build` 的生产模式接口地址；发布前按部署环境核对。 |
| [.env.blog](.env.blog) | AiBlog 同源模式：`VITE_BASE_URL=/admin/`、`VITE_SERVICE_BASE_URL=/api`、上传 `/api/upload`、关闭 Vite HTTP 代理。 |
| [vite.config.ts](vite.config.ts) | 加载当前 mode、设置别名、SCSS、插件、开发端口、代理和输出资源。 |
| [uno.config.ts](uno.config.ts) | UnoCSS 预设、颜色变量、图标尺寸、快捷类与转换器。 |
| [tsconfig.json](tsconfig.json) | TypeScript 严格检查、`@/` 与 `~/` 别名。 |
| [eslint.config.js](eslint.config.js) | ESLint 规则。 |
| [index.html](index.html) | Vue 挂载节点和 HTML 入口。 |
| [nginx.conf](nginx.conf) | 后台容器的静态资源与路由回退配置；AiBlog 同源部署另看根目录 Nginx 配置。 |
| [Dockerfile](Dockerfile)、[Dockerfile.prod](Dockerfile.prod) | 两种构建场景的镜像定义。 |
| [docker-compose.yml](docker-compose.yml)、[docker-compose.prod.yml](docker-compose.prod.yml) | 对应 Docker Compose 编排。 |
| [pnpm-lock.yaml](pnpm-lock.yaml)、[package.json](package.json) | 锁定依赖及开发、构建、类型检查脚本。 |

修改 API 地址先检查 `.env.<mode>` 和 `src/utils/service.ts`。Vite 代理的创建和路径重写分别在 `build/config/proxy.ts`；blog 模式由同源网关转发 `/api`。

## 启动、路由、权限和请求

| 文件 | 作用 |
| --- | --- |
| [src/main.ts](src/main.ts) | 初始化加载动画、进度条、图标、日期、Pinia、路由、国际化、版本通知，最后挂载 Vue。 |
| [src/App.vue](src/App.vue) | Naive UI 主题和语言的顶层 Provider、路由出口及水印。 |
| [src/router/index.ts](src/router/index.ts) | 创建并安装 Vue Router。 |
| [src/router/routes/builtin.ts](src/router/routes/builtin.ts) | 登录、错误页等内置路由。 |
| [src/router/routes/index.ts](src/router/routes/index.ts) | 汇合生成路由和自定义路由。 |
| [src/router/elegant/routes.ts](src/router/elegant/routes.ts) | Elegant Router 的页面路由；含 `/blog/about`、`/blog/music` 等博客入口。 |
| [src/router/elegant/imports.ts](src/router/elegant/imports.ts) | 布局与页面懒加载映射。 |
| [src/router/elegant/transform.ts](src/router/elegant/transform.ts) | Elegant Router 定义到 Vue Router 路由的转换。 |
| [src/router/elegant/generate-route-list.ts](src/router/elegant/generate-route-list.ts) | 生成路由列表的辅助逻辑。 |
| [src/router/guard/index.ts](src/router/guard/index.ts) | 注册路由守卫。 |
| [src/router/guard/route.ts](src/router/guard/route.ts) | 登录、权限与动态路由守卫。 |
| [src/router/guard/progress.ts](src/router/guard/progress.ts) | 页面切换进度提示。 |
| [src/router/guard/title.ts](src/router/guard/title.ts) | 浏览器标题更新。 |
| [src/hooks/business/auth.ts](src/hooks/business/auth.ts) | 通用按钮和菜单权限判断。 |
| [src/hooks/business/blog-auth.ts](src/hooks/business/blog-auth.ts) | 博客管理页面的权限判断和提示。 |
| [src/service/request/index.ts](src/service/request/index.ts) | 附加授权头，处理后端成功码、Token 续期、登出和错误提示。 |
| [src/service/request/shared.ts](src/service/request/shared.ts) | 请求层复用的登录态清理、授权头和提示逻辑。 |
| [src/service/request/type.ts](src/service/request/type.ts) | 请求实例扩展状态类型。 |
| [src/service/api/blog.ts](src/service/api/blog.ts) | 内容种类/内容/菜单/站点类型，博客列表、详情、评论审核、上传和媒体 URL。 |
| [src/service/api/music.ts](src/service/api/music.ts) | 曲库读取、预览、导入及应用接口与曲目类型。 |
| [src/service/api/auth.ts](src/service/api/auth.ts) | 登录、登出、续期等认证接口。 |
| [src/service/api/route.ts](src/service/api/route.ts) | 后端菜单和权限路由接口。 |
| [src/service/api/account.ts](src/service/api/account.ts) | 账号资料、密码及账号菜单。 |
| [src/service/api/third-login.ts](src/service/api/third-login.ts) | 第三方登录。 |
| [src/service/api/upload.ts](src/service/api/upload.ts) | 文件上传接口。 |
| [src/service/api/index.ts](src/service/api/index.ts) | 服务 API 聚合入口。 |
| [src/utils/service.ts](src/utils/service.ts) | 根据环境变量生成服务地址及代理规则。 |
| [src/utils/storage.ts](src/utils/storage.ts) | 登录态等浏览器存储封装。 |

`VITE_AUTH_ROUTE_MODE=dynamic` 时，登录后由后台菜单决定可见路由；页面仍需在 Elegant Router 的路由定义、懒加载映射和后端菜单配置中对应。跨页复用权限与鉴权请求时，分别从 Hook 和 request 层调用，不要在页面复制响应码判断。

## 博客管理页面：逐文件说明

`src/views/blog/<模块>/index.vue` 是该功能的页面入口；`content/index.ts` 是仅供其他博客页面使用的内容管理组件出口，不直接作为路由页面。下面的路径均相对 `src/views/blog/`。

### 共享编辑组件与内容管理

| 文件 | 作用 |
| --- | --- |
| [components/body-editor.vue](src/views/blog/components/body-editor.vue) | 多博客页面共用的正文编辑器。 |
| [components/media-field.vue](src/views/blog/components/media-field.vue) | 可上传、选择或预览的媒体字段。 |
| [components/page-header-settings.vue](src/views/blog/components/page-header-settings.vue) | 各页面共用的页面头部设置。 |
| [content/index.ts](src/views/blog/content/index.ts) | 导出通用内容管理器。 |
| [content/components/ContentManager.vue](src/views/blog/content/components/ContentManager.vue) | 内容列表、筛选、编辑表单与操作的组合容器。 |
| [content/components/ContentFilters.vue](src/views/blog/content/components/ContentFilters.vue) | 内容状态、关键字等筛选控件。 |
| [content/components/BasicFields.vue](src/views/blog/content/components/BasicFields.vue) | 标题、摘要等基础字段。 |
| [content/components/PublishingFields.vue](src/views/blog/content/components/PublishingFields.vue) | 发布状态与时间等发布字段。 |
| [content/components/RelationFields.vue](src/views/blog/content/components/RelationFields.vue) | 分类、标签等关联字段。 |
| [content/components/MediaFields.vue](src/views/blog/content/components/MediaFields.vue) | 通用封面与媒体字段。 |
| [content/components/DisplayFields.vue](src/views/blog/content/components/DisplayFields.vue) | 展示方式相关字段。 |
| [content/components/AdditionalFields.vue](src/views/blog/content/components/AdditionalFields.vue) | 附加元数据字段。 |
| [content/components/BodyFields.vue](src/views/blog/content/components/BodyFields.vue) | 正文编辑字段。 |
| [content/components/AlbumFields.vue](src/views/blog/content/components/AlbumFields.vue) | 相册内容的专门字段。 |
| [content/content-config.ts](src/views/blog/content/content-config.ts) | 各种内容类型的表单和列表配置。 |
| [content/table-columns.ts](src/views/blog/content/table-columns.ts) | 通用内容表格列定义。 |
| [content/content-manager.css](src/views/blog/content/content-manager.css) | 内容管理器样式。 |

### 独立业务模块

| 页面 / 文件 | 作用 |
| --- | --- |
| [about/index.vue](src/views/blog/about/index.vue) | 关于本人资料页面：载入、编辑、保存和离开时未保存提示。 |
| [about/components/AboutFields.vue](src/views/blog/about/components/AboutFields.vue) | 关于页专用字段组。 |
| [about/components/about-field.vue](src/views/blog/about/components/about-field.vue) | 关于页单个可配置字段的输入与展示。 |
| [about/modules/about-fields.ts](src/views/blog/about/modules/about-fields.ts) | 关于页栏目、分组和字段配置。 |
| [about/modules/use-about-settings.ts](src/views/blog/about/modules/use-about-settings.ts) | 表单状态、加载、保存、恢复和脏数据控制。 |
| [albums/index.vue](src/views/blog/albums/index.vue) | 相册内容管理入口。 |
| [albums/components/PhotoFields.vue](src/views/blog/albums/components/PhotoFields.vue) | 照片专用字段。 |
| [albums/components/album-media-manager.vue](src/views/blog/albums/components/album-media-manager.vue) | 相册媒体列表、排序、增删与上传。 |
| [albums/components/album-media-preview.vue](src/views/blog/albums/components/album-media-preview.vue) | 相册媒体预览。 |
| [bangumis/index.vue](src/views/blog/bangumis/index.vue) | 追番内容管理入口。 |
| [bangumis/components/BangumiFields.vue](src/views/blog/bangumis/components/BangumiFields.vue) | 番剧专用字段。 |
| [categories/index.vue](src/views/blog/categories/index.vue) | 分类管理入口。 |
| [collections/index.vue](src/views/blog/collections/index.vue) | 收藏内容管理入口。 |
| [collections/components/CollectionFields.vue](src/views/blog/collections/components/CollectionFields.vue) | 收藏条目专用字段。 |
| [comments/index.vue](src/views/blog/comments/index.vue) | 评论查询、审核和回复入口。 |
| [comments/components/comment-table.vue](src/views/blog/comments/components/comment-table.vue) | 评论列表和批量操作展示。 |
| [comments/components/comment-replies.vue](src/views/blog/comments/components/comment-replies.vue) | 评论回复及对话展示。 |
| [comments/comment-utils.ts](src/views/blog/comments/comment-utils.ts) | 评论显示和数据处理辅助函数。 |
| [comments/detail-selection.ts](src/views/blog/comments/detail-selection.ts) | 评论详情选中状态逻辑。 |
| [documents/index.vue](src/views/blog/documents/index.vue) | 文章内容管理入口。 |
| [essays/index.vue](src/views/blog/essays/index.vue) | 说说管理入口。 |
| [essays/components/essay-editor.vue](src/views/blog/essays/components/essay-editor.vue) | 说说编辑器。 |
| [essays/components/essay-media.vue](src/views/blog/essays/components/essay-media.vue) | 说说媒体展示及编辑。 |
| [links/index.vue](src/views/blog/links/index.vue) | 友链管理入口。 |
| [menus/index.vue](src/views/blog/menus/index.vue) | 前台博客导航菜单管理。 |
| [moments/index.vue](src/views/blog/moments/index.vue) | 短内容 / 动态管理入口。 |
| [music/index.vue](src/views/blog/music/index.vue) | 音乐内容和曲库管理入口。 |
| [music/components/MusicFields.vue](src/views/blog/music/components/MusicFields.vue) | 音乐内容专用字段。 |
| [music/music-library.ts](src/views/blog/music/music-library.ts) | 曲库导入、预览和应用相关数据及处理逻辑。 |
| [site/index.vue](src/views/blog/site/index.vue) | 站点名称、主题、主页布局、社交资料等设置入口。 |
| [site/components/HomeCards.vue](src/views/blog/site/components/HomeCards.vue) | 首页卡片设置。 |
| [site/components/SocialLinks.vue](src/views/blog/site/components/SocialLinks.vue) | 社交链接设置。 |
| [site/components/home-hero-settings.vue](src/views/blog/site/components/home-hero-settings.vue) | 首页 Hero 设置。 |
| [site/components/site-image-field.vue](src/views/blog/site/components/site-image-field.vue) | 站点图片字段。 |
| [site/components/site-theme-field.vue](src/views/blog/site/components/site-theme-field.vue) | 站点主题字段。 |
| [site/modules/home-hero-defaults.ts](src/views/blog/site/modules/home-hero-defaults.ts) | Hero 默认设置。 |
| [site/modules/use-site-settings.ts](src/views/blog/site/modules/use-site-settings.ts) | 站点表单加载、编辑与保存。 |
| [site/index.css](src/views/blog/site/index.css) | 站点设置页样式。 |
| [tags/index.vue](src/views/blog/tags/index.vue) | 标签管理入口。 |

新增博客种类时，同时检查 `src/service/api/blog.ts` 中的 `Kind`、`content/content-config.ts`、专属页面和字段、`src/router/elegant/`、后台菜单权限以及 `nest-admin/src/modules/blog`。不要把追番、音乐或站点专用字段放进通用内容管理器。

## 后台其他页面与组件

| 目录 / 文件 | 作用 |
| --- | --- |
| [src/views/_builtin](src/views/_builtin) | 登录、403/404/500、iframe 页面；`login/modules/` 是密码、验证码、注册、重置及第三方登录表单。 |
| [src/views/home](src/views/home) | 后台首页；`modules/` 内有图表、通知和展示卡片。 |
| [src/views/system/user](src/views/system/user) | 用户管理；`components/user-table-columns.tsx` 和 `user-detail-columns.tsx` 分别定义列表/详情列，抽屉、部门树、重置密码也归在 `components/`。 |
| [src/views/system/menu](src/views/system/menu) | **后台系统菜单**管理，区别于博客前台菜单 `views/blog/menus`；表格列、详情列和编辑抽屉放在本模块 `components/`。 |
| [src/views/system/role](src/views/system/role) | 角色及权限配置；`modules/role-operate-drawer.vue` 是编辑抽屉。 |
| [src/views/system/dept](src/views/system/dept) | 部门管理与部门编辑抽屉。 |
| [src/views/system/dict](src/views/system/dict) | 字典类型、字典项列表及对应编辑抽屉。 |
| [src/views/system/notice](src/views/system/notice) | 公告列表和 `notice-operate` 编辑页面。 |
| [src/views/system/parameter](src/views/system/parameter) | 参数配置及编辑抽屉。 |
| [src/views/system/schedule](src/views/system/schedule) | 定时任务和任务执行日志。 |
| [src/views/system/monitor](src/views/system/monitor) | 缓存、验证码/登录日志、在线用户和服务器信息。 |
| [src/views/tools](src/views/tools) | 邮件、支付、SQL、对象存储及本地存储工具；`storage/modules/storage-preview.vue` 是文件预览。 |
| [src/views/plugin](src/views/plugin) | 图表、编辑器、甘特图、地图、PDF、表格、视频等组件示例；`tables/vtable/components/` 按列表、分组、透视和自定义布局拆分。 |
| [src/views/user-center](src/views/user-center) | 个人资料、资料修改和密码修改。 |
| [src/components/advanced](src/components/advanced) | 配置表单、搜索表单、详情描述、表头操作和列设置；各子目录有自己的入口/类型/README。 |
| [src/components/common](src/components/common) | 全局 Provider、文件上传、主题/语言、导航切换和 TinyMCE 集成。 |
| [src/components/custom](src/components/custom) | 头像、图标、滚动、按钮、计数等通用展示组件。 |
| [src/layouts](src/layouts) | 基础/空白布局及导航、侧栏、页签、面包屑、主题抽屉、搜索等布局组成部分。 |

后台系统业务的 API 在 `src/service/api/system/<模块>.ts`；监控接口在 `system/monitor/`，工具接口在 `tool/`。修改相应页面时检查同名 API 文件、类型声明及后端 Controller。通用表单和表格 Hook 在 `src/hooks/common`，通用鉴权与验证码 Hook 在 `src/hooks/business`。

## 状态、主题和语言

| 文件 / 目录 | 作用 |
| --- | --- |
| [src/store/index.ts](src/store/index.ts) | 创建并安装 Pinia。 |
| [src/store/modules/auth](src/store/modules/auth) | 用户、Token、登录和权限；`shared.ts` 放跨动作复用逻辑。 |
| [src/store/modules/route](src/store/modules/route) | 动态路由、菜单及缓存路由。 |
| [src/store/modules/app](src/store/modules/app) | 全局语言、布局与应用状态。 |
| [src/store/modules/theme](src/store/modules/theme) | 主题、暗色模式和水印配置。 |
| [src/store/modules/tab](src/store/modules/tab) | 后台多页签状态。 |
| [src/store/modules/sse](src/store/modules/sse) | 服务端事件和连接状态。 |
| [src/store/plugins/index.ts](src/store/plugins/index.ts) | Pinia 插件。 |
| [src/theme/settings.ts](src/theme/settings.ts) | 默认主题配置。 |
| [src/theme/vars.ts](src/theme/vars.ts) | 颜色与 UnoCSS 主题变量。 |
| [src/locales](src/locales) | Vue I18n、Naive UI 和 Day.js 语言适配；`langs/` 放中英文文本。 |
| [src/styles](src/styles) | 全局 CSS、SCSS、滚动条、编辑器、过渡和进度条样式。 |
| [src/typings](src/typings) | API、路由、存储、组件、环境变量等全局 TypeScript 声明。 |
| [src/constants](src/constants) | 应用、业务、枚举、图标、正则及地图 SDK 常量。 |
| [src/plugins](src/plugins) | 图标、静态资源、加载动画、Day.js、路由进度和版本提示初始化。 |
| [src/assets](src/assets) | 打包进应用的图像及 SVG 图标；`public/` 存放直接复制的静态资源。 |

## 工作区包和构建脚本

| 路径 | 作用 |
| --- | --- |
| [packages/alova](packages/alova) | Alova 请求客户端封装。 |
| [packages/axios](packages/axios) | 当前后台请求层使用的 Axios 封装、配置及类型。 |
| [packages/color](packages/color) | 色板、颜色名称和主题计算工具。 |
| [packages/hooks](packages/hooks) | Boolean、倒计时、加载、请求、表格等可复用 Hook。 |
| [packages/materials](packages/materials) | 后台布局、页签、滚动条等可复用 Vue 组件。 |
| [packages/ofetch](packages/ofetch) | ofetch 的本地封装入口。 |
| [packages/scripts](packages/scripts) | `sa` 命令：路由生成、清理、发布、依赖更新等；`bin.ts` 是 CLI 入口。 |
| [packages/uno-preset](packages/uno-preset) | UnoCSS 的后台主题预设。 |
| [packages/utils](packages/utils) | 存储、加密、拷贝和 ID 生成等纯工具。 |
| [packages/vite-plugin-tinymce-resource](packages/vite-plugin-tinymce-resource) | 构建时复制 TinyMCE 资源的 Vite 插件。 |
| [build/config](build/config) | 代理、时间及构建配置辅助函数。 |
| [build/plugins](build/plugins) | 路由、HTML、压缩、UnoCSS 和自动导入等 Vite 插件配置。 |

## 常见改动入口

| 目标 | 首选位置 |
| --- | --- |
| 增加后台博客页面 | `src/views/blog/<模块>/index.vue`、私有 `components/`、`src/router/elegant/`、后端菜单 |
| 改内容通用字段 | `src/views/blog/content/components/`、`content-config.ts` |
| 改音乐 / 追番专用字段 | `src/views/blog/music/components/` / `bangumis/components/` |
| 改评论审核 | `src/views/blog/comments/`、`src/service/api/blog.ts` |
| 改登录和权限 | `src/store/modules/auth/`、`src/router/guard/`、`src/hooks/business/blog-auth.ts` |
| 改接口地址或请求错误提示 | `.env.<mode>`、`src/utils/service.ts`、`src/service/request/` |
| 改菜单和页签布局 | `src/layouts/modules/`、`src/store/modules/route/`、`src/store/modules/tab/` |
| 改全站配色 | `src/theme/`、`uno.config.ts`、`src/styles/` |

改完至少运行 `pnpm typecheck` 与对应模式的 `pnpm build:blog`。构建时可能出现 UnoCSS 未找到个别模板图标的提示，应单独核对图标名称；构建成功不代表图标资源正确。删除博客测试文件后的页面交互需要手动走一遍对应流程。

项目原始许可证见 [LICENSE](LICENSE)。

## 文件级补充索引

上述章节介绍调用关系；下面列出尚未单列的源码文件。路径相对项目根目录，每个条目可直接打开。静态图片、证书和锁文件在对应目录章节说明。

### `src/components/advanced`

| 文件 | 职责 |
| --- | --- |
| [component-map.ts](src/components/advanced/config-form/component-map.ts) | 表单字段类型到组件的映射。 |
| [config-form-item-options.vue](src/components/advanced/config-form/config-form-item-options.vue) | 配置表单字段的可选项设置。 |
| [config-form-item.vue](src/components/advanced/config-form/config-form-item.vue) | 配置表单中的单项字段。 |
| [config-form-type.d.ts](src/components/advanced/config-form/config-form-type.d.ts) | config-form的组件属性与类型定义。 |
| [config-form.vue](src/components/advanced/config-form/config-form.vue) | 根据字段配置生成表单。 |
| [index.ts](src/components/advanced/config-form/index.ts) | 配置表单组件和类型的公共导出。 |
| [details-descriptions.vue](src/components/advanced/details-descriptions/details-descriptions.vue) | 按照描述配置展示详情字段。 |
| [index.ts](src/components/advanced/details-descriptions/index.ts) | 详情描述组件及类型的公共导出。 |
| [type.d.ts](src/components/advanced/details-descriptions/type.d.ts) | details-descriptions的组件属性与类型定义。 |
| [index.ts](src/components/advanced/search-form/index.ts) | 搜索表单组件和类型的公共导出。 |
| [search-form-type.ts](src/components/advanced/search-form/search-form-type.ts) | search-form的类型定义。 |
| [search-form.vue](src/components/advanced/search-form/search-form.vue) | 由配置生成搜索表单。 |
| [table-column-setting.vue](src/components/advanced/table-column-setting.vue) | 表格可见列设置。 |
| [table-header-operation.vue](src/components/advanced/table-header-operation.vue) | 表格表头操作区。 |

### `src/components/common`

| 文件 | 职责 |
| --- | --- |
| [app-provider.vue](src/components/common/app-provider.vue) | 全局消息、弹窗、通知等 UI Provider。 |
| [dark-mode-container.vue](src/components/common/dark-mode-container.vue) | 暗色模式背景容器。 |
| [exception-base.vue](src/components/common/exception-base.vue) | 403、404、500 页面共用的异常状态视图。 |
| [file-upload.vue](src/components/common/file-upload.vue) | 通用文件上传。 |
| [full-screen.vue](src/components/common/full-screen.vue) | 全屏切换。 |
| [lang-switch.vue](src/components/common/lang-switch.vue) | 语言切换。 |
| [menu-toggler.vue](src/components/common/menu-toggler.vue) | 菜单展开切换。 |
| [pin-toggler.vue](src/components/common/pin-toggler.vue) | 侧栏固定切换。 |
| [reload-button.vue](src/components/common/reload-button.vue) | 页面刷新按钮。 |
| [system-logo.vue](src/components/common/system-logo.vue) | 系统 Logo。 |
| [theme-schema-switch.vue](src/components/common/theme-schema-switch.vue) | 明暗主题切换。 |
| [constants.ts](src/components/common/tinymce/constants.ts) | TinyMCE 初始化常量。 |
| [index.ts](src/components/common/tinymce/index.ts) | TinyMCE 组件及配置的导出入口。 |
| [index.vue](src/components/common/tinymce/index.vue) | TinyMCE 编辑器 Vue 组件。 |
| [index.ts](src/components/common/tinymce/langs/index.ts) | TinyMCE 语言资源入口。 |
| [zh_CN.js](src/components/common/tinymce/langs/zh_CN.js) | TinyMCE 简体中文语言资源。 |
| [plugins.ts](src/components/common/tinymce/plugins.ts) | TinyMCE 插件列表。 |
| [props.ts](src/components/common/tinymce/props.ts) | TinyMCE 组件属性定义。 |
| [tinymce-preview.vue](src/components/common/tinymce/tinymce-preview.vue) | TinyMCE 内容预览弹窗。 |

### `src/components/custom`

| 文件 | 职责 |
| --- | --- |
| [admin-avatar.vue](src/components/custom/admin-avatar.vue) | 管理员头像。 |
| [better-scroll.vue](src/components/custom/better-scroll.vue) | 滚动容器。 |
| [button-icon.vue](src/components/custom/button-icon.vue) | 图标按钮。 |
| [count-to.vue](src/components/custom/count-to.vue) | 数字递增动画。 |
| [github-link.vue](src/components/custom/github-link.vue) | 项目地址入口。 |
| [icon-select.vue](src/components/custom/icon-select.vue) | 图标选择器。 |
| [look-forward.vue](src/components/custom/look-forward.vue) | 占位期待页。 |
| [svg-icon.vue](src/components/custom/svg-icon.vue) | SVG 图标渲染。 |
| [wave-bg.vue](src/components/custom/wave-bg.vue) | 波浪背景。 |
| [web-site-link.vue](src/components/custom/web-site-link.vue) | 站点地址入口。 |

### `src/constants`

| 文件 | 职责 |
| --- | --- |
| [app.ts](src/constants/app.ts) | 应用常量。 |
| [business.ts](src/constants/business.ts) | 业务状态常量。 |
| [common.ts](src/constants/common.ts) | 通用常量。 |
| [enum.ts](src/constants/enum.ts) | 枚举常量。 |
| [icon.ts](src/constants/icon.ts) | 图标常量。 |
| [map-sdk.ts](src/constants/map-sdk.ts) | 地图服务常量。 |
| [reg.ts](src/constants/reg.ts) | 正则表达式常量。 |

### `src/enum`

| 文件 | 职责 |
| --- | --- |
| [index.ts](src/enum/index.ts) | 枚举的统一出口。 |

### `src/hooks/business`

| 文件 | 职责 |
| --- | --- |
| [captcha.ts](src/hooks/business/captcha.ts) | 验证码的可复用组合式逻辑。 |

### `src/hooks/common`

| 文件 | 职责 |
| --- | --- |
| [config-form.ts](src/hooks/common/config-form.ts) | 配置表单的可复用组合式逻辑。 |
| [detail-descriptions.ts](src/hooks/common/detail-descriptions.ts) | 详情描述的可复用组合式逻辑。 |
| [dict.ts](src/hooks/common/dict.ts) | 字典的可复用组合式逻辑。 |
| [echarts.ts](src/hooks/common/echarts.ts) | ECharts 图表的可复用组合式逻辑。 |
| [form.ts](src/hooks/common/form.ts) | 表单的可复用组合式逻辑。 |
| [icon.ts](src/hooks/common/icon.ts) | 图标的可复用组合式逻辑。 |
| [router.ts](src/hooks/common/router.ts) | 路由的可复用组合式逻辑。 |
| [search-form.ts](src/hooks/common/search-form.ts) | 搜索表单的可复用组合式逻辑。 |
| [table.ts](src/hooks/common/table.ts) | 表格的可复用组合式逻辑。 |
| [vchart.ts](src/hooks/common/vchart.ts) | VChart 图表的可复用组合式逻辑。 |

### `src/layouts/base-layout`

| 文件 | 职责 |
| --- | --- |
| [index.vue](src/layouts/base-layout/index.vue) | 带导航、页签和内容区的后台主布局。 |

### `src/layouts/blank-layout`

| 文件 | 职责 |
| --- | --- |
| [index.vue](src/layouts/blank-layout/index.vue) | 登录和异常页使用的空白布局。 |

### `src/layouts/context`

| 文件 | 职责 |
| --- | --- |
| [index.ts](src/layouts/context/index.ts) | 布局上下文的注入和读取入口。 |

### `src/layouts/modules/global-breadcrumb`

| 文件 | 职责 |
| --- | --- |
| [index.vue](src/layouts/modules/global-breadcrumb/index.vue) | 显示当前路由的面包屑。 |

### `src/layouts/modules/global-content`

| 文件 | 职责 |
| --- | --- |
| [index.vue](src/layouts/modules/global-content/index.vue) | 渲染主内容区域和过渡效果。 |

### `src/layouts/modules/global-footer`

| 文件 | 职责 |
| --- | --- |
| [index.vue](src/layouts/modules/global-footer/index.vue) | 后台页脚区域。 |

### `src/layouts/modules/global-header`

| 文件 | 职责 |
| --- | --- |
| [theme-button.vue](src/layouts/modules/global-header/components/theme-button.vue) | 顶部栏的主题设置入口；暗色切换不响应时检查它与 theme store。 |
| [user-avatar.vue](src/layouts/modules/global-header/components/user-avatar.vue) | 顶部用户头像、资料入口和退出菜单。 |
| [index.vue](src/layouts/modules/global-header/index.vue) | 组装导航折叠、主题按钮与用户头像的顶部栏。 |

### `src/layouts/modules/global-logo`

| 文件 | 职责 |
| --- | --- |
| [index.vue](src/layouts/modules/global-logo/index.vue) | 后台标识和首页入口。 |

### `src/layouts/modules/global-menu`

| 文件 | 职责 |
| --- | --- |
| [first-level-menu.vue](src/layouts/modules/global-menu/components/first-level-menu.vue) | 一级菜单。 |
| [index.vue](src/layouts/modules/global-menu/index.vue) | 根据 route store 菜单渲染侧栏/顶部菜单容器。 |
| [horizontal-menu.vue](src/layouts/modules/global-menu/modules/horizontal-menu.vue) | 水平菜单。 |
| [horizontal-mix-menu.vue](src/layouts/modules/global-menu/modules/horizontal-mix-menu.vue) | 水平混合菜单。 |
| [reversed-horizontal-mix-menu.vue](src/layouts/modules/global-menu/modules/reversed-horizontal-mix-menu.vue) | 反向水平混合菜单。 |
| [vertical-menu.vue](src/layouts/modules/global-menu/modules/vertical-menu.vue) | 垂直菜单。 |
| [vertical-mix-menu.vue](src/layouts/modules/global-menu/modules/vertical-mix-menu.vue) | 垂直混合菜单。 |

### `src/layouts/modules/global-search`

| 文件 | 职责 |
| --- | --- |
| [search-footer.vue](src/layouts/modules/global-search/components/search-footer.vue) | 搜索弹窗的快捷操作提示。 |
| [search-modal.vue](src/layouts/modules/global-search/components/search-modal.vue) | 全局搜索弹窗。 |
| [search-result.vue](src/layouts/modules/global-search/components/search-result.vue) | 全局搜索结果项。 |
| [index.vue](src/layouts/modules/global-search/index.vue) | 打开全局路由搜索弹窗并组织结果。 |

### `src/layouts/modules/global-sider`

| 文件 | 职责 |
| --- | --- |
| [index.vue](src/layouts/modules/global-sider/index.vue) | 后台侧栏区域。 |

### `src/layouts/modules/global-tab`

| 文件 | 职责 |
| --- | --- |
| [context-menu.vue](src/layouts/modules/global-tab/context-menu.vue) | 页签右键菜单，提供关闭当前/其他等动作。 |
| [index.vue](src/layouts/modules/global-tab/index.vue) | 路由多页签栏。 |

### `src/layouts/modules/theme-drawer`

| 文件 | 职责 |
| --- | --- |
| [layout-mode-card.vue](src/layouts/modules/theme-drawer/components/layout-mode-card.vue) | 布局模式选项卡。 |
| [setting-item.vue](src/layouts/modules/theme-drawer/components/setting-item.vue) | 主题配置单项。 |
| [index.vue](src/layouts/modules/theme-drawer/index.vue) | 主题设置抽屉。 |
| [config-operation.vue](src/layouts/modules/theme-drawer/modules/config-operation.vue) | 主题设置导入/重置操作。 |
| [dark-mode.vue](src/layouts/modules/theme-drawer/modules/dark-mode.vue) | 暗色模式设置。 |
| [layout-mode.vue](src/layouts/modules/theme-drawer/modules/layout-mode.vue) | 布局模式设置。 |
| [page-fun.vue](src/layouts/modules/theme-drawer/modules/page-fun.vue) | 页面功能开关。 |
| [theme-color.vue](src/layouts/modules/theme-drawer/modules/theme-color.vue) | 主题颜色设置。 |

### `src/locales`

| 文件 | 职责 |
| --- | --- |
| [dayjs.ts](src/locales/dayjs.ts) | Day.js 区域语言初始化。 |
| [index.ts](src/locales/index.ts) | 国际化初始化入口。 |
| [locale.ts](src/locales/locale.ts) | 语言标识及默认语言处理。 |
| [naive.ts](src/locales/naive.ts) | Naive UI 语言包和日期语言包映射。 |

### `src/locales/langs`

| 文件 | 职责 |
| --- | --- |
| [en-us.ts](src/locales/langs/en-us.ts) | 英文翻译文本。 |
| [zh-cn.ts](src/locales/langs/zh-cn.ts) | 简体中文翻译文本。 |

### `src/plugins`

| 文件 | 职责 |
| --- | --- |
| [app.ts](src/plugins/app.ts) | 应用版本更新提醒。 |
| [assets.ts](src/plugins/assets.ts) | 全局资源和样式加载。 |
| [dayjs.ts](src/plugins/dayjs.ts) | Day.js 区域语言初始化。 |
| [iconify.ts](src/plugins/iconify.ts) | 离线图标初始化。 |
| [index.ts](src/plugins/index.ts) | 插件初始化统一出口。 |
| [loading.ts](src/plugins/loading.ts) | 页面启动加载动画。 |
| [nprogress.ts](src/plugins/nprogress.ts) | 页面进度条初始化。 |

### `src/service/api`

| 文件 | 职责 |
| --- | --- |
| [dept.ts](src/service/api/system/dept.ts) | 部门接口的路径、参数及请求函数。 |
| [dict-item.ts](src/service/api/system/dict-item.ts) | 字典项接口的路径、参数及请求函数。 |
| [dict-type.ts](src/service/api/system/dict-type.ts) | 字典类型接口的路径、参数及请求函数。 |
| [menu.ts](src/service/api/system/menu.ts) | 系统菜单接口的路径、参数及请求函数。 |
| [cache.ts](src/service/api/system/monitor/cache.ts) | 缓存接口的路径、参数及请求函数。 |
| [captcha-log.ts](src/service/api/system/monitor/captcha-log.ts) | 验证码日志接口的路径、参数及请求函数。 |
| [login-log.ts](src/service/api/system/monitor/login-log.ts) | 登录日志接口的路径、参数及请求函数。 |
| [online.ts](src/service/api/system/monitor/online.ts) | 在线用户接口的路径、参数及请求函数。 |
| [task-log.ts](src/service/api/system/monitor/task-log.ts) | 任务日志接口的路径、参数及请求函数。 |
| [notice.ts](src/service/api/system/notice.ts) | 公告接口的路径、参数及请求函数。 |
| [parameter.ts](src/service/api/system/parameter.ts) | 系统参数接口的路径、参数及请求函数。 |
| [role.ts](src/service/api/system/role.ts) | 角色接口的路径、参数及请求函数。 |
| [serve.ts](src/service/api/system/serve.ts) | 服务器监控接口的路径、参数及请求函数。 |
| [task.ts](src/service/api/system/task.ts) | 定时任务接口的路径、参数及请求函数。 |
| [user.ts](src/service/api/system/user.ts) | 用户接口的路径、参数及请求函数。 |
| [mail.ts](src/service/api/tool/mail.ts) | 邮件接口的路径、参数及请求函数。 |
| [pay.ts](src/service/api/tool/pay.ts) | 支付接口的路径、参数及请求函数。 |
| [sql.ts](src/service/api/tool/sql.ts) | SQL 工具接口的路径、参数及请求函数。 |
| [storage-local.ts](src/service/api/tool/storage-local.ts) | 本地存储接口的路径、参数及请求函数。 |
| [storage-oss.ts](src/service/api/tool/storage-oss.ts) | 对象存储接口的路径、参数及请求函数。 |

### `src/store/modules`

| 文件 | 职责 |
| --- | --- |
| [index.ts](src/store/modules/app/index.ts) | 应用全局设置状态。 |
| [index.ts](src/store/modules/auth/index.ts) | 登录用户与令牌状态、登录登出动作。 |
| [shared.ts](src/store/modules/auth/shared.ts) | 认证状态内部共享函数。 |
| [index.ts](src/store/modules/route/index.ts) | 权限路由和菜单状态。 |
| [shared.ts](src/store/modules/route/shared.ts) | 路由状态内部共享函数。 |
| [index.ts](src/store/modules/sse/index.ts) | SSE 连接状态。 |
| [index.ts](src/store/modules/tab/index.ts) | 多页签状态及增删切换动作。 |
| [shared.ts](src/store/modules/tab/shared.ts) | 页签状态内部共享函数。 |
| [index.ts](src/store/modules/theme/index.ts) | 当前主题状态与切换动作。 |
| [shared.ts](src/store/modules/theme/shared.ts) | 主题状态内部共享函数。 |

### `src/styles/css`

| 文件 | 职责 |
| --- | --- |
| [global.css](src/styles/css/global.css) | 全局变量与通用样式。 |
| [nprogress.css](src/styles/css/nprogress.css) | 进度条样式。 |
| [reset.css](src/styles/css/reset.css) | 浏览器默认样式重置。 |
| [transition.css](src/styles/css/transition.css) | 页面动画与过渡。 |

### `src/styles/scss`

| 文件 | 职责 |
| --- | --- |
| [global.scss](src/styles/scss/global.scss) | 全局变量与通用样式。 |
| [scrollbar.scss](src/styles/scss/scrollbar.scss) | 滚动条样式。 |
| [tinymce.scss](src/styles/scss/tinymce.scss) | 富文本编辑器样式。 |

### `src/typings`

| 文件 | 职责 |
| --- | --- |
| [api.d.ts](src/typings/api.d.ts) | 后端接口响应类型。 |
| [app.d.ts](src/typings/app.d.ts) | 应用全局状态类型。 |
| [common.d.ts](src/typings/common.d.ts) | 通用类型。 |
| [components.d.ts](src/typings/components.d.ts) | 自动注册组件类型。 |
| [elegant-router.d.ts](src/typings/elegant-router.d.ts) | 生成路由的类型声明。 |
| [global.d.ts](src/typings/global.d.ts) | 全局变量类型。 |
| [naive-ui.d.ts](src/typings/naive-ui.d.ts) | Naive UI 扩展类型。 |
| [os.d.ts](src/typings/os.d.ts) | 操作系统及环境类型。 |
| [package.d.ts](src/typings/package.d.ts) | 工作区包类型。 |
| [router.d.ts](src/typings/router.d.ts) | 路由名称和元数据类型。 |
| [shim.d.ts](src/typings/shim.d.ts) | 第三方模块兼容声明。 |
| [storage.d.ts](src/typings/storage.d.ts) | 浏览器存储类型。 |
| [union-key.d.ts](src/typings/union-key.d.ts) | 联合类型键辅助定义。 |
| [upload.d.ts](src/typings/upload.d.ts) | 上传文件类型。 |
| [vite-env.d.ts](src/typings/vite-env.d.ts) | Vite 环境变量类型。 |

### `src/utils`

| 文件 | 职责 |
| --- | --- |
| [agent.ts](src/utils/agent.ts) | 浏览器环境识别。 |
| [common.ts](src/utils/common.ts) | 通用纯函数。 |
| [icon.ts](src/utils/icon.ts) | 图标名称和资源处理。 |
| [urlUtils.ts](src/utils/urlUtils.ts) | URL 处理函数。 |

### `src/views/_builtin/403`

| 文件 | 职责 |
| --- | --- |
| [index.vue](src/views/_builtin/403/index.vue) | 无权限提示页页面入口。 |

### `src/views/_builtin/404`

| 文件 | 职责 |
| --- | --- |
| [index.vue](src/views/_builtin/404/index.vue) | 路由不存在提示页页面入口。 |

### `src/views/_builtin/500`

| 文件 | 职责 |
| --- | --- |
| [index.vue](src/views/_builtin/500/index.vue) | 服务器错误提示页页面入口。 |

### `src/views/_builtin/iframe-page`

| 文件 | 职责 |
| --- | --- |
| [iframe 页面入口](src/views/_builtin/iframe-page/[url].vue) | 外部页面嵌入视图页面入口。 |

### `src/views/_builtin/login`

| 文件 | 职责 |
| --- | --- |
| [index.vue](src/views/_builtin/login/index.vue) | 登录和注册入口页面入口。 |
| [bind-wechat.vue](src/views/_builtin/login/modules/bind-wechat.vue) | 微信账号绑定表单。 |
| [code-login.vue](src/views/_builtin/login/modules/code-login.vue) | 验证码登录表单。 |
| [github-login.vue](src/views/_builtin/login/modules/github-login.vue) | GitHub 登录入口。 |
| [pwd-login.vue](src/views/_builtin/login/modules/pwd-login.vue) | 密码登录表单。 |
| [register.vue](src/views/_builtin/login/modules/register.vue) | 注册表单。 |
| [reset-pwd.vue](src/views/_builtin/login/modules/reset-pwd.vue) | 找回密码表单。 |

### `src/views/about`

| 文件 | 职责 |
| --- | --- |
| [index.vue](src/views/about/index.vue) | 后台模板关于页页面入口。 |

### `src/views/home`

| 文件 | 职责 |
| --- | --- |
| [index.vue](src/views/home/index.vue) | 后台工作台首页页面入口。 |

### `src/views/home/modules`

| 文件 | 职责 |
| --- | --- |
| [card-data.vue](src/views/home/modules/card-data.vue) | 首页统计卡片。 |
| [creativity-banner.vue](src/views/home/modules/creativity-banner.vue) | 首页创意 Banner。 |
| [header-banner.vue](src/views/home/modules/header-banner.vue) | 首页头部 Banner。 |
| [line-chart.vue](src/views/home/modules/line-chart.vue) | 首页折线图。 |
| [notice.vue](src/views/home/modules/notice.vue) | 首页公告。 |
| [pie-chart.vue](src/views/home/modules/pie-chart.vue) | 首页饼图。 |

### `src/views/plugin/barcode`

| 文件 | 职责 |
| --- | --- |
| [index.vue](src/views/plugin/barcode/index.vue) | 条形码演示页面入口。 |

### `src/views/plugin/charts`

| 文件 | 职责 |
| --- | --- |
| [data.ts](src/views/plugin/charts/antv/data.ts) | AntV 图表/流程图演示的演示数据。 |
| [index.vue](src/views/plugin/charts/antv/index.vue) | AntV 图表/流程图演示页面入口。 |
| [antv-flow.vue](src/views/plugin/charts/antv/modules/antv-flow.vue) | AntV 流程图视图。 |
| [antv-g6-flow.ts](src/views/plugin/charts/antv/modules/antv-g6-flow.ts) | G6 流程图配置。 |
| [status.ts](src/views/plugin/charts/antv/modules/status.ts) | AntV 流程图示例节点/流程状态配置。 |
| [types.ts](src/views/plugin/charts/antv/modules/types.ts) | AntV 流程图节点、连线和数据类型。 |
| [data.ts](src/views/plugin/charts/echarts/data.ts) | ECharts 图表示例的演示数据。 |
| [index.vue](src/views/plugin/charts/echarts/index.vue) | ECharts 图表示例页面入口。 |
| [data.ts](src/views/plugin/charts/vchart/data.ts) | VChart 图表示例的演示数据。 |
| [index.vue](src/views/plugin/charts/vchart/index.vue) | VChart 图表示例页面入口。 |

### `src/views/plugin/copy`

| 文件 | 职责 |
| --- | --- |
| [index.vue](src/views/plugin/copy/index.vue) | 复制功能演示页面入口。 |

### `src/views/plugin/editor`

| 文件 | 职责 |
| --- | --- |
| [index.vue](src/views/plugin/editor/markdown/index.vue) | Markdown 编辑器演示页面入口。 |
| [index.vue](src/views/plugin/editor/quill/index.vue) | Quill 编辑器演示页面入口。 |

### `src/views/plugin/excel`

| 文件 | 职责 |
| --- | --- |
| [index.vue](src/views/plugin/excel/index.vue) | 表格导出导入演示页面入口。 |

### `src/views/plugin/gantt`

| 文件 | 职责 |
| --- | --- |
| [data.ts](src/views/plugin/gantt/dhtmlx/data.ts) | DHTMLX 甘特图示例的演示数据。 |
| [index.vue](src/views/plugin/gantt/dhtmlx/index.vue) | DHTMLX 甘特图示例页面入口。 |
| [basic-options.ts](src/views/plugin/gantt/vtable/basic-options.ts) | VTable 基础甘特图选项。 |
| [custom-options.ts](src/views/plugin/gantt/vtable/custom-options.ts) | VTable 自定义甘特图选项。 |
| [data.ts](src/views/plugin/gantt/vtable/data.ts) | VTable 表格/甘特图示例的演示数据。 |
| [index.vue](src/views/plugin/gantt/vtable/index.vue) | VTable 表格/甘特图示例页面入口。 |
| [linked-options.ts](src/views/plugin/gantt/vtable/linked-options.ts) | VTable 任务依赖联动选项。 |

### `src/views/plugin/icon`

| 文件 | 职责 |
| --- | --- |
| [icons.ts](src/views/plugin/icon/icons.ts) | 图标示例使用的图标数据。 |
| [index.vue](src/views/plugin/icon/index.vue) | 图标展示页页面入口。 |

### `src/views/plugin/map`

| 文件 | 职责 |
| --- | --- |
| [baidu-map.vue](src/views/plugin/map/components/baidu-map.vue) | 百度地图实例与加载后的交互。 |
| [gaode-map.vue](src/views/plugin/map/components/gaode-map.vue) | 高德地图实例与加载后的交互。 |
| [index.ts](src/views/plugin/map/components/index.ts) | 三种地图示例组件的聚合出口。 |
| [tencent-map.vue](src/views/plugin/map/components/tencent-map.vue) | 腾讯地图实例与加载后的交互。 |
| [index.vue](src/views/plugin/map/index.vue) | 地图 SDK 演示页面入口。 |

### `src/views/plugin/pdf`

| 文件 | 职责 |
| --- | --- |
| [index.vue](src/views/plugin/pdf/index.vue) | PDF 查看演示页面入口。 |

### `src/views/plugin/pinyin`

| 文件 | 职责 |
| --- | --- |
| [index.vue](src/views/plugin/pinyin/index.vue) | 拼音转换演示页面入口。 |

### `src/views/plugin/print`

| 文件 | 职责 |
| --- | --- |
| [index.vue](src/views/plugin/print/index.vue) | 打印演示页面入口。 |

### `src/views/plugin/swiper`

| 文件 | 职责 |
| --- | --- |
| [index.vue](src/views/plugin/swiper/index.vue) | 轮播组件演示页面入口。 |

### `src/views/plugin/tables`

| 文件 | 职责 |
| --- | --- |
| [CustomLayoutDemo.vue](src/views/plugin/tables/vtable/components/CustomLayoutDemo.vue) | VTable 自定义布局示例。 |
| [GroupTableDemo.vue](src/views/plugin/tables/vtable/components/GroupTableDemo.vue) | VTable 分组表格示例。 |
| [ListTableDemo.vue](src/views/plugin/tables/vtable/components/ListTableDemo.vue) | VTable 普通列表示例。 |
| [PivotChartDemo.vue](src/views/plugin/tables/vtable/components/PivotChartDemo.vue) | VTable 透视图表示例。 |
| [PivotTableDemo.vue](src/views/plugin/tables/vtable/components/PivotTableDemo.vue) | VTable 透视表示例。 |
| [data.ts](src/views/plugin/tables/vtable/data.ts) | VTable 表格/甘特图示例的演示数据。 |
| [index.vue](src/views/plugin/tables/vtable/index.vue) | 切换 VTable 列表、分组、透视、图表与自定义布局示例的入口。 |

### `src/views/plugin/typeit`

| 文件 | 职责 |
| --- | --- |
| [index.vue](src/views/plugin/typeit/index.vue) | 打字动画演示页面入口。 |

### `src/views/plugin/video`

| 文件 | 职责 |
| --- | --- |
| [index.vue](src/views/plugin/video/index.vue) | 视频播放器演示页面入口。 |

### `src/views/system/dept`

| 文件 | 职责 |
| --- | --- |
| [index.vue](src/views/system/dept/index.vue) | 部门管理页面入口。 |
| [dept-operate-drawer.vue](src/views/system/dept/modules/dept-operate-drawer.vue) | 部门管理新增和编辑抽屉。 |

### `src/views/system/dict`

| 文件 | 职责 |
| --- | --- |
| [index.vue](src/views/system/dict/index.vue) | 字典管理页面入口。 |
| [dict-item-operate-drawer.vue](src/views/system/dict/modules/dict-item-operate-drawer.vue) | 字典管理新增和编辑抽屉。 |
| [dict-type-list.vue](src/views/system/dict/modules/dict-type-list.vue) | 字典管理列表子组件。 |
| [dict-type-operate-drawer.vue](src/views/system/dict/modules/dict-type-operate-drawer.vue) | 字典管理新增和编辑抽屉。 |

### `src/views/system/menu`

| 文件 | 职责 |
| --- | --- |
| [menu-detail-columns.tsx](src/views/system/menu/components/menu-detail-columns.tsx) | 系统菜单详情列定义。 |
| [menu-operate-drawer.vue](src/views/system/menu/components/menu-operate-drawer.vue) | 菜单编辑抽屉。 |
| [menu-table-columns.tsx](src/views/system/menu/components/menu-table-columns.tsx) | 系统菜单列表列定义。 |
| [index.vue](src/views/system/menu/index.vue) | 后台菜单管理页面入口。 |

### `src/views/system/monitor`

| 文件 | 职责 |
| --- | --- |
| [index.vue](src/views/system/monitor/cache/index.vue) | 缓存监控页面入口。 |
| [index.vue](src/views/system/monitor/captcha-log/index.vue) | 验证码日志页面入口。 |
| [index.vue](src/views/system/monitor/login-log/index.vue) | 登录日志页面入口。 |
| [index.vue](src/views/system/monitor/online/index.vue) | 在线用户监控页面入口。 |
| [index.vue](src/views/system/monitor/serve/index.vue) | 服务器监控页面入口。 |

### `src/views/system/notice`

| 文件 | 职责 |
| --- | --- |
| [index.vue](src/views/system/notice/index.vue) | 系统公告管理页面入口。 |
| [index.vue](src/views/system/notice/notice-operate/index.vue) | 系统公告管理页面入口。 |

### `src/views/system/parameter`

| 文件 | 职责 |
| --- | --- |
| [index.vue](src/views/system/parameter/index.vue) | 参数管理页面入口。 |
| [parameter-operate-drawer.vue](src/views/system/parameter/modules/parameter-operate-drawer.vue) | 参数管理新增和编辑抽屉。 |

### `src/views/system/role`

| 文件 | 职责 |
| --- | --- |
| [index.vue](src/views/system/role/index.vue) | 角色管理页面入口。 |
| [role-operate-drawer.vue](src/views/system/role/modules/role-operate-drawer.vue) | 角色管理新增和编辑抽屉。 |

### `src/views/system/schedule`

| 文件 | 职责 |
| --- | --- |
| [index.vue](src/views/system/schedule/task/index.vue) | 定时任务页面入口。 |
| [task-operate-drawer.vue](src/views/system/schedule/task/modules/task-operate-drawer.vue) | modules新增和编辑抽屉。 |
| [index.vue](src/views/system/schedule/task-log/index.vue) | 任务执行日志页面入口。 |

### `src/views/system/user`

| 文件 | 职责 |
| --- | --- |
| [dept-tree.vue](src/views/system/user/components/dept-tree.vue) | 用户筛选部门树。 |
| [reset-password.vue](src/views/system/user/components/reset-password.vue) | 重置用户密码弹窗。 |
| [user-detail-columns.tsx](src/views/system/user/components/user-detail-columns.tsx) | 用户详情列定义。 |
| [user-operate-drawer.vue](src/views/system/user/components/user-operate-drawer.vue) | 用户编辑抽屉。 |
| [user-table-columns.tsx](src/views/system/user/components/user-table-columns.tsx) | 用户列表列定义。 |
| [index.vue](src/views/system/user/index.vue) | 用户管理页面入口。 |
| [user-search-form.ts](src/views/system/user/modules/user-search-form.ts) | 用户筛选表单配置。 |

### `src/views/tools/mail`

| 文件 | 职责 |
| --- | --- |
| [index.vue](src/views/tools/mail/index.vue) | 邮件工具页面入口。 |

### `src/views/tools/pay`

| 文件 | 职责 |
| --- | --- |
| [index.vue](src/views/tools/pay/index.vue) | 支付工具页面入口。 |

### `src/views/tools/sql`

| 文件 | 职责 |
| --- | --- |
| [index.vue](src/views/tools/sql/index.vue) | SQL 工具页面入口。 |

### `src/views/tools/storage`

| 文件 | 职责 |
| --- | --- |
| [index.vue](src/views/tools/storage/local/index.vue) | 本地文件管理页面入口。 |
| [storage-preview.vue](src/views/tools/storage/modules/storage-preview.vue) | 存储文件预览。 |
| [index.vue](src/views/tools/storage/oss/index.vue) | 云端对象存储管理页面入口。 |

### `src/views/user-center`

| 文件 | 职责 |
| --- | --- |
| [index.vue](src/views/user-center/index.vue) | 个人中心页面入口。 |

### `src/views/user-center/modules`

| 文件 | 职责 |
| --- | --- |
| [editInfo.vue](src/views/user-center/modules/editInfo.vue) | 个人资料编辑。 |
| [editPassword.vue](src/views/user-center/modules/editPassword.vue) | 修改密码。 |
| [info.vue](src/views/user-center/modules/info.vue) | 个人资料显示。 |

## 工作区包与构建脚本文件索引

前面的表解释每个包的用途；这里列出各包入口、实现与构建插件。

### `packages/alova`

| 文件 | 职责 |
| --- | --- |
| [client.ts](packages/alova/src/client.ts) | Alova 客户端实例。 |
| [constant.ts](packages/alova/src/constant.ts) | Alova 配置常量。 |
| [fetch.ts](packages/alova/src/fetch.ts) | 底层 fetch 适配。 |
| [index.ts](packages/alova/src/index.ts) | 包导出入口。 |
| [mock.ts](packages/alova/src/mock.ts) | 模拟请求支持。 |
| [type.ts](packages/alova/src/type.ts) | 请求类型约束。 |

### `packages/axios`

| 文件 | 职责 |
| --- | --- |
| [constant.ts](packages/axios/src/constant.ts) | Axios 请求常量。 |
| [index.ts](packages/axios/src/index.ts) | Axios 封装出口。 |
| [options.ts](packages/axios/src/options.ts) | 请求实例选项。 |
| [shared.ts](packages/axios/src/shared.ts) | 公共错误和参数处理。 |
| [type.ts](packages/axios/src/type.ts) | 请求与响应类型。 |

### `packages/color`

| 文件 | 职责 |
| --- | --- |
| [index.ts](packages/color/src/constant/index.ts) | 子模块导出入口。 |
| [name.ts](packages/color/src/constant/name.ts) | 颜色名称常量。 |
| [palette.ts](packages/color/src/constant/palette.ts) | 色板常量。 |
| [index.ts](packages/color/src/index.ts) | 包导出入口。 |
| [antd.ts](packages/color/src/palette/antd.ts) | Ant Design 风格色板。 |
| [index.ts](packages/color/src/palette/index.ts) | 子模块导出入口。 |
| [recommend.ts](packages/color/src/palette/recommend.ts) | 推荐色板。 |
| [colord.ts](packages/color/src/shared/colord.ts) | 颜色转换基础封装。 |
| [index.ts](packages/color/src/shared/index.ts) | 子模块导出入口。 |
| [name.ts](packages/color/src/shared/name.ts) | 颜色名称计算。 |
| [index.ts](packages/color/src/types/index.ts) | 颜色相关类型。 |

### `packages/hooks`

| 文件 | 职责 |
| --- | --- |
| [index.ts](packages/hooks/src/index.ts) | 包导出入口。 |
| [use-boolean.ts](packages/hooks/src/use-boolean.ts) | 布尔状态切换 Hook。 |
| [use-context.ts](packages/hooks/src/use-context.ts) | 上下文注入 Hook。 |
| [use-count-down.ts](packages/hooks/src/use-count-down.ts) | 倒计时 Hook。 |
| [use-loading.ts](packages/hooks/src/use-loading.ts) | 加载状态 Hook。 |
| [use-request.ts](packages/hooks/src/use-request.ts) | 异步请求状态 Hook。 |
| [use-signal.ts](packages/hooks/src/use-signal.ts) | 信号状态 Hook。 |
| [use-svg-icon-render.ts](packages/hooks/src/use-svg-icon-render.ts) | 图标渲染 Hook。 |
| [use-table.ts](packages/hooks/src/use-table.ts) | 表格状态 Hook。 |

### `packages/materials`

| 文件 | 职责 |
| --- | --- |
| [index.ts](packages/materials/src/index.ts) | 包导出入口。 |
| [index.module.css](packages/materials/src/libs/admin-layout/index.module.css) | 后台布局局部样式。 |
| [index.module.css.d.ts](packages/materials/src/libs/admin-layout/index.module.css.d.ts) | CSS Modules 类名类型声明。 |
| [index.ts](packages/materials/src/libs/admin-layout/index.ts) | 子模块导出入口。 |
| [index.vue](packages/materials/src/libs/admin-layout/index.vue) | 后台布局主组件。 |
| [shared.ts](packages/materials/src/libs/admin-layout/shared.ts) | 布局属性和共享配置。 |
| [button-tab.vue](packages/materials/src/libs/page-tab/button-tab.vue) | 按钮风格页签。 |
| [chrome-tab-bg.vue](packages/materials/src/libs/page-tab/chrome-tab-bg.vue) | Chrome 页签背景。 |
| [chrome-tab.vue](packages/materials/src/libs/page-tab/chrome-tab.vue) | Chrome 风格页签。 |
| [index.module.css](packages/materials/src/libs/page-tab/index.module.css) | 页签局部样式。 |
| [index.module.css.d.ts](packages/materials/src/libs/page-tab/index.module.css.d.ts) | CSS Modules 类名类型声明。 |
| [index.ts](packages/materials/src/libs/page-tab/index.ts) | 子模块导出入口。 |
| [index.vue](packages/materials/src/libs/page-tab/index.vue) | 页签主组件。 |
| [shared.ts](packages/materials/src/libs/page-tab/shared.ts) | 页签配置和共享类型。 |
| [svg-close.vue](packages/materials/src/libs/page-tab/svg-close.vue) | 页签关闭图标。 |
| [index.ts](packages/materials/src/libs/simple-scrollbar/index.ts) | 子模块导出入口。 |
| [index.vue](packages/materials/src/libs/simple-scrollbar/index.vue) | 简易滚动条组件。 |
| [index.ts](packages/materials/src/types/index.ts) | 布局材料的公开类型。 |

### `packages/ofetch`

| 文件 | 职责 |
| --- | --- |
| [index.ts](packages/ofetch/src/index.ts) | ofetch 封装出口。 |

### `packages/scripts`

| 文件 | 职责 |
| --- | --- |
| [bin.ts](packages/scripts/bin.ts) | `sa` 命令入口。 |
| [changelog.ts](packages/scripts/src/commands/changelog.ts) | 变更日志命令。 |
| [cleanup.ts](packages/scripts/src/commands/cleanup.ts) | 清理命令。 |
| [git-commit.ts](packages/scripts/src/commands/git-commit.ts) | 交互式提交命令。 |
| [index.ts](packages/scripts/src/commands/index.ts) | 子命令聚合。 |
| [release.ts](packages/scripts/src/commands/release.ts) | 发布命令。 |
| [router.ts](packages/scripts/src/commands/router.ts) | 路由生成命令。 |
| [update-pkg.ts](packages/scripts/src/commands/update-pkg.ts) | 依赖更新命令。 |
| [index.ts](packages/scripts/src/config/index.ts) | CLI 配置。 |
| [index.ts](packages/scripts/src/index.ts) | 命令注册出口。 |
| [index.ts](packages/scripts/src/locales/index.ts) | CLI 中英文消息。 |
| [index.ts](packages/scripts/src/shared/index.ts) | CLI 共用辅助函数。 |
| [index.ts](packages/scripts/src/types/index.ts) | CLI 参数与结果类型。 |

### `packages/uno-preset`

| 文件 | 职责 |
| --- | --- |
| [index.ts](packages/uno-preset/src/index.ts) | UnoCSS 预设和通用快捷类。 |

### `packages/utils`

| 文件 | 职责 |
| --- | --- |
| [crypto.ts](packages/utils/src/crypto.ts) | 加密工具。 |
| [index.ts](packages/utils/src/index.ts) | 包导出入口。 |
| [klona.ts](packages/utils/src/klona.ts) | 数据深拷贝工具。 |
| [nanoid.ts](packages/utils/src/nanoid.ts) | 短 ID 生成。 |
| [storage.ts](packages/utils/src/storage.ts) | 浏览器存储封装。 |

### `packages/vite-plugin-tinymce-resource`

| 文件 | 职责 |
| --- | --- |
| [index.ts](packages/vite-plugin-tinymce-resource/src/index.ts) | TinyMCE 静态资源复制插件。 |

### `build/config`

| 文件 | 职责 |
| --- | --- |
| [index.ts](build/config/index.ts) | 子模块导出入口。 |
| [proxy.ts](build/config/proxy.ts) | Vite 代理生成和前缀重写。 |
| [time.ts](build/config/time.ts) | 构建时间生成。 |

### `build/plugins`

| 文件 | 职责 |
| --- | --- |
| [compression.ts](build/plugins/compression.ts) | 产物压缩插件。 |
| [html.ts](build/plugins/html.ts) | HTML 模板处理插件。 |
| [index.ts](build/plugins/index.ts) | 构建插件组装入口。 |
| [router.ts](build/plugins/router.ts) | Elegant Router 构建插件。 |
| [unocss.ts](build/plugins/unocss.ts) | UnoCSS 构建插件。 |
| [unplugin.ts](build/plugins/unplugin.ts) | 组件和图标自动导入插件。 |
