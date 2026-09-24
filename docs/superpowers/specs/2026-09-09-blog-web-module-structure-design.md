# blog-web 模块化工程结构设计

## 目标

将 `blog-web/src` 从单层文件目录重组为按工程职责和业务域组织的模块结构，降低 `App.tsx`、`pages.tsx`、`common.tsx` 的职责密度，方便后续扩展和测试。

本次只进行结构重组，保持现有路由、接口请求、页面行为、视觉样式和后端数据契约不变。不新增业务功能，不删除仍被运行时使用的逻辑。

## 目标结构

```text
src/
  app/
    App.tsx
    router.tsx
    providers/
  components/
    layout/
    navigation/
    media/
    feedback/
    content/
  features/
    home/
    articles/
    taxonomy/
    comments/
    resources/
    albums/
    music/
    auth/
  services/
    api.ts
    content.ts
    media.ts
  hooks/
  types/
  utils/
  styles/
  main.tsx
```

## 模块边界

- `app/` 负责应用入口、全局上下文、布局装配和路由配置，不承载具体业务页面实现。
- `components/` 只放可跨业务复用的展示组件和交互组件。组件通过 props、context 或明确的服务函数获取数据。
- `features/` 按业务域组织页面及其仅在该业务域使用的组件。页面路由的 URL 和参数保持现状。
- `services/` 封装 API 基础请求、内容列表/详情请求、媒体地址和认证相关访问；保留现有请求路径和响应类型。
- `hooks/` 放跨业务复用的 React hooks，例如响应式导航和加载状态逻辑。
- `types/` 放共享 TypeScript 类型；业务域专用类型可以留在对应 feature 内。
- `utils/` 放纯函数，例如路径生成、日期格式化和安全 URL 处理。
- `styles/` 保留现有全局样式入口，迁移过程中不改变选择器和样式内容。

## 迁移策略

1. 先建立目录和稳定的公共出口，保留运行时行为。
2. 将 `api.ts`、`types.ts`、`originalStars.ts`、`useResponsiveNav.ts` 按职责迁移并更新引用。
3. 将 `common.tsx` 拆为布局、媒体、内容、反馈等公共组件；必要时通过 index 文件提供清晰导出。
4. 将 `pages.tsx` 按业务域拆成 feature 页面文件，保持原有导出语义和路由参数。
5. 将 `App.tsx` 拆出路由、全局布局、导航、搜索、播放器和站点上下文相关模块。
6. 将测试移动到对应模块附近或统一的测试目录，并只更新导入路径。
7. 删除旧的单层实现文件前，使用全仓库搜索确认没有残留引用。

迁移过程中每一小组文件后执行类型检查或测试，最后执行完整测试、类型检查和生产构建。

## 依赖方向

```text
app -> features/components/hooks/services/types/utils
features -> components/hooks/services/types/utils
components -> hooks/services/types/utils
services -> types/utils
hooks -> services/types/utils
types/utils -> no application modules
```

禁止 feature 之间通过深层相对路径互相依赖；跨业务共享逻辑必须提升到 `components`、`hooks`、`services` 或 `utils`。

## 验证标准

- `npm test` 通过；
- `npm run typecheck` 通过；
- `npm run build` 通过；
- 路由路径、菜单导航、认证、内容加载、媒体访问和弹窗交互的现有测试继续通过；
- 全仓库不再依赖已删除的单层旧文件路径；
- Git 工作区只包含本次结构重组相关变更，不自动提交。

## 不在本次范围内

- 不改变 API URL、请求参数、响应字段或鉴权策略；
- 不重新设计页面视觉效果；
- 不升级依赖或更换路由、状态管理方案；
- 不补充与结构迁移无关的新业务功能。
