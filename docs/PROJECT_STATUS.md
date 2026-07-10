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
- [x] Documentation baseline committed.
- [x] R2 conditionally approved as the off-site encrypted backup destination;
  key-custody model keeps recovery material outside Cloudflare and Git.
- [x] Account R2 usage verified: approximately 18.2 MB stored and zero operations
  reported for the preceding 31 days at preflight time.
- [x] Private `bazaar-encrypted-backups` Standard bucket created with no public
  development URL or custom domain.
- [x] Five-GB project quota accepts safe uploads and rejects over-limit uploads.
- [x] Synthetic encrypted upload, download, integrity, restore, corruption
  detection, deletion, and empty-bucket verification completed.
- [ ] Project owner has copied the Restic recovery password to protected offline
  custody.
- [ ] Lowest practical Cloudflare budget alert configured and recipient tested.

Gate 0 is not complete until every item is checked. Do not begin downloading
models or collecting Tiv recordings merely because the documentation exists.

## Immediate operational blockers

1. Copy `/data/tiv-live/secrets/r2-restic-password` through a protected channel
   into project-owner offline custody; never paste it into chat or Git.
2. Configure the lowest practical Cloudflare budget alert and verify its email
   recipient. Alerts are informational and remain secondary to the project-side
   quota.

## Repository synchronization

The local `main` branch is connected to `saent-x/bazaar` using a dedicated,
repository-scoped SSH deploy key with write access. Local and remote history were
synchronized and verified on 2026-07-10.

## Next work after Gate 0

Create the evaluation rubric and smoke-test consent material, then benchmark one
license-approved ASR candidate and one license-approved TTS candidate on the
actual CPU-only host.
