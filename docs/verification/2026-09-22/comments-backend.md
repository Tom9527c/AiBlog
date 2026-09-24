# Comments backend verification — 2026-09-22

Implemented dedicated public and admin comments endpoints on the existing `blog_comment` table. No schema migration or synchronization was run. Guest submissions are pending; review state and reaction votes live in JSON metadata. Existing published comments without explicit review state remain approved; drafts remain pending.

## API contract

- `GET /blog/public/comments?targetKind=documents&targetId=123&page=1&pageSize=10&order=latest|oldest|popular`: `{items,total,commentCount,page,pageSize}`. `items` are root comments with `replies`; each has `id,title,body,format,parentId,createdAt,updatedAt,metadata,likes,dislikes,myVote`. `metadata` is public-only `targetKind,targetId,authorName,authorAvatar,authorWebsite,isOwner,browser,os,replyToName`.
- `POST /blog/public/comments`: `{body,parentId?,nickname?,email?,website?,metadata:{targetKind?,targetId?},honeypot?}` → `{id,status:'pending',createdAt}`. Guests require nickname; a targetless guestbook comment uses `{}`. Every submission, signed-in or guest, remains pending. Replying to a reply is stored under the root, with `metadata.replyToName` identifying the replied-to author.
- `POST /blog/public/comments/:id/reaction`: `{value:1|-1|0}` → `{likes,dislikes,myVote}`. A guest sends a stable `x-comment-visitor` UUID; server hashes it before persistence. Signed-in voters are keyed by hashed account ID. Reactions are transaction-locked, rate-limited, and limited to readable approved comments.
- `GET /blog/admin/comments?moderation=pending|approved|rejected&keyword=...&targetKind=...&page=1&pageSize=20`: `{items,total,page,pageSize,counts:{pending,approved,rejected}}`; items are full admin content rows plus `moderationStatus`. Keyword search covers body, author name, and private email. Pagination, moderation, and target filters are validated.
- `POST /blog/admin/comments/moderate`: `{ids:number[],status:'approved'|'rejected'|'pending',reason?:string}` → `{updated:number}`. Permission `blog:comments:update`, atomic transaction. A reply cannot be approved before its parent.
- `POST /blog/admin/comments/:id/reply`: `{body}` → approved comment row with server-derived admin name/avatar/owner flag and request-derived browser/OS. Permission `blog:comments:create`. Existing `DELETE /blog/admin/content/comments/:id` remains guarded by `blog:comments:delete`; a root with children returns 409 until its children are deleted.

Public comments and generic `/blog/public/content/comments` projections omit private email, voter identifiers, moderation reasons and author IDs. Generic detail/list also reject hidden targets and non-approved comments. Guest comments cannot claim ownership or inject metadata, and guest bodies cannot reference managed `/blog-media/:id` files. HTTP(S) websites are validated; OS/browser and attribution are computed by the server from request transport metadata.

## Environment badges and IP attribution

New comments store public, server-derived display strings in `metadata.browser`, `metadata.os`, and `metadata.location`. Browser and OS include the available full version (for example `Microsoft Edge 143.0.0.0` and `Windows 11`). Comment endpoints advertise `Accept-CH` for Chromium's platform version and full-version list; `Sec-CH-UA-Platform-Version` distinguishes Windows 11 when supplied, otherwise the user-agent fallback is used. Existing rows are not rewritten and may retain name-only badges.

Geography is resolved locally with `ip2region-ts` 2.0.1 and its bundled ip2region XDB dated 2025-08-09. The package is MIT licensed and derives its database from [lionsoul2014/ip2region](https://github.com/lionsoul2014/ip2region). No visitor IP is sent to an external service, persisted in comment metadata, or exposed publicly. Loopback/private addresses display `本地/内网`; an unresolved address displays `未知属地`; China results are reduced to their province-level label.

By default the server ignores forwarding headers, using the direct socket peer. Set `TRUST_PROXY_CIDRS` to an explicit comma-separated proxy allowlist (for example `127.0.0.1/32,10.20.0.0/16`) only when those peers are administrator-controlled reverse proxies. `X-Forwarded-For` is ignored unless the direct socket peer matches the allowlist, and the proxy chain is evaluated right-to-left to select the first untrusted client rather than a spoofable leftmost value. `X-Real-IP` is never trusted. Local development therefore normally reports `本地/内网`. Deployments without a trusted reverse proxy should leave the setting empty to prevent clients forging their province.

## Verification

- `NODE_ENV=development DB_SYNCHRONIZE=false DB_LOGGING=false pnpm exec jest --runInBand`: 15 suites, 151 tests passed. Includes transaction-bound managed-media ownership rejection, offline IP attribution, Chrome/Edge client-hint UA formatting, and spoof-resistant proxy-chain regressions.
- `NODE_ENV=development DB_SYNCHRONIZE=false DB_LOGGING=false pnpm build`: passed.
- `node scripts/blog-integration.cjs`: 66 checks passed, isolated records cleaned. Covered guest pending → approval → public, blank optional email, dedicated and generic private email exclusion, private email admin search, trusted admin reply identity/browser/OS, pending parent denial, approved nested reply, reaction/list-refresh identity, locked target access, and existing blog boundaries.

The original backend listener was replaced after confirming PID 59135 was `node dist/main.js` with `nest-admin` cwd. A concurrent Nest development listener subsequently held port 3000 (PID 63035), and the successful integration run used that listener. The extra standalone compiled process from exec session 72182 was verified not to be listening and stopped; the development listener was left running.

Known limitation: `popular` ordering uses reaction count in SQL (positive and negative votes both contribute to rank), so a highly disliked comment can appear high; the displayed likes/dislikes are accurate.
