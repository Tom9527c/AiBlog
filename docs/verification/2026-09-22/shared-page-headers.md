# 统一页面头部与短文心情天气

## 实现
- 前台共用 components/page/PageHeader.tsx 与 page-header.css。PageShell、相册列表/详情、文章详情均接入。分类/标签/收藏/短文旧头部替换，去掉“关于我”按钮。
- 排除首页、首页分页和关于本人；其他支持路由对应 archives/articles/categories/tags/albums/bangumis/essays/links/collections/music/comments/notFound 设置。
- 各模块独立 enabled/title/subtitle/cover，默认开启；关闭显示普通标题。兼容旧 essayTitle/essaySubtitle/essayCover。详情使用实际内容标题，封面回退只使用可读内容。
- 后台 page-header-settings.vue 共用弹窗，接入各内容管理页和站点管理统一入口。文档管理可选归档/文章详情；站点管理可配置全部页面。
- site.pageHeaders 部分更新保留其他页面；普通站点保存不回传旧 pageHeaders，防止独立弹窗设置被覆盖。
- 心情/天气允许常用项及自定义，选填，可清空，最长50字符；公开投影/管理卡片与博客卡片显示，锁定内容不暴露。

## 验证
- 博客全量测试112项通过，包含共享组件开关、旧配置回退、首页/about排除、分类/标签/文章标题与权限、短文心情天气显示。
- 后端相关测试61项通过，包括配置校验、按页字段合并、心情天气格式验证。
- 管理站点状态测试7项通过，包括普通站点保存不会覆盖弹窗头部设置。
- 真实API回归55项通过，包含心情/天气保存和公开读取；隔离数据清理完成。
- 后端、博客构建及后台类型检查/构建通过（既有大包与UnoCSS图标警告）。
- 浏览器实际在即刻短文设置关闭头部并保存，刷新博客确认0个封面、仅1个普通h1；随后恢复开启，保留原有标题和描述。
- 参考素材未复制；继续使用用户已有站点封面。
- 相册页桌面与390px手机实测使用同一组件；手机封面358×260、左右16px，document.scrollWidth=390，仅1个h1，无横向溢出。
