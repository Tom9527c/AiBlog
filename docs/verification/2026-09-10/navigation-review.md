# 导航与菜单独立审查（2026-09-10）

按 `requesting-code-review` 的独立审查要求检查当前文件；根目录及 blog-web 无 Git 基线，子项目存在既有修改，因此本报告针对当前实现，不判断每一行的引入时间。初次审查只读；随后按主代理指派修复下述迁移问题并添加回归测试。未操作数据库或 Git 状态。

## 已确认的改进

- `MenuTree.tsx` 为带路径的父分组保留真实链接和新窗口设置，并提供独立展开按钮；空路径分组仍只负责展开。
- 移动端的 `aria-expanded` 与 `hidden` 来自相同状态，CSS 不再强制显示已收起内容。
- 初始导航分组、子项顺序和图标与参考站点一致；修复规划识别完整默认配置，已自定义的导航保持不变。
- 后端允许空路径分组，仍拒绝不安全地址及空外链；后台菜单编辑页支持对应配置。

## 发现及修复

### P2（已修复）— 重跑博客迁移会删除已正式分配的非超级管理员入口权限

位置：`nest-admin/scripts/blog-migrate.cjs:60`。

该 SQL 每次执行时都会删除所有非 `superadmin` 角色对 `/blog` 父菜单的关联，未区分旧外链遗留授权与后来通过角色管理正式配置的博客管理授权。

复现场景：给 `editor` 角色分配 `/blog`、`/blog/menus` 和 `blog:menus:list`，然后再次运行文档声明可重复执行的 `blog:migrate`。该角色的父菜单关联被删除，而子项仍保留。`getMenusByUserId` 只读取角色关联项，`generateRoutes` 不为孤立子项补建父路由，因此该角色整个博客后台入口及动态路由消失。

已运行当前 `generateRoutes` 的内存验证：包含父项时返回 `/blog → /blog/menus`，移除父项后返回 `[]`。此验证未操作数据库。

已修复：`blog-migration-permissions.cjs` 从迁移前的菜单及角色关联判断哪些角色只有旧父入口；已有内部管理子菜单或博客操作权限的角色保留父授权。迁移仅按角色和父菜单 ID 精确删除待清理关联。旧外链节点不构成管理授权，初始管理授权仍只授予启用的 `superadmin`，现有停用角色/菜单的管理关联不会因暂时停用而丢失。

新增测试先对原迁移执行，合法管理子授权和重复运行两项出现预期失败（父授权被删除）；实现后转为通过。测试运行真实迁移脚本及纯函数，数据库、环境文件和备份写入均由内存边界隔离，未执行真实数据库迁移。

## 执行的验证

- `blog-web`: `npm test -- src/tests/menu-tree.test.tsx src/tests/navigation.test.tsx`，7/7 通过。
- `nest-admin`: `node --test scripts/blog-navigation.test.cjs`，4/4 通过。
- `nest-admin`: `npm test -- --runInBand src/modules/blog/blog-menu.spec.ts`，5/5 通过。
- 修复后 `nest-admin`: `node --test scripts/blog-migration-permissions.test.cjs scripts/blog-navigation.test.cjs`，9/9 通过；覆盖旧导航角色、单独管理子菜单、单独操作权限、启用/停用超级管理员、重复运行、旧外链及非后代排除。
- `node --check scripts/blog-migrate.cjs` 和 `node --check scripts/blog-migration-permissions.cjs` 通过。
- 本地 Chrome / Playwright：桌面悬浮展开及移出关闭；390px 下移动菜单初始展开、点击收起、再次展开；每一步的可见性与 `aria-expanded` 一致，无页面运行时异常。
- 当前权限路由生成器的内存复现确认父授权删除后的路由丢失。

## 结论

两个既有导航回归及本次发现的迁移权限保留问题已修复，在本次范围内无未解决的重要正确性问题。未审查首页及 Aside，也未据此声明全站视觉完全一致。迁移验证使用内存数据库边界，实际 MySQL 环境尚未执行本次修复脚本。
