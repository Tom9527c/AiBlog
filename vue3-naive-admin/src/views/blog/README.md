# 博客管理页面

- 每个功能目录以 `index.vue` 为页面入口；仅供其他页面复用的 `content/` 以 `index.ts` 为入口。
- 页面专用 Vue 组件统一放入该功能的 `components/`，例如 `music/components/` 和 `about/components/`。
- 跨博客页面共用的组件放在 `blog/components/`；通用内容管理的编辑字段放在 `content/components/`。
- 数据、配置和测试保留在所属功能目录。新增字段先判断所属模块，再把专用字段放在对应功能的 `components/`。
