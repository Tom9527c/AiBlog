# Global restricted media validation toggle

- Added site setting restrictedMediaValidationEnabled, default false (including sites with no saved value). Admin: Site settings > Basic information > 受限内容媒体校验.
- Shared BlogService.save checks the setting for every blog resource kind, including existing album children and photos inheriting a parent album's access mode. When enabled, existing managed-media validation applies. When disabled, external media may be saved in restricted content.
- Password/login enforcement, normal URL/metadata validation, media ownership and managed-file authorization remain in place.
- Updated about/media helper text so it no longer claims media validation is always required. No personal content or access modes changed.

Verification:
- Backend settings/service/media/access/about tests: 70 passed, including all 13 resource kinds, old-site defaults, on/off save/read roundtrip, album children and inherited restrictions.
- Admin settings state tests: 6 passed. Admin typecheck passed. Backend and admin blog production builds passed (existing UnoCSS missing-icon warnings).
- Real API integration: 48 checks passed; global switch restored in finally; isolated data cleaned. Enabled mode rejected external album media, disabled mode accepted it; existing access checks remained passing.
- Browser confirmed the switch is present in Basic information and aria-checked=false.
