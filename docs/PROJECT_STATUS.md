# Project status

## Current phase

**Phase 0: repository and safety foundation — in progress.**

The implementation plan and hybrid Cloudflare/personal-server direction were
approved by the project owner on 2026-07-10. No application runtime, model,
dataset, Cloudflare resource, or new host service has been installed or deployed.

## Gate 0 checklist

- [x] Implementation plan approved.
- [x] Hybrid Cloudflare/personal-server direction approved.
- [x] Transport will be selected through a measured spike.
- [x] Dependency license register created.
- [x] Data classification and retention policy created.
- [x] Development, staging, and pilot environments defined.
- [x] Secret-handling policy created.
- [x] Shared-host deployment and rollback policy created.
- [x] Repository ignore rules cover secrets, audio, datasets, model weights, and
  runtime databases.
- [x] Git repository initialized on the `main` branch.
- [ ] Documentation baseline committed.
- [ ] Off-site encrypted backup destination and key-custody model approved.
- [ ] Backup restoration tested after a destination is approved.

Gate 0 is not complete until every item is checked. Do not begin downloading
models or collecting Tiv recordings merely because the documentation exists.

## Immediate blockers requiring project-owner input

1. Choose the off-site encrypted backup destination and who controls the
   encryption key. R2 is the leading candidate, but no voice or contributor data
   will be uploaded without explicit approval.
2. If Git author identity is not already configured on the host, provide the
   name and email to use for repository commits.

## Next work after Gate 0

Create the evaluation rubric and smoke-test consent material, then benchmark one
license-approved ASR candidate and one license-approved TTS candidate on the
actual CPU-only host.
