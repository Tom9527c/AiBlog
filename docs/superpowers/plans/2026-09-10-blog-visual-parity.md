# Blog navigation and homepage parity repair

> Execute the approved original-site design in this session with subagent-driven-development for isolated tasks and independent review. Do not commit Git changes.

**Goal:** Restore original navigation and visible homepage structure from Tom9527c.github.io-main while retaining backend-managed content.

**Architecture:** React owns state and routing; original DOM classes, assets and animation parameters supply the visual contract. Navigation hierarchy is stored in blog_menu, not fabricated in frontend rendering. Keep existing context fix.

**Constraints:** No old business-content import; no Git staging/commits; no edits to reference checkout. Preserve custom menu edits. Verify responsive layout in a real browser.

## Task 1: Navigation and menu configuration

- [x] Record current 13-row flat legacy menu response and original four-group DOM.
- [x] Add failing behavior tests for centered-menu overflow and dropdown interactions.
- [x] Extract MenuTree and BlogNavigation, restore 60px centered navigation, original icons, hover/focus capsule dropdowns, title/home hover, and original sticky title/menu scroll states. Move account access into existing console.
- [x] Add narrowly scoped, idempotent backend navigation repair: back up rows; upgrade only exact legacy defaults; preserve records and IDs; create editable groups; leave customized trees intact. Seed future installations with the same tree.
- [x] Run frontend tests and backend repair tests; check real menus API.

## Task 2: Visible homepage structure

- [x] Restore original header/content width alignment, announcement layout, hero proportions, category tile markup/hover, recommendation cover/text/button layering, and article grid sizing.
- [x] Reuse original decorative assets where locally available; retain backend-controlled hero image, cards, categories and text. No sample business records in database.
- [x] Isolate homepage CSS from navigation. Preserve loading/error/empty and restricted-content behavior.
- [x] Run relevant frontend tests and build.

## Task 3: Browser comparison and review

- [x] Serve reference read-only and compare same viewport with React, including actual backend content and temporary browser-only comparable fixtures.
- [x] Check widths 360, 390, 768, 1024, 1440, 1920; hover/focus dropdown, click routing, scrolling, mobile drawer, search, console, dark theme. Save screenshots and measurements under docs/verification/2026-09-10.
- [x] Review changes, fix actionable regressions, then report exact checks and remaining differences without claiming full-site parity.

## Final integration notes

- The reference also loads `custom/css/aurora.css`; the final browser baseline includes this and Element UI alongside the original theme CSS. Restored relevant custom navigation/card rules, including the hidden home category row.
- Fixed StrictMode scroll-direction regression with a failing-then-passing test; state updaters now capture the prior scroll position before ref mutation.
- Restored the original author-card structure and article-card hierarchy. Missing author-background resource returned HTTP 403; local gradient remains as an explicit fallback.
- Independent review found repeated migration removed deliberate role parent-menu grants; fixed with migration execution tests, without running that migration against the live database.
- Final scope and evidence: `docs/verification/2026-09-10/verification.md`. No Git staging or commits.
