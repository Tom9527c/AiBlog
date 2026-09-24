# blog-web Module Structure Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Reorganize `blog-web/src` into clear application, shared component, service, hook, type, utility, style, and feature modules while preserving all current behavior.

**Architecture:** Keep the existing React Router route contract and API contract. Move code in dependency order: foundational services/types/utilities first, shared UI next, feature pages after that, and the app shell last. Use focused files with explicit exports and keep feature-specific code inside its feature directory.

**Tech Stack:** React 19, TypeScript 5.9, React Router 7, Vite 6, Vitest, Testing Library.

## Global Constraints

- Preserve existing route paths, URL parameters, API URLs, request fields, response fields, and authentication behavior.
- Preserve existing CSS selectors and visual behavior; move the global stylesheet without rewriting it.
- Do not add dependencies or change the routing/state-management approach.
- Do not stage, commit, or push Git changes.
- Run `npm test`, `npm run typecheck`, and `npm run build` before reporting completion.

## File map

- `src/app/`: application bootstrap, provider/context composition, route registration, global shell, search, player, and menu navigation.
- `src/components/`: reusable layout, navigation, media, feedback, and content components extracted from `common.tsx` and `App.tsx`.
- `src/features/`: route-level pages grouped by home, articles, taxonomy, comments, resources, albums, music, and auth.
- `src/services/`: API transport and domain request helpers.
- `src/hooks/`: shared hooks such as responsive navigation and loading state.
- `src/types/`: shared domain interfaces and unions.
- `src/utils/`: pure path/date/safe URL helpers.
- `src/styles/`: unchanged global CSS entry.
- `src/**/*.test.tsx`: tests colocated with the module they exercise.

### Task 1: Establish foundational modules

**Files:**
- Create: `blog-web/src/services/api.ts`, `blog-web/src/services/content.ts`, `blog-web/src/services/media.ts`
- Create: `blog-web/src/types/index.ts`
- Create: `blog-web/src/utils/path.ts`, `blog-web/src/utils/date.ts`, `blog-web/src/utils/url.ts`
- Create: `blog-web/src/hooks/useLoad.ts`, `blog-web/src/hooks/useResponsiveNav.ts`
- Modify: `blog-web/src/main.tsx`, all current imports of `api.ts`, `types.ts`, `useResponsiveNav.ts`
- Test: existing `access.test.tsx`, navigation tests

**Interfaces:**
- `services/api.ts` exports `api`, `list`, `detail`, `unlock`, `setToken`, `token`, `headers`, `mediaUrl`, and `safeUrl` compatibility exports during migration.
- `services/content.ts` exports typed list/detail helpers for `Content`, `Page`, and `Kind`.
- `types/index.ts` re-exports all current types without changing field names.
- `utils/path.ts` exports `pathFor`; `utils/date.ts` exports `date`; `utils/url.ts` exports `safeUrl` and `mediaUrl`.
- `hooks/useLoad.ts` exports the current loading-state hook API used by `Status` and pages.

- [ ] **Step 1: Copy foundational implementations into their target files without changing logic.**
- [ ] **Step 2: Add compatibility re-exports in the old files so existing tests remain runnable during migration.**
- [ ] **Step 3: Update imports in a small batch and run `npm test -- access.test.tsx navigation.test.tsx`.**
- [ ] **Step 4: Run `npm run typecheck` and fix only path/type errors caused by the move.**

### Task 2: Split shared components

**Files:**
- Create: `blog-web/src/components/layout/PageShell.tsx`, `blog-web/src/components/layout/SiteLayout.tsx`
- Create: `blog-web/src/components/navigation/MenuTree.tsx`, `blog-web/src/components/navigation/Search.tsx`
- Create: `blog-web/src/components/media/Media.tsx`, `blog-web/src/components/media/Lightbox.tsx`
- Create: `blog-web/src/components/feedback/Modal.tsx`, `blog-web/src/components/feedback/Status.tsx`, `blog-web/src/components/feedback/Pager.tsx`
- Create: `blog-web/src/components/content/PostCard.tsx`, `blog-web/src/components/content/ContentBody.tsx`, `blog-web/src/components/content/Gate.tsx`
- Modify: `blog-web/src/common.tsx` and its consumers
- Test: `about.test.tsx`, `extras.test.tsx`, `window.test.tsx`

**Interfaces:**
- Preserve each current named export and prop shape while moving implementation into one-responsibility files.
- Add `components/index.ts` only for stable shared exports; feature code imports from explicit component paths where clarity matters.

- [ ] **Step 1: Identify each export in `common.tsx` and map it to exactly one target component.**
- [ ] **Step 2: Move implementations and retain temporary re-exports from `common.tsx`.**
- [ ] **Step 3: Move `AboutCards` and `CountYear` into `components/content`, `FloatingWindow` into `components/layout`, and `extras.tsx` into `components/feedback` because these are the current shared UI consumers.**
- [ ] **Step 4: Run the affected tests and `npm run typecheck`.**
- [ ] **Step 5: Remove only duplicate implementations after repository-wide import search confirms target imports are active.**

### Task 3: Split route pages by feature

**Files:**
- Create: `blog-web/src/features/home/Home.tsx`, `blog-web/src/features/home/Aside.tsx`
- Create: `blog-web/src/features/articles/Article.tsx`, `blog-web/src/features/articles/Archives.tsx`
- Create: `blog-web/src/features/taxonomy/Taxonomy.tsx`
- Create: `blog-web/src/features/comments/Comments.tsx`
- Create: `blog-web/src/features/resources/ResourcePage.tsx`
- Create: `blog-web/src/features/albums/Albums.tsx`
- Create: `blog-web/src/features/music/Music.tsx`
- Create: `blog-web/src/features/auth/Auth.tsx`
- Create: `blog-web/src/features/NotFound.tsx`
- Modify: `blog-web/src/pages.tsx`, `blog-web/src/Auth.tsx`, feature tests

**Interfaces:**
- Export the same page component names currently imported by `App.tsx`.
- Preserve all route params, search params, list/detail calls, unlock flows, comment submission, and navigation paths.

- [ ] **Step 1: Split `pages.tsx` by top-level exported component and its directly owned helpers.**
- [ ] **Step 2: Keep shared helpers in `components` or `utils` when used by multiple features.**
- [ ] **Step 3: Add feature index files with explicit page exports.**
- [ ] **Step 4: Update tests to import feature modules and run all page tests.**
- [ ] **Step 5: Remove the old `pages.tsx` only after `rg 'from "./pages"|from "../pages"' blog-web/src` returns no runtime imports.**

### Task 4: Extract app shell and routing

**Files:**
- Create: `blog-web/src/app/App.tsx`, `blog-web/src/app/router.tsx`, `blog-web/src/app/BlogProvider.tsx`
- Create: `blog-web/src/app/navigation/Player.tsx`
- Modify: `blog-web/src/App.tsx`, `blog-web/src/main.tsx`, route imports

**Interfaces:**
- `app/router.tsx` exports the route tree consumed by `App`.
- `BlogProvider` exports the current context value and provider behavior.
- `App` remains the default application component used by `main.tsx`.

- [ ] **Step 1: Move provider initialization and site/session loading into `BlogProvider.tsx`.**
- [ ] **Step 2: Move route declarations into `router.tsx` using the existing paths and page components.**
- [ ] **Step 3: Move global navigation, search, player, and shell markup into focused files.**
- [ ] **Step 4: Replace the root `App.tsx` with a compatibility re-export or remove it after imports are updated.**
- [ ] **Step 5: Run navigation, access, window, and extras tests.**

### Task 5: Relocate styles, tests, and remove legacy files

**Files:**
- Create: `blog-web/src/styles/index.css`
- Modify: `blog-web/src/main.tsx`, all test imports
- Delete after search: `blog-web/src/common.tsx`, `blog-web/src/pages.tsx`, root duplicates of moved files

- [ ] **Step 1: Move `styles.css` unchanged and update the single stylesheet import.**
- [ ] **Step 2: Move tests beside their owning modules or into the corresponding feature directory without changing assertions.**
- [ ] **Step 3: Run `rg` over `blog-web/src` for old root imports and resolve every result.**
- [ ] **Step 4: Run `npm test`, `npm run typecheck`, and `npm run build`.**
- [ ] **Step 5: Inspect `git diff --stat` and `git status --short` to confirm only intended structural changes exist; do not commit.**

## Verification checklist

- `cd blog-web && npm test`
- `cd blog-web && npm run typecheck`
- `cd blog-web && npm run build`
- `rg -n 'from ["'"']\./(App|Auth|api|common|pages|types|extras|useResponsiveNav)' blog-web/src` returns no unintended legacy imports.
- Existing route and API behavior tests remain green.
