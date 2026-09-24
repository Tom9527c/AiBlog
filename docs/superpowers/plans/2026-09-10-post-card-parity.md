# Homepage article card parity correction

Continue the approved original-site reconstruction in this workspace. No Git staging/commits, old business-content import, or live database writes. Existing tables already store publishedAt, updatedAt, categoryId and tagIds.

- [x] Capture same-card original/current browser measurements: cover, info, badges, title, dates, tags, normal/hover/dark. Expanded to 9 widths including breakpoint boundaries.
- [x] Add failing regression tests for backend document-list category/tag summaries and globally latest published article (independent of pinned sort, pagination, drafts and scheduling). Add frontend tests for date formatting, rendered tags/latest/unread, read persistence and protected article behavior.
- [x] Enrich public document list using batched published taxonomy queries and a latest-publication query. Return only id/title/slug for related taxonomy; do not alter admin entity or database schema.
- [x] Extract PostCard into components/posts, restore original DOM and actual metadata. Mark visited only on a successfully readable detail page; retain login/password labels. Format card dates YYYY-MM-DD.
- [x] Replace estimated card spacing with computed original CSS values. Keep desktop 225px cover/174px info, mobile 200px cover/174px info; restore status/title layout, date/update row and tags below it. Restore 769–1200 single-column horizontal cards, desktop 49% card width, and original font fallback.
- [x] Run focused tests, all frontend tests/build, backend tests/build, and browser card-only verification; save images and exact limitations. No fake data written to DB. Independent review issue resolved and reviewed again.

Files: nest-admin/src/modules/blog/blog.service.ts + document-card tests; blog-web/src/types/index.ts, components/posts/PostCard.tsx, hooks/useReadPost.ts, features/_legacy/pages.tsx (Article implementation), components/index.tsx, styles/post-card-parity.css, focused tests; docs/verification/2026-09-10/post-card-check.cjs and post-card-verification.md.
