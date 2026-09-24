# Album media management

Approved request: replace album body editor with integrated image/GIF/video management; remove separate photo navigation.

- Reuse photo records and parentId, preserving existing content and permissions. Album update permission also authorizes child photo operations. Existing photo-specific permissions continue working.
- Backend: infer managed photo media type from stored MIME; validate metadata; include type in public payload, including existing managed uploads. GIF stays image; MP4 is video.
- Admin: dedicated AlbumMediaManager with paginated cards, batch upload, retryable pending registrations, title/summary/sort/status editing, private previews and removal. New album saves first and remains open. Remove separate photos menu, page and generated route; preserve photo records/body data.
- Blog: render video previews and player, retain GIF/image lightbox and gated access; avoid requesting locked album photo list until unlocked; honor album layout.
- Verification: metadata/permission tests, image/video frontend tests, backend/admin/blog builds, local integration and browser checks. No destructive media migration.

Completed: editor replaced; menu migration applied locally; existing photo records preserved; 62 backend tests, 81 blog frontend tests, 32 integration checks passed. Browser verified existing album cards and an actual 6.96-second MP4 loaded with readyState=4 in the public player.
