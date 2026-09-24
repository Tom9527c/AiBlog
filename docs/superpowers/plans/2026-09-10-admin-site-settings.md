# 站点管理页面优化

目标：让现有站点设置更容易浏览、编辑和保存；继续使用既有 Site 字段、站点读写接口和上传鉴权。

设计：采用四个页签（基本信息、外观展示、首页卡片、社交链接），按用途分组卡片。独立的页内滚动区和常驻操作栏保障保存可达；展示已保存/未保存状态，撤销恢复最近一次成功加载或保存的快照。浅色与深色配色从 Naive UI 主题获取，窄屏使用单列。图片上传采用本站点页专用组件，支持预览、替换、移除与地址输入。

备选方案：仅调整原长表单间距成本低但仍难定位；左侧导航加实时整站预览占用宽度且超出单页设置优化范围。本次使用页签分组。

约束：不提交 Git；保留用户现有修改；复用已运行的服务；不修改数据库结构或共享布局；不扩展到其他管理页面。

- [x] 从截图和源码确认长表单与底部保存入口，追踪 GlobalContent / AdminLayout 的 flex 与滚动结构。浏览器尺寸测量受连接权限阻塞。
- [x] 重构 site/index.vue：分组页签、状态快照、独立加载/保存状态、撤销确认、离开提醒、失败重试。
- [x] 新建 site/modules/site-image-field.vue：沿用 mediaUrl/upload，校验后端支持的图片类型及 25 MB 上限；上传期间禁用保存并跟踪状态。
- [x] 首页卡片和社交链接支持添加、删除、上移/下移，保留接口数组顺序与最多 30 项限制。
- [ ] 浏览器验证桌面、窄屏和深色布局；验证编辑/撤销、保存失败保留内容、成功后状态、跨页签编辑、上传失败和离开提醒。写请求用浏览器拦截验证载荷，避免改变现有配置。
- [x] 对修改文件执行 ESLint、执行 typecheck 和 build:blog，记录既有错误与本次结果。


## 实现与验证记录

实际修改范围为 vue3-naive-admin/src/views/blog/site/：
- index.vue：四个页签、分组卡片、页内滚动、底部操作栏、排序/增删、离开提醒和主题变量。
- modules/site-image-field.vue：图片预览/替换/移除、类型/大小校验、上传状态和过期预览释放。
- modules/use-site-settings.ts：加载、保存、独立快照、错误保留、权限与上传并发保护。
- modules/use-site-settings.test.ts：4 个状态行为测试。

已执行：
- `node --import tsx --test src/views/blog/site/modules/use-site-settings.test.ts`：4/4 通过。
- `pnpm exec eslint src/views/blog/site`：检查本次文件。
- `pnpm typecheck`：通过。
- `pnpm build:blog`：通过。构建输出仍提示 select / local- 图标无法加载。
- `git diff --check`：通过；本次新增文件另经 ESLint 检查。
- `/private/tmp/site-settings-ui-qa.mjs`：在 jsdom 中挂载真实 Vue / Naive UI 组件，模拟 API 测试四个页签、跨页签编辑、卡片排序/添加、链接添加、失败保存保留编辑与载荷、成功保存状态、撤销、离开取消/确认、刷新提醒、非法/过大/失败/成功上传及过期预览竞争，全部通过。未向运行中的后端写入测试配置。

验证限制：Chrome 浏览器接口返回 `Codex auth token is unavailable`，桌面入口返回 `Computer Use permissions are not granted`；用户要求使用 ChatGPT for Chrome 后，本会话可调用工具中未提供已连接的 Chrome 控制入口。因此桌面/窄屏/深色的真实截图、DOM 尺寸与真实上传保存链路尚未验证，jsdom 和构建不代表视觉验证。

没有执行 Git 暂存、提交、推送或数据库修改。


## 本次视觉细化

沿用现有四个页签和站点 API。在当前工作区直接调整，以便已运行的开发服务热更新；不提交 Git。

- [ ] 统一页签、内容滚动区与保存栏为一个完整的设置面板，收紧表单间距，按实际内容宽度切换单列。
- [ ] 默认主题改为三种外观可视化单选；图片预览可点击上传，地址输入可展开，降低重复说明的密度。
- [ ] 新增卡片或链接后定位到新条目；失败保存自动回到提示处；保留已有撤销、排序、上传保护和权限控制。
- [ ] 执行已有状态测试、真实 Vue/Naive UI 组件挂载验证、定向 ESLint、typecheck 和 build:blog。浏览器连接恢复后再补视觉验证，否则明确说明限制。
