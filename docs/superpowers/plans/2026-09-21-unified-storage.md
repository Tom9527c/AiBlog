# Unified storage implementation plan

Goal: One OSS_* configuration for general and blog uploads; all new files and existing blog media appear in file management, with private access, safe deletion and verified migration.

Architecture: A shared object driver uses the existing OssConfig. tool_storage records source, visibility, object key, backend profile, MIME and blog media ID. Each cloud file record encrypts a configuration snapshot using the existing security.jwtSecret, so changing the active configuration does not lose historical access or require a second user-maintained configuration. Blog media IDs remain stable. Local private data stays outside public.

Approved design: conversation of 2026-09-21; user explicitly authorized implementation.

Constraints: preserve existing work and URLs; no raw secrets returned; do not migrate data destructively; existing blog file directory remains readable; no additional user configuration. Execute inline, no subagents.

- [x] Object driver/profile tests: local private bytes never under public; local reads independent of current provider; reject unsafe keys; cloud PUT sets private ACL atomically; encrypted profiles round trip and do not leak secrets.
- [x] Implement object store and encrypted file profile services in tools/storage; register in StorageModule. General uploads and blog uploads use shared service. Compensate object writes if DB persistence fails.
- [x] Extend tool_storage; import historical blog metadata idempotently on bootstrap; keep existing files in place. Supply idempotent production schema migration script.
- [x] Storage list filters source/provider/visibility, returns blog references; authorized media preview endpoint; reject deletion of referenced media and protect raw filename deletion route. Preserve ordinary uploads and URLs.
- [x] Selected-file migration endpoint copies to current backend, verifies hash before updating pointer and retains source. Blog stable links continue; public files keep existing URLs.
- [x] Admin UI: unified file table with filters, authenticated image/audio/video preview, reference display, safe deletion, migration action. Retain legacy cloud inventory for preexisting OSS objects.
- [x] Verify backend tests/build, frontend focused tests/build/typecheck, local integration of upload, denied access, authenticated preview, reference protection and migration. Document deployment/backups and real OSS verification limits.

Verification: 59 backend unit tests, 20 local integration checks, backend build, admin vue-tsc and build passed. Browser confirmed all 27 records (25 blog), reference protection and a 1280×1024 protected image preview. Real cloud network testing remains dependent on actual credentials.
