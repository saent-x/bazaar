# Dependency and data license register

No model, model weight, dataset, external API, hosted service, or substantial
library may be integrated until its row is complete and reviewed.

The repository's own code and documentation are licensed under Apache License
2.0. This register tracks separate third-party and data terms; inclusion in this
repository does not relicense those artifacts.

## Status values

- `Candidate`: identified but not approved for download or integration.
- `Reviewing`: primary license and provenance documents are being checked.
- `Approved for evaluation`: may be used only in private feasibility work.
- `Approved for pilot`: may process invited-pilot traffic under recorded terms.
- `Rejected`: may not be used; record why.
- `Replaced`: previously used but no longer active.

## Register

| Artifact | Type | Exact version | Owner/source | Code license | Weight/data license | Permitted purpose | Attribution/notice | Modification/redistribution | Provenance and consent evidence | Data sent externally | Status | Reviewer/date | Notes |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| Meta MMS ASR | Model candidate | TBD | Meta / primary source TBD | TBD | CC BY-NC 4.0 reported; verify exact artifact | Private noncommercial evaluation pending review | TBD | TBD | Training-data documentation TBD | None planned for local evaluation | Candidate | Unassigned | Do not download until artifact and license are pinned. |
| Meta MMS TTS (Tiv) | Model candidate | TBD | Meta / primary source TBD | TBD | CC BY-NC 4.0 reported; verify exact artifact | Private noncommercial evaluation pending review | TBD | TBD | Training-data documentation TBD | None planned for local evaluation | Candidate | Unassigned | Confirm that a Tiv checkpoint exists and is accessible. |
| Tiv TTS Dataset | Dataset candidate | TBD | Mozilla Data Collective listing / dataset owner TBD | N/A | NOODL-1.0 reported; obtain and read exact terms | Evaluation pending review | TBD | TBD | Contributor/source consent claims TBD | No download approved | Candidate | Unassigned | Dataset quality, speakers, and redistribution need review. |
| English-Tiv MT560 pairs | Dataset candidate | TBD | OPUS-derived Hugging Face dataset | N/A | TBD | Evaluation pending review | TBD | TBD | OPUS provenance chain TBD | No download approved | Candidate | Unassigned | Human quality sampling required. |
| Cloudflare services | Hosted infrastructure | Account-specific | Cloudflare | Service terms | Service terms | Edge delivery/control plane after configuration review | N/A | N/A | N/A | Metadata depends on enabled service | Candidate | Unassigned | Workers, Tunnel, TURN, Turnstile, and R2 reviewed separately before activation. |

## Review procedure

1. Pin the exact repository, model/dataset identifier, revision, and files.
2. Read the primary license and artifact card; do not rely on search summaries.
3. Separate code, weights, dataset, and hosted-service terms.
4. Record training-data provenance and consent claims, including unknowns.
5. Record what user or contributor data leaves the personal server.
6. Check attribution, notices, modification, redistribution, and publication.
7. Approve only the narrowest stage justified by the evidence.
8. Re-review before moving from evaluation to pilot or publishing derivatives.
