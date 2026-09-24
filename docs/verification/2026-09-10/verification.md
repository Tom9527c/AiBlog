# 导航与首页还原验收（2026-09-10）

本轮修复以 `/Users/tom/Downloads/Tom9527c.github.io-main` 的实际 HTML、主题 CSS、`custom/css/aurora.css` 和局部交互代码为依据。范围为公共导航和首页可见结构；不据此声明全站所有页面及动画已达到 1:1。

## 根因与修复

- 早先 `Home` 的 `homeCards` 空白页来自两个不同的 BlogContext；兼容入口统一引用 `components/context.ts`，保留该修复及回归测试。
- 默认前台菜单被初始化为 13 个平级入口，内容宽度导致导航折叠。现恢复“文章 / 友链 / 我的 / 关于”四组、原站子项和图标；配置仍保存在后台菜单表。
- 提取导航组件，恢复 60px 高度、居中菜单、横向胶囊下拉、标题悬浮首页图标、随机/搜索/控制台图标、滚动标题切换及原站吸顶渐变。手机使用随机、搜索、折叠菜单入口。
- 修复向上滚动不恢复菜单：React StrictMode 重跑 state updater 时会读取已经更新的 ref；改为在事件中捕获原滚动位置。回归测试先失败再通过。
- 菜单父项可同时保留真实链接、新窗口属性和独立展开按钮；纯分组使用空路径。键盘 ArrowDown/Escape 和手机展开状态与实际显示同步。
- 首页恢复原技术栈飘带、标题行高、推荐大卡与六张小卡切换、分类渐变/悬浮、窄屏横向轨道。修复隐藏 hero 的残留空白和推荐封面被 flex 压缩的问题。
- 还原 `aurora.css` 中隐藏分类行、文章卡片 25px 圆角、半透明背景、分类浮标、扫光，以及作者卡片 DOM 层级；真实标题、图片、分类、访问限制等仍来自 API。
- 修复导航迁移时保留合法角色授权的问题：只清理旧导航关联，重跑不会删除已有管理子权限角色的父菜单。只执行内存边界测试，未运行全量真实数据库迁移。

## 验证证据

| 验证 | 结果 |
| --- | --- |
| React `pnpm --dir blog-web test` | 9 个文件，25 项通过 |
| React `pnpm --dir blog-web build` | TypeScript 与 Vite 通过 |
| Nest 菜单服务定向测试 | 5 项通过 |
| 导航修复及权限迁移 Node 测试 | 9 项通过 |
| `pnpm --dir nest-admin build` | 通过 |
| `pnpm --dir vue3-naive-admin typecheck` | 通过 |
| Chrome 360 / 390 / 768 / 1024 / 1440 / 1920 | 无页面横向溢出，导航按宽度显示/折叠 |
| 浏览器交互 | 详见 `browser-checks.json`，无 pageerror |

浏览器脚本：`browser-check.cjs`。覆盖导航居中、键盘下拉、搜索、控制台、主题切换、推荐展开/恢复、滚动固定/恢复、手机抽屉跳转、随机文章。正常动画模式额外检查飘带时长及推荐键盘恢复；截图布局使用 reduced motion 固定几何状态。

桌面四组菜单宽度为 320.6875px，在 1024 / 1440 / 1920 下与视口中心误差小于 1px。390 下首页顶部区 y=135px、占高 175.1875px，与参考相同；1440 下首屏两块内容 x=46px / 778px，左栏宽720px，与参考相同。

## 截图

- `actual-1440.png`、`actual-390.png`：真实后台内容。
- `reference-1440.png`、`reference-390.png`：原站本地 DOM/CSS 布局基准。
- `fixture-actual-1440.png`、`fixture-reference-1440.png`：相同标题、分类和临时 SVG 封面的首屏对照。
- `fixture-actual-390.png`、`fixture-reference-390.png`：相同内容的手机轨道对照。
- `actual-dark.png`：实际深色主题。
- `responsive-measurements.json`、`fixture-measurements.json`：坐标和尺寸。

同内容对照仅拦截当前浏览器 API 响应，测试数据未写入数据库；没有迁移旧文章、旧个人配置或业务图片。

## 数据与限制

- 导航修复仅匹配未被编辑的默认树，修改前备份，保留旧记录 ID；冗余首页/朋友圈旧记录禁用保留。备份在 `nest-admin/.blog-backups/navigation-before-*.json`，当前公开结果见 `menus-after.json`。用户自定义菜单不被覆盖。
- 原站作者卡片背景 `https://sourcebucket.s3.bitiful.net/img/springBg.png` 在解除沙箱网络限制后仍返回 HTTP 403；未能取得原背景，现使用本地渐变作为可见替代。原站深色背景同域，也未本地化。
- 原站预览禁用其全局脚本及远程业务资源；加载原主题、Element UI、自定义 Aurora CSS 与本地装饰图标，因此是布局基准，不是全站原 JS 功能验收。原第三方服务、控制台整体布局、其他内容页及所有动画尚未逐项复核。
- API 的站名、说明、分类数量、封面及文章不同会使真实内容截图不同；相同内容对照用于区分结构差异。
- Vite 保留 OpenCC 繁简字库约 1.10MB chunk 警告，构建成功。
- 本轮没有 Git 暂存、提交或推送。
