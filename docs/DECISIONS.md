# Decision log

Use this log for choices that affect product scope, architecture, funding,
privacy, licensing, or long-term maintenance. Statuses are `Proposed`,
`Provisional`, `Accepted`, `Superseded`, or `Rejected`.

## Accepted

### D-001: Tiv live conversation is the product

- **Status:** Accepted
- **Decision:** Optimize for an ongoing, Tiv-first voice conversation with
  automatic turns and interruption, inspired by the experience of GPT Live.
- **Consequence:** A translator or push-to-talk form alone does not satisfy the
  product goal.

### D-002: Free and donation-supported

- **Status:** Accepted
- **Decision:** The app is free to users and may be sustained by voluntary
  donations.
- **Consequence:** No paid tiers, advertising, donor-only core features, or sale
  of user data are in scope.

### D-003: Reuse before training from scratch

- **Status:** Accepted
- **Decision:** Evaluate existing open-source, open-weight, and permitted
  noncommercial resources before training foundational models.
- **Consequence:** New training work must respond to a demonstrated benchmark
  gap.

### D-004: Separate operational processing from data donation

- **Status:** Accepted
- **Decision:** Using audio to conduct a conversation does not grant permission
  to retain it or train on it.
- **Consequence:** Donation is an explicit, separate, optional consent flow.

## Provisional

### D-005: Browser-first voice laboratory

- **Status:** Provisional
- **Decision:** Validate the experience with an Android-friendly browser client
  before investing in a native mobile application.
- **Evidence needed:** Browser audio reliability and usability on representative
  low-cost Android devices.

### D-006: Modular cascaded MVP

- **Status:** Provisional
- **Decision:** Approximate the live experience initially with replaceable
  streaming ASR, conversation-model, and TTS components plus interruption.
- **Evidence needed:** Native-speaker quality tests and an acceptable latency
  budget.

### D-007: Evaluate existing realtime frameworks

- **Status:** Provisional
- **Decision:** Compare LiveKit and Pipecat rather than building transport,
  session management, and interruption infrastructure from scratch.
- **Evidence needed:** A short technical spike covering self-hosting, Android
  browser behavior, adapter effort, latency instrumentation, maintenance, and
  licensing.

### D-008: Evaluate MMS for Tiv ASR and TTS

- **Status:** Provisional
- **Decision:** Benchmark Meta MMS and available Tiv resources as initial speech
  candidates.
- **Evidence needed:** Artifact-specific license review, held-out conversational
  Tiv evaluation, code-switching performance, synthesis ratings, and latency.

## Accepted on 2026-07-10

### D-009: Hybrid Cloudflare and personal-server deployment

- **Status:** Accepted
- **Context:** The project has access to Cloudflare and a personal server with a
  public network interface, substantial RAID storage, and no compute GPU.
- **Decision:** Use Cloudflare for public static delivery, DNS/TLS, edge
  protection, and a small session-ticket control plane; run speech/language
  orchestration and sensitive pilot storage on the personal server.
- **Alternatives:** Fully managed cloud, fully direct-hosted, or Cloudflare-hosted
  inference where supported.
- **Approval evidence:** Project-owner approval on 2026-07-10.
- **Validation still required:** Cloudflare account/domain inventory, origin latency from
  target networks, CPU inference benchmarks, security review, and operating-cost
  comparison.
- **Consequences:** The media path cannot be assumed to work through Tunnel; it
  needs a separate transport decision.
- **Documents affected:** `docs/ARCHITECTURE.md`, `SETUP.md`.

### D-010: Select realtime transport by measured spike

- **Status:** Accepted
- **Context:** WebSocket audio is simpler, while WebRTC provides stronger media
  behavior but complicates public UDP, TURN, and port ownership.
- **Decision:** Implement a minimal WebSocket baseline and one WebRTC option,
  score both on representative Android/mobile networks, and accept only one for
  the private laboratory.
- **Alternatives:** Commit immediately to LiveKit, Pipecat SmallWebRTC, or
  Cloudflare Realtime SFU.
- **Approval evidence:** Project-owner approval on 2026-07-10.
- **Validation still required:** Connection success, latency, interruption, jitter, echo,
  resource use, port conflicts, maintenance, and cost.
- **Consequences:** Realtime UI work waits until model feasibility passes.
- **Documents affected:** `docs/ARCHITECTURE.md`, `SETUP.md`.

### D-011: Phase-gated implementation

- **Status:** Accepted
- **Context:** A polished interface could conceal unusable Tiv speech quality or
  CPU latency.
- **Decision:** Follow `docs/IMPLEMENTATION_PLAN.md`; benchmark data, ASR,
  conversation, and TTS before building the realtime client.
- **Alternatives:** Build the complete app and replace weak components later.
- **Approval evidence:** Project-owner approval on 2026-07-10.
- **Consequences:** Early progress is measured in verified feasibility evidence,
  not screen count.
- **Documents affected:** `docs/MVP_SCOPE.md`, `docs/ARCHITECTURE.md`, `SETUP.md`.

## Decision-change template

```text
### D-XXX: Title

- Status: Proposed
- Context:
- Decision:
- Alternatives:
- Evidence:
- Consequences:
- Documents affected:
```
