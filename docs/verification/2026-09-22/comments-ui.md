# Shared comments and guestbook verification

Implemented shared React comments across guestbook, articles, essays, album detail and about. Guestbook has a responsive envelope introduction with desktop hover and touch/keyboard toggle, retaining the shared configured header. Comments show pink names, avatars/fallback, owner badge, dates, thread replies, OS/browser, votes, sort and refresh. Composer supports guest nickname, optional private email/website, safe Markdown preview, emoji and external image/GIF URLs. Submissions await moderation; errors preserve the draft. Location is not fabricated (no geographic provider configured).

Validation:
- Frontend full suite: 119/119 passed; then added account-upload avatar regression and ran shared comments 4/4; final frontend build passed.
- Browser (local public 5174 and admin8080): submitted guest without email -> pending acknowledgement and absent from public list -> admin approval -> visible public comment -> admin reply -> nested reply and owner badge. Exact test marker UI_COMMENT_CHECK_20260922, comment22, admin reply27. User added reply28 during work; the thread is deliberately preserved to avoid deleting user content.
- Browser at390px: document scrollWidth390, no horizontal overflow; vertical identity fields, nested replies and real loaded account avatars. Desktop1280px also no overflow.
- Avatar paths /upload resolve through API origin; failed images fall back to author initial. Images/GIF comments use links, no guest file-upload endpoint was introduced.
- Backend final verification: 14 suites / 139 tests, Nest build, 66 isolated integration checks passed. Admin source/selection tests 5/5, typecheck and build:blog passed.
- Admin browser verified pending/approved tabs, counts, review action, detail private-contact section, reply modal. Source links corrected to public app origin and authoritative target slug.
- Reference examined live at https://ayakasuki.com/comments/ and supplied screenshot. No fabricated comments or geo badges.
- Independent review issues (managed media references, stale preview) fixed and scoped rereview clean; see comments-review.md.

Existing build warnings remain: large frontend chunks and Lightbox mixed static/dynamic imports; admin existing UnoCSS select/local- icons warnings. Guest reaction keys are browser-persisted anonymous UUIDs with rate limits, not a strong one-person voting identity. Public popular order uses total reactions.
