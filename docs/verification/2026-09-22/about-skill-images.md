# Skill image fill and mobile detail disclosure

- Removed fixed 60px/18px image sizing: skill images now fill their 120px wall tiles and 32px detail icons using cover cropping and inherited corner radius.
- Removed the hover:none rule that forced the detail list below the image wall. Details are hidden by default on all devices and replace the wall in the same space when requested.
- Added an accessible toggle with expanded/control state, Escape-to-close and focus restoration. Desktop mouse entry over the image wall still reveals details; mobile users can tap the wall or toggle and return using the button.
- Browser verified 1280px desktop and 390px mobile: images measure 120x120 inside 120x120 tiles. Mobile details display:none initially; toggle changes to flex and back to none without changing the 450px card height. Document width remains 390px. Viewport reset after verification.
- Regression first failed on the old always-exposed detail region, then passed. About component/page suites: 8 passed. Blog production build passed; existing chunk size warning remains.
