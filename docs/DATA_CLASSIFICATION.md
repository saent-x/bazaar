# Data classification and retention

## Principles

- Operational processing, debugging retention, research donation, and public
  release are separate purposes.
- Retain the minimum data for the shortest useful period.
- Raw audio and verbatim transcripts are sensitive even when names are absent;
  voices and conversation content can identify people.
- No retention schedule begins until the relevant consent language is approved.

## Classification table

| Class | Examples | Default storage | Default retention | Access | External transfer | Owner |
|---|---|---|---|---|---|---|
| Public | Application code, published documentation, approved aggregate metrics | Git repository / public web | Indefinite while maintained | Public | Allowed after review | Project owner |
| Internal | Architecture notes, non-sensitive operational metrics, synthetic fixtures | Git or protected project storage | While operationally useful | Maintainers | Only approved services | Technical maintainer |
| Confidential | Service credentials, signing keys, private infrastructure details | Secret manager or protected host path outside repository | Until rotated or service removed | Least-privilege operators | Only the service requiring it | Infrastructure owner |
| Sensitive contributor metadata | Consent records, withdrawal requests, contact information | Encrypted local database under `/data/tiv-live` | Policy TBD before collection | Authorized research operators | Prohibited until approved | Data steward |
| Sensitive voice content | Raw audio, transcripts, corrections, conversation content | Memory for operation; encrypted local storage only after explicit donation | Policy TBD before collection | Authorized research operators | Prohibited until approved | Data steward |
| Held-out evaluation data | Consented audio, verified transcripts, speaker-disjoint metadata | Encrypted local evaluation store | Duration of evaluation program, reviewed periodically | Evaluation team only | Prohibited until separately approved | Evaluation lead |

## Required records

Every retained contributor item must be traceable to:

- A pseudonymous contributor identifier.
- The exact consent-text version and timestamp.
- Permitted purposes.
- Retention or review date.
- Withdrawal/deletion state.
- Dataset split and access history where applicable.

Do not place direct contact information in the same store as donated audio.

## Logging

Routine logs may contain correlation IDs, component versions, durations, error
codes, and resource metrics. They must not contain raw audio, verbatim
transcripts, model prompts containing user speech, secrets, or direct identifiers.

Debug capture must be time-limited, explicitly enabled for a specific incident,
and use synthetic data unless contributor consent clearly covers the capture.

## Unresolved before collection

- Exact retention periods.
- Contributor age requirements and guardian consent, if minors participate.
- Withdrawal limits after derived models or published datasets exist.
- Jurisdiction-specific privacy notice and data-controller identity.
- Off-site backup destination and encryption-key custody.

No real contributor data may be collected until these are resolved for the
relevant collection stage.
