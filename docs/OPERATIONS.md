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

RAID 1 protects against one disk failure but is not a backup. No off-site voice
backup is active. The destination, client-side encryption method, key custodian,
retention, deletion propagation, and restore test must be approved before Gate 0
is marked complete or contributor data is retained.
