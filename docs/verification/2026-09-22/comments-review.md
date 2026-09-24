# Comments review — 2026-09-22

Scope: current unified comments service, public/admin controllers, generic comment projection/access checks, shared React comments, and the in-progress Vue moderation screen. Read-only source review; no implementation files changed and no full suite run (coordinator handles verification). Requirements: `docs/superpowers/specs/2026-09-22-comments-design.md` and `docs/superpowers/plans/2026-09-22-comments.md`.

## Scoped follow-up review

Both original P2 findings below are **resolved in the current source**:

- `CommentsService.create` and `adminReply` now save through a transaction-scoped repository and call the existing permission-checking `mediaReferences` inside that same transaction. Unauthorized references propagate an error and roll back the save. The signed-in regression test verifies the transaction manager and rejection path.
- `createDetailSelection` now clears previous preview/source state and uses a generation token before accepting asynchronous render or source-lookup results. Selection changes, including clearing selection, invalidate old work; deferred-result tests cover reversed completion order.

The requested adjacent avatar change also looks correct: `/upload/` sources use the configured API base, other URLs still go through `useMedia`, failed images show the initial, and a source change remounts the failure state. The frontend test covers API URL mapping and image-error fallback.

No new actionable findings in this bounded rereview. This confirms source changes and inspected regression tests; tests were not independently rerun. Backend UA/email-filter/pagination work remains outside this follow-up scope.

## Original findings (resolved)

1. **P2 — Dedicated comment saves do not register managed-media references.** `nest-admin/src/modules/blog/comments.service.ts:83–87` and `:219–222` directly save comments/replies, bypassing the existing `BlogService.mediaReferences` transaction used by generic content saves. Signed-in comments deliberately allow `/blog-media/<id>`, and `CommentBody` explicitly renders them. An administrator can upload a new image, include `![image](/blog-media/<id>)` in a reply (or a signed-in comment later approved), and see it personally, but anonymous readers receive 403: `blog-media.service.ts:33–42` permits an unreferenced upload only to its uploader. Register references with existing ownership/permission validation in the same transaction as saving; do not merely create unchecked references, which would grant a new public access path to another content item's private media. Alternatively reject these references consistently if they are intentionally unsupported. Verify owner-upload → comment approval/reply → anonymous image read, plus unauthorized private-file reference rejection.

2. **P2 — An older asynchronous preview can overwrite the selected comment's preview.** `vue3-naive-admin/src/views/blog/comments/index.vue:89–95` starts `Vditor.md2html` on each selection and unconditionally assigns the result. Selecting comment B while A's render is still pending can leave A's body displayed beneath B's identity and action buttons when A resolves last. The list request already guards against stale results; apply the same generation/selected-id check to successful and fallback preview results, invalidating pending work when clearing selection. Verify two deferred renders resolved in reverse order display only B.

## Checks without additional findings

- Public submission constructs identity/moderation fields on the server and always saves pending, including authenticated readers.
- Public comment metadata allowlists omit contact email, moderation notes, and reaction voter identifiers; the generic projection uses the same privacy rule.
- Target/ancestor access checks include publication state and moderation; locked content metadata is not projected.
- Dedicated moderation/reply/admin-list endpoints check their matching existing comment permissions.
- Reaction read/write voter keys now agree for accounts; transactional row locks avoid lost concurrent vote updates.
- The previously reported blank optional email, invisible-root counts/pagination, guestbook filter, future ancestor, and generic metadata compatibility fixes were not reported again.

Limitations: no live moderation concurrency stress test or database media lifecycle integration was performed in this review. Frontend browser/testing evidence is owned by the coordinator.
