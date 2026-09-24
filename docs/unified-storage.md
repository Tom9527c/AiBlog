# 统一文件存储

博客与普通上传共用后端现有 `.env` / `.env.production` 中的 `OSS_TYPE`、`OSS_SECRET_ID`、`OSS_SECRET_KEY`、`OSS_BUCKET`、`OSS_REGION`、`OSS_DOMAIN`。无需第二套配置。配置通过进程启动读取，修改后重启后端。可选类型：`local`、`aliyun`、`qcloud`。

## 文件位置与管理

- 普通文件：本地使用 `nest-admin/public/upload/`，云端使用同一存储桶的 `upload/` 前缀，返回公开 URL。
- 博客文件：本地使用 `nest-admin/storage/blog-private/`，云端使用 `storage/blog-private/` 前缀，写入即设为私有。不能将这个目录挂到 Nginx 等静态服务中。
- 历史文件：继续读取 `nest-admin/.blog-private/`，原 `/blog-media/:id` 不变。
- 管理入口：系统工具 → 存储管理 → 文件管理。支持来源、存储位置、访问方式筛选，文件预览，查看引用位置、删除和单文件迁移。引用中的博客文件禁止删除。
- 原 OSS 存储页面仍用于查看旧的云端对象清单。改造前未入库的普通 OSS 文件不会自动导入；此次改造后的所有上传都会进入文件管理。

## 配置切换与迁移

切换配置只改变新上传的目标。每个文件保留原存储位置和加密的云配置快照，读取/删除使用文件自己的记录，旧配置不需要用户另写一份。云凭证本身仍须有效；若在云平台撤销旧密钥，需先完成旧文件迁移。

博客文件可在文件管理中点击“迁移”：使用当前唯一配置复制，读取目标并校验 SHA-256 后切换记录，保持博客媒体 ID 与引用地址不变。失败时保留原指向；同一位置再次迁移不重复复制。原文件保留，原位置及加密配置快照记录在 `tool_storage.previous_locations`，可供管理员恢复或后续清理备份。普通文件的公开 URL 不自动迁移。

管理列表与预览需要 `tool:storage:list`；删除需要 `tool:storage:delete`；迁移需要 `tool:storage:migrate`。超级管理员可直接使用；普通管理角色需分配相应权限。

云配置快照使用已有 `JWT_SECRET` 派生的密钥加密，数据库和该密钥需要一起备份。更换 JWT_SECRET 前必须重加密云配置快照（包括 previous_locations 中的历史快照），否则无法读取历史云文件。本地文件不依赖这个密钥。

## 部署

从旧版本升级、生产环境关闭自动同步时，在启动新后端前，从 `nest-admin` 目录运行：

```sh
NODE_ENV=production npm run storage:migrate
npm run build
npm run start:prod
```

脚本可重复运行，仅增加字段、补录博客文件、增加迁移权限菜单；不搬动或删除原文件。开发环境同样可以运行 `npm run storage:migrate`。启动时也会补录遗漏的历史博客媒体。

容器部署必须持久化 `public/upload/`、`storage/`、`.blog-private/` 和数据库，备份还需保留运行配置；当前 Docker 工作目录为 `/usr/src/app`。不要只备份数据库。

## 验证

```sh
npm test -- --runInBand
npm run test:storage
```

`test:storage` 需要运行中的本地后端、MySQL、Redis，要求 `OSS_TYPE=local`。使用临时账号与文件，验证上传入库、访问权限、预览、引用删除保护和历史文件迁移，结束后清理测试数据。云 SDK 的私有 ACL 和历史位置读取由单元测试验证；实际 OSS/COS 网络与账号权限需在配置真实云凭证后验证。
