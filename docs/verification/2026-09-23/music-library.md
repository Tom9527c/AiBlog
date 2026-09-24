# Music library verification — 2026-09-23

Implemented approved durable QQ sync + reference listening room. No commits/deployment. Existing manual music preserved. Additive schema applied locally. User playlist 9766739035 previewed and applied through authenticated admin UI, 36 unique tracks now visible publicly.

Backend: 13 focused tests passed (import safety, duplicate/truncated upstream rejection, failed fetch preservation, apply/history/revision, expired preview, slow sync race, configured-empty library and public scope), Nest build passed.
Blog: 16 music tests passed across player+lyrics. Whole blog suite previously passed142 tests before final targeted NotAllowedError retry regression; latest player file15 tests passed plus build. Tests include rapid selection, volume during load, mobile-visible error, empty snapshot, loop/shuffle/seek/lyrics, teardown and direct retry without refetch.
Admin: 6 helper tests passed including near-limit export/import roundtrip; final typecheck and production build passed.
Existing warnings: admin UnoCSS select/local- icons; blog large bundle and existing Lightbox dynamic/static import warning.
Independent review findings (empty fallback/mobile errors/volume race/export size/gesture retry) fixed and scoped re-review approved.

Browser: authenticated admin generated 36-song preview, confirmed snapshot. Desktop1512x767: full gradient, left songs, right artwork, controls; white navigation; one audio element; no horizontal overflow. Real QQ first-track media request returned lyrics and empty audio URL; visible explanatory fallback and official QQ link. Mobile390x844: list/now-playing tabs, controls inside viewport, no horizontal overflow; real unavailable error visible on list and lyrics tabs. Temporary viewport restored.

Maintenance: docs/maintenance/music-library.md. Schema: scripts/music-library-migrate.cjs. Provider: qq-music.provider.ts. Public response adds configured boolean to distinguish absent library from intentionally empty snapshot.

## Follow-up: lyric tracking and slider appearance
User screenshots showed blue outlines on volume/seek input and highlighted lyric outside visible viewport. Root causes: global input:focus outline leaked into pointer-focused ranges; volume had no fill variable; lyric effect subtracted container.offsetTop from row.offsetTop although origins differed.

Fixed in Music.tsx/music.css: use viewport rect difference + scrollTop, ResizeObserver recentering, half-viewport lyric padding for first/last lines, explicit track/thumb styles with 20px hit area, white keyboard-only focus indicator, volume fill and previous nonzero mute restore. Reduced cover height on short displays to provide more lyric room.

Regression tests were red for wrong scroll target (-100 rather than150) and missing volume fill, then all18 music tests passed. Blog production build passed with preexisting bundle warnings. Browser real playback of 被神明写的歌, seek2:12: active line center error0px and white highlight. Clicking both range controls yields focus=true, focusVisible=false, outline none; volume fill changes50%. No deploy.

## Follow-up: manual tracks, music form and page settings
The user requested existing manual music alongside QQ tracks, superseding the configured-library-only display rule. Public loading now merges all readable published manual pages, excludes locked entries, uses collision-safe legacy identities and rechecks detail access before playback. A failure in either source preserves available tracks with a retry message. Focused review found the partial-failure issue before the fix; scoped re-review found no blocking issues afterward.

Music uses site.pageHeaders.music title/subtitle/cover and enabled setting, resolving background media through the shared Media component. Admin page settings moved to the music page heading with music-specific labels. Music editing hides body, summary and advanced slug fields while preserving existing stored values.

Browser verified 38 tracks (36 QQ + 2 manual), mixed-source label, resolved backdrop, top-level page settings and the simplified new-music drawer. The unsaved blank drawer was closed afterward. Latest validation: 22 music tests passed and blog production build passed; admin typecheck and production build passed, with previously recorded warnings. Tests cover merged identities/access, configured and disabled header settings, and retaining QQ tracks on manual-source failure. No deployment.

QQ login feasibility: inspected QQMusicApi login module supporting QR login, credential refresh and expiry checks. No login integration or actual authenticated playback was performed; anonymous playback remains in use. Maintenance documentation records the proposed server-only credential approach and its playback limits.

## Final follow-up: shared cover and canceled QQ login
Music now renders the shared PageHeader above the listening room when enabled; disabling it preserves the original title/subtitle layout. The blurred atmosphere uses the selected track cover, independent of the header artwork. Browser verified the 304px shared header, correct image stacking, matching current cover/background and no horizontal overflow. Music tests: 23 passed; blog build passed.

QQ login experimentation was canceled explicitly by the user after repeated real authorization failures and blank mobile authorization pages. All added login UI, routes, services, credential storage code, tests and MQTT dependency were removed. Music provider and media cache restored to anonymous behavior. Local experimental account table had no stored credentials, was removed, and migration additions were reverted. Pending in-memory sessions stopped with backend restart; temporary QR artifacts removed. Existing song library and manual music preserved. Browser confirmed no login entry remains. Backend music tests: 13 passed; backend build passed. Admin typecheck and build rerun after withdrawal. No deployment.

## Auto skip and floating player
User explicitly requested auto-advance on unplayable tracks, replacing the previous stop-on-error behavior. Shared useMusicPlayback handles missing URLs/request and media errors, 350ms skip delay, 20s initial load timeout, failed-track exclusion per chain, stop when exhausted, cancel/unmount invalidation and NotAllowedError direct gesture retry. Music and floating capsule both use merged QQ/manual tracks and existing access checks.

FloatingPlayer replaces old App inline Player: cover play/pause, song title, synchronized LRC line, expandable seek/volume/mode/queue panel, lyrics toggle and responsive theme colors. Browser discovered inherited nav-music overflow:hidden clipping panel; overridden to visible. Browser actual QQ playback of 被神明写的歌 confirmed currentTime advancing and live lyric; keyboard Home/PageUp seek updated currentTime to18.5s and matching lyric. Existing original music-route unmount behavior retained.

Real merged library contains 38 songs. Selecting unavailable 你在看孤独的风景 automatically advanced through unavailable entries to 风执意远走, with audio playing, currentTime advancing and synchronized lyrics. Final blog suite: 33 files, 154 tests passed. Final production build passed; existing Lightbox import and bundle-size warnings remain. Independent component review found no blocking issues. No deployment.
