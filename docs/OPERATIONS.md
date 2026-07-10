# Shared-host operations and rollback

## Host safety

The personal server already runs Caddy, DNS, SSH, radio API/worker/playout, and
streaming services. Tiv Live work must not alter or restart those services as a
side effect of development.

Before installing or starting a Tiv Live service:

- Record the package, files, ports, users, directories, and service units it
  will add or change.
- Confirm port ownership and avoid TCP/UDP 443 conflicts with Caddy.
- Run as a dedicated unprivileged account.
- Put writable state under `/data/tiv-live/<environment>`.
- Set CPU, memory, process, and restart limits.
- Back up any configuration file before an approved modification.
- Define health checks and the exact rollback command.

## Change record template

```text
Change:
Purpose:
Environment:
Files/packages/services affected:
Ports affected:
Data migration:
Pre-change health evidence:
Deployment commands:
Post-change verification:
Rollback trigger:
Rollback commands:
Data restoration required:
Owner/date:
```

## Default rollback

Until concrete services exist, the default rollback contract is:

1. Stop and disable only the new Tiv Live unit.
2. Restore the previous Tiv Live configuration from its versioned or protected
   copy.
3. Remove or deactivate the new route without restarting unrelated services.
4. Verify Caddy, DNS, radio API, worker, playout, Icecast, and SSH health.
5. Preserve diagnostic logs while ensuring they contain no sensitive voice data.

Every implemented service must replace this generic contract with exact tested
commands in `SETUP.md` before staging use.

## Backups

RAID 1 protects against one disk failure but is not a backup. Cloudflare R2 is
conditionally approved as the off-site destination under the no-charge and
privacy controls in `docs/research/R2_BACKUP.md`.

No off-site backup is active. Initial testing must use synthetic data. Real voice
or contributor data cannot be uploaded until consent permits encrypted off-site
processing, retention and deletion propagation are defined, and restoration is
tested.

The project owner controls the offline recovery key. Any runtime key must live in
a protected host credential file outside Cloudflare and the repository.

The private Standard bucket is `bazaar-encrypted-backups`. Restic 0.18.1 is the
approved client-side encryption and integrity tool. The quota preflight is
`infra/backup/check-r2-quota.sh`; it must pass immediately before every upload.
Backup objects must use immutable unique keys rather than overwriting a recently
deleted key.
