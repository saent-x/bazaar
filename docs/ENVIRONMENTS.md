# Environments

## Development

- Purpose: local coding, unit tests, adapter fakes, and synthetic audio.
- Data: synthetic or explicitly disposable test data only.
- External access: none by default.
- Secrets: development-only credentials with minimum scope.
- Models: only artifacts approved for evaluation in the license register.
- Host: personal server or developer machine, isolated under `/data/tiv-live/dev`.

## Staging voice laboratory

- Purpose: end-to-end technical testing with invited evaluators.
- Data: consented evaluation material only after the consent flow is approved.
- External access: private and authenticated; no public discovery.
- Secrets: staging-specific and never shared with development or pilot.
- Models: pinned versions approved for evaluation.
- Host: resource-limited services under `/data/tiv-live/staging`.

## Invited pilot

- Purpose: approximately 30-50 invited speakers after Gate 4 passes.
- Data: operational audio remains ephemeral; retained donation is separately
  opted in and governed.
- External access: invitation/session controls, capacity limits, and abuse
  protection.
- Secrets: pilot-specific, rotated before launch.
- Models: pinned versions approved for pilot in the license register.
- Host: isolated under `/data/tiv-live/pilot`; no shared writable state with
  staging.

## Separation requirements

- Separate host paths, databases, credentials, Cloudflare resources, consent
  records, and retention jobs.
- Never copy real data from pilot into development.
- Promote code and configuration through review; do not promote databases.
- Each environment must be identifiable in logs and metrics without encoding
  contributor identity.
