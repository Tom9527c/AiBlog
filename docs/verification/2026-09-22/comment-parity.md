# Comment reference parity follow-up

Reference inspected live at ayakasuki.com/comments and user screenshots. User explicitly removed the input background-image requirement.

- Shared `CommentComposer` renders130px rounded textarea, lower-left emoji/image controls, count at lower right, identity fields and send below. No background image. Desktop fields share a row; narrow layouts stack fields.
- Reply button opens the composer immediately under the selected root/reply, before its descendants, with centered cancel. Main and inline text drafts are independent; guest identity shared. All submissions still require moderation. Email remains optional; no false required label or third-party auth logo.
- Scoped reference font,40px desktop avatars,40px byline,16px comment padding,16px body/32px line height, pink owner/name and per-reply light dashed separators. Guestbook enables existing configured aside with site visibility setting preserved.
- Environment badges use location/OS/browser icons with compact bordered rounded pills. Windows,Android,Apple,Edge,Chrome have matching visual symbols; other browsers use fallback compass. New backend values include real location and available versions, historical unavailable data is not fabricated.
- Browser1280px verified both root and nested reply placement, active pink focus border, two simultaneous main/inline forms.390px width verified scrollWidth390, main form326px and root inline302px, no overflow.
- Frontend29 suites121 tests passed; frontend build passed (existing large chunk / Lightbox import warnings). Regression verifies reply-to-reply correct parentId and retaining root draft, plus actual OS/version/region badge labels.
- Final targeted comment regression: 7/7 tests passed after adding preservation of inline drafts across refresh and protection against a pending reply response closing a newer reply. Frontend build passed after those changes.
- Backend final verification: 15 suites / 151 tests, build, and 66 isolated integration checks passed. Province lookup uses an offline IP database; public comments expose attribution only, never the raw IP. Local/private requests show 本地/内网; unresolved public IPv6 shows 未知属地. Historical missing metadata is left unchanged.
- Forwarded client addresses require explicit TRUST_PROXY_CIDRS and use the rightmost untrusted address; X-Real-IP is ignored. Browser/OS versions use available UA and client hints, including Windows 11 and Google Chrome full-version hints. Exact versions depend on what the visiting browser supplies.
