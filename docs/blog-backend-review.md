# Blog backend review — 2026-09-08

Read-only code review against the approved React blog specification and API contract. No application files changed, no tests rerun, no Git operations. Findings below are source-confirmed execution paths; reproduction scenarios are proposed regression checks, not claims of executed tests. The publication timestamp fix was present during review.

## Actionable findings

### P1 — Migration grants full management permissions to roles that only had navigation/read access

**Location:** `nest-admin/scripts/blog-migrate.cjs:46-53`, `:60-66` (source query `:15-16`).

`oldRoles` includes associations for every existing blog menu, including permission nodes on subsequent runs. Their union becomes the grant list for every resource and every action. A role that could merely see the old external blog link receives document/site/media management privileges; on a later migration run, a deliberately read-only blog role receives create/update/delete for all resources. Thus the migration is data-preserving but is not permission-preserving or safely repeatable.

**Required fix:** Grant new management permissions only to explicitly authorized management roles, preserving all other existing associations without broadening them. Do not infer management authorization from an old navigation link or any one existing blog permission. Verify rerunning after configuring a list-only role leaves that role list-only.

**Category:** Approved spec security/RBAC and repeatable migration compliance.

### P1 — Disabled role/menu permissions remain effective in admin authorization

**Location:** `nest-admin/src/modules/blog/blog-auth.service.ts:52-56`.

Although `identify` reloads only enabled role names, `permit` calls existing `AuthService.getPermissions(uid)`. Its implementation at `src/modules/system/menu/menu.service.ts:293-308` obtains all role IDs from `src/modules/system/role/role.service.ts:135-141` and filters neither role status nor menu status. Disabling a non-superadmin role (or its permission menu) therefore does not revoke its blog management API permissions while the account/token remains valid. A disabled superadmin role with explicit seeded permissions can similarly retain those permissions through the fallback.

**Required fix:** Resolve blog permissions through enabled roles AND enabled permission menus (as upload already does), or fix the shared permission resolver after assessing other consumers. Check list and write endpoints after role and menu disablement.

**Category:** Approved spec current-role authorization compliance.

### P1 — Arbitrary media references allow cross-resource private media disclosure

**Location:** `nest-admin/src/modules/blog/blog.service.ts:211-215`; authorization consequence at `blog-media.service.ts:42-46`.

Reference creation extracts every `/blog-media/<id>` from arbitrary content without checking that the editor owns or is authorized to use that file. Media delivery grants access if ANY reference is readable. A user who only has essays create/update can place a guessed private document/album media ID in a published public essay; the new essay reference makes that private file anonymously downloadable. Even placing it in unused metadata creates a reference. Conversely, a draft reference can grant an editor with that resource's list permission access to media belonging to a different restricted resource.

**Required fix:** Authorize every media attachment against uploader ownership or existing legitimate source-resource management rights before committing references; reject unknown IDs. Define reuse policy explicitly so a newly invented reference cannot establish its own authorization. Check a limited essays editor cannot attach/read a documents-only administrator's private upload.

**Category:** Approved spec private media and resource RBAC compliance.

### P2 — Making an album restricted does not enforce mediated URLs on its existing photos

**Location:** `nest-admin/src/modules/blog/blog.service.ts:160-166`.

The inherited restriction check runs only while saving a photo. Create a public album with a photo whose URL is permanently public, then change the album access mode to password/login: the album save succeeds without checking its children. Its protected photos still rely on public URLs, violating the promised inherited private media boundary. The same URL remains directly available to anyone who previously obtained it.

**Required fix:** Before tightening an album's access mode, inspect every child cover/URL/body and reject the change until external media is replaced by managed uploads, or perform an explicit storage migration. Treat existing public exposure honestly; an old third-party URL cannot be revoked by frontend/API hiding.

**Category:** Approved spec album inheritance/media compliance.

### P2 — Published replies do not inherit parent-comment moderation or access state

**Location:** `nest-admin/src/modules/blog/blog.service.ts:87-90`, parent validation `:187-190`.

Comment readability checks only its own state and target resource, never its parent comment. After a published parent is hidden (draft) or given a stricter access rule, its published replies remain available by list/detail and their media references remain readable. Reply creation likewise allows replying to a hidden parent if the caller knows its ID, since parent validation checks only nesting and target consistency.

**Required fix:** Apply parent-comment publication/access checks during reads and public reply creation. Use the existing recursion-cycle guard. Verify hiding a parent removes its replies from public output, and direct reply/media reads cannot bypass the parent state.

**Category:** Moderation/access consistency; clarify whether standalone replies to hidden parents are an intentional product exception before accepting it.

### P2 — Resource metadata is not structurally validated

**Location:** `nest-admin/src/modules/blog/blog.dto.ts:34` (`metadata`); `blog.service.ts:150`.

Except comment targets, metadata accepts any object up to a serialized size limit. The declared contract's bangumi state/progress, about skills/socials, music artist/lyrics, and photo dimensions have no field/type/URL validation. Inputs such as `metadata.skills: {}` or `metadata.socials: [null]` are persisted and returned even though clients expect arrays of typed values. This conflicts with the explicit requirement for structurally validated JSON and permits malformed records to break public page rendering.

**Required fix:** Add kind-specific metadata validation, with partial-update semantics decided explicitly, validating nested URLs and array limits as well as primitive types.

**Category:** Approved spec JSON validation/API contract compliance.

### P2 — Integration list projection assertion passes on an empty result

**Location:** `nest-admin/scripts/blog-integration.cjs:49-50`.

The test searches `keyword=run`, but generated test documents put `run` only in their slug. Search intentionally checks title/summary only, so this returns no test documents; `items.every(...)` passes vacuously. The current integration therefore does not establish the named list/body/password projection guarantee.

**Required fix:** Put a unique run marker in a test title or query by a known title; assert the expected fixture IDs are present before asserting forbidden fields are absent. Also add regressions for the authorization findings above. Do not describe existing checks as coverage for revoked roles, banned users, or cross-resource media attachment.

**Category:** Verification quality.

## Reviewed paths with no additional finding

- Optional authentication explicitly verifies JWT/access-token validity, blacklist, current account status/forced-offline state, and single-device state; it does not trust `@Public` as proof of authentication. Invalid supplied authorization is rejected rather than silently treated as logged in.
- Unlock tokens are HMAC authenticated, kind/ID/version/expiry scoped, and Argon2 verifies stored passwords. Access-mode or password changes bump versions. Unlock endpoint uses throttling.
- Public detail excludes drafts/future content. List search is title/explicit summary only. Locked projections remove body, URL, cover, metadata and author ID; hashes and access versions are removed from both public/admin projections.
- Photo access checks parent albums, and comment access checks target resources. Protected content and media routes use private/no-store caching.
- Migration creates blog tables without resetting user/business tables, saves menu/role backups before mutation, preserves existing blog site/content, and seeds frontend navigation only when empty. The role expansion finding above remains a blocker despite those protections.

No build, policy tests, integration run, database mutation, browser validation, or exploit execution was performed as part of this review.

## Scoped re-review after fixes

Source re-reviewed after the root agent's corrections. The root reports 9 unit checks and 40 real HTTP/MySQL/Redis checks passing, isolated fixtures cleaned, and 219 excess generated role grants restored from the earliest backup. Those execution/database results were not independently rerun or queried in this review.

**Addressed in current source:** migration now bootstraps only active superadministrators; permission resolution checks enabled roles, permission nodes and the two ancestors in the generated blog hierarchy; media attachment verifies source-resource update permissions for existing references and rejects unknown files; comment reads recursively check parent visibility; kind-specific metadata rules now validate nested values; integration fixtures have searchable run titles and a nonempty result assertion. Explicit database environment values now take precedence because dotenv uses `override: false`. No remaining finding on those specific corrected paths, subject to the residual cases below.

### Residual P1 — Site editors can claim another user's orphan private upload

**Current location:** `nest-admin/src/modules/blog/blog.service.ts:233`.

The ownership check explicitly exempts anyone with `blog:site:update`. A site-only editor can guess another uploader's still-unreferenced media ID and set it as site logo/hero; this creates a site reference and makes it public. Site configuration permission is not permission to access every other administrator's pending uploads. The attached-media exploit is fixed, but this orphan variant remains. Require ownership for unreferenced files; if superadministrator override is desired, check that role explicitly rather than granting the exception to every site editor.

**Category:** Resource authorization/private upload boundary.

### Residual P2 — Album transition checks omit existing child body media

**Current location:** `nest-admin/src/modules/blog/blog.service.ts:170-174`, compare photo-save body check `:181`.

An existing public photo can have a managed URL/cover plus an external image in its Markdown/HTML body. Restricting its album passes because only cover/URL are inspected; saving that same photo under the restricted album would reject its body. Reuse the complete restricted-media validation for each child before changing album access. This closes the original transition finding fully rather than only its cover/URL variants.

**Category:** Private media consistency/spec compliance.

### Residual P2 — Public reply creation still accepts inaccessible parents

**Current location:** `nest-admin/src/modules/blog/blog-public.controller.ts:54`; `blog.service.ts` `validateComment` parent branch.

Read inheritance is fixed, but an authenticated user can still create a pending reply to a draft/password-locked parent by guessing its ID and matching its target. `validateComment` checks target consistency and nesting only. Before saving a public reply, call `readable('comments', parent, req)` and reject inaccessible parents. This is a moderation workflow gap, not a remaining reply-body read leak.

**Verdict:** The fixes materially address the original RBAC and published-media exposure paths. Do not close the backend security review while the orphan-upload exception remains. The two P2 residuals are narrow completion gaps in touched validation paths. The reported passing tests are useful evidence but do not cover these residual scenarios.

## Final scoped verification

The orphan ownership exception is removed (`blog.service.ts:229`); another uploader's unreferenced file cannot be attached even by a site editor. Public reply creation now verifies the parent is readable before saving (`blog-public.controller.ts:44`). Both residual findings are closed by source inspection. Album restriction changes now apply the same media validator to every existing photo (`blog.service.ts:173`), so the missing-child-body call is corrected.

One narrow **P2** validation gap remains in `blog-private-media.ts:12-18`: shortcut Markdown reference images are not checked. For example, `![secret]` followed by a blank line and `[secret]: https://example.com/private.png` is valid Markdown image syntax, but matches neither the inline-image expression nor the explicit/collapsed-reference expression. A restricted body or album transition containing that image still passes. Validate shortcut references too (preferably using the same Markdown parser semantics as rendering).

Root reports 15 unit tests and 43 real HTTP/database checks passing, including the three previous residual scenarios. This reviewer did not rerun them. Current verdict: original security findings closed; one concrete P2 body-media syntax gap remains before claiming complete private-body media validation.

## Root verification closure

The remaining Markdown image syntax gap was fixed using `markdown-it` token parsing instead of incomplete image-reference regular expressions. Shortcut references and nested linked images now go through the same managed-media validation. The corresponding regression tests failed before the parser replacement and pass afterward. Final root execution: 17 backend tests across 3 suites and Nest build passed; 46 real HTTP/MySQL/Redis checks passed, including the new archive year/month query checks. Isolated integration fixtures were cleaned. This closure records root execution, not an additional independent reviewer run.
