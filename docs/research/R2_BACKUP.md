# R2 backup cost and privacy review

## Decision

Cloudflare R2 is conditionally approved as the off-site backup destination. It
must remain disabled until a synthetic encrypted backup and restoration test can
be completed without enabling billable project usage.

The project owner approved R2 on 2026-07-10 only on the condition that it does
not cost money.

## Verified pricing on 2026-07-10

Cloudflare's published R2 Standard free tier includes, per month:

- 10 GB-month of storage.
- 1 million Class A operations.
- 10 million Class B operations.
- Free direct R2 egress.

The free tier applies to Standard storage, not Infrequent Access. Above the free
tier, Standard storage and operations are billable. Cloudflare rounds billable
usage up to billing units.

Cloudflare supports budget alerts, but its documentation states that alerts are
informational only and do not pause or cap usage. Therefore a budget alert is a
warning, not a zero-cost control.

Primary references:

- https://developers.cloudflare.com/r2/pricing/
- https://developers.cloudflare.com/billing/manage/budget-alerts/
- https://developers.cloudflare.com/r2/reference/data-security/

## No-charge controls

- Use **Standard** storage only.
- The Tiv Live bucket must remain private.
- Keep Tiv Live encrypted backup inventory at or below **5 GB**, leaving half of
  the published storage allowance as project safety margin.
- Bundle small files into versioned encrypted archives to keep operations far
  below the free allowance.
- Do not use R2 Data Catalog, event-driven Workers, automatic storage-class
  transitions, or other metered services for backup.
- Before enabling scheduled uploads, inventory all R2 usage in the Cloudflare
  account. The free allowance may be shared with other buckets.
- Refuse new uploads if the project inventory would exceed 5 GB.
- Configure the lowest available practical budget alert, understanding that it
  cannot prevent charges.
- If account-wide usage cannot be measured reliably or another workload could
  consume the remaining free allowance, keep R2 backups disabled.
- Recheck official pricing before enabling the backup and at least quarterly
  while it remains active.

These controls make a project charge unlikely under the current published free
tier, but they cannot mathematically guarantee a zero invoice when other
account-level usage is outside this project's control.

## Encryption and key custody

- Encrypt locally before upload with an authenticated, versioned backup tool.
- Cloudflare receives only ciphertext and non-sensitive object metadata.
- Never store the encryption key, passphrase, or recovery material in R2, Git,
  application logs, shell history, or repository configuration.
- The project owner is the primary key custodian and keeps an offline recovery
  copy.
- An automated backup process may receive a least-privilege runtime secret from
  a protected host credential file outside the repository.
- Losing all key copies makes the backup unrecoverable; exposing the key defeats
  the client-side encryption boundary.

## Data boundary

Initial restore testing must use synthetic non-personal data. Real voice,
transcript, consent, or contributor metadata must not be uploaded until the
relevant consent explicitly permits encrypted off-site processing and the
retention/deletion behavior has been tested.

## Activation gate

R2 backup is active only after all of these are verified:

- Cloudflare account and existing R2 usage inventoried.
- Private Standard bucket created with least-privilege credentials.
- Client-side encryption configured outside the repository.
- 5 GB project-side hard quota implemented and tested.
- Budget alert configured where the account supports it.
- Synthetic backup, restore, corruption detection, and deletion tested.
- Official pricing rechecked and documented on the activation date.
