# 首页视觉一致性实施报告

## 变更文件

- `blog-web/src/features/_legacy/pages.tsx`
  - 按旧站恢复 `bbTimeList`、`swiper_container_card`、`bannerGroup`、`categoryGroup`、`topGroup`、`todayCard` 与 `categoryBar` 的关键 DOM 层级和类名。
  - 分类、即刻短文、推荐卡与文章继续读取现有公共 API / 站点配置，不引入旧站业务数据。
  - 桌面推荐封面继续使用 `site.homeCards`，窄屏推荐小卡复用当前文章列表；文章的访问限制标识仍由现有 `PostCard` 呈现。
  - 无 hero 图片时使用旧站装饰性技术栈飘带：原始图标已本地化到 `blog-web/public/theme/skills`，React 图形沿用旧站内嵌 SVG 结构；未以随机符号代替。
  - “更多推荐”恢复旧站交互：点击隐藏今日推荐并露出六张文章小卡，鼠标离开推荐区后恢复大卡。
  - 1200px 以下恢复旧站 175px 高的横向分类/推荐轨道，移动端不再保留被隐藏 hero 的空白高度。
  - 隐藏的今日推荐退出键盘焦点顺序；展开推荐后聚焦第一张文章卡，Escape 恢复今日推荐和按钮焦点。
- `blog-web/src/styles/home-parity.css`
  - 首页样式独立于导航，按旧站 340px 顶部区、600px 推荐区、三分类伸缩 hover、推荐蒙层/按钮、1200px 横向小卡与 768px 移动布局实现。
  - 首页宽度由共享 1400px 外层容器控制，避免额外内层 padding 造成双重缩进。
  - 高优先级覆盖继承的 `#recent-posts { display:flex }`，使 `.recent-post-list` 占满内容列并保持桌面双列、移动单列。
- `blog-web/src/features/home/Home.test.tsx`
  - 增加首页原始结构与后端内容映射回归测试，并已先验证测试因缺少旧站层级而失败，再完成实现使其通过。

## 验证结果

- `npm test`：8 个测试文件，24 个测试全部通过。
- `npm run typecheck`：通过。
- `npm run build`：通过；Vite 仅提示既有大 chunk 警告（最大约 1.10 MB），不影响构建产物生成。

## 限制与后续核验

- 本任务未修改共享样式入口；`home-parity.css` 需由集成人在 `index.css` 之后引入，确保覆盖既有首页规则。
- 未在本子任务中启动真实浏览器或后端，因此像素级对照、真实媒体加载和 360/390/768/1024/1440/1920 多视口检查留给总任务浏览器验收。
- 技术栈飘带使用旧站明确引用的装饰资源，不包含文章封面、相册或其他业务数据。
- 未执行 Git 暂存或提交。
