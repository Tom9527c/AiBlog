# 音乐馆与可维护 QQ 歌单同步
用户已确认同步方案并指定 ayakasuki.com/music 的全屏播放器视觉。沿用博客字体导航，模糊蓝紫/暖色背景，左侧可滚动曲目，右侧封面及同步歌词，底部上一首/播放/下一首、进度、音量及播放模式；窄屏使用列表/歌词切换。音频受限显示提示及官方链接，不自动循环跳过失败歌曲。

独立 QQ adapter 获取歌单、歌词及平台允许的音源。仅访问固定 QQ 主机，不接受任意服务地址，不使用个人 Cookie。歌单分页拉齐、验证数量与唯一标识；异常不覆盖旧快照。手动同步，无后台定时任务。

独立 blog_music_library 单行 JSON 状态，revision 乐观并发控制，数据库行锁提交。保存 snapshot、pending preview（token/baseRevision/24h 有效期）、lastAttemptAt/lastSuccessAt/lastError/consecutiveFailures。抓取在事务外，预览写入前检查 revision。确认仅提交服务器保存的预览，过期/并发变更拒绝。每次应用另保存 previousSnapshot 便于回滚导出。公开接口不返回预览/错误/管理字段。

后台歌单链接、状态、同步预览（新增/移除/修改与数量骤降警告）、确认更新、JSON 导入导出、曲目编辑；编辑与导入同样先预览后确认。原手动音乐管理保留为另一标签。首次以用户提供的 9766739035 初始化，经预览确认流程载入；不修改已有手动内容。

## 数据接口
Track: {id:string, provider:'tencent'|'manual', mid?:string, title:string, artist:string, album:string, cover:string, duration:number, url:string, lyric:string, externalUrl:string}。
Snapshot: {version:1,title:string,source:{provider:'tencent'|'manual',id:string,url:string},tracks:Track[]}。
Preview: {token:string,baseRevision:number,createdAt:string,snapshot:Snapshot,diff:{added:Track[],removed:Track[],changed:Track[],suspicious:boolean}}。
State: {revision:number,snapshot:Snapshot|null,pending:Preview|null,lastAttemptAt:string|null,lastSuccessAt:string|null,lastError:string,consecutiveFailures:number}。
GET /blog/admin/music-library => State。
POST /blog/admin/music-library/preview {source:string,revision:number} => State。
POST /blog/admin/music-library/import {snapshot:Snapshot,revision:number} => State。
POST /blog/admin/music-library/apply {token:string,revision:number} => State。
GET /blog/public/music => Snapshot & {configured:boolean}（仅未配置时 configured=false，客户端回退原有音乐；主动清空不回退）。
GET /blog/public/music/tracks/:id/media => {url:string,lyric:string,message:string}。仅解析已发布快照中的曲目，短期缓存，歌词失败不影响音源；无可用音源返回空 url 和清晰提示。
