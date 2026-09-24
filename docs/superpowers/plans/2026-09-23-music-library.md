# Music library implementation plan
Spec: ../specs/2026-09-23-music-library-design.md
User approval: user explicitly requested implementation of agreed design and reference layout.

- [x] Backend: add adapter, strict snapshot validation, paginated fetch, diff, durable preview/state service, guarded admin/public routes, repeatable additive migration. Tests first for invalid source, partial/duplicate song lists, empty/large shrink preview, failed sync preservation, stale preview, imports and media scope.
- [x] Admin: implement library manager in music page with status, preview/apply, JSON upload/download and manual track edit. Keep existing ContentManager in manual tab. Match spec interfaces.
- [x] Blog: full-screen responsive Music route, independent audio lifecycle and request races, LRC parsing/highlighting, queue/mode/seek/volume, no double mini-player, honest unavailable state. Test queue/lyrics/error cases.
- [x] Integration: builds/typechecks/tests, apply additive schema, initialize user's playlist through service preview/apply, browser verify admin preview, blog desktop/mobile and playback fallback.
- [x] Review: independent code review, fix findings, maintainer guide and verification notes.

Ruling: continue in current shared working directories with targeted backups. Both nested repositories contain substantial existing changes and blog-web is not a git repository; moving into clean worktrees would omit required user work. No commits or deployment.
Ruling: isolate backend/admin/blog ownership and use subagent-driven-development for independent frontends while primary implements backend; implementation is already authorized.
