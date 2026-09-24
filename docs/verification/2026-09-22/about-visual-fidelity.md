# About visual restoration — 2026-09-22

Restored the original site's card geometry and presentation while retaining the singleton admin editor and saved personal content. Reference: ../Tom9527c.github.io-main/about/index.html and css/index.css, plus the user's screenshots.

- At a 1280px browser viewport, page content starts at x=24 and is 1232px wide. Introduction/personality/game columns are 59%/39%; skills and careers are 50%/49%. Skills/careers measure 450px high, personality/photo 240px, motto/buff 200px, game/comics 300px, technology/music 400px, matching the reference measurements.
- Restored floating profile tags/status dot, rotating pursuit words, masked Hello pointer effect, 120px two-row skill ribbon with named details on hover/focus, career dots/artwork, separate map/facts, colored fact values, gradients, tilted comic panels and image hover effects. Skills repeat only configured entries; decorative repetitions are hidden from assistive technology.
- Added admin/server fields careersImage, mapDarkImage, birthYearText, with URL validation and restricted-media enforcement. Explicit empty values win. Existing public records receive missing career artwork/privacy-text defaults without replacing saved arrays or images. New empty records receive no personal artwork defaults.
- The original remote career illustration failed to load in the browser. Recreated its simple straw-hat illustration as local SVG at /theme/about/careers.svg, available in both frontends and editable in admin. This is a local recreation, not the original image file.

Validation:
- Blog full suite: 100 tests passed; focused about suite: 6 passed.
- Backend about/metadata/restricted-media suites: 32 passed, including save/read preservation and explicit-clear behavior.
- Blog and backend production builds passed. Admin vue-tsc passed.
- Browser checked 1280px desktop and 390px mobile. Mobile document width equals viewport width with no page overflow. Temporary viewport override reset.
- Keyboard focus on the skills detail region changes list opacity to 1 and ribbon opacity to 0. The detail region is focusable and scrollable.
- Admin UI confirmed new fields and /theme/about/careers.svg default. Existing saved record content was not modified during verification.
- Independent review's keyboard scrolling finding fixed. Existing build chunk-size warnings remain.
