# React 博客当前实施报告

更新：2026-09-08。范围 `blog-web`；未暂存、提交、推送 Git，未修改旧静态站及其他实现目录。

## 当前实现

React 19 / TypeScript / Vite / React Router，生产构建完成。默认开发 5174，若端口已占用由 Vite 输出实际端口；API 默认 `/api`，代理剥离 `/api` 后转到 localhost:3000。可通过 `VITE_API_BASE_URL` 配置。

所有业务数据来自 AiBlog API：站点、菜单、统计、文章、分类、标签、相册/照片、追番、关于、说说、友链、朋友圈、收藏、音乐、评论。没有迁移旧作者资料、文章、照片、音乐或旧外部账号数据。

### 页面与路由

- 首页、文章、归档、分类/标签目录和关联文章、相册集/照片瀑布流、dailyPhoto/lovePic/wordScenery、追番、关于、说说、友链、朋友圈、收藏、音乐、留言、404。
- 兼容首页 `/page/N`，分类/标签 `/page/N`，归档 `/archives/:year/:month`（month 可省略）及其 `/page/N`。归档 year/month/page 发后台做整体筛选，不只筛当前页。
- 加载、空列表、失败重试、分页、锁定页面均有对应状态和操作。

### 公共交互

- 导航树和多级下拉、图标装饰、移动抽屉遮罩；ResizeObserver 测量 Logo/菜单/操作区总宽度，放不下时折叠，窗口扩大后恢复。
- 滚动隐藏导航、控制台、主题/侧栏/特效偏好、搜索及分页、随机文章、阅读进度、返回顶部、快捷键、路由过渡、通知。
- 右键图片复制/下载/新窗口、链接新窗口、页面链接和选中文字复制、音乐控制、主题切换、搜索、随机文章。
- 本地 QRCode 分享；OpenCC 简繁转换及动态文字更新/切回原文，含title/alt/placeholder属性（跳过代码、输入值及URL）。两库异步加载，不读取旧站业务服务。
- 背景设置支持纯色、原渐变、后台配置封面、恢复默认，偏好 24 小时有效；受限封面继续使用带认证的 managed blob，不存过期 blob 地址。背景窗口直接使用原WinBox0.2.82本地bundle+React portal，支持拖拽、缩放、最小化、最大化、还原、关闭，移动端使用原95%宽/90%高比例。
- 全局音乐播放器：真实详情音频、播放/暂停、上一首/下一首、列表、进度、音量、歌词；浏览器自动播放受限时用户可点播。

### 正文与内容页交互

- Markdown/GFM、DOMPurify 净化 HTML、代码复制/折叠、目录锚点与跟随高亮、图片灯箱、关联文章、评论登录/回复/审核提示。
- 文章宽度被容器约束，长 URL/标题折行，代码/表格局部横向滚动，图片不撑宽页面。
- 相册瀑布流、加载更多、灯箱翻页；追番状态切换；说说展开收起；友链分组；朋友圈刷新/换批。
- 关于页按原 HTML 重建头像和标签、介绍卡、Hello 指针遮罩动画、技能、经历、展示卡、社交与打赏弹窗。只使用后端支持的 skills/socials/experiences/cards/donationText/donationImage/birthYear。出生年份仅配置后渲染，使用原CountUp1.9.2 easeOutExpo/2秒/不分组，进入视口启动、支持减少动画及卸载清理。

### 认证与媒体

- 共用 JSON 编码 `SOY_token`；真实图形验证码登录、邮箱登录、注册、邮箱重置密码、session、退出、401 清理；storage/auth/access 事件刷新身份。
- 登录 gate、密码 gate；资源 token 按 kind:id 存 sessionStorage，不存密码，不以遮罩保护已下载正文。
- managed `/blog-media/:id` 经认证头和解锁头获取 blob；文章 Markdown/HTML 图片同样处理，卸载撤销 URL。

## 原站复用与已定位修复

原 CSS `css/index.css` 复制到 `public/theme/original.css`，只去除4个第三方背景 URL，留言装饰图本地复用；布局修正在 `src/styles.css`。已解析原代表页 HTML 并读取 main.js、tw_cn.js、右键、WinBox、aurora.js 和 npm 动画源码。

- 修复原绝对定位菜单与 React flex 冲突、浅色 Logo/按钮白字、侧栏旧 CSS 干扰、首页空配置大块空白。
- 手机首页多余顶空来自原 body-wrap space-between，已改 flex-start/main 承担余量。
- 显式代码/token 浅深色配色，计算最低对比度分别 5.85:1 和 6.86:1。
- 暗色星空从 anzhiyu-theme-static 1.0.1 的 dark.js 原算法本地适配，保留密度、颜色、彗星轨迹、淡入淡出；增加 RAF、resize、计时器清理。原 HTML 引用1.0.0，两个版本逐字一致性未证明。
- 原 bubble.js 只在 `.author-content.author-content-item.single` 存在时生效，旧193 HTML精确 class 搜索无匹配，未额外开启。
- 原 custom/aurora.js 实际是复制通知，不是 Aurora 背景动画。

## 已执行验证

- `npm test`：5 文件 / 15 项通过。覆盖身份/资源 grant/密码不存储、401清理、managed media、错误密码/login gate、HTML净化/代码折叠、导航测量折叠/恢复、关于数据/打赏弹窗、归档年/月/page请求、简繁动态更新/恢复/保留代码、图片下载失败拒绝、原星空生命周期清理、原WinBox bundle拖拽/最小化/最大化/还原/卸载、CountUp计数/清理、简繁允许属性转换且不改输入/URL/代码。
- `npm run build`：TypeScript 和 Vite 通过，355 modules。主 JS约480 KB（gzip153 KB）；二维码约26 KB异步 chunk；OpenCC词典约1.1 MB（gzip467 KB）异步 chunk，Vite存在单chunk大小提示。
- 根线程报告已对文章进行六宽度检查，无全页溢出，代码明暗可读；主线程仍执行其他页面和后台真实联调。本文不将未执行浏览器操作标成通过。

## 待验证项

1. 外部图片复制/下载依赖CORS和浏览器剪贴板权限，失败时明确提示并可新窗口保存；二维码实际扫码、图片复制权限需要真实浏览器验收。
2. 图形验证码求解、真实注册/邮件重置没有由本代理实际提交，依赖既有邮件配置和主线程授权验证。
3. 全部原动画逐帧一致尚未证明；原1.0.0/本地1.0.1 dark版本差异、手机触屏拖拽和所有内容页最终截图由主线程继续验收。原外部业务搜索/评论弹幕/音乐/统计账号不再调用，相关数据来自新API。
4. OpenCC词典采用懒加载，构建仍提示单独词典chunk超过500KB，不进入首屏主JS。

已修复的WinBox窗口形态、CountUp出生年份、简繁属性转换不再列为缺口。测试执行原本地WinBox代码，并非仅断言模拟函数。
