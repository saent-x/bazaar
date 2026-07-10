# Implementation plan

## Status

**Accepted on 2026-07-10.** This plan is intentionally phase-gated. A later phase does not
begin merely because the previous phase produced code; it begins only when the
previous phase's evidence gate passes.

## Outcome

Deliver a private Tiv voice laboratory in which a native speaker starts one
session, speaks naturally, receives understandable Tiv speech, continues for
multiple turns, and interrupts the assistant. The system must expose enough
quality, latency, consent, and cost evidence to decide whether a wider pilot is
responsible.

The plan optimizes for learning whether the product can work. It does not
optimize for producing the largest application in the shortest time.

## Evidence ledger

### Verified on 2026-07-10

- The host is Ubuntu Linux on x86-64 with an AMD Ryzen 5 PRO 3600: 6 physical
  cores and 12 threads.
- It has approximately 30 GiB RAM and no usable compute GPU. The detected ASPEED
  adapter is a server display controller, not an ML accelerator.
- `/data` has approximately 862 GiB free on a healthy two-device RAID 1 array.
- The root filesystem has only approximately 12 GiB free. Models, environments,
  datasets, and donated audio must live under `/data`, not under `/`.
- The server has a public network interface, 1 Gbit/s link on its primary NIC,
  and an additional 100 Mbit/s link. Actual Internet throughput and client
  latency have not been measured.
- Caddy already owns TCP and UDP port 443, and the machine hosts unrelated radio,
  DNS, SSH, and web services.
- Node 22, npm, Git, Python 3.14, and `uv` are installed. Docker, Podman,
  `cloudflared`, Wrangler, and an NVIDIA runtime are not installed.
- The machine is nearly idle at the time of inspection.

### Inferred

- The host is suitable for the web origin, control plane, metadata, evaluation
  tooling, and one-user-at-a-time experiments.
- CPU inference may be adequate for selected quantized or compact models, but
  running ASR, an LLM, and TTS concurrently within a two-second response budget
  is the plan's largest technical uncertainty.
- Sharing this host with existing services is acceptable for a private lab only
  if resource limits, ports, backups, and rollback are explicit.

### Assumed until tested

- At least two native Tiv speakers can help create the smoke-test set, and at
  least ten can later contribute to a held-out evaluation set.
- The Cloudflare account contains or can receive a suitable domain and allows
  Workers, Tunnel, Turnstile, and Realtime/TURN use.
- Existing Tiv ASR and TTS artifacts are accessible under licenses compatible
  with this free, donation-supported project.
- One existing language model can produce useful Tiv responses without training
  a foundation model.
- Users in the target geography can reach this server with acceptable latency.

An assumption becoming convenient is not evidence. Each load-bearing assumption
has a gate below.

## Accepted deployment direction

```text
                         Cloudflare
                 +------------------------+
                 | DNS, TLS, WAF/rate     |
Browser / PWA <--| Workers static assets  |
                 | session-ticket Worker  |
                 | Turnstile when needed  |
                 +-----------+------------+
                             |
                    HTTPS / WebSocket
                    through Tunnel or
                    protected origin
                             |
                  Personal cloud server
        +--------------------+--------------------+
        | session API / realtime orchestrator    |
        | VAD -> Tiv ASR -> conversation -> TTS  |
        | consent ledger / evaluation metadata   |
        | optional donated-audio storage         |
        +--------------------+--------------------+
                             |
                  encrypted off-site backup
                  only after policy approval
```

Realtime media is deliberately shown separately from ordinary HTTPS. Cloudflare
Tunnel is appropriate for the HTTP control plane and WebSocket signaling, but a
self-hosted WebRTC server normally needs public UDP media ports. The transport
spike must choose one of these paths:

1. **WebSocket audio through Cloudflare:** simplest private-lab baseline; works
   over HTTPS infrastructure but may suffer head-of-line blocking and weaker
   network adaptation.
2. **Small peer-to-peer WebRTC plus Cloudflare TURN:** lower-latency media and
   NAT traversal without operating a full SFU; integration and cost require a
   real spike.
3. **Self-hosted LiveKit:** mature agent/session tooling, but requires direct
   UDP/TCP media exposure, port planning, certificates, and conflict resolution
   with the existing Caddy service.
4. **Cloudflare Realtime SFU:** managed global media plane; promising for later
   scale, but adds an integration surface before the Tiv model path is proven.

Do not select a transport from architectural taste. Measure connection success,
first-audio latency, jitter, interruption time, CPU, bandwidth, and complexity
on representative Android devices and networks.

## Accepted component boundaries

The implementation must define replaceable contracts for:

- `Transport`: session audio input/output, reconnect, and cancellation.
- `TurnDetector`: speech start, provisional end, and final end of turn.
- `Transcriber`: partial/final Tiv transcripts and confidence information.
- `ConversationEngine`: recent context, Tiv response generation, and safe
  fallback behavior.
- `Synthesizer`: first-audio streaming, chunk delivery, and cancellation.
- `ConsentStore`: versioned consent grants and withdrawals.
- `DonationStore`: optional audio/transcript/correction storage.
- `MetricsSink`: latency, errors, resource use, and quality ratings without raw
  transcript or audio logging by default.

Provider SDK objects must terminate inside their adapter.

## Target repository shape

This is a target, not authorization to scaffold every folder immediately.

```text
apps/
  web/                 Android-friendly PWA
  evaluator/           private review and correction UI
services/
  session-api/         auth tickets, consent, metadata, feedback
  voice-runtime/       transport and conversational pipeline
packages/
  contracts/           versioned events and adapter interfaces
  evaluation/          benchmark fixtures, scorers, reports
infra/
  cloudflare/          Worker, assets, Tunnel and security config
  systemd/             personal-server service definitions
docs/
  research/            model and license evaluations
```

## Phase 0: repository and safety foundation

### Work

- Initialize Git and record the initial documentation baseline.
- Create a license register template before downloading models or datasets.
- Create a data-classification and retention table.
- Define development, staging, and pilot environments.
- Establish secret handling; no secrets in source control or shell history.
- Decide where encrypted backup will live, without uploading voice data yet.
- Add a minimal CI check for formatting, tests, secret scanning, and documentation
  links after the first code is scaffolded.

### Gate 0

- Repository history exists and the current documentation is committed.
- Data classes, consent versions, retention intentions, and dependency-license
  records have owners and locations.
- A rollback path exists for every service installed on the shared host.

## Phase 1: offline feasibility

The first goal is not realtime conversation. It is independently verifying each
load-bearing model claim.

### 1A. Evaluation data

- Create a disposable smoke set: about 20 utterances from at least two native
  Tiv speakers, with explicit test consent and human-verified transcripts.
- Create the held-out feasibility set only after the collection and consent flow
  is reviewed: initially 100-200 utterances from at least ten speakers.
- Include scripted and natural speech, short and long turns, device variation,
  ordinary background noise, names, numbers, and Tiv/English code-switching.
- Keep speaker-disjoint train/development/evaluation partitions.

### 1B. ASR benchmark

- Inventory and license-check MMS, Whisper-derived baselines, and any credible
  Tiv-specific checkpoint.
- Run them on identical normalized audio.
- Measure character/word error rates where appropriate, meaning preservation,
  code-switch behavior, real-time factor, peak RAM, and cold/warm latency.
- Record failure examples, not only aggregate scores.

### 1C. Conversation benchmark

- Build 50-100 representative Tiv prompts and multi-turn continuations.
- Compare at least one locally runnable model and one strong reference model if
  permitted and affordable.
- Have native speakers blind-rate comprehension, correctness, naturalness,
  consistency, cultural fit, and harmful fabrication.
- Test the fallback behavior when the model does not understand.

### 1D. TTS benchmark

- License-check MMS-TTS and the available Tiv TTS data/model artifacts.
- Have native speakers blind-rate intelligibility, pronunciation, prosody,
  naturalness, names, numbers, and code-switched phrases.
- Measure time to first playable audio, total generation speed, peak RAM, and
  cancellation granularity.

### Gate 1

Proceed only if one candidate per stage is good enough for a private voice lab:

- At least 80% of evaluated turns preserve intended meaning end to end.
- TTS is understandable to most native-speaker evaluators.
- The three selected components can coexist within host memory.
- A warm single-session pipeline has a credible path to first audio near two
  seconds; otherwise the plan explicitly identifies the hardware or hosted
  inference needed.
- Every selected artifact has a recorded version, provenance, license, and
  attribution requirement.

If this gate fails, improve only the failed component. Do not hide poor Tiv
quality behind a polished realtime UI.

## Phase 2: local vertical slice

### Work

- Implement a local command-line or minimal browser flow using recorded audio:
  audio -> VAD -> ASR -> conversation -> TTS -> playback.
- Stream partial events through the same versioned contracts intended for the
  realtime client.
- Implement cancellation at every stage.
- Keep operational audio in memory and disabled from logs.
- Emit a per-turn trace containing timestamps, component versions, errors, and
  resource metrics but no raw transcript by default.
- Add deterministic adapter fakes so orchestration and interruption tests do not
  require loading ML models.

### Working latency budget

- End-of-turn decision: 350-600 ms after speech ends.
- Final ASR result: within 700 ms after end-of-turn.
- First response text/chunk: within 400 ms after final transcript.
- First synthesized audio: within 700 ms after response begins.
- Browser/network/playback overhead: within 200 ms on a good connection.
- First audible response: target approximately 2 seconds after speech ends.
- Barge-in to stopped playback: target 250 ms or less.

These are hypotheses. Measurements may force a new accepted budget.

### Gate 2

- A ten-minute prerecorded or locally driven conversation completes without a
  process restart or unbounded memory growth.
- Cancellation tests prove stale audio cannot play after a user interruption.
- Timings identify where every millisecond in the response delay was spent.
- Existing radio and DNS services remain unaffected under a one-session load.

## Phase 3: transport spike

### Work

Implement the same tiny conversation with no product polish over at least:

- WebSocket audio through the normal Cloudflare HTTP path.
- One WebRTC option: peer-to-peer with managed TURN, self-hosted LiveKit, or
  Cloudflare Realtime SFU.

Test on low-cost Android hardware over Wi-Fi and mobile data. Include background
noise, network switching, packet loss, a long pause, rapid interruption, and a
speaker talking while assistant audio plays.

### Transport scorecard

- Connection success rate and time.
- Round-trip and first-audio latency.
- Jitter and audible gaps.
- Echo-cancellation behavior.
- Barge-in latency and false interruptions.
- Reconnect behavior and session continuity.
- Origin bandwidth and CPU.
- Required ports and impact on Caddy and existing services.
- Cloudflare and operating cost per conversation minute.
- Maintenance burden and vendor coupling.

### Gate 3

Accept the simplest transport that meets the experience and connectivity target.
Record the selection in `docs/DECISIONS.md`; do not let both spikes become
permanent production paths.

## Phase 4: private voice laboratory

### Client

- A small installable PWA served as Cloudflare Worker static assets.
- Start conversation, end conversation, mute, and replay-last-response controls.
- Clear listening, thinking, speaking, reconnecting, and error states.
- Live transcript available but visually secondary to conversation.
- Accessible consent, correction, rating, and deletion/withdrawal flows.

### Edge

- A minimal Worker issues short-lived, narrowly scoped session tickets.
- Cloudflare handles DNS, TLS, baseline rate limiting, and static delivery.
- Turnstile is introduced only where abuse evidence justifies friction, with
  mandatory server-side token validation.
- The edge does not receive or store donated audio unless a later reviewed
  architecture explicitly requires it.

### Personal server

- Run the API and voice runtime as dedicated, unprivileged systemd services.
- Use a Python 3.11 or 3.12 `uv` environment under `/data`; do not assume the
  system Python 3.14 is supported by ML dependencies.
- Put model caches, temporary audio, databases, and evaluation artifacts under
  dedicated `/data/tiv-live` paths with quotas and permissions.
- Apply CPU and memory limits so Tiv experiments cannot starve existing radio or
  DNS services.
- Use health checks, structured logs, service restart limits, and a documented
  one-command rollback.
- Do not install a container platform merely for fashion. Choose containers only
  if they materially improve reproducibility or isolate conflicting runtimes.

### Pilot storage

- Start with SQLite in WAL mode for consent, session metadata, and ratings if the
  write pattern remains single-host and low-concurrency.
- Store explicitly donated audio as opaque IDs in a private encrypted filesystem
  area, separate from identity/contact records.
- Treat RAID 1 as availability, not backup.
- Design an encrypted off-site backup and restore test. R2 is a candidate, but
  uploading donated voice data requires an explicit privacy decision even though
  R2 encrypts objects at rest and in transit.

### Gate 4

- Five native Tiv speakers complete about twenty conversations.
- Sessions last ten minutes without forced restart.
- Meaning preservation, intelligibility, interruption, latency, and connection
  targets are reported by device/network and speaker context.
- Consent and withdrawal are exercised in testing, not merely displayed.
- No raw audio or transcript appears in routine application logs.
- A restore drill and service rollback succeed.

## Phase 5: constrained pilot

Expand to approximately 30-50 invited speakers only after Gate 4. Set a hard
concurrency cap based on load testing. Add a waiting-room or capacity response
instead of allowing overload to degrade every conversation.

Improve only the measured bottleneck:

- ASR weakness -> collect/transcribe representative consented speech and
  fine-tune an adapter.
- Response weakness -> improve Tiv data, retrieval, prompting, or a small
  fine-tune after evaluation.
- TTS weakness -> improve text normalization and licensed Tiv speech data.
- Latency weakness -> profile, quantize, pipeline, or add a suitable GPU/hosted
  service based on cost evidence.
- Connectivity weakness -> change media transport or TURN strategy based on
  failure traces.

## Cloudflare responsibilities and limits

Use Cloudflare where it removes undifferentiated infrastructure work:

- Workers static assets for the PWA and a small session-ticket API.
- DNS, TLS, WAF/rate limiting, and later Turnstile for demonstrated abuse.
- Tunnel for private HTTP origin access or WebSocket signaling if its measured
  latency is acceptable.
- Managed TURN as a transport candidate for restricted networks.
- R2 only for approved encrypted artifacts or backup, never as an accidental
  dumping ground for raw conversations.

Do not assume Cloudflare Tunnel carries a self-hosted WebRTC media plane. LiveKit
normally needs direct UDP media ports or TURN. Cloudflare TURN and Realtime SFU
solve different media problems and must be evaluated as such.

Current reference points:

- Cloudflare Workers static assets:
  https://developers.cloudflare.com/workers/static-assets/
- Cloudflare Tunnel connectivity:
  https://developers.cloudflare.com/cloudflare-one/networks/connectivity-options/
- Cloudflare Realtime TURN:
  https://developers.cloudflare.com/realtime/turn/
- Cloudflare Realtime SFU:
  https://developers.cloudflare.com/realtime/sfu/
- Cloudflare R2 data security:
  https://developers.cloudflare.com/r2/reference/data-security/
- LiveKit ports and firewall:
  https://docs.livekit.io/transport/self-hosting/ports-firewall/

## Deep scrutiny: likely ways this plan is wrong

### 1. Existing Tiv models are not conversationally usable

**Impact:** Fatal to the experience even if the UI is excellent.

**Early disconfirmation:** Blind native-speaker evaluation on natural,
code-switched speech before realtime work.

**Response:** Adapt the weakest component, narrow conversation behavior, or use
a temporary reference service. Do not lower the score by redefining bad Tiv as
acceptable.

### 2. The CPU-only server misses the latency target

**Impact:** Responses feel turn-based and slow; concurrent sessions collapse.

**Early disconfirmation:** Run all chosen models concurrently and measure warm
and cold latency, real-time factor, RAM, and throttling in Phase 1.

**Response:** Use smaller/quantized models, overlap safe pipeline stages, add a
suitable GPU, or selectively host inference. Do not optimize infrastructure
before identifying which stage dominates.

### 3. Central-server geography makes conversation slow for Tiv speakers

**Impact:** Model latency improvements cannot compensate for network delay and
packet loss.

**Early disconfirmation:** Measure from representative Nigerian mobile networks,
not from the server itself.

**Response:** Use a closer inference host, managed media edge, or regional
deployment. Cloudflare can shorten edge access but cannot erase the round trip
from its edge to a distant origin inference server.

### 4. The shared host creates an avoidable outage or security incident

**Impact:** Tiv experiments disrupt the existing radio/DNS workload or expose
other services.

**Early disconfirmation:** Port inventory, least-privilege services, resource
limits, load tests, firewall review, and rollback drills.

**Response:** Move the voice runtime to a VM, dedicated host, or GPU service.

### 5. WebRTC complexity consumes the project

**Impact:** Weeks are spent on media infrastructure before Tiv quality is known.

**Early disconfirmation:** Build a timeboxed WebSocket baseline and one narrow
WebRTC spike against the same scorecard.

**Response:** Ship the simpler transport for the private lab if it meets the
experience target; revisit only with failure evidence.

### 6. Data donation damages trust

**Impact:** Community participation falls or contributors are harmed.

**Early disconfirmation:** Review the consent text and withdrawal journey with
Tiv speakers before collection; test deletion end to end.

**Response:** Run without data donation until the policy and mechanism are
credible. Product operation must not depend on donation.

### 7. Noncommercial licensing is interpreted too casually

**Impact:** Models or datasets must be removed after integration.

**Early disconfirmation:** Artifact-level license register before download or
deployment, including weights and data separately.

**Response:** Seek written permission or replace the component. Free access and
donation support do not erase license conditions.

### 8. The evaluation target rewards memorized or scripted speech

**Impact:** Benchmarks pass while real conversation fails.

**Early disconfirmation:** Speaker-disjoint natural conversations, code-switching,
noise, device variation, and meaning-based human evaluation.

**Response:** Preserve the held-out set and expand only by documented failure
categories.

### 9. A polished transcript UI quietly replaces the live product

**Impact:** The team ships a translator/dictation tool while believing it built
a live assistant.

**Early disconfirmation:** Every milestone demonstration must be voice-first and
must include interruption and multi-turn continuity.

**Response:** Treat text as evaluation/accessibility support, not the primary
interaction.

## Explicit deferrals

- True full duplex, backchannels, emotional voice modeling, video, screen share,
  phone calls, WhatsApp, avatars, public profiles, broad tool use, and native apps.
- Kubernetes, multi-region orchestration, a vector database, and distributed
  queues until measured scale requires them.
- PostgreSQL until SQLite's verified workload or operational needs justify it.
- A GPU purchase until Phase 1 identifies the exact workload, VRAM need, and
  benefit.
- Publishing donated data until consent, governance, redaction, licensing, and
  community review are complete.

## Definition of MVP complete

The MVP is complete only when all of these are demonstrated:

- A native Tiv speaker starts one session and completes a natural ten-minute
  multi-turn conversation.
- The speaker can interrupt the assistant reliably.
- Most speech is understandable, and at least 80% of evaluated turns preserve
  intended meaning under the agreed rubric.
- First-audio and interruption targets are measured and either met or explicitly
  revised with native-speaker evidence.
- The system remains stable under its declared concurrency limit.
- Consent, non-donation, donation, withdrawal, deletion, backup, and restore paths
  are tested.
- Component versions, licenses, attribution, cost, and known limitations are
  documented.
- Existing services on the personal server remain healthy during load testing.

## Next executable slice

After project-owner review of this proposal:

1. Initialize Git and commit the documentation baseline.
2. Create the license register and evaluation rubric.
3. Install an isolated Python 3.11/3.12 environment under `/data/tiv-live`.
4. Obtain the smoke-test Tiv recordings with explicit test consent.
5. Benchmark one ASR and one TTS candidate offline on the actual host.
6. Stop and review the evidence before scaffolding the realtime application.
