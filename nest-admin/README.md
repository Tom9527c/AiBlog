# nest-admin（AiBlog 后端）

这是 AiBlog 的 NestJS 服务端，提供账号认证、角色权限、系统管理、博客内容与评论、音乐曲库、媒体存储、定时任务及后台工具接口。管理页面在同级 `../vue3-naive-admin`，访客页面在 `../blog-web`。本文件描述当前仓库的运行方式、请求链和文件职责；博客模块还有一份简短的 [模块说明](src/modules/blog/README.md)。

**推荐阅读顺序：**第一次接手先看下文「初学者先读」和「实战」；排查线上或本地问题看「排障路线」；查职责再回到逐文件表。初始化环境看 [../docs/blog-setup.md](../docs/blog-setup.md)。


## 初学者先读：一个请求到底经过哪些文件

以管理后台保存追番为例，先区分前端地址与服务端地址：浏览器进入 `/admin/blog/bangumis`（Vue 路由）；Vue 发 `PUT /api/blog/admin/content/bangumis/:id`（网关转发后，Nest 实际收到 `/blog/admin/content/bangumis/:id`）。这不是两个 Controller；`/api` 是网关加的前缀。

```text
vue3-naive-admin/views/blog/bangumis/index.vue
  → content/components/ContentManager.vue（表单和保存）
  → vue3-naive-admin/src/service/api/blog.ts（请求封装）
  → 网关 /api → Nest /blog/admin/content/bangumis/:id
  → BlogAdminController.update（鉴权并接收 BlogContentDto）
  → BlogService.save（验证、规范化、写表、更新媒体引用）
  → BlogBangumi / blog_bangumi 表
  → 响应 { code, data, message } → Vue 刷新列表
```

初次排查时用浏览器 Network 记下方法、URL、请求体、HTTP 状态、后端业务码，再按上面顺序进入文件。Controller 解决“请求去了哪里、能否访问”，DTO 解决“参数合法吗”，Service 解决“为何保存或查询成这样”，Entity/迁移解决“数据库有没有字段或表”。

### 启动前的最低检查

1. `pnpm install` 安装后端依赖；核对 `.env.development` 的 MySQL、Redis、JWT 配置与本机运行环境。示例 `.env` 中的密码只是示例，生产配置要替换。
2. MySQL 首次建库按 [sql/nest_admin.sql](sql/nest_admin.sql)；博客增量表和管理菜单由 `pnpm run blog:migrate` 创建。迁移会修改数据库并生成 `.blog-backups` 备份，确认连接到正确的库再运行。根目录联调指引见 [../docs/blog-setup.md](../docs/blog-setup.md)。
3. `pnpm run blog:dev` 用 `NODE_ENV=development` 启动，并显式设置 `DB_SYNCHRONIZE=false`、`DB_LOGGING=false`。看到服务启动日志后再访问后台；如果连库失败，先修配置和服务状态，别改 Controller。
4. 没有现成权限的账号先检查 `sys_role`、`sys_menu` 和 `sys_role_menus`。增量脚本只默认给有效的 `superadmin` 授予新博客管理权限；其他角色在后台角色管理按需授权。

## 博客数据模型：新增内容前必须理解

[blog.entity.ts](src/modules/blog/blog.entity.ts) 的 `BlogContent` 定义所有内容共享字段：`id`、标题/固定标识（slug）、摘要/正文及格式、封面/链接、分组与排序、草稿/发布状态、公开/登录/密码访问、相册父项/分类/标签、`metadata`、作者、发布时间与创建更新时间。`BlogDocument`、`BlogBangumi` 等实体各映射独立表；`CONTENT_ENTITIES` 将 API 使用的 `documents`、`bangumis` 等 kind 映射到实体。`BlogSite`、`BlogMenu`、`BlogMedia`、`BlogMediaReference` 则是站点、前台导航和媒体引用，不是 `BlogContent` 的子类型。

| 字段 | 服务端决定了什么 | 开发时注意 |
| --- | --- | --- |
| `slug` | 公开详情可用固定标识访问；同一类型表中有唯一索引 | 只支持文字、数字、下划线、点和横线；为空时创建流程有默认值，编辑已有条目要留意前端删空 slug 的规则 |
| `status` / `publishedAt` | 公开列表只返回已发布且时间已到的条目 | 后台能看到草稿，不代表前台立刻显示 |
| `accessMode` | `public` 所有人可读；`login` 需要有效登录；`password` 要提交解锁凭证 | 改访问方式或密码时 `accessVersion` 更新，旧凭证不应继续授权 |
| `passwordHash` | Argon2 保存密码哈希，默认查询不选出 | API 不应返回原密码或哈希；编辑时空密码表示保留已有密码 |
| `metadata` | 追番状态、照片尺寸等模块专有字段 | 必须经过 `content/blog-metadata.ts` 校验；该文件未允许的键不能仅靠前端新增输入框保存 |
| `categoryId` / `tagIds` | 文章分类和标签关系 | 保存时检查分类及每个标签是否存在，标签 ID 去重 |
| `parentId` | 照片所属相册、评论所属回复 | 照片必须有有效相册；评论的目标与回复关系还要单独核对 |
| `cover` / `url` | 内容展示的外部或托管媒体地址 | 需要 URL 安全检查；受限内容使用托管媒体及引用关系 |

### 发布后的“后台有、前台没有”

[BlogService.list](src/modules/blog/blog.service.ts) 在公开模式过滤草稿、未到发布时间的条目；`projection()` 对不可读内容标记 `locked`，移除封面、URL、元数据等可能泄漏的字段。`readable()` 还逐层检查：照片必须同时可读所属相册，评论必须审核通过且目标内容可读。因此不要在前端发现空 `metadata` 就补一个公开 API 绕过投影；先确认状态、访问模式、父内容和认证头。后台模式经过 `adminProjection()`，不向管理端返回 `passwordHash` 和 `accessVersion`。

## 管理接口：接口、权限、保存过程

[BlogAdminController](src/modules/blog/blog-admin.controller.ts) 以 `/blog/admin` 为根路径，不依赖页面隐藏按钮决定权限。每个入口先调用 `BlogAuthService.permit(req, resource, action)`。`content/:kind` 的资源就是对应 kind；`photos` 的权限可以由相册权限映射。服务端重新查询当前有效角色、菜单和权限，不把旧 JWT 中的角色声明直接当作最终授权。

| 请求（Nest 实际路径） | 主要用途 | 权限 / 下一跳 |
| --- | --- | --- |
| `GET /blog/admin/content/:kind` | 列表、搜索、分页、筛选 | `kind:list` → `BlogService.list(..., true)` |
| `GET /blog/admin/content/:kind/:id` | 编辑前取详情 | `kind:list` → `detail(..., true)` |
| `POST /blog/admin/content/:kind` | 新建 | `kind:create` → `save()` |
| `PUT /blog/admin/content/:kind/:id` | 更新 | `kind:update` → `save()` |
| `DELETE /blog/admin/content/:kind/:id` | 删除 | `kind:delete` → `remove()`，留意关联 |
| `GET/PUT /blog/admin/site` | 读取/保存站点设置 | `site:list/update` → `site()/saveSite()` |
| `GET/PUT /blog/admin/about` | 关于页单例读取/保存 | `about:list/update` → `about()/saveAbout()` |
| `GET/POST/PUT/DELETE /blog/admin/menus...` | 访客导航维护 | `menus:list/create/update/delete` → `site/blog-menus.ts` |
| `GET /blog/admin/comments` | 待审/已审列表与计数 | `comments:list` → `CommentsService.adminList()` |
| `POST /blog/admin/comments/moderate` | 批量通过/拒绝/待审 | `comments:update` → `CommentsService.moderate()` |
| `POST /blog/admin/comments/:id/reply` | 管理员回复 | `comments:create` → `CommentsService.adminReply()` |
| `POST /blog/admin/upload` | 博客图片/音视频上传 | `BlogMediaService.upload()` 检查身份、权限、大小和真实文件头 |

保存内容时 [blog.dto.ts](src/modules/blog/blog.dto.ts) 控制基础字段类型和长度；`BlogService.save()` 合并原条目、设置默认值、校验 slug 和 URL、规范化 `metadata`、用 Argon2 处理新密码、检查分类/标签/相册存在性、维护媒体引用并写库。关于页走单例 `saveAbout()`：先锁定 `blog_site` 锚点，再更新同一条关于内容，避免并发创建多份“关于本人”。站点设置走 `validateSettings()`，在事务中同时更新 `blog_site` 与媒体引用。

## 公开接口、登录与密码解锁

[BlogPublicController](src/modules/blog/blog-public.controller.ts) 以 `/blog/public` 为根路径并声明公开入口，但**公开入口不表示所有数据可读**：具体内容调用 `BlogService.readable()`，后者通过 `BlogAuthService.identify()` 与 `BlogAccessPolicy.canRead()` 判断。

1. `GET /blog/public/site` 和 `/menus` 提供全站设置和启用的访客菜单。前台 App 启动时先取它们。
2. `GET /blog/public/content/:kind` 和 `/:slug` 返回列表/详情；服务端公开投影清除锁定正文与元数据。`moments` 的公开列表已经并入说说，旧类型的请求不可当作新页面数据源。
3. 登录后前台发送 `Authorization: Bearer <token>`；`BlogAuthService.identify()` 检查 Token、黑名单、账号状态和当前有效角色。`GET /blog/public/session` 返回前台使用的安全会话资料。
4. 密码内容调用 `POST /blog/public/content/:kind/:id/unlock`。`BlogAccessPolicy.unlock()` 校验发布状态和 Argon2 哈希后，签发带 `kind/id/accessVersion/exp` 的 HMAC 凭证；有效期为 3600 秒。前台将凭证置于 `X-Blog-Unlock`，后续读取时 `canRead()` 对签名、时间与版本进行验证。
5. `GET /blog/public/media/:id` 单独经 `BlogMediaService.read()` 判断媒体的引用目标是否可读；服务端以 `private, no-store`、正确 MIME 和 `nosniff` 返回二进制。知道媒体 ID 并不等于获得下载权限。

**容易误判的情况：**后台能打开文章但公开详情 `locked=true` 是预期的权限分离；修改了密码后浏览器旧解锁记录失效是版本校验；图片路径 `/blog-media/:id` 本身不是可直接公开访问的静态文件。不要把受保护文件放进 `public/` 试图修好 403。

## 评论：从提交到公开可见

- 前台 `POST /blog/public/comments` 进入 [CommentsService](src/modules/blog/comments/comments.service.ts)；DTO 限制正文长度、昵称/邮箱/网站和目标元数据，`comment-targets.ts` 校验文章/相册/说说/关于等目标。匿名访客可以提交，但频率受 Throttler 约束。
- 审核状态保存在评论 `metadata.moderationStatus`。管理员在后台通过 `/blog/admin/comments/moderate` 批量审核；公开列表只包含已发布、已到发布时间且审核通过的评论。公开投影只保留允许公开的作者和浏览器信息，不向访客暴露邮箱等私人字段。
- 前台 `GET /blog/public/comments` 的 `targetKind/targetId` 决定查询某篇内容的评论，未提供目标时是留言板；读取受限目标时先校验目标可读。排序包括最新、最早和热门；回复归到根评论下。`POST /comments/:id/reaction` 用 `x-comment-visitor` 或登录身份识别当前投票者。
- 看到“评论提交成功但页面没出现”：先查后台待审核，再看目标 kind/ID、公开状态与目标访问权限；不要修改前台列表让待审评论泄漏。

## 媒体存储：文件去向和删除约束

1. `BlogAdminController.upload` 经 `FileInterceptor('file')` 限制单文件 25 MB；[BlogMediaService.upload](src/modules/blog/media/blog-media.service.ts) 再检查用户是否有博客创建/更新权限，依据文件**内容字节**识别 JPG、PNG、GIF、WebP、AVIF、MP3、MP4，不信任用户给的扩展名。
2. [StorageService.upload](src/modules/tools/storage/storage.service.ts) 创建统一存储记录；博客媒体以私有方式保存，同时关联 `blog_media` ID；本地私有数据在 `.blog-private/` 或 `storage/blog-private/` 的既有路径，具体以存储记录和配置为准。普通公开上传位于 `public/` 中的公开路径。
3. 保存文章/相册/站点设置时，`BlogService.mediaReferences()` 根据内容字段维护 `blog_media_reference`。媒体读取先查引用：站点引用可公开；普通内容要能读引用目标；未被引用的文件默认只允许上传者读取。
4. [StorageService.delete](src/modules/tools/storage/storage.service.ts) 在删除前检查文件是否仍被博客引用；有引用就拒绝删除。迁移 `storage-migrate.cjs` 升级存储字段，运行时迁移 `StorageService.migrate()` 先复制并读取校验哈希，保存新位置，保留旧位置作恢复副本。
5. [object-store.ts](src/modules/tools/storage/object-store.ts) 统一处理本地/阿里云/腾讯云对象存储；本地路径做白名单检查，私有对象不写公开目录，云端私有对象使用私有 ACL。改存储驱动要同时覆盖读取、写入、删除和 profile 记录，不能只改上传 URL。

## 曲库：预览、并发、应用和播放

音乐有两种来源：`blog_music` 普通内容表存手工歌曲；`blog_music_library` 的状态 JSON 存完整歌单快照。前端会合并两种曲目。曲库管理 API 单独放在 [music/music-library.controller.ts](src/modules/blog/music/music-library.controller.ts)。

| 操作 | 请求 | 服务端行为与失败场景 |
| --- | --- | --- |
| 读取管理状态 | `GET /blog/admin/music-library` | 返回当前 `revision`、快照、待应用预览及最近错误，要求 `blog:music:list` |
| QQ 歌单预览 | `POST /blog/admin/music-library/preview` | 根据 source 读取歌单，计算新增/移除/变化；拉取失败记录 `lastError`，保留当前曲库 |
| JSON 导入预览 | `POST /blog/admin/music-library/import` | 校验快照结构和曲目，生成带 token 的待应用差异，不立即替换线上歌单 |
| 确认应用 | `POST /blog/admin/music-library/apply` | 校验 token、`baseRevision` 和 24 小时预览时限；保存旧快照、应用新快照，`revision+1` |
| 前台读取 | `GET /blog/public/music` | 返回已应用的快照和 `configured` 标识，不返回待应用内容 |
| 播放时获取音源 | `GET /blog/public/music/tracks/:id/media` | 只解析当前已应用歌单中的曲目，手工曲目返回已有地址，QQ 音源由 Provider 查询并短时缓存 |

`revision` 是防止两个管理员互相覆盖的版本号；冲突时刷新再预览，而不是在前端强行重试旧 token。QQ 歌单数据在 `qq-music.provider.ts`，校验、差异和曲目 ID 在 `music-library.ts`，持久状态和更新事务在 `music-library.store.ts`，业务流程在 `music-library.service.ts`。前台音频播放失败还可能是浏览器限制或源 URL 失效，应对照 React `useMusicPlayback.ts` 诊断。

## 实战：初学者怎样加一个字段或模块

### 例子 A：追番新增 `metadata.recommendation`

这是**在现有 kind 上加元数据**，无需新表：

1. 管理后台在 `views/blog/bangumis/components/BangumiFields.vue` 加字段输入与旧数据默认值；提交时确认 `ContentManager.saveData()` 的 `metadata` 带了新键。
2. 本项目在 [content/blog-metadata.ts](src/modules/blog/content/blog-metadata.ts) 的 `bangumis` 规则中加入这个字符串字段及长度限制，明确处理空值。否则管理端即使能输入，`validateMetadata()` 也可能拒绝请求。若需要公共列、搜索排序或 SQL 索引，再设计实体字段和迁移；普通小字段优先按现有元数据规则处理。

   ```ts
   // 与 bangumis 的 state、region 等规则并列：
   recommendation: v => typeof v === 'string' && v.length <= 200,
   ```

   请求中的 `metadata` 必须是对象；校验函数逐键检查，未声明的键不会默默保存。旧行没有这个键仍有效，因此前端读取时要处理空值。此例只改 JSON `metadata`，不需要改 `BlogContentDto` 的表字段；若改的是独立列，就要同步实体、DTO 和数据库迁移。
3. 访客页若要展示，在 `blog-web/src/views/bangumi/BangumiPage.tsx` 对可读内容使用该键，给旧条目留空态；受限条目不应该显示它。
4. 验证“后台填值 → Network 请求体 → 后端返回 → 刷新后依然存在 → 前台可读内容可见”。若后端报 400，看 DTO 和 `validateMetadata`；报 403，看 `blog:bangumis:update`；后台保存成功前台不显示，看发布状态、公开投影和前台组件。

### 例子 B：新增真正的 `notes` 内容类型

先明确表、接口、权限、前后台路由再编码。后端需要在 `blog.entity.ts` 增加 `BlogNote` 与 `CONTENT_ENTITIES.notes`；在 `blog.dto.ts` 或 `content/blog-metadata.ts` 加请求校验；按 [scripts/blog-migrate.cjs](scripts/blog-migrate.cjs) 的增量方式新增表与 `sys_menu` 的 `blog:notes:list/create/update/delete` 授权。将实体加入 `blog.module.ts` 的 `TypeOrmModule.forFeature`，或确保它从 `CONTENT_ENTITIES` 自动注册。通用 Controller 的 `content/:kind` 经映射识别新类型，但公开可读逻辑、slug/URL、前台路由和后台菜单仍要逐一检查。后台扩展 `Kind`、页面 `views/blog/notes/index.vue`、专属 `components/`、路由映射；前台扩展 `Kind`、页面、`pathFor`。部署前在备份过的测试库执行迁移，确认旧条目和权限不被覆盖。

## 排障路线：先看证据再动代码

| 现象 | 最先看 | 下一跳 |
| --- | --- | --- |
| Nest 启动失败 | `NODE_ENV`、MySQL/Redis 可连接性、`AppConfig.port` 和日志 | `DatabaseModule`、配置命名空间、缺失的迁移 |
| `/api/...` 返回 404 | 网关是否去掉 `/api`、Nest `GLOBAL_PREFIX` | Controller 的 `@Controller`/方法装饰器、前端请求路径 |
| 401 | 请求是否带 Bearer Token、是否过期/被列入黑名单 | `BlogAuthService.identify()`、`TokenService`、账号状态 |
| 403 | 当前资源和动作、有效角色和 `sys_menu.permission` | `BlogAuthService.hasPermission()`；公开内容还要看 `BlogAccessPolicy` |
| 400 | Nest 的验证消息与请求体 | `BlogContentDto`、`validateMetadata()`、slug/URL/相册校验 |
| 后台有数据，前台为空 | 草稿和未来发布时间、`accessMode` | `BlogService.list()/projection()`、父相册、评论目标 |
| 更新报冲突 | 内容关联、曲库 revision/token 是否旧 | 对应 `remove()` 或曲库 `apply()` 的冲突分支 |
| 媒体无法显示或无法删除 | `blog_media`、存储记录、`blog_media_reference` | `BlogMediaService.read()`、存储 profile、文件是否真实存在 |
| 字段保存后消失 | 后台请求体、DTO、元数据校验 | 数据库记录、公开投影及前台类型/视图 |

常规代码修改先执行 `pnpm exec tsc --noEmit --pretty false` 和 `pnpm run build`。需要联动数据库的端到端验证在测试环境运行；上线数据结构改动要先确认备份和迁移顺序。本文是定位入口，接口最终行为以当前代码和实际请求结果共同核对。

## 项目结构与请求路径

```text
src/main.ts  启动 HTTP / WebSocket / Swagger / 全局校验和异常过滤
  └─ src/app.module.ts  注册配置、数据库、共享服务、权限守卫和业务模块
      ├─ modules/auth       登录、Token、权限
      ├─ modules/user       用户与个人资料
      ├─ modules/system     后台管理
      ├─ modules/blog       博客内容、站点、评论、媒体、曲库
      ├─ modules/tools      上传、存储、邮件、支付、SQL
      ├─ modules/tasks      后台任务
      ├─ modules/sse        服务端事件
      └─ socket             WebSocket
```

普通请求进入全局 JWT / RBAC 守卫和管道，Controller 负责路由与 DTO，Service 实现业务，Entity 对应数据库，响应与错误分别由拦截器和异常过滤器统一处理。博客公开接口、博客管理接口、曲库接口在 `src/modules/blog`；上传与统一存储在 `src/modules/tools`。博客管理的资源权限不是前端按钮权限的替代：后端仍在请求时校验。

## 安装、数据库与启动

`package.json` 声明 Node.js ≥ 18.12、pnpm ≥ 8.7。本仓库根目录的联调脚本要求 Node.js ≥ 20.19。启动前配置 MySQL、Redis 和环境变量；建库脚本见 [sql/nest_admin.sql](sql/nest_admin.sql)，具体联调见 [../docs/blog-setup.md](../docs/blog-setup.md)。

```bash
pnpm install
pnpm run start:dev       # NODE_ENV=development，Nest 监听文件变动
pnpm run blog:dev        # 本地博客联调；关闭 TypeORM 自动同步和 SQL 日志
pnpm run build
pnpm run start:prod      # NODE_ENV=production，运行 dist/main
pnpm test                # Jest，当前博客测试文件已按要求移除
pnpm run test:e2e        # test/ 中的端到端用例
```

`src/config/app.config.ts` 读取端口和 API 全局前缀；端口默认 3000，前缀由 `GLOBAL_PREFIX` 决定。Nest 启动日志会显示实际监听地址和 `/docs`、`/doc.html` 接口文档地址。根目录 `npm run dev` 另启动前端和同源网关；浏览器通过 5173 的 `/api/` 访问服务，网关去掉 `/api` 再转发到 Nest 的 3000 端口。不要把网关的 `/api` 当作 Nest Controller 自身的路由前缀。

### 环境、构建和数据库文件

| 文件 | 作用 |
| --- | --- |
| [.env](.env) | 所有环境共用的基础参数；本地私有值应按环境核对。 |
| [.env.development](.env.development) | 开发环境 MySQL、Redis、JWT、日志及第三方登录参数。 |
| [.env.production](.env.production) | 生产环境对应参数；上线前必须替换示例密钥与密码，保持 `DB_SYNCHRONIZE=false`。 |
| [config/default.json](config/default.json)、[config/development.json](config/development.json) | `config` 包读取的默认/开发配置。 |
| [src/config/index.ts](src/config/index.ts) | 集中注册配置命名空间并定义配置类型。 |
| [src/config/app.config.ts](src/config/app.config.ts) | 端口、全局前缀等应用配置。 |
| [src/config/database.config.ts](src/config/database.config.ts) | 数据库连接配置。 |
| [src/config/redis.config.ts](src/config/redis.config.ts) | Redis 连接配置。 |
| [src/config/security.config.ts](src/config/security.config.ts) | JWT 和安全配置。 |
| [src/config/mailer.config.ts](src/config/mailer.config.ts) | 邮件服务配置。 |
| [src/config/oss.config.ts](src/config/oss.config.ts) | 本地或云端对象存储配置。 |
| [src/config/pay.config.ts](src/config/pay.config.ts) | 支付服务配置。 |
| [src/config/third-login.config.ts](src/config/third-login.config.ts) | GitHub 等第三方登录配置。 |
| [nest-cli.json](nest-cli.json) | Nest 构建及静态资源复制；生成新文件时默认不生成 spec。 |
| [tsconfig.json](tsconfig.json)、[tsconfig.build.json](tsconfig.build.json) | TS 编译与排除项，使用 `~/` 指向 `src/`。 |
| [package.json](package.json)、[pnpm-lock.yaml](pnpm-lock.yaml) | 依赖、脚本和锁文件。 |
| [Dockerfile](Dockerfile)、[docker-compose.yml](docker-compose.yml)、[docker-compose.prod.yml](docker-compose.prod.yml) | 镜像及开发/生产服务编排。 |
| [ecosystem.config.js](ecosystem.config.js) | 进程管理配置。 |
| [webpack-hmr.config.js](webpack-hmr.config.js) | 热更新构建配置。 |
| [sql/nest_admin.sql](sql/nest_admin.sql) | 原始后台数据库初始化 SQL。 |
| [sql/nest_admin_2026-09-23.sql](sql/nest_admin_2026-09-23.sql) | 仓库内的指定日期 SQL 快照；恢复前检查实际环境和数据。 |

数据库和媒体都是持久数据。`DB_SYNCHRONIZE=true` 仅用于受控开发环境；AiBlog 联调使用 `blog:dev` 并先执行需要的增量迁移。`pnpm run docker:down:v` 会删除 Compose 数据卷，不能作为普通停止命令。

## 应用入口和全局处理

| 文件 | 作用 |
| --- | --- |
| [src/main.ts](src/main.ts) | 创建 Nest Express 应用、JSON 限制、CORS、全局前缀、静态资源、日志、管道、异常过滤、Redis Socket 适配器及 Swagger。 |
| [src/app.module.ts](src/app.module.ts) | 注册所有业务模块、全局拦截器、JWT / RBAC 守卫和请求上下文。 |
| [src/app.controller.ts](src/app.controller.ts) | 应用级基础接口。 |
| [src/setup-swagger.ts](src/setup-swagger.ts) | Swagger / Knife4j 文档配置。 |
| [src/common/pipes/global-validation.pipes.ts](src/common/pipes/global-validation.pipes.ts) | 全局 DTO 参数验证。 |
| [src/common/pipes/creator.pipe.ts](src/common/pipes/creator.pipe.ts)、[updater.pipe.ts](src/common/pipes/updater.pipe.ts) | 新增和更新操作使用的参数处理。 |
| [src/common/interceptors/transform.interceptor.ts](src/common/interceptors/transform.interceptor.ts) | 将返回值包装成统一的业务响应。 |
| [src/common/interceptors/logging.interceptor.ts](src/common/interceptors/logging.interceptor.ts) | 请求日志。 |
| [src/common/interceptors/timeout.interceptor.ts](src/common/interceptors/timeout.interceptor.ts) | 请求超时处理。 |
| [src/common/interceptors/idempotence.interceptor.ts](src/common/interceptors/idempotence.interceptor.ts) | 幂等请求处理。 |
| [src/filters/all-exception-filter.ts](src/filters/all-exception-filter.ts) | 全局异常到 HTTP 响应及日志的转换。 |
| [src/filters/http-exception-filter.ts](src/filters/http-exception-filter.ts) | HTTP 异常过滤辅助实现。 |
| [src/common/exceptions/biz.exception.ts](src/common/exceptions/biz.exception.ts) | 业务异常类型。 |
| [src/common/model/response.model.ts](src/common/model/response.model.ts) | 统一响应模型。 |
| [src/common/dto/pager.dto.ts](src/common/dto/pager.dto.ts)、[operator.dto.ts](src/common/dto/operator.dto.ts)、[delete.dto.ts](src/common/dto/delete.dto.ts) | 分页、操作人和删除参数的通用 DTO。 |
| [src/common/entity/common.eneity.ts](src/common/entity/common.eneity.ts) | 公用实体字段基类（文件名保留现有拼写）。 |
| [src/common/decorators](src/common/decorators) | HTTP、Swagger、参数 ID、幂等、变换、Redis 注入等通用装饰器。 |
| [src/common/adapters/socket.adapter.ts](src/common/adapters/socket.adapter.ts) | WebSocket 的 Redis 适配。 |
| [src/constants](src/constants) | 缓存键、Redis、错误、返回码、系统参数和正则常量。 |
| [src/helper/pagination](src/helper/pagination) | 查询分页的参数和结果封装。 |
| [src/utils](src/utils) | 配置、加密、IP、文件、权限、菜单、部门和查询条件等无状态工具。 |
| [src/types](src/types) | 全局及工具类型声明。 |
| [src/assets/templates](src/assets/templates) | 邮箱验证码模板。 |
| [src/https](src/https) | HTTPS 证书文件；部署时按实际证书管理。 |

## 认证、用户和共享服务

| 文件 / 目录 | 作用 |
| --- | --- |
| [src/modules/auth/auth.module.ts](src/modules/auth/auth.module.ts) | 认证模块注册和依赖组装。 |
| [src/modules/auth/auth.controller.ts](src/modules/auth/auth.controller.ts) | 登录、注册、验证码登录和 Token 刷新入口。 |
| [src/modules/auth/auth.service.ts](src/modules/auth/auth.service.ts) | 用户验证与认证业务。 |
| [src/modules/auth/auth.constant.ts](src/modules/auth/auth.constant.ts) | 认证相关常量。 |
| [src/modules/auth/controllers](src/modules/auth/controllers) | 账号资料、验证码、邮箱验证码、第三方登录等独立路由。 |
| [src/modules/auth/dto](src/modules/auth/dto) | 登录、注册、验证码和第三方登录请求类型及校验。 |
| [src/modules/auth/entities](src/modules/auth/entities) | Access / Refresh Token 实体。 |
| [src/modules/auth/services](src/modules/auth/services) | 验证码、Token 和第三方登录业务。 |
| [src/modules/auth/strategies/jwt.strategy.ts](src/modules/auth/strategies/jwt.strategy.ts) | JWT 解析策略。 |
| [src/modules/auth/guards](src/modules/auth/guards) | JWT、local 登录和 RBAC 权限守卫。 |
| [src/modules/auth/decorators](src/modules/auth/decorators) | 公开、匿名、当前用户和权限元数据。 |
| [src/modules/user/user.controller.ts](src/modules/user/user.controller.ts) | 用户及个人资料 HTTP 接口。 |
| [src/modules/user/user.service.ts](src/modules/user/user.service.ts) | 用户服务协调入口。 |
| [src/modules/user/user-list.ts](src/modules/user/user-list.ts) | 用户列表查询和列表相关逻辑。 |
| [src/modules/user/user-session.ts](src/modules/user/user-session.ts) | 用户会话相关逻辑。 |
| [src/modules/user/user-contact.ts](src/modules/user/user-contact.ts) | 用户联系方式处理。 |
| [src/modules/user/user.entity.ts](src/modules/user/user.entity.ts)、[profile.entity.ts](src/modules/user/profile.entity.ts) | 用户和用户资料实体。 |
| [src/modules/user/dto/user.dto.ts](src/modules/user/dto/user.dto.ts)、[user.model.ts](src/modules/user/user.model.ts) | 用户参数与响应模型。 |
| [src/modules/user/user.module.ts](src/modules/user/user.module.ts) | 用户模块依赖注册。 |
| [src/shared/database](src/shared/database) | TypeORM 注册和数据库约束。 |
| [src/shared/redis](src/shared/redis) | Redis 缓存、发布订阅及共享连接。 |
| [src/shared/mailer](src/shared/mailer) | 邮件模块与发送服务。 |
| [src/shared/logger](src/shared/logger) | Winston 日志模块。 |
| [src/shared/helper](src/shared/helper) | Cron / QQ 等可注入辅助服务。 |
| [src/shared/shared.module.ts](src/shared/shared.module.ts) | 汇总共享依赖。 |

## 博客模块：逐文件说明

博客路由和通用数据入口在 `src/modules/blog` 根目录；专门业务按 `comments/`、`content/`、`media/`、`music/`、`site/` 分类。前台公开接口和后台管理接口分离，受限内容依赖访问策略及媒体权限验证。

| 文件 | 作用 |
| --- | --- |
| [blog.module.ts](src/modules/blog/blog.module.ts) | 注册内容、站点、音乐实体和控制器，注入服务及访问策略。 |
| [blog-admin.controller.ts](src/modules/blog/blog-admin.controller.ts) | `/blog/admin`：内容增删改查、站点、菜单、关于页、评论审核等后台接口。 |
| [blog-public.controller.ts](src/modules/blog/blog-public.controller.ts) | `/blog/public`：公开内容、站点、前台菜单、评论等访客接口。 |
| [blog.service.ts](src/modules/blog/blog.service.ts) | 博客业务总服务，协调内容、站点及其他子域。 |
| [blog.entity.ts](src/modules/blog/blog.entity.ts) | 内容、站点、菜单、媒体及引用关系的 TypeORM 实体。 |
| [blog.dto.ts](src/modules/blog/blog.dto.ts) | 内容、菜单、分页等博客接口 DTO。 |
| [blog-access.policy.ts](src/modules/blog/blog-access.policy.ts) | 内容可见性与访问凭证策略。 |
| [blog-auth.service.ts](src/modules/blog/blog-auth.service.ts) | 后台博客资源授权、用户身份与权限校验。 |
| [blog-exception.filter.ts](src/modules/blog/blog-exception.filter.ts) | 博客接口的异常转换。 |
| [comments/comments.service.ts](src/modules/blog/comments/comments.service.ts) | 评论创建、查询、审核、回复等业务。 |
| [comments/comment-targets.ts](src/modules/blog/comments/comment-targets.ts) | 评论关联目标解析与有效性检查。 |
| [comments/comment-environment.ts](src/modules/blog/comments/comment-environment.ts) | 评论访客环境信息处理。 |
| [content/blog-metadata.ts](src/modules/blog/content/blog-metadata.ts) | 内容元数据读写及规范化。 |
| [media/blog-media.service.ts](src/modules/blog/media/blog-media.service.ts) | 博客托管媒体的服务入口。 |
| [media/blog-photo-media.ts](src/modules/blog/media/blog-photo-media.ts) | 相册照片媒体关联处理。 |
| [media/blog-private-media.ts](src/modules/blog/media/blog-private-media.ts) | 私有媒体及访问控制处理。 |
| [music/music-library.controller.ts](src/modules/blog/music/music-library.controller.ts) | 后台曲库和前台曲库的 HTTP 接口。 |
| [music/music-library.service.ts](src/modules/blog/music/music-library.service.ts) | 曲库预览、导入、应用等业务。 |
| [music/music-library.store.ts](src/modules/blog/music/music-library.store.ts) | 曲库存取与持久状态。 |
| [music/music-library.entity.ts](src/modules/blog/music/music-library.entity.ts) | 曲库持久化实体。 |
| [music/music-library.ts](src/modules/blog/music/music-library.ts) | 曲库结构、规范化与共享处理。 |
| [music/qq-music.provider.ts](src/modules/blog/music/qq-music.provider.ts) | QQ 音乐来源数据对接。 |
| [site/blog-settings.ts](src/modules/blog/site/blog-settings.ts) | 站点设置的读取、规范化和保存逻辑。 |
| [site/blog-about.ts](src/modules/blog/site/blog-about.ts) | 关于页内容处理。 |
| [site/blog-menus.ts](src/modules/blog/site/blog-menus.ts) | 前台导航菜单读取、保存与排序等处理。 |

接口改动通常需要同步 DTO/Entity/Service/Controller、前端 `vue3-naive-admin/src/service/api/blog.ts` 和 `blog-web/src/types/index.ts`。受保护媒体不能直接用公开文件 URL 替代，应该走访问策略及媒体服务。新增博客功能归入其业务目录，并在 `blog.module.ts` 注册需要注入的服务、控制器和实体。

## 后台系统模块与工具

| 路径 | 作用与关键文件 |
| --- | --- |
| [src/modules/system/system.module.ts](src/modules/system/system.module.ts) | 注册系统管理子模块。 |
| [src/modules/system/dept](src/modules/system/dept) | 部门管理；`*.controller.ts` 定义 HTTP 路由，`*.service.ts` 处理业务，`*.entity.ts` 持久化，`dto/` 校验参数。 |
| [src/modules/system/dict/type](src/modules/system/dict/type) | 字典类型；独立 Controller、Service、Entity、DTO。 |
| [src/modules/system/dict/item](src/modules/system/dict/item) | 字典项；与字典类型分模块。 |
| [src/modules/system/menu](src/modules/system/menu) | **后台系统菜单**和权限路由；不同于 `blog/site/blog-menus.ts` 的前台导航。 |
| [src/modules/system/role](src/modules/system/role) | 角色和角色权限。 |
| [src/modules/system/notice](src/modules/system/notice) | 系统公告。 |
| [src/modules/system/parameter](src/modules/system/parameter) | 系统参数。 |
| [src/modules/system/monitor/cache](src/modules/system/monitor/cache) | 缓存查看与操作。 |
| [src/modules/system/monitor/log](src/modules/system/monitor/log) | 验证码、登录、任务日志；`entities/` 和 `services/` 按日志类型拆分。 |
| [src/modules/system/monitor/online](src/modules/system/monitor/online) | 在线用户和会话管理。 |
| [src/modules/system/monitor/serve](src/modules/system/monitor/serve) | 服务器监控数据。 |
| [src/modules/system/task](src/modules/system/task) | 可配置任务的 Controller、Service、Entity；`task.processor.ts` 执行队列任务。 |
| [src/modules/tasks](src/modules/tasks) | 任务调度基础设施；`jobs/` 中邮件、HTTP 请求、日志及 Token 清理各有独立任务文件。 |
| [src/modules/tools/tool.module.ts](src/modules/tools/tool.module.ts) | 聚合后台工具模块。 |
| [src/modules/tools/upload](src/modules/tools/upload) | 上传接口及上传服务。 |
| [src/modules/tools/storage](src/modules/tools/storage) | 文件记录、统一对象存储、本地/云端适配、预览和迁移；`object-store.ts` 为存储抽象，`object-storage.service.ts` 协调具体实现。 |
| [src/modules/tools/oss](src/modules/tools/oss) | 阿里云和腾讯云 OSS 实现及管理接口。 |
| [src/modules/tools/mail](src/modules/tools/mail) | 邮件发送接口。 |
| [src/modules/tools/pay](src/modules/tools/pay) | 支付接口、业务服务及密钥资源。 |
| [src/modules/tools/sql](src/modules/tools/sql) | SQL 工具接口和服务。 |
| [src/modules/sse](src/modules/sse) | SSE 连接与消息推送。 |
| [src/socket](src/socket) | WebSocket 模块、基础网关、管理/前台事件及认证网关；`socket/client/index.html` 用于本地调试。 |

每个 Nest 模块以 `*.module.ts` 注册依赖，`*.controller.ts` 接收请求，`*.dto.ts` 做输入约束，`*.service.ts` 实现业务，`*.entity.ts` 映射表，`*.model.ts` 定义返回结构。查一个功能时先从 Controller 到 Service 再到 Entity；无需把其他模块的查询和权限逻辑堆进博客总服务。

## 数据迁移、媒体与验证脚本

| 文件 | 作用 |
| --- | --- |
| [scripts/blog-migrate.cjs](scripts/blog-migrate.cjs) | 博客增量建表、菜单及权限初始化；执行前阅读 [../docs/blog-setup.md](../docs/blog-setup.md) 并备份数据。 |
| [scripts/blog-migration-permissions.cjs](scripts/blog-migration-permissions.cjs) | 博客迁移所需的菜单/权限数据。 |
| [scripts/blog-navigation.cjs](scripts/blog-navigation.cjs) | 博客前台导航迁移数据与辅助逻辑。 |
| [scripts/blog-navigation-repair.cjs](scripts/blog-navigation-repair.cjs) | 前台导航修复。 |
| [scripts/blog-repair-bootstrap.cjs](scripts/blog-repair-bootstrap.cjs) | 根据迁移前备份恢复非超级管理员的博客角色授权。 |
| [scripts/blog-merge-essays.cjs](scripts/blog-merge-essays.cjs) | 说说数据合并迁移。 |
| [scripts/album-media-migrate.cjs](scripts/album-media-migrate.cjs) | 相册媒体迁移。 |
| [scripts/music-library-migrate.cjs](scripts/music-library-migrate.cjs) | 曲库表的增量准备。 |
| [scripts/storage-migrate.cjs](scripts/storage-migrate.cjs) | 统一存储表的增量字段升级。 |
| [scripts/blog-integration.cjs](scripts/blog-integration.cjs) | 需要运行中服务和数据库的博客集成验证脚本。 |
| [scripts/blog-browser-fixtures.cjs](scripts/blog-browser-fixtures.cjs) | 浏览器联调所需数据准备。 |
| [scripts/storage-integration.cjs](scripts/storage-integration.cjs) | 统一存储的集成验证脚本。 |
| [test/app.e2e-spec.ts](test/app.e2e-spec.ts)、[test/jest-e2e.json](test/jest-e2e.json) | Nest 端到端测试及 Jest 配置。 |
| [public](public) | 可以由 Nest 静态服务提供的公共资源。 |
| [.blog-private](.blog-private) | 私有博客媒体的本地文件目录，部署和备份时必须与数据库一起保存。 |
| [.blog-backups](.blog-backups) | 博客迁移之前产生的菜单和权限备份。 |
| [storage](storage) | 统一存储的本地文件目录。 |

按用户要求，博客模块的单元测试和 `scripts/blog-*.test.cjs` 已删除；`scripts/blog-integration.cjs` 是显式执行的集成验证脚本。执行 `pnpm run blog:test`、`pnpm run test:storage` 会连接真实运行的服务和数据库，应在隔离的测试环境进行。迁移脚本是数据操作，不属于只读检查；先确认连接的数据库、备份位置和目标数据。

## 常见修改入口

| 目标 | 首选位置 |
| --- | --- |
| 新增博客内容字段 | `src/modules/blog/blog.dto.ts`、`blog.entity.ts`、`content/blog-metadata.ts`、相应 Service |
| 修改博客权限 | `src/modules/blog/blog-auth.service.ts`、`blog-access.policy.ts`、`src/modules/auth/guards/` |
| 修改评论审核 | `src/modules/blog/comments/`、`blog-admin.controller.ts` |
| 修改前台导航 | `src/modules/blog/site/blog-menus.ts`、`blog-public.controller.ts` |
| 修改曲库导入 | `src/modules/blog/music/` |
| 修改私有照片或下载 | `src/modules/blog/media/`、`src/modules/tools/storage/` |
| 修改上传位置 | `src/config/oss.config.ts`、`src/modules/tools/upload/`、`src/modules/tools/storage/` |
| 修改响应格式和校验 | `src/common/interceptors/transform.interceptor.ts`、`src/common/pipes/` |
| 修改端口或 API 前缀 | `src/config/app.config.ts`、对应 `.env`、`src/main.ts` |

纯代码修改可用 `pnpm exec tsc --noEmit --pretty false` 和 `pnpm run build` 检查。需要连接 MySQL / Redis 的验证应先确认运行环境和迁移情况；本 README 的文档修改不要求触发数据库脚本。

原始项目的英文介绍见 [README.en_US.md](README.en_US.md)，许可证见 [LICENSE](LICENSE)。

## 文件级补充索引

上述章节介绍调用关系；下面列出尚未单列的源码文件。路径相对项目根目录，每个条目可直接打开。静态图片、证书和锁文件在对应目录章节说明。

### `src/assets/templates`

| 文件 | 职责 |
| --- | --- |
| [verification-code-zh.hbs](src/assets/templates/verification-code-zh.hbs) | 中文邮箱验证码模板。 |
| [verification-code.hbs](src/assets/templates/verification-code.hbs) | 英文邮箱验证码模板。 |

### `src/common/decorators`

| 文件 | 职责 |
| --- | --- |
| [api-result.decorator.ts](src/common/decorators/api-result.decorator.ts) | 统一响应的 Swagger 注解。 |
| [bypass.decorator.ts](src/common/decorators/bypass.decorator.ts) | 跳过指定全局处理的标记。 |
| [http.decorator.ts](src/common/decorators/http.decorator.ts) | HTTP 接口复合装饰器。 |
| [idempotence.decorator.ts](src/common/decorators/idempotence.decorator.ts) | 幂等请求标记。 |
| [inject-redis.decorator.ts](src/common/decorators/inject-redis.decorator.ts) | Redis 依赖注入标记。 |
| [param-id.decorator.ts](src/common/decorators/param-id.decorator.ts) | ID 参数提取与校验。 |
| [swagger.decorators.ts](src/common/decorators/swagger.decorators.ts) | Swagger 文档复合注解。 |
| [transform.decorator.ts](src/common/decorators/transform.decorator.ts) | 响应转换控制标记。 |

### `src/constants`

| 文件 | 职责 |
| --- | --- |
| [cache.constant.ts](src/constants/cache.constant.ts) | 缓存键与缓存时长常量。 |
| [common.constant.ts](src/constants/common.constant.ts) | 通用业务常量。 |
| [error.constant.ts](src/constants/error.constant.ts) | 错误码及错误标识。 |
| [parameter.constant.ts](src/constants/parameter.constant.ts) | 系统参数名常量。 |
| [redis.constant.ts](src/constants/redis.constant.ts) | Redis 频道及键常量。 |
| [reg.ts](src/constants/reg.ts) | 正则表达式常量。 |
| [response.constant.ts](src/constants/response.constant.ts) | 统一响应码常量。 |

### `src/helper`

| 文件 | 职责 |
| --- | --- |
| [gen-redis-key.ts](src/helper/gen-redis-key.ts) | 生成 Redis 缓存键。 |

### `src/helper/pagination`

| 文件 | 职责 |
| --- | --- |
| [create-pagination.ts](src/helper/pagination/create-pagination.ts) | 构造分页结果。 |
| [index.ts](src/helper/pagination/index.ts) | 分页模块的聚合导出入口。 |
| [interface.ts](src/helper/pagination/interface.ts) | 分页接口类型。 |
| [pagination.ts](src/helper/pagination/pagination.ts) | 分页查询逻辑。 |

### `src/modules/auth/controllers`

| 文件 | 职责 |
| --- | --- |
| [account.controller.ts](src/modules/auth/controllers/account.controller.ts) | 个人资料、菜单、权限、密码修改与退出登录接口。 |
| [captcha.controller.ts](src/modules/auth/controllers/captcha.controller.ts) | 图形验证码接口。 |
| [email.controller.ts](src/modules/auth/controllers/email.controller.ts) | 发送邮箱验证码接口。 |
| [third-login.controller.ts](src/modules/auth/controllers/third-login.controller.ts) | 第三方登录授权、回调与关联接口。 |

### `src/modules/auth/decorators`

| 文件 | 职责 |
| --- | --- |
| [allow-anon.decorator.ts](src/modules/auth/decorators/allow-anon.decorator.ts) | 标记允许匿名访问的接口。 |
| [auth-user.decorator.ts](src/modules/auth/decorators/auth-user.decorator.ts) | 注入当前认证用户。 |
| [permission.decorator.ts](src/modules/auth/decorators/permission.decorator.ts) | 声明所需操作权限。 |
| [public.decorator.ts](src/modules/auth/decorators/public.decorator.ts) | 标记无需 JWT 的公开接口。 |

### `src/modules/auth/dto`

| 文件 | 职责 |
| --- | --- |
| [account.dto.ts](src/modules/auth/dto/account.dto.ts) | 资料更新和密码修改入参。 |
| [auth.dto.ts](src/modules/auth/dto/auth.dto.ts) | 登录、注册和令牌相关入参。 |
| [captcha.dto.ts](src/modules/auth/dto/captcha.dto.ts) | 验证码请求和校验入参。 |
| [third-login.dto.ts](src/modules/auth/dto/third-login.dto.ts) | 第三方登录授权入参。 |

### `src/modules/auth/entities`

| 文件 | 职责 |
| --- | --- |
| [access-token.entity.ts](src/modules/auth/entities/access-token.entity.ts) | 访问令牌表。 |
| [refresh-token.entity.ts](src/modules/auth/entities/refresh-token.entity.ts) | 刷新令牌表。 |

### `src/modules/auth/guards`

| 文件 | 职责 |
| --- | --- |
| [jwt-auth.guard.ts](src/modules/auth/guards/jwt-auth.guard.ts) | JWT 身份守卫。 |
| [local.guard.ts](src/modules/auth/guards/local.guard.ts) | 本地账号登录守卫。 |
| [rbac.guard.ts](src/modules/auth/guards/rbac.guard.ts) | 角色和权限守卫。 |

### `src/modules/auth/models`

| 文件 | 职责 |
| --- | --- |
| [auth.model.ts](src/modules/auth/models/auth.model.ts) | 认证接口返回模型或视图数据类型。 |

### `src/modules/auth/services`

| 文件 | 职责 |
| --- | --- |
| [captcha.service.ts](src/modules/auth/services/captcha.service.ts) | 图形或短信验证码业务。 |
| [third-login.service.ts](src/modules/auth/services/third-login.service.ts) | 第三方登录业务。 |
| [token.service.ts](src/modules/auth/services/token.service.ts) | Token 签发、校验和续期业务。 |

### `src/modules/sse`

| 文件 | 职责 |
| --- | --- |
| [sse.controller.ts](src/modules/sse/sse.controller.ts) | SSE 订阅路由；后台权限或菜单变化时浏览器由此接收通知。 |
| [sse.module.ts](src/modules/sse/sse.module.ts) | SSE模块依赖与控制器注册。 |
| [sse.service.ts](src/modules/sse/sse.service.ts) | 维护客户端连接，向单个或全部在线客户端推送菜单更新消息。 |

### `src/modules/system/dept`

| 文件 | 职责 |
| --- | --- |
| [dept.controller.ts](src/modules/system/dept/dept.controller.ts) | `/dept/list`、`/dept/tree`、创建、详情、更新、默认部门与删除入口。 |
| [dept.entity.ts](src/modules/system/dept/dept.entity.ts) | 部门数据库实体定义。 |
| [dept.module.ts](src/modules/system/dept/dept.module.ts) | 部门模块依赖与控制器注册。 |
| [dept.service.ts](src/modules/system/dept/dept.service.ts) | 构造部门树，校验父子部门和关联用户，执行增删改及默认部门设置。 |
| [dept.dto.ts](src/modules/system/dept/dto/dept.dto.ts) | 部门名称、上级、默认项等入参与列表查询验证。 |

### `src/modules/system/dict/item`

| 文件 | 职责 |
| --- | --- |
| [dict-item.controller.ts](src/modules/system/dict/item/dict-item.controller.ts) | `/dict-item/list`、新增、详情、编辑、状态切换和批量删除。 |
| [dict-item.dto.ts](src/modules/system/dict/item/dict-item.dto.ts) | 字典项内容及类型、排序、状态等请求字段。 |
| [dict-item.entity.ts](src/modules/system/dict/item/dict-item.entity.ts) | 字典项数据库实体定义。 |
| [dict-item.module.ts](src/modules/system/dict/item/dict-item.module.ts) | 字典项模块依赖与控制器注册。 |
| [dict-item.service.ts](src/modules/system/dict/item/dict-item.service.ts) | 字典项按类型查询、增删改、批量状态处理和删除前校验。 |

### `src/modules/system/dict/type`

| 文件 | 职责 |
| --- | --- |
| [dict-type.controller.ts](src/modules/system/dict/type/dict-type.controller.ts) | 字典类型列表、按 code 取字典项、新增、编辑、状态切换和删除。 |
| [dict-type.dto.ts](src/modules/system/dict/type/dict-type.dto.ts) | 字典类型标识和编辑请求字段校验。 |
| [dict-type.entity.ts](src/modules/system/dict/type/dict-type.entity.ts) | 字典类型数据库实体定义。 |
| [dict-type.module.ts](src/modules/system/dict/type/dict-type.module.ts) | 字典类型模块依赖与控制器注册。 |
| [dict-type.service.ts](src/modules/system/dict/type/dict-type.service.ts) | 字典类型的列表、查询、增删改与批量状态变更。 |

### `src/modules/system/menu`

| 文件 | 职责 |
| --- | --- |
| [create-menu.dto.ts](src/modules/system/menu/dto/create-menu.dto.ts) | 创建后台菜单、路由组件和权限节点的请求字段。 |
| [menu.controller.ts](src/modules/system/menu/menu.controller.ts) | `/menu/list` 与树、权限、详情、新增、更新、状态切换及删除入口。 |
| [menu.entity.ts](src/modules/system/menu/menu.entity.ts) | 后台菜单数据库实体定义。 |
| [menu.model.ts](src/modules/system/menu/menu.model.ts) | 后台菜单接口返回模型或视图数据类型。 |
| [menu.module.ts](src/modules/system/menu/menu.module.ts) | 后台菜单模块依赖与控制器注册。 |
| [menu.service.ts](src/modules/system/menu/menu.service.ts) | 后台菜单树构造、角色关联校验、权限查询和在线用户菜单刷新。 |

### `src/modules/system/monitor/cache`

| 文件 | 职责 |
| --- | --- |
| [cache.controller.ts](src/modules/system/monitor/cache/cache.controller.ts) | 按前缀列 Redis 键、读取键值、删除键与清理缓存的接口。 |
| [cache.model.ts](src/modules/system/monitor/cache/cache.model.ts) | 缓存接口返回模型或视图数据类型。 |
| [cache.module.ts](src/modules/system/monitor/cache/cache.module.ts) | 缓存模块依赖与控制器注册。 |
| [cache.service.ts](src/modules/system/monitor/cache/cache.service.ts) | 缓存前缀和键查询、读取值、删除/按前缀清理。 |

### `src/modules/system/monitor/log`

| 文件 | 职责 |
| --- | --- |
| [log.dto.ts](src/modules/system/monitor/log/dto/log.dto.ts) | 日志列表筛选、分页和删除参数。 |
| [captcha-log.entity.ts](src/modules/system/monitor/log/entities/captcha-log.entity.ts) | 验证码日志表。 |
| [login-log.entity.ts](src/modules/system/monitor/log/entities/login-log.entity.ts) | 登录日志表。 |
| [task-log.entity.ts](src/modules/system/monitor/log/entities/task-log.entity.ts) | 任务日志表。 |
| [log.controller.ts](src/modules/system/monitor/log/log.controller.ts) | 登录、任务和验证码日志的列表与删除接口。 |
| [log.module.ts](src/modules/system/monitor/log/log.module.ts) | 系统日志模块依赖与控制器注册。 |
| [log.model.ts](src/modules/system/monitor/log/models/log.model.ts) | 系统日志接口返回模型或视图数据类型。 |
| [captcha-log.service.ts](src/modules/system/monitor/log/services/captcha-log.service.ts) | 验证码日志查询。 |
| [login-log.service.ts](src/modules/system/monitor/log/services/login-log.service.ts) | 登录日志查询。 |
| [task-log.service.ts](src/modules/system/monitor/log/services/task-log.service.ts) | 任务日志查询。 |

### `src/modules/system/monitor/online`

| 文件 | 职责 |
| --- | --- |
| [online.controller.ts](src/modules/system/monitor/online/online.controller.ts) | 在线用户列表、总数和踢出会话接口。 |
| [online.dto.ts](src/modules/system/monitor/online/online.dto.ts) | 在线用户分页筛选和踢出请求字段。 |
| [online.model.ts](src/modules/system/monitor/online/online.model.ts) | 在线用户接口返回模型或视图数据类型。 |
| [online.module.ts](src/modules/system/monitor/online/online.module.ts) | 在线用户模块依赖与控制器注册。 |
| [online.service.ts](src/modules/system/monitor/online/online.service.ts) | 记录在线用户、推送登出通知、清理状态与踢出会话。 |

### `src/modules/system/monitor/serve`

| 文件 | 职责 |
| --- | --- |
| [serve.controller.ts](src/modules/system/monitor/serve/serve.controller.ts) | 读取服务器监控统计数据的入口。 |
| [serve.model.ts](src/modules/system/monitor/serve/serve.model.ts) | 服务器指标接口返回模型或视图数据类型。 |
| [serve.module.ts](src/modules/system/monitor/serve/serve.module.ts) | 服务器指标模块依赖与控制器注册。 |
| [serve.service.ts](src/modules/system/monitor/serve/serve.service.ts) | 采集服务器运行信息并组装监控响应。 |

### `src/modules/system/notice`

| 文件 | 职责 |
| --- | --- |
| [notice.dto.ts](src/modules/system/notice/dto/notice.dto.ts) | 公告标题、内容、状态和列表筛选等请求字段。 |
| [notice.controller.ts](src/modules/system/notice/notice.controller.ts) | 系统公告列表、总数、新增、详情、修改、状态和删除接口。 |
| [notice.entity.ts](src/modules/system/notice/notice.entity.ts) | 公告数据库实体定义。 |
| [notice.module.ts](src/modules/system/notice/notice.module.ts) | 公告模块依赖与控制器注册。 |
| [notice.service.ts](src/modules/system/notice/notice.service.ts) | 公告的查询、新增、修改、删除和批量启停处理。 |

### `src/modules/system/parameter`

| 文件 | 职责 |
| --- | --- |
| [parameter.dto.ts](src/modules/system/parameter/dto/parameter.dto.ts) | 参数键、值与新增编辑请求字段。 |
| [parameter.controller.ts](src/modules/system/parameter/parameter.controller.ts) | 系统参数列表、按键取值、新增、详情、编辑与删除接口。 |
| [parameter.entity.ts](src/modules/system/parameter/parameter.entity.ts) | 参数数据库实体定义。 |
| [parameter.module.ts](src/modules/system/parameter/parameter.module.ts) | 参数模块依赖与控制器注册。 |
| [parameter.service.ts](src/modules/system/parameter/parameter.service.ts) | 参数的读写和按 key 查询；改系统配置值优先查这里。 |

### `src/modules/system/role`

| 文件 | 职责 |
| --- | --- |
| [role.dto.ts](src/modules/system/role/dto/role.dto.ts) | 角色信息、角色权限和修改操作的请求字段。 |
| [role.controller.ts](src/modules/system/role/role.controller.ts) | 角色列表、全部有效角色、新增、详情、默认角色、更新及删除接口。 |
| [role.entity.ts](src/modules/system/role/role.entity.ts) | 角色数据库实体定义。 |
| [role.module.ts](src/modules/system/role/role.module.ts) | 角色模块依赖与控制器注册。 |
| [role.service.ts](src/modules/system/role/role.service.ts) | 角色授权、默认角色、用户关联检查及角色删除约束。 |

### `src/modules/system/task`

| 文件 | 职责 |
| --- | --- |
| [constant.ts](src/modules/system/task/constant.ts) | 任务业务常量。 |
| [task.controller.ts](src/modules/system/task/task.controller.ts) | 任务列表、新增、详情、更新、删除、单次执行、启动与暂停接口。 |
| [task.dto.ts](src/modules/system/task/task.dto.ts) | 定时任务 Cron、执行参数和状态等输入校验。 |
| [task.entity.ts](src/modules/system/task/task.entity.ts) | 任务数据库实体定义。 |
| [task.module.ts](src/modules/system/task/task.module.ts) | 任务模块依赖与控制器注册。 |
| [task.processor.ts](src/modules/system/task/task.processor.ts) | 定时任务队列处理器。 |
| [task.service.ts](src/modules/system/task/task.service.ts) | 注册和管理任务，处理单次执行、运行状态与队列调度。 |

### `src/modules/tasks/jobs`

| 文件 | 职责 |
| --- | --- |
| [email.job.ts](src/modules/tasks/jobs/email.job.ts) | 邮件发送任务。 |
| [http-request.job.ts](src/modules/tasks/jobs/http-request.job.ts) | HTTP 请求任务。 |
| [log-clear.job.ts](src/modules/tasks/jobs/log-clear.job.ts) | 日志清理任务。 |
| [token-clear.ts](src/modules/tasks/jobs/token-clear.ts) | 过期 Token 清理任务。 |

### `src/modules/tasks`

| 文件 | 职责 |
| --- | --- |
| [mission.decorator.ts](src/modules/tasks/mission.decorator.ts) | 调度任务元数据标记。 |
| [tasks.module.ts](src/modules/tasks/tasks.module.ts) | 后台调度模块依赖与控制器注册。 |

### `src/modules/tools/mail`

| 文件 | 职责 |
| --- | --- |
| [mail.controller.ts](src/modules/tools/mail/mail.controller.ts) | `POST /mail/send` 的邮件发送入口。 |
| [mail.dto.ts](src/modules/tools/mail/mail.dto.ts) | 收件人、主题与邮件正文的输入规则。 |
| [mail.module.ts](src/modules/tools/mail/mail.module.ts) | 邮件模块依赖与控制器注册。 |

### `src/modules/tools/oss`

| 文件 | 职责 |
| --- | --- |
| [alioss.service.ts](src/modules/tools/oss/alioss.service.ts) | 阿里云 OSS 接入。 |
| [oss.controller.ts](src/modules/tools/oss/oss.controller.ts) | `GET /oss/list` 获取可用对象存储配置或资源。 |
| [oss.dto.ts](src/modules/tools/oss/oss.dto.ts) | 云端对象存储查询和上传相关请求字段。 |
| [oss.model.ts](src/modules/tools/oss/oss.model.ts) | 云端对象存储接口返回模型或视图数据类型。 |
| [oss.module.ts](src/modules/tools/oss/oss.module.ts) | 云端对象存储模块依赖与控制器注册。 |
| [qcloudoss.service.ts](src/modules/tools/oss/qcloudoss.service.ts) | 腾讯云 COS 接入。 |

### `src/modules/tools/pay`

| 文件 | 职责 |
| --- | --- |
| [pay.controller.ts](src/modules/tools/pay/pay.controller.ts) | 创建支付、按 ID 验证支付、退款和关闭订单入口。 |
| [pay.dto.ts](src/modules/tools/pay/pay.dto.ts) | 支付金额、订单及退款请求字段校验。 |
| [pay.module.ts](src/modules/tools/pay/pay.module.ts) | 支付模块依赖与控制器注册。 |
| [pay.service.ts](src/modules/tools/pay/pay.service.ts) | 支付宝支付、验证、关闭与退款的业务处理。 |

### `src/modules/tools/sql`

| 文件 | 职责 |
| --- | --- |
| [sql.controller.ts](src/modules/tools/sql/sql.controller.ts) | 数据库导出与导入请求入口；只能在受控环境使用。 |
| [sql.module.ts](src/modules/tools/sql/sql.module.ts) | SQL 工具模块依赖与控制器注册。 |
| [sql.service.ts](src/modules/tools/sql/sql.service.ts) | 执行数据库 SQL 导入和导出。 |

### `src/modules/tools/storage`

| 文件 | 职责 |
| --- | --- |
| [object-storage.service.ts](src/modules/tools/storage/object-storage.service.ts) | 对象存储业务协调服务。 |
| [object-store.ts](src/modules/tools/storage/object-store.ts) | 对象存储接口与实现契约。 |
| [storage.controller.ts](src/modules/tools/storage/storage.controller.ts) | 文件列表、按 ID 预览、文件迁移及批量删除入口。 |
| [storage.dto.ts](src/modules/tools/storage/storage.dto.ts) | 文件列表筛选和删除、迁移等请求字段。 |
| [storage.entity.ts](src/modules/tools/storage/storage.entity.ts) | 文件存储数据库实体定义。 |
| [storage.modal.ts](src/modules/tools/storage/storage.modal.ts) | 文件存储接口返回模型或视图数据类型。 |
| [storage.module.ts](src/modules/tools/storage/storage.module.ts) | 文件存储模块依赖与控制器注册。 |
| [storage.service.ts](src/modules/tools/storage/storage.service.ts) | 上传和读取记录、引用检查、列表、删除及目标存储迁移。 |

### `src/modules/tools/upload`

| 文件 | 职责 |
| --- | --- |
| [upload.controller.ts](src/modules/tools/upload/upload.controller.ts) | 普通文件上传和删除接口；博客受限媒体使用博客专门入口。 |
| [upload.dto.ts](src/modules/tools/upload/upload.dto.ts) | 文件删除等上传模块请求字段。 |
| [upload.module.ts](src/modules/tools/upload/upload.module.ts) | 上传模块依赖与控制器注册。 |
| [upload.service.ts](src/modules/tools/upload/upload.service.ts) | 普通上传业务与存储服务协作。 |

### `src/shared/database/constraints`

| 文件 | 职责 |
| --- | --- |
| [unique.constraint.ts](src/shared/database/constraints/unique.constraint.ts) | 数据库唯一性校验器；DTO 校验重复值时查看。 |

### `src/shared/database`

| 文件 | 职责 |
| --- | --- |
| [database.module.ts](src/shared/database/database.module.ts) | 数据库模块依赖注册。 |

### `src/shared/helper`

| 文件 | 职责 |
| --- | --- |
| [cron.service.ts](src/shared/helper/cron.service.ts) | Cron 表达式辅助服务。 |
| [helper.module.ts](src/shared/helper/helper.module.ts) | 辅助服务模块依赖注册。 |
| [qq.service.ts](src/shared/helper/qq.service.ts) | QQ 相关共享服务。 |

### `src/shared/logger`

| 文件 | 职责 |
| --- | --- |
| [logger.module.ts](src/shared/logger/logger.module.ts) | 日志模块依赖注册。 |

### `src/shared/mailer`

| 文件 | 职责 |
| --- | --- |
| [mailer.module.ts](src/shared/mailer/mailer.module.ts) | 邮件模块依赖注册。 |
| [mailer.service.ts](src/shared/mailer/mailer.service.ts) | 根据模板和收件人发送邮件，认证验证码等调用。 |

### `src/shared/redis`

| 文件 | 职责 |
| --- | --- |
| [cache.service.ts](src/shared/redis/cache.service.ts) | 共享 Redis 缓存的读写封装。 |
| [redis-subpub.service.ts](src/shared/redis/redis-subpub.service.ts) | Redis 发布订阅服务，多个实例之间广播事件。 |
| [redis-subpub.ts](src/shared/redis/redis-subpub.ts) | 发布订阅消息体和频道相关约定。 |
| [redis.module.ts](src/shared/redis/redis.module.ts) | Redis模块依赖注册。 |

### `src/socket`

| 文件 | 职责 |
| --- | --- |
| [base.gateway.ts](src/socket/base.gateway.ts) | WebSocket 基础网关。 |
| [socket.constant.ts](src/socket/socket.constant.ts) | WebSocket 事件和连接配置。 |
| [socket.module.ts](src/socket/socket.module.ts) | WebSocket 模块注册。 |

### `src/socket/events`

| 文件 | 职责 |
| --- | --- |
| [admin.gateway.ts](src/socket/events/admin.gateway.ts) | 后台 WebSocket 事件网关。 |
| [web.gateway.ts](src/socket/events/web.gateway.ts) | 前台 WebSocket 事件网关。 |

### `src/socket/shared`

| 文件 | 职责 |
| --- | --- |
| [auth.gateway.ts](src/socket/shared/auth.gateway.ts) | WebSocket 连接认证网关。 |

### `src/types`

| 文件 | 职责 |
| --- | --- |
| [global.d.ts](src/types/global.d.ts) | 全局类型扩展。 |
| [utils.d.ts](src/types/utils.d.ts) | 工具类型定义。 |

### `src/utils`

| 文件 | 职责 |
| --- | --- |
| [and-where.util.ts](src/utils/and-where.util.ts) | 组合数据库查询条件。 |
| [config.util.ts](src/utils/config.util.ts) | 读取配置并转换类型。 |
| [crypto.util.ts](src/utils/crypto.util.ts) | 加密解密辅助。 |
| [dept.util.ts](src/utils/dept.util.ts) | 部门树和层级处理。 |
| [file.util.ts](src/utils/file.util.ts) | 文件名、扩展名与路径处理。 |
| [https.util.ts](src/utils/https.util.ts) | HTTPS 证书读取。 |
| [index.ts](src/utils/index.ts) | 工具函数聚合出口。 |
| [ip.util.ts](src/utils/ip.util.ts) | 访客 IP 获取。 |
| [menu.util.ts](src/utils/menu.util.ts) | 菜单树和路由菜单处理。 |
| [nickname.util.ts](src/utils/nickname.util.ts) | 昵称生成。 |
| [permission.util.ts](src/utils/permission.util.ts) | 权限标识与授权处理。 |
| [redis.util.ts](src/utils/redis.util.ts) | Redis 操作辅助。 |
| [tool.util.ts](src/utils/tool.util.ts) | 通用业务辅助。 |
