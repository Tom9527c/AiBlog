# Full card backgrounds and mobile homepage — 2026-09-22

User requested full-bleed career/custom card artwork and clarified that the mobile homepage should show the configured recommendation cover next to categories, instead of individual article cards.

Changes:
- Career and custom images now use the existing managed background layer (cover sizing, centered cropping, clipped by card corners). Removed the bottom-offset career image and inset custom image. Text stays over the image with a contrast gradient; clearing an image restores the text-only card.
- At <=768px, categories occupy 40% of the homepage top row, and the configured recommendation card fills the remaining width. Article teaser cards and the desktop reveal button remain hidden in this row. The whole recommendation cover retains its configured link and carousel content.
- Entering the mobile breakpoint resets an open desktop recommendation panel so the cover does not remain inert/hidden.

Verification:
- Initial regression tests failed for career/custom background handling and desktop-to-mobile restoration; all passed after implementation.
- Blog suite: 24 files, 102 tests passed. Production build passed (existing chunk-size warning).
- Browser checks: 1280px desktop, 390px phone, 320px narrow phone. Career/custom artwork reaches all four card edges within the existing 1px border. Desktop career card 603.68x450 and custom card 1232x300; mobile career 320x400 and custom 320x300. No document horizontal overflow on either phone width.
- Mobile home shows the configured cover and zero visible top-row article teasers. No backend settings or saved personal data were changed.
