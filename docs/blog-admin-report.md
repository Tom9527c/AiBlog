# Vue 博客后台实施报告

2026-09-08，目录 `vue3-naive-admin`，没有暂存、提交或推送 Git。

## 已实现

- 15 个实际管理入口：site、menus、documents、categories、tags、albums、photos、bangumis、about、essays、links、moments、comments、collections、music。路由 `/blog/<resource>`、名称 `blog_<resource>`，已移除旧 blog_zym / blog_zym-href 静态配置、生成器配置、类型和国际化。
- 站点专用表单覆盖 API Site 全部字段，首页卡片和社交链接使用可增删、调整顺序的结构化表单。站点图片支持托管上传和登录态 blob 预览。
- 前台菜单使用树形列表、父级选择、图标、排序、启停、外链和新窗口表单。父级选择排除自身和后代；删除操作二次确认，后台关联校验失败保留错误提示。
- 13 类内容支持查询、状态和分组筛选、分页、详情后编辑、新增、保存、删除、排序、发布状态、日期、公开/登录/密码访问规则。文章提供分类和多标签选择；照片提供相册选择；追番提供状态/进度/总集数/评分；音乐提供歌手/歌词；关于本人提供技能/社交/经历/卡片/打赏；标签提供颜色；相册提供布局；评论提供目标内容和回复关联。
- Markdown 使用 Vditor 源码编辑模式，基础 Lute/i18n/icon 资源本地化；HTML 使用既有 TinyMCE。正文可通过托管上传后插入媒体。HTML 编辑器中的托管媒体转换为鉴权 blob，保存时转换回 `/blog-media/:id`。媒体字段可预览图片和音频。
- 使用现有 request / SOY token / RBAC。操作按钮按 `blog:<resource>:create/update/delete` 限制，服务器执行最终权限验证。上传 FormData 字段为 file。
- 编辑密码留空不提交 password；新建空 slug 不提交，使用服务端生成；日期提交 ISO 字符串；数字输入保留整数规则；管理员新增评论提供默认标题。

## 实际验证

- `pnpm typecheck`：通过，完整项目无 TypeScript 诊断；最后一次包含空 slug/评论标题修正。
- `pnpm build`：首次完整构建通过；输出原有 UnoCSS 图标 `select` / `local-` 无法加载警告。随后 HTML 媒体转换、本地编辑器资源和表单字段细节有更新，最终构建已再次启动（日志 `/tmp/blog-admin-build.log`，执行 session 1979）；交接时仍在运行，不能将此轮标为通过。
- `pnpm exec eslint src/views/blog src/service/api/blog.ts`：0 errors，8 条静态 inline-style warnings（响应式尺寸/媒体尺寸）。最后之后仅增加 DTO 空 slug/评论默认标题适配与英文父标题。
- `git diff --check`：通过。
- 旧 blog_zym 搜索：src/router、src/typings、src/locales、build/plugins/router.ts 无命中。

## 验收边界

本子任务没有使用浏览器，没有自行创建数据库业务样例；真实后台录入、菜单树操作、两种编辑器输入和前台展示的交互验收由主线程继续执行。不能把类型检查、构建作为全部 15 种 CRUD 的浏览器验收证据。
