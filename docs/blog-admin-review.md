# Blog admin review

Read-only source review against the implemented Nest backend. No tests, builds, or browser runs were repeated.

1. **[P2] Album waterfall choice cannot be saved.** `vue3-naive-admin/src/views/blog/modules/content-manager.vue:415` submits `metadata.layout: 'masonry'`. The backend accepts only `waterfall`, `grid`, or `gallery` (`nest-admin/src/modules/blog/blog-metadata.ts:12`). Selecting the displayed 瀑布流 option causes both create and update to fail with 扩展字段 layout 格式错误. Use the backend enum and expose `grid` if all supported layouts must be editable.

2. **[P2] Comment target picker offers unsupported content types.** `vue3-naive-admin/src/views/blog/modules/content-manager.vue:476` offers every kind except comments. The backend only permits `documents`, `albums`, `essays`, and `about` (`nest-admin/src/modules/blog/blog-metadata.ts:17`; `blog.service.ts:195`). Selecting photos, music, tags, categories, bangumis, links, moments, or collections produces an unsavable form even when the entered ID exists. Align the picker with the actual allowed target set.

3. **[P2] Clearing comment target leaves a hidden ID that prevents saving.** At `vue3-naive-admin/src/views/blog/modules/content-manager.vue:475-481`, clearing `targetKind` hides its ID input without clearing `metadata.targetId`. The complete metadata object is submitted. Backend metadata normalization removes the null kind but retains the numeric ID, and `nest-admin/src/modules/blog/blog.service.ts:194-195` rejects it. Consequently, the advertised 留空为留言板 action fails when converting a targeted top-level comment to a guestbook entry or clearing a target chosen during creation. Clear both fields together.

4. **[P2] Blog permission buttons inherit an admin bypass the backend does not grant.** `vue3-naive-admin/src/views/blog/modules/content-manager.vue:26` uses the shared `hasAuth`; site and menus use the same helper. `vue3-naive-admin/src/hooks/business/auth.ts:11-12` grants every action to the `admin` role, whereas `nest-admin/src/modules/blog/blog-auth.service.ts:59-65` bypasses resource permissions only for `superadmin`. An admin-role account with blog list permission but no create/update/delete permission still sees those operations enabled and encounters 403 on submit. Apply blog permission checks consistent with the backend without implicitly broadening backend access.

## Follow-up verdict

All four findings are resolved by scoped source inspection on 2026-09-08:

- `content-manager.vue:420-422` now offers `waterfall`, `grid`, and `gallery`, matching the backend metadata allowlist.
- `content-manager.vue:482` limits comment targets to `documents`, `albums`, `essays`, and `about`.
- `content-manager.vue:200-204` clones outgoing metadata and deletes both target fields when no kind is selected, so a hidden ID is not submitted for a guestbook entry.
- `src/hooks/business/blog-auth.ts:6-8` requires login and either explicit permission or the `superadmin` role. Content, site, and menu managers all import and use this helper; the ordinary `admin` bypass is removed from blog controls.

No remaining findings in these four fixes. This verdict is source-only; no tests, builds, or browser verification were run in this follow-up.
