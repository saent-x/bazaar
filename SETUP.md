# Development setup

## Current status

The repository has not yet been scaffolded. There are currently no authoritative
install, build, test, or run commands. Do not invent or document commands until
the initial stack is selected and committed.

## Verified host baseline (2026-07-10)

- Ubuntu Linux, x86-64.
- AMD Ryzen 5 PRO 3600: 6 cores / 12 threads.
- Approximately 30 GiB RAM; no compute GPU.
- Approximately 862 GiB free under `/data` on healthy RAID 1.
- Approximately 12 GiB free on `/`; do not put models or datasets there.
- Caddy already uses TCP and UDP port 443.
- Existing DNS, radio, SSH, and web workloads share the host.
- Node 22, npm, Git, Python 3.14, and `uv` are installed.
- Docker, Podman, `cloudflared`, and Wrangler are not installed.

Wrangler can currently be run transiently with `npx wrangler@latest`; version
4.110.0 was verified on 2026-07-10. A `CLOUDFLARE_API_TOKEN` is present and can
read the configured zone, but Cloudflare rejects R2 bucket access with API code
10000 because the token lacks the required R2 permission. No R2 resource has
been created.

Use an isolated Python 3.11 or 3.12 environment under `/data/tiv-live` for ML
compatibility unless dependency tests prove a different runtime. Any new service
must be unprivileged, resource-limited, and reversible so it cannot disrupt the
existing workloads.

## Expected first implementation

The initial implementation is expected to contain:

- A browser-based, Android-friendly client.
- A WebRTC or WebSocket realtime audio transport.
- A server-side orchestration service.
- Replaceable ASR, conversation-model, and TTS adapters.
- A consent-aware test and feedback interface.
- Latency and quality instrumentation.

LiveKit and Pipecat are candidates for the realtime layer. Meta MMS is a
candidate for Tiv ASR and TTS. These are provisional evaluation choices, not
permanent dependencies. See `docs/DECISIONS.md`.

The proposed Cloudflare/personal-server boundary and phase gates are documented
in `docs/IMPLEMENTATION_PLAN.md`.

## Maintenance rule

When the stack is initialized, replace this section with exact prerequisites,
environment variables, install commands, local-service commands, tests, and
troubleshooting steps. Never commit secrets or real donated recordings.
