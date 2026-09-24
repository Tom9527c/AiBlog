# AiBlog 本地运行与部署

## 安装与启动

使用 Node.js 20.19+ 和 pnpm 8.7+。三个项目保留自己的依赖管理；根目录脚本只使用 Node 内置模块，无须根目录 npm install。

```sh
npm --prefix blog-web install
pnpm --dir nest-admin install
pnpm --dir vue3-naive-admin install
npm --prefix nest-admin run blog:migrate
npm run dev
```

先根据 `nest-admin/.env.development` 配好 MySQL、Redis 和后端业务数据。`dev:api` 调用后端 `blog:dev`：本地关闭 TypeORM 自动同步及 SQL 日志，不会自动初始化或迁移数据库。现有账号、权限和博客菜单仍由后端数据库控制。

`blog:migrate` 是增量迁移，可重复执行；创建博客表、升级“博客管理”菜单并初始化前台导航，不导入旧博客业务数据。执行前会把原博客菜单及角色关联保存到 `nest-admin/.blog-backups/`。新管理权限默认只授予启用的 `superadmin`，其他角色请在系统角色管理中按需分配各资源的查询/新增/编辑/删除权限。初次使用依次配置站点、前台菜单、分类/标签，再发布文档或其他内容。

图片、音视频可通过管理表单上传。受限内容必须使用博客托管媒体；文件保存在 `nest-admin/.blog-private/`，部署和备份时需要同时保留数据库与该目录。将已有公开相册改为登录/密码可见前，需把其中的外部图片换成托管上传。

统一访问：

- 博客：`http://localhost:5173/`
- 管理后台：`http://localhost:5173/admin/`
- API：`http://localhost:5173/api/`，网关去掉 `/api` 后转发至 Nest 3000。

根目录 `npm run dev` 会启动四个进程，Ctrl+C 停止本次创建的进程。任何目标端口已占用时会在启动前报错，不会终止已有服务。已有服务运行时，只补启动缺少的服务：

```sh
npm run dev:api      # Nest 3000
npm run dev:blog     # React Vite 5174
npm run dev:admin    # Vue Vite 8080，独立 blog mode
npm run dev:gateway # 同源入口 5173，支持 Vite HMR WebSocket
```

后台 `.env.blog` 指定 `/admin/` 路由与资源基址、`/api` 接口基址及 `SOY_` 存储前缀。原来的 `dev`、`dev:prod`、`build`、`build:test` 模式继续可用。建议联调时始终通过 5173 访问两套页面，不要在 5174/8080 页面完成登录：localStorage 按协议、主机、端口隔离，后台与博客只有在同一个 origin 才能共享 `SOY_token`。`localhost` 与 `127.0.0.1` 也应统一使用。前端共用 token 不代替后端的权限校验。

## 验证与构建

```sh
npm run test:gateway
npm --prefix blog-web test
npm --prefix nest-admin test -- --runInBand blog
npm --prefix nest-admin run blog:test # 需要运行中的 Nest、MySQL 和 Redis；自动清理测试数据
pnpm --dir vue3-naive-admin typecheck
npm run build
npm --prefix nest-admin run build
```

`npm run build` 输出 `blog-web/dist` 与 `vue3-naive-admin/dist`；后者使用 `build:blog`。后端按现有项目的构建、数据库迁移和生产启动流程部署，不要用开发启动器跑生产。

## Nginx 同源部署

将博客 dist 内容复制至 `/srv/aiblog/public/`，将后台 dist 内容复制至 `/srv/aiblog/public/admin/`，保留后台 `tinymce-resource` 目录。参考 `deploy/nginx-blog.conf` 替换域名及磁盘路径后，用 `nginx -t` 检查并加载；生产站点应在 HTTPS 下访问。

配置将 `/api/` 转发到 `127.0.0.1:3000/`，并分别为博客和后台深链接回退至自己的 index.html。HTML 不长期缓存，哈希资源长期缓存，API 响应禁止缓存。两套前端部署在相同协议、域名及端口，才能沿用本地的登录共享方式。示例仅为 HTTP server 块，证书与 TLS server 按部署环境配置。
