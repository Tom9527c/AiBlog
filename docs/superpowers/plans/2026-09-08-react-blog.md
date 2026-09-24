# React 博客实施计划

> For agentic workers: 使用 subagent-driven-development 执行独立任务，主线程负责后端、接口整合与最终验收。用户要求不提交 Git；直接在已指定的 AiBlog 目录中实施。

**Goal:** 原站 React 重构、后台数据管理、统一用户和服务端内容访问控制完整联通。

**Architecture:** blog-web 使用 React/TypeScript/Vite；vue3-naive-admin 延续 Vue/Naive UI；nest-admin 新增独立 blog 模块和增量数据库脚本。接口以 docs/superpowers/plans/blog-api-contract.md 为共同契约。

**Tech Stack:** React、TypeScript、Vite、React Router、NestJS、TypeORM、MySQL、Redis。

## Global Constraints

- 不自动暂存、提交或推送 Git。
- 不迁移旧业务数据；只复用旧站装饰资源、样式及交互。
- 全部业务数据由 AiBlog API 管理，所有受限内容在后端校验。
- 保留原站页面、交互和动画，兼容 360、390、768、1024、1440、1920 宽度。

## Task 1: 数据库与 API

文件：nest-admin/src/modules/blog/{blog.entity,blog.dto,blog.service,blog-access.service,blog-public.controller,blog-admin.controller,blog.module}.ts；nest-admin/scripts/blog-migrate.cjs；修改 src/app.module.ts。

- [ ] 先写 blog-access.spec.ts，覆盖匿名、登录、错误/正确/过期/资源不匹配/版本变化密码凭证；使用实际 Argon2 和签名验证，不断言 mock。
- [ ] 运行 `npm test -- --runInBand blog-access`，确认缺失访问实现导致失败。
- [ ] 实现内容字段、导航、站点配置、各内容类型独立表；校验查询和写入字段。
- [ ] 实现列表安全投影、详情解锁、受限媒体、发布状态、统一认证及权限。
- [ ] 编写增量脚本：建 blog 表、备份已有博客菜单、升级父菜单、细分菜单和权限；重复执行不复制数据。
- [ ] 运行访问测试和 `npm run build`，检查每项测试结果。

## Task 2: React 博客端

文件：blog-web/package.json、vite.config.ts、src/{api,types,App}.tsx/ts、src/components、src/pages、src/styles、public/theme。

- [ ] 建立旧站页面/交互清单；复用 CSS/装饰资源，正文和个人数据不复制。
- [ ] 实现接口客户端、路由、站点数据、用户登录及解锁状态。
- [ ] 实现公共头尾、导航下拉、移动抽屉、控制台、主题、搜索、阅读进度、右键菜单、播放器与动画。
- [ ] 实现首页/文章/归档/分类/标签/相册/追番/关于/说说/友链/朋友圈/音乐/收藏/评论/404。
- [ ] 验证页面在加载、空列表、网络失败和受限内容状态下可操作；运行类型检查和构建。

## Task 3: Vue 后台管理

文件：vue3-naive-admin/src/service/api/blog.ts、src/views/blog/**、router/routes/index.ts、router/elegant/**、typings/elegant-router.d.ts、locales/langs/{zh-cn,en-us}.ts。

- [ ] 对照契约实现所有资源管理、筛选分页、编辑、保存、发布、访问规则和上传。
- [ ] 站点配置和树形前台菜单使用专用表单；文档支持编辑器及分类标签关联，相册支持照片关联。
- [ ] 删除原博客 iframe 和外链配置，新增全部管理页面路由和中英文标题。
- [ ] 执行 `pnpm typecheck` 与 `pnpm build`；分清新增和基线诊断。

## Task 4: 集成与验收

文件：docs/blog-setup.md、docs/blog-verification.md、开发/部署代理配置、验证脚本。

- [ ] 执行本地增量迁移两次，确认幂等；检查现有数据和新菜单。
- [ ] 启动三端服务，使用真实用户、真实 MySQL 创建隔离测试内容，验证 CRUD、公开/登录/密码边界并清理测试内容。
- [ ] 浏览器对照原站与 React；检查六个宽度、主题、导航、搜索、正文与解锁、图片灯箱、管理表单。
- [ ] 独立审查差异和访问控制，处理发现问题后重跑相关检查。
- [ ] 写入启动命令、部署配置和实际测试结果；不把未完成或未验证内容标成完成。
