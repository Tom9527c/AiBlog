# blog-web

`blog-web` 是博客的 React 前台项目，负责向访客展示文章、分类、标签、相册、追番、音乐、说说、友链、收藏、关于页面和评论功能，同时提供登录、密码内容解锁、媒体访问、主题切换、背景设置、右键菜单、阅读进度和悬浮音乐播放器等交互能力。

项目使用 React + TypeScript + Vite 构建，页面按照业务模块放在 `src/views` 下。每个页面模块都有自己的入口文件，模块私有组件放在该模块的 `components/` 目录中；跨模块复用的组件才放在 `src/components`。

## 目录原则

项目目录遵循下面的边界：

- `src/app`：应用外壳、全站状态、路由、全局效果和应用级弹窗。
- `src/views`：页面业务模块。每个模块以 `index.ts` 或 `index.tsx` 作为模块入口。
- `src/views/<module>/components`：只服务于当前页面模块的组件。
- `src/components`：至少被两个页面模块使用的公共组件。
- `src/services`：请求和业务服务。
- `src/hooks`：跨页面复用的 React Hooks。
- `src/types`：跨模块共享的 TypeScript 类型。
- `src/utils`：无状态工具函数。
- `src/styles`：全站样式。
- `public/theme`：不经过 Vite 模块打包的主题静态资源。

判断一个组件放在哪里时，优先看它的业务归属：

1. 只属于音乐页面，放到 `src/views/music/components`。
2. 只属于评论模块，放到 `src/views/comments/components`。
3. 多个页面都需要的内容渲染、弹窗、分页、媒体组件，放到 `src/components`。
4. 页面入口只负责组织页面和调用数据，不把其他模块的组件实现复制进来。

## 技术栈

- React 19
- TypeScript 5.9
- Vite 6
- React Router 7
- `react-markdown` + `remark-gfm`：Markdown 内容渲染
- `dompurify`：HTML 内容清洗
- `yet-another-react-lightbox`：图片灯箱
- `opencc-js`：简体中文和繁体中文转换
- `qrcode`：分享二维码
- `theme-effects`：主题相关静态效果依赖
- Vitest：项目配置仍保留测试脚本，但当前项目中的测试文件已经移除

## 开发命令

```bash
# 安装依赖
npm install

# 启动开发服务，监听所有网卡
npm run dev

# 只做 TypeScript 类型检查
npm run typecheck

# 构建生产版本
npm run build

# 运行 Vitest
npm test
```

开发服务默认使用 Vite 配置的 `5174` 端口：

```text
http://localhost:5174
```

如果前端请求使用 `/api` 开头的地址，Vite 会把请求代理到：

```text
http://localhost:3000
```

代理配置位于 [vite.config.ts](vite.config.ts)。后端地址可以通过 `VITE_API_BASE_URL` 覆盖；如果没有设置，浏览器端默认使用 `/api`。

## 运行流程

应用从 [index.html](index.html) 的 `#root` 节点开始挂载：

```text
src/main.tsx
  └─ BrowserRouter
      └─ src/app/App.tsx
          └─ src/app/App.tsx 中的 App
              ├─ 请求站点配置和导航菜单
              ├─ 初始化主题、背景、登录会话和全局事件
              ├─ BlogProvider
              ├─ BlogNavigation
              ├─ AppRoutes
              ├─ SiteFooter
              ├─ MobileMenu
              ├─ SettingsConsole
              ├─ ContextMenu
              ├─ ShareDialog / BackgroundSettings / Auth
              └─ FloatingPlayer
```

### 应用启动阶段

1. [src/main.tsx](src/main.tsx) 引入全局样式。
2. 使用 `React.StrictMode` 和 `BrowserRouter` 挂载应用。
3. [src/app/App.tsx](src/app/App.tsx) 请求 `/blog/public/site` 和 `/blog/public/menus`。
4. 站点配置没有加载完成之前显示 [StartupScreen.tsx](src/components/StartupScreen.tsx)，避免用默认配置先渲染一次再发生布局跳变。
5. 站点配置加载完成后，通过 `BlogProvider` 向页面提供站点、登录会话、通知、播放音乐和刷新版本号。
6. [src/app/router.tsx](src/app/router.tsx) 根据 URL 渲染具体页面。

## 路由表

| 路径 | 页面模块 | 作用 |
| --- | --- | --- |
| `/` | `views/home` | 首页文章流、首页 Hero、分类入口、推荐文章和说说摘要 |
| `/page/:pageNumber` | `views/home` | 首页分页 |
| `/essay/` | `views/essays` | 说说、短内容和说说评论 |
| `/fcircle/` | `views/essays` | 兼容旧地址，重定向到 `/essay/` |
| `/about/` | `views/about` | 关于本人和关于页评论 |
| `/random/` | `views/articles/RandomPost` | 随机打开一篇文章 |
| `/posts/:slug` | `views/articles` | 文章详情、目录、上一篇/下一篇、推荐和评论 |
| `/archives/` | `views/articles` | 文章归档 |
| `/archives/page/:pageNumber` | `views/articles` | 文章归档分页 |
| `/archives/:year` | `views/articles` | 按年份查看归档 |
| `/archives/:year/page/:pageNumber` | `views/articles` | 按年份查看归档分页 |
| `/archives/:year/:month` | `views/articles` | 按年月查看归档 |
| `/archives/:year/:month/page/:pageNumber` | `views/articles` | 按年月查看归档分页 |
| `/categories/` | `views/taxonomy` | 分类列表 |
| `/categories/:slug` | `views/taxonomy` | 分类详情和文章列表 |
| `/categories/:slug/page/:pageNumber` | `views/taxonomy` | 分类分页 |
| `/tags/` | `views/taxonomy` | 标签列表 |
| `/tags/:slug` | `views/taxonomy` | 标签详情和文章列表 |
| `/tags/:slug/page/:pageNumber` | `views/taxonomy` | 标签分页 |
| `/album/` | `views/albums` | 相册列表 |
| `/album/:slug` | `views/albums` | 相册详情和媒体瀑布流 |
| `/dailyPhoto/` | `views/albums` | 日常生活相册分组 |
| `/lovePic/` | `views/albums` | 壁纸相册分组 |
| `/wordScenery/` | `views/albums` | 世界风景相册分组 |
| `/bangumis/` | `views/bangumi` | 追番状态和追番列表 |
| `/link/` | `views/links` | 友情链接 |
| `/collect/` | `views/collections` | 收藏内容 |
| `/music/` | `views/music` | 音乐库和完整播放器 |
| `/comments/` | `views/comments` | 留言板 |
| 其他路径 | `views/not-found` | 404 页面 |

路由定义集中在 [src/app/router.tsx](src/app/router.tsx)。新增页面时，应先在 `src/views/<module>` 下创建模块入口，再在这里引用模块入口。

## 应用层文件说明

### 根入口

| 文件 | 作用 |
| --- | --- |
| [src/main.tsx](src/main.tsx) | React 入口。创建 React 根节点，挂载 `StrictMode`、`BrowserRouter` 和 `App`，同时引入全局 CSS 和页面兼容样式。 |
| [src/App.tsx](src/App.tsx) | 兼容入口，只从 `src/app/App.tsx` 重导出，方便旧代码或外部入口继续引用。 |

### `src/app`

| 文件 | 作用 |
| --- | --- |
| [src/app/App.tsx](src/app/App.tsx) | 全站应用外壳。负责请求站点配置和菜单、初始化主题及本地设置、维护会话、处理路由切换、阅读进度、快捷键、右键菜单、通知、移动菜单、控制台、分享、登录和悬浮播放器。 |
| [src/app/BlogProvider.tsx](src/app/BlogProvider.tsx) | `BlogContext` 的 Provider 封装。将站点配置、当前用户、登录入口、通知方法、播放方法和刷新版本提供给子树。 |
| [src/app/router.tsx](src/app/router.tsx) | 所有前台页面路由的集中定义。只负责 URL 到页面组件的映射，不实现页面业务。 |
| [src/app/MobileMenu.tsx](src/app/MobileMenu.tsx) | 移动端侧边菜单。显示站点头像、站点名称和菜单树，点击遮罩、关闭按钮或菜单后关闭。 |
| [src/app/SettingsConsole.tsx](src/app/SettingsConsole.tsx) | 全局控制台弹窗。提供主题、背景、侧栏、特效、快捷键、右键菜单、播放器和登录状态控制。 |
| [src/app/SiteFooter.tsx](src/app/SiteFooter.tsx) | 全局页脚。显示站点页脚文案、社交链接、运行天数和备案信息；音乐页不显示。 |
| [src/app/effects/Effects.tsx](src/app/effects/Effects.tsx) | 根据站点配置挂载星空特效 Canvas，并尊重系统的减少动态效果设置。 |
| [src/app/effects/originalStars.ts](src/app/effects/originalStars.ts) | 星空 Canvas 动画的具体实现，负责初始化粒子、动画帧、窗口尺寸变化和清理。 |

## 公共组件

### `src/components/index.tsx`

这是公共组件的聚合出口，只负责重导出，不应重新堆积组件实现。当前出口包括：

- `BlogContext`、`useBlog`
- `useLoad`
- `Status`
- `Modal`
- `Media`、`useMedia`
- `Gate`
- `ContentBody`
- `LoadedContent`
- `Pager`
- `date`
- `pathFor`
- `PostCard`

如果组件只属于一个页面模块，不要为了方便从这里导出，应保留在对应模块的 `components/` 中。

### 内容组件：`src/components/content`

| 文件 | 作用 |
| --- | --- |
| [ContentBody.tsx](src/components/content/ContentBody.tsx) | 渲染文章、关于页等内容正文。支持 Markdown 和受清洗的 HTML；处理标题锚点、代码块工具、托管媒体 URL、外链、安全链接和图片灯箱。 |
| [Gate.tsx](src/components/content/Gate.tsx) | 受限内容访问门。根据 `accessMode` 显示登录入口或密码解锁表单。解锁成功后通知父组件重新加载内容。 |
| [LoadedContent.tsx](src/components/content/LoadedContent.tsx) | 根据内容类型和 ID 请求详情，统一处理加载、错误、锁定和正文渲染。页面可以通过 children 自定义解锁后的内容布局。 |

### 反馈组件：`src/components/feedback`

| 文件 | 作用 |
| --- | --- |
| [Modal.tsx](src/components/feedback/Modal.tsx) | 通用弹窗。处理遮罩点击关闭、Esc 关闭、焦点恢复、Tab 焦点循环和 body 滚动锁定。 |
| [Status.tsx](src/components/feedback/Status.tsx) | 统一的加载、错误和空状态展示。支持传入 retry 回调。 |

### 媒体组件：`src/components/media`

| 文件 | 作用 |
| --- | --- |
| [Media.tsx](src/components/media/Media.tsx) | 统一图片组件。通过 `useMedia` 处理普通 URL 和受保护的 `/blog-media/:id`，加载期间显示占位内容。 |
| [Lightbox.tsx](src/components/media/Lightbox.tsx) | 基于 `yet-another-react-lightbox` 的全屏图片查看器。支持图片列表、当前索引和关闭回调。 |

### 导航组件：`src/components/navigation`

| 文件 | 作用 |
| --- | --- |
| [BlogNavigation.tsx](src/components/navigation/BlogNavigation.tsx) | 顶部导航栏。显示站点 Logo、菜单、搜索、随机文章、控制台、移动端菜单和阅读进度。 |
| [ContextMenu.tsx](src/components/navigation/ContextMenu.tsx) | 自定义右键菜单。支持复制/下载图片、打开链接、前进后退、回到顶部、复制文字、复制当前链接、分享、语言切换、搜索、随机文章和音乐控制。 |
| [MenuTree.tsx](src/components/navigation/MenuTree.tsx) | 将扁平菜单数据递归转换成树形菜单。支持桌面菜单和移动端菜单。 |
| [PageTools.tsx](src/components/navigation/PageTools.tsx) | 页面右侧快捷工具，打开站点控制台或背景设置。 |
| [Pager.tsx](src/components/navigation/Pager.tsx) | 通用分页组件，同时提供 `articlePageSize` 和 `articlePage` 两个文章分页参数解析函数。 |

### 页面布局组件：`src/components/page`

| 文件 | 作用 |
| --- | --- |
| [PageShell.tsx](src/components/page/PageShell.tsx) | 页面通用外壳。统一页面标题、页头、主体容器和侧栏布局。 |
| [PageHeader.tsx](src/components/page/PageHeader.tsx) | 页面头部。根据 `PageHeaderKey` 显示配置中的标题、副标题和封面，支持详情页模式。 |
| [page-header.ts](src/components/page/page-header.ts) | 页面头部配置的读取、默认值和标题相关辅助逻辑。 |
| [page-header.css](src/components/page/page-header.css) | 页面头部局部样式。 |

### 文章卡片和窗口：`src/components/posts`、`src/components/window`

| 文件 | 作用 |
| --- | --- |
| [PostCard.tsx](src/components/posts/PostCard.tsx) | 首页、归档、分类、标签等列表中的文章卡片。显示封面、分类、标签、日期、摘要和已读状态。 |
| [FloatingWindow.tsx](src/components/window/FloatingWindow.tsx) | 可拖动、可缩放或使用 WinBox 样式承载的浮动窗口。背景设置等功能使用它。 |
| [CountYear.tsx](src/components/window/CountYear.tsx) | 年份或运行时长的数字递增展示。`countUpValue` 负责计算动画过程中的数字。 |
| [StartupScreen.tsx](src/components/StartupScreen.tsx) | 应用启动屏。显示站点配置加载状态和失败后的重试按钮。 |

### 全站辅助组件：`src/components/extra`

| 文件 | 作用 |
| --- | --- |
| [extras.tsx](src/components/extra/extras.tsx) | 兼容聚合出口，只重导出语言切换、分享、图片操作和背景设置。新实现应放在具体文件中。 |
| [BackgroundSettings.tsx](src/components/extra/BackgroundSettings.tsx) | 背景设置浮窗。支持恢复默认背景、选择纯色、选择渐变和使用站点封面。 |
| [ShareDialog.tsx](src/components/extra/ShareDialog.tsx) | 当前页面分享弹窗。异步生成二维码，并提供可复制的当前页面地址。 |
| [imageActions.ts](src/components/extra/imageActions.ts) | 图片下载和复制能力。负责获取图片 Blob、转成 PNG、触发下载和写入剪贴板。 |
| [useTraditional.ts](src/components/extra/useTraditional.ts) | 简繁转换 Hook。监听 DOM 变化，将页面文字和部分属性转换为繁体，并在关闭时恢复原文字。 |

## 页面模块说明

每个页面模块都遵循同样的结构：

```text
views/<module>/
├── index.ts                # 模块入口
├── <Page>.tsx              # 页面主体
├── components/             # 只属于当前模块的组件
├── *.css                   # 当前模块样式
└── *.ts                    # 当前模块的数据、解析和业务逻辑
```

### `src/views/home`：首页

| 文件 | 作用 |
| --- | --- |
| [index.ts](src/views/home/index.ts) | 导出 `Home` 和首页侧栏 `Aside`。 |
| [Home.tsx](src/views/home/Home.tsx) | 首页主体。加载文章、分类和说说，计算分页，渲染首页 Hero、推荐文章、分类栏、文章列表、侧栏和分页。 |
| [components/HomeHero.tsx](src/views/home/components/HomeHero.tsx) | 首页大屏 Hero。支持站点配置的多张图片/视频、移动端资源、自动播放、随机顺序、视差、遮罩和加载失败处理。 |
| [components/Aside.tsx](src/views/home/components/Aside.tsx) | 首页右侧信息栏。显示站点信息、分类、标签、归档或其他摘要内容。 |
| [components/EssayTicker.tsx](src/views/home/components/EssayTicker.tsx) | 首页说说滚动或轮播摘要，并提供 `loadPublicEssays` 请求公开说说。 |
| [components/SkillRibbon.tsx](src/views/home/components/SkillRibbon.tsx) | 首页 Hero 没有封面时展示的技能图标带。 |
| [components/TopPost.tsx](src/views/home/components/TopPost.tsx) | 首页推荐文章卡片，负责推荐文章的封面、标题和链接。 |
| [home-parity.css](src/views/home/home-parity.css) | 首页主体和主题兼容样式。 |
| [home-hero.css](src/views/home/home-hero.css) | 首页 Hero、大屏、视频和轮播样式。 |
| [aside-parity.css](src/views/home/aside-parity.css) | 首页侧栏样式。 |

### `src/views/articles`：文章和归档

| 文件 | 作用 |
| --- | --- |
| [index.ts](src/views/articles/index.ts) | 导出 `Article` 和 `Archives`。 |
| [Article.tsx](src/views/articles/Article.tsx) | 文章详情页。加载文章详情、相邻文章、推荐内容和评论，处理阅读标记、文章头部、正文、目录、分享和文章底部。 |
| [Archives.tsx](src/views/articles/Archives.tsx) | 文章归档页。根据年份、月份和分页参数加载文章列表。 |
| [RandomPost.tsx](src/views/articles/RandomPost.tsx) | 随机文章页面逻辑。请求文章列表后跳转到随机文章。 |
| [components/SearchDialog.tsx](src/views/articles/components/SearchDialog.tsx) | 文章搜索弹窗。支持关键词防抖、分页、空状态和点击结果跳转。 |
| [article-parity.css](src/views/articles/article-parity.css) | 文章详情页兼容样式、正文周边样式和文章布局样式。 |

### `src/views/about`：关于页面

| 文件 | 作用 |
| --- | --- |
| [index.ts](src/views/about/index.ts) | 导出 `AboutPage`。 |
| [AboutPage.tsx](src/views/about/AboutPage.tsx) | 请求关于内容，处理锁定状态，组合关于卡片和评论。 |
| [components/AboutCards.tsx](src/views/about/components/AboutCards.tsx) | 根据关于页 metadata 渲染个人资料、经历、技能、展示卡片、社交链接和背景图片。 |
| [components/about.css](src/views/about/components/about.css) | 关于页面专属样式。 |

### `src/views/albums`：相册和媒体

| 文件 | 作用 |
| --- | --- |
| [index.ts](src/views/albums/index.ts) | 导出 `Albums`。 |
| [Albums.tsx](src/views/albums/Albums.tsx) | 相册列表和相册详情入口。识别相册 slug、分组地址和详情地址。 |
| [useAlbumFeed.ts](src/views/albums/useAlbumFeed.ts) | 相册媒体数据加载 Hook，负责分页、分组和媒体列表状态。 |
| [components/AlbumMedia.tsx](src/views/albums/components/AlbumMedia.tsx) | 单个相册媒体的展示组件，处理图片、动图、视频和媒体信息。 |
| [components/AlbumLightbox.tsx](src/views/albums/components/AlbumLightbox.tsx) | 相册专用灯箱，负责媒体预览、键盘操作、焦点恢复和图片升级。 |
| [album.css](src/views/albums/album.css) | 相册列表、瀑布流、媒体卡片和详情样式。 |

### `src/views/bangumi`：追番

| 文件 | 作用 |
| --- | --- |
| [index.ts](src/views/bangumi/index.ts) | 导出 `BangumiPage`。 |
| [BangumiPage.tsx](src/views/bangumi/BangumiPage.tsx) | 加载追番内容，按“想看、在看、看过”筛选，显示进度、集数、评分和详情。 |
| [bangumi.css](src/views/bangumi/bangumi.css) | 追番页面样式。 |

### `src/views/collections`：收藏

| 文件 | 作用 |
| --- | --- |
| [index.ts](src/views/collections/index.ts) | 导出 `CollectionsPage`。 |
| [CollectionsPage.tsx](src/views/collections/CollectionsPage.tsx) | 加载收藏列表、处理分页并套用页面外壳。 |
| [components/CollectionPage.tsx](src/views/collections/components/CollectionPage.tsx) | 收藏项目列表和卡片渲染。 |
| [collections.css](src/views/collections/collections.css) | 收藏页面样式。 |

### `src/views/comments`：评论和留言板

| 文件 | 作用 |
| --- | --- |
| [index.ts](src/views/comments/index.ts) | 导出评论列表页面。 |
| [Comments.tsx](src/views/comments/Comments.tsx) | 评论核心模块。请求评论分页、处理排序、登录提示、评论回复、草稿、刷新和评论数量。 |
| [Guestbook.tsx](src/views/comments/Guestbook.tsx) | 留言板页面入口，使用 `Comments` 渲染无目标内容的公共留言。 |
| [comment-model.ts](src/views/comments/comment-model.ts) | 评论类型、评论分页类型、评论目标类型、访客 ID 和评论名称辅助函数。 |
| [components/CommentAvatar.tsx](src/views/comments/components/CommentAvatar.tsx) | 评论头像。处理头像 URL、默认头像和头像失败回退。 |
| [components/CommentBody.tsx](src/views/comments/components/CommentBody.tsx) | 评论正文渲染，支持 Markdown 和安全链接。 |
| [components/CommentComposer.tsx](src/views/comments/components/CommentComposer.tsx) | 评论和回复表单。处理昵称、邮箱、网站、正文、目标内容、回复关系和提交状态。 |
| [components/CommentEnvironment.tsx](src/views/comments/components/CommentEnvironment.tsx) | 评论环境信息展示，例如浏览器、系统、位置等。 |
| [components/CommentIcon.tsx](src/views/comments/components/CommentIcon.tsx) | 评论模块使用的图标封装。 |
| [components/CommentRow.tsx](src/views/comments/components/CommentRow.tsx) | 单条评论及其回复。处理点赞、点踩、作者、时间、评论正文、回复入口和环境信息。 |
| [comments.css](src/views/comments/comments.css) | 评论列表、评论项、回复、操作按钮和评论状态样式。 |
| [guestbook.css](src/views/comments/guestbook.css) | 留言板页面样式。 |

### `src/views/essays`：说说

| 文件 | 作用 |
| --- | --- |
| [index.ts](src/views/essays/index.ts) | 导出 `EssayPage`。 |
| [EssayPage.tsx](src/views/essays/EssayPage.tsx) | 说说页面。加载短内容，显示卡片、媒体、时间线和评论。 |
| [broadcast.ts](src/views/essays/broadcast.ts) | 说说广播和公开说说数据处理。首页的说说摘要也复用这里的逻辑。 |
| [model.ts](src/views/essays/model.ts) | 说说媒体和日期的类型、解析及格式化函数。 |
| [components/EssayMedia.tsx](src/views/essays/components/EssayMedia.tsx) | 说说中的图片、视频和媒体灯箱。 |
| [essay.css](src/views/essays/essay.css) | 说说卡片、时间线、媒体和评论布局样式。 |

### `src/views/home` 与 `src/views/articles` 的共享关系

首页会复用说说模块的 `broadcast.ts`，文章详情会复用评论模块的 `Comments`、分类标签模块的 `TagVisual`，首页和文章列表会复用公共的 `PostCard`。这些依赖属于明确的业务共享，不应复制实现。

### `src/views/links`：友链

| 文件 | 作用 |
| --- | --- |
| [index.ts](src/views/links/index.ts) | 导出 `LinksPage`。 |
| [LinksPage.tsx](src/views/links/LinksPage.tsx) | 加载和展示友情链接，处理外链安全 URL 和新窗口打开。 |
| [links.css](src/views/links/links.css) | 友链页面样式。 |

### `src/views/music`：音乐

| 文件 | 作用 |
| --- | --- |
| [index.ts](src/views/music/index.ts) | 导出 `Music`。 |
| [Music.tsx](src/views/music/Music.tsx) | 完整音乐页。加载音乐库、管理播放队列、播放/暂停、上一首/下一首、随机模式、歌词和歌曲详情。 |
| [useMusicPlayback.ts](src/views/music/useMusicPlayback.ts) | 音乐播放状态 Hook。维护当前曲目、队列、播放模式、音频元素、失败重试和自动切歌。 |
| [music-service.ts](src/views/music/music-service.ts) | 音乐库请求和音乐媒体解析服务。 |
| [lyrics.ts](src/views/music/lyrics.ts) | LRC 歌词解析、歌词时间点转换和当前歌词索引计算。 |
| [components/FloatingPlayer.tsx](src/views/music/components/FloatingPlayer.tsx) | 非音乐页面显示的悬浮播放器。通过 `blog-player` 自定义事件响应全局播放、暂停、上一首、下一首和打开操作。 |
| [music.css](src/views/music/music.css) | 完整音乐页样式。 |
| [floating-player.css](src/views/music/floating-player.css) | 悬浮播放器样式。 |

### `src/views/taxonomy`：分类和标签

| 文件 | 作用 |
| --- | --- |
| [index.ts](src/views/taxonomy/index.ts) | 导出 `Taxonomy`。 |
| [Taxonomy.tsx](src/views/taxonomy/Taxonomy.tsx) | 分类和标签通用页面。根据 `kind` 加载列表、详情、文章分页和页面头部。 |
| [components/CategoryCover.tsx](src/views/taxonomy/components/CategoryCover.tsx) | 分类封面图片，处理媒体 URL、加载状态和失败回退。 |
| [components/TagVisual.tsx](src/views/taxonomy/components/TagVisual.tsx) | 标签视觉组件、标签封面和标签页头。 |
| [tag-color.ts](src/views/taxonomy/tag-color.ts) | 根据标签数据生成稳定颜色和视觉样式。 |
| [category.css](src/views/taxonomy/category.css) | 分类、标签列表、标签卡片和页面头样式。 |

### `src/views/auth` 和 `src/views/not-found`

| 文件 | 作用 |
| --- | --- |
| [auth/index.tsx](src/views/auth/index.tsx) | 登录、注册、重置密码和邮箱验证码登录弹窗。通过 `api` 调用后端认证接口，并在成功后写入 Token。 |
| [not-found/index.tsx](src/views/not-found/index.tsx) | 404 页面，提供返回首页和文章归档入口。 |

## 服务层

### [src/services/api.ts](src/services/api.ts)

API 兼容出口。当前请求实现仍位于 `services/legacy/api.ts`，此文件用于保持调用方统一从 `services/api` 引入，后续可以在不大量修改页面的情况下替换底层实现。

### [src/services/legacy/api.ts](src/services/legacy/api.ts)

当前实际的 HTTP 和认证基础层，主要职责包括：

- 根据 `VITE_API_BASE_URL` 计算 API 前缀。
- 从 `localStorage` 读取和保存 `SOY_token`。
- 从 `sessionStorage` 读取内容解锁 Token。
- 自动拼接 `Authorization`、`Content-Type` 和 `X-Blog-Unlock` 请求头。
- 统一解析后端返回值和错误信息。
- 401 时清除本地登录 Token。
- 获取公开内容列表和详情。
- 提交密码解锁请求并保存解锁凭证。
- 处理受保护媒体 `/blog-media/:id` 的 Blob 下载和 Blob URL 生命周期。
- 提供 `safeUrl`，过滤不允许的 URL 协议。

### [src/services/content.ts](src/services/content.ts)

内容业务 API。提供：

- `listContent` / `list`：分页获取某种内容类型。
- `getContent` / `detail`：获取内容详情。
- `articleNeighbors`：按公开文章排序查找上一篇和下一篇。

页面应该优先通过这个文件访问文章、分类、标签、相册、说说等内容接口，不要在每个页面重新拼接 URL。

### [src/services/media.ts](src/services/media.ts)

媒体服务的简短出口，目前重导出 `api` 层的 `mediaUrl`，供媒体组件使用。

## Hooks

| 文件 | 作用 |
| --- | --- |
| [useLoad.ts](src/hooks/useLoad.ts) | 通用异步加载 Hook。返回 `data`、`error`、`loading` 和 `reload`；通过 `alive` 标记避免组件卸载后写状态。 |
| [useArticlePageScroll.ts](src/hooks/useArticlePageScroll.ts) | 文章列表翻页后等待数据加载，再滚动到文章列表位置。 |
| [useReadPost.ts](src/hooks/useReadPost.ts) | 通过 `localStorage` 记录已读文章，并监听自定义事件和 storage 事件同步多个页面。 |
| [useResponsiveNav.ts](src/hooks/useResponsiveNav.ts) | 使用 `ResizeObserver` 测量导航栏实际空间，决定是否折叠菜单。 |

## 类型文件

### [src/types/index.ts](src/types/index.ts)

全站共享类型：

- `Kind`：内容类型联合，包括 documents、categories、tags、albums、photos、bangumis、about、essays、links、moments、collections、music、comments。
- `TaxonomySummary`：分类和标签摘要。
- `Content`：文章、说说、相册、追番、音乐等内容的统一数据模型。
- `Page`：分页响应。
- `Menu`：站点导航菜单。
- `PageHeaderSettings`、`PageHeaderKey`：页面头部配置。
- `Site`：站点全局配置，包括主题、Hero、首页卡片、社交链接和播放器开关。
- `Session`：登录会话。

新增接口字段时，应优先更新这里的共享类型，再让页面使用类型检查发现遗漏。

## 工具文件

| 文件 | 作用 |
| --- | --- |
| [src/utils/date.ts](src/utils/date.ts) | 将日期字符串格式化为中文本地日期。 |
| [src/utils/path.ts](src/utils/path.ts) | 根据内容类型和 slug/id 生成前台 URL。文章使用 `/posts/...html`，相册使用 `/album/...`，其他内容使用对应类型路径。 |
| [src/utils/url.ts](src/utils/url.ts) | 提供安全 URL 过滤和媒体 URL 重导出。 |

## 全局样式

| 文件 | 作用 |
| --- | --- |
| [src/styles/index.css](src/styles/index.css) | 全站基础变量、布局、主题、通用组件和页面基础样式入口。 |
| [src/styles/global.css](src/styles/global.css) | 全局通用样式补充。 |
| [src/styles/navigation.css](src/styles/navigation.css) | 顶部导航、菜单和移动菜单样式。 |
| [src/styles/pagination.css](src/styles/pagination.css) | 分页样式。 |
| [src/styles/loading.css](src/styles/loading.css) | 加载动画和启动状态样式。 |
| [src/styles/lightbox.css](src/styles/lightbox.css) | 内容正文和图片灯箱样式。 |
| [src/styles/post-card-parity.css](src/styles/post-card-parity.css) | 文章卡片兼容样式。 |

页面模块专属样式放在模块目录，例如 `views/music/music.css`、`views/comments/comments.css`。不要把模块专属样式继续堆到 `styles/index.css`。

## 公共静态资源

| 路径 | 作用 |
| --- | --- |
| [public/theme/original.css](public/theme/original.css) | 原主题静态样式资源。 |
| [public/theme/icon/iconfont.css](public/theme/icon/iconfont.css) | Anzhiyu 图标字体 CSS。 |
| `public/theme/icon/anzhiyufont.woff2` | 图标字体文件。 |
| `public/theme/comment_bg.png` | 评论区域背景图。 |
| `public/theme/about/careers.svg` | 关于页面经历或职业相关插图。 |
| `public/theme/skills/*` | 首页技能带使用的 Java、Docker、Vue、React、Vite 等技能图标。 |
| `public/theme/vendor/winbox.bundle.min.js` | 浮动窗口依赖的静态脚本。 |

## 状态和浏览器存储

### React Context

`BlogProvider` 提供以下全站状态：

| 字段 | 作用 |
| --- | --- |
| `site` | 站点配置。 |
| `session` | 当前登录会话，没有登录时为 `null`。 |
| `login` | 打开登录弹窗。 |
| `notify` | 显示底部通知。 |
| `play` | 设置当前要播放的曲目。 |
| `revision` | 登录、解锁或 storage 事件后递增，触发依赖权限状态的内容重新加载。 |

### localStorage

| Key | 作用 |
| --- | --- |
| `SOY_token` | 登录 Token。 |
| `blog-background` | 背景值和保存时间，超过 24 小时会失效。 |
| `blog-traditional` | 是否开启繁体中文。 |
| `blog-theme` | 用户选择的主题模式。 |
| `blog-aside` | 是否显示侧栏。 |
| `blog-effects` | 是否启用星空特效。 |
| `blog-read:<id>` | 某篇文章是否已读。 |

### sessionStorage

| Key | 作用 |
| --- | --- |
| `blog-unlocks` | 当前浏览器会话中已通过密码解锁的内容凭证。 |

## 请求和权限流程

### 普通公开内容

```text
页面组件
  └─ useLoad
      └─ services/content.ts
          └─ services/api.ts
              └─ services/legacy/api.ts
                  └─ fetch(base + path)
```

### 受限内容

```text
ContentBody / Media
  └─ 检测 locked 或 /blog-media/:id
      ├─ Gate -> POST /blog/public/content/:kind/:id/unlock
      │          └─ 保存 blog-unlocks
      └─ mediaUrl -> GET /blog/public/media/:id
                     └─ Blob URL
```

受保护媒体一定要通过 `Media` 或 `mediaUrl` 加载，不要直接给 `<img>` 写 `/blog-media/123`，否则不会带上登录和解锁请求头。

### URL 安全

所有来自接口、用户输入或内容正文的外链都应经过 `safeUrl`。当前允许：

- `https://...`
- `http://...`
- `/relative-path`
- `blob:...`

不允许直接把未校验的 `javascript:`、`data:` 或其他协议写入 `href`、`src`。

## 新增或修改模块的流程

以新增一个 `notes` 页面为例：

```text
src/views/notes/
├── index.ts
├── NotesPage.tsx
├── components/
│   ├── NoteCard.tsx
│   └── NoteFilter.tsx
├── notes.css
└── notes-service.ts
```

### 步骤

1. 在 `src/types/index.ts` 增加必要的数据类型或内容类型。
2. 在 `src/services/content.ts` 或模块自己的 `notes-service.ts` 添加请求方法。
3. 创建 `src/views/notes/index.ts`，只导出页面入口。
4. 创建 `NotesPage.tsx`，只负责页面组合和页面级状态。
5. 页面专用组件放到 `src/views/notes/components`。
6. 页面专用样式放到 `src/views/notes/notes.css`。
7. 在 `src/app/router.tsx` 添加路由，优先从 `../views/notes` 引入模块入口。
8. 如果导航菜单需要新入口，由后台菜单配置提供，不要在前台硬编码第二份菜单数据。
9. 运行 `npm run typecheck` 和 `npm run build`。

### 组件拆分标准

建议满足以下标准：

- 一个文件只负责一个明确的视觉或业务职责。
- 页面文件负责数据组合，不负责实现所有卡片细节。
- 超过约 200～300 行且包含多个独立区域时，优先拆成 `components/` 子组件。
- 组件同时包含请求、列表、弹窗、表单和媒体处理时，应按职责拆开。
- `src/components` 只放跨页面组件，不要把音乐播放器、评论项、相册卡片等页面专属组件放进去。
- `index.ts` 只负责导出，不在入口文件里实现业务。

## 修改常见功能时应该看哪些文件

| 修改目标 | 首选文件 |
| --- | --- |
| 修改 API 基础地址或认证请求头 | `vite.config.ts`、`src/services/legacy/api.ts` |
| 修改站点配置加载 | `src/app/App.tsx`、`src/types/index.ts` |
| 修改顶部导航 | `src/components/navigation/BlogNavigation.tsx`、`MenuTree.tsx`、`src/styles/navigation.css` |
| 修改页面公共布局 | `src/components/page/PageShell.tsx`、`PageHeader.tsx` |
| 修改文章正文安全渲染 | `src/components/content/ContentBody.tsx` |
| 修改密码内容访问 | `src/components/content/Gate.tsx`、`src/components/content/LoadedContent.tsx`、`src/services/legacy/api.ts` |
| 修改受保护媒体 | `src/components/media/Media.tsx`、`src/services/legacy/api.ts` |
| 修改文章详情 | `src/views/articles/Article.tsx` |
| 修改首页 Hero | `src/views/home/components/HomeHero.tsx`、`src/views/home/home-hero.css` |
| 修改首页文章流 | `src/views/home/Home.tsx`、`src/views/home/components/TopPost.tsx` |
| 修改评论提交 | `src/views/comments/Comments.tsx`、`src/views/comments/components/CommentComposer.tsx` |
| 修改评论显示 | `src/views/comments/components/CommentRow.tsx`、`CommentBody.tsx` |
| 修改音乐播放 | `src/views/music/useMusicPlayback.ts`、`Music.tsx` |
| 修改音乐歌词 | `src/views/music/lyrics.ts` |
| 修改悬浮播放器 | `src/views/music/components/FloatingPlayer.tsx` |
| 修改相册媒体 | `src/views/albums/Albums.tsx`、`src/views/albums/components/AlbumMedia.tsx` |
| 修改简繁转换 | `src/components/extra/useTraditional.ts` |
| 修改背景设置 | `src/components/extra/BackgroundSettings.tsx`、`src/app/App.tsx` |
| 修改全局快捷键 | `src/app/App.tsx` |
| 修改右键菜单 | `src/components/navigation/ContextMenu.tsx`、`src/app/App.tsx` |

## 构建检查

当前项目完成结构调整后建议至少执行：

```bash
npm run typecheck
npm run build
```

构建可能出现以下提示，它们不一定是错误：

- `Lightbox.tsx` 同时被动态和静态引用时，Vite 会提示它不会被拆到独立动态 chunk。
- 某些主题或依赖 chunk 超过 500 kB 时，Vite 会给出 chunk size warning。

如果出现 TypeScript 错误，应先修复路径、类型或导出问题；不要通过关闭 `strict` 或添加无意义的 `any` 来绕过检查。

## 文件命名约定

- React 页面：`PascalCase.tsx`，例如 `Article.tsx`、`Music.tsx`。
- React 组件：`PascalCase.tsx`，例如 `CommentRow.tsx`。
- 工具和 Hook：功能名或 `useXxx.ts`，例如 `lyrics.ts`、`useLoad.ts`。
- 样式：模块名或组件关联名，例如 `music.css`、`floating-player.css`。
- 模块入口：`index.ts` 或 `index.tsx`。
- 组件目录统一使用 `components`，不要再使用含义模糊的 `modules` 存放页面组件。

## 维护注意事项

1. `src/services/api.ts` 是兼容入口，修改请求底层逻辑时应优先确认 `legacy/api.ts` 是否仍被其他模块依赖。
2. 文章正文同时支持 Markdown 和 HTML；HTML 必须经过 `DOMPurify`，不要绕过 `ContentBody` 直接渲染接口正文。
3. 受保护媒体和密码内容依赖请求头中的权限信息，不能使用普通 `<img src>` 或绕过 `Media`。
4. 页面切换时依赖 `revision` 重新加载的功能，不要随意删掉相关依赖，否则登录、解锁和跨标签页状态可能不会刷新。
5. `pathFor` 是前台 URL 的统一生成入口，新增内容类型时要同步处理它。
6. 页面专属代码应该留在页面模块内，只有确定存在跨模块复用关系时才上移到 `src/components`。
7. 修改菜单、站点配置或内容字段时，需要同时检查 `src/types/index.ts`、请求服务和对应页面的兼容处理。
