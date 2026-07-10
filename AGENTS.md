# AGENTS.md

This file contains durable instructions for every coding agent working in this
repository. Read it before planning or changing the project.

## Project mission

Build a free, donation-supported, community-oriented live Tiv voice assistant.
The target experience is a natural, ongoing conversation similar in feel to
GPT Live: a user starts one session, speaks Tiv naturally, hears a Tiv response,
and can interrupt the assistant without repeatedly pressing a microphone button.

This is not primarily a translator, dictation tool, or generic chatbot with a
microphone attached. Those may be components, but the live Tiv conversation is
the product.

## Sources of truth

Before making product or architectural choices, read:

1. `docs/OPERATING_MANUAL.md` for the required reasoning, verification, and
   communication discipline.
2. `docs/PRODUCT_CHARTER.md` for enduring product principles.
3. `docs/MVP_SCOPE.md` for what is and is not in the current MVP.
4. `docs/ARCHITECTURE.md` for current technical direction.
5. `docs/IMPLEMENTATION_PLAN.md` for the current phase, gates, evidence ledger,
   and explicitly deferred work.
6. `docs/PROJECT_STATUS.md` for the active phase and incomplete gate items.
7. `docs/DATA_AND_LICENSING.md` and `docs/DATA_CLASSIFICATION.md` before
   collecting data or adding a model,
   dataset, analytics service, or external API.
8. `docs/DEPENDENCY_LICENSES.md` before downloading or integrating an artifact.
9. `docs/DECISIONS.md` for accepted and provisional decisions.
10. `docs/ENVIRONMENTS.md`, `docs/SECRETS.md`, and `docs/OPERATIONS.md` before
    changing the development environment or shared host.
11. `SETUP.md` before running or changing the development environment.

If these documents disagree, stop and resolve the documentation conflict before
implementing the affected feature.

## Non-negotiable product guardrails

- Keep the app free to users. Do not add subscriptions, paid tiers, advertising,
  paywalls, or sale of user data without an explicit new project decision.
- Donations may support infrastructure and development, but core functionality
  must not depend on whether a user donates.
- Optimize for Tiv-first conversation, including realistic Tiv/English
  code-switching. Do not silently replace this goal with English-first voice chat.
- The first milestone is turn-based streaming with automatic turn detection and
  barge-in. True simultaneous full-duplex interaction is a later milestone.
- Prefer existing open-source or open-weight components over training foundational
  models from scratch. Train or fine-tune only after benchmarks identify a gap.
- Keep ASR, conversation model, TTS, transport, and storage behind replaceable
  interfaces. Do not lock the application to one model or vendor.
- Treat low-cost Android devices, imperfect networks, and limited bandwidth as
  primary operating conditions.
- Do not add broad feature areas merely because the underlying model supports
  them. Follow `docs/MVP_SCOPE.md`.
- Do not present medical, legal, financial, or other high-stakes guidance as
  authoritative. Expert-reviewed safeguards are required before adding such
  domains.

## Data and privacy guardrails

- Recording a conversation for product operation and donating it for model
  improvement are separate choices with separate consent.
- Data donation must be optional, explicit, understandable, and revocable where
  technically and legally possible.
- Do not enable voice cloning or speaker impersonation from donated recordings.
- Minimize retained audio and personal data. Never log raw audio by default.
- Record provenance, license, attribution requirements, permitted use, and
  redistribution constraints for every model and dataset before integration.
- "Open source", "open weights", "free", and "noncommercial" are not
  interchangeable. Review the actual license.
- Keep a held-out, human-verified Tiv evaluation set separate from training data.

## Development workflow

- Follow the self-test in `docs/OPERATING_MANUAL.md` before reporting work as
  complete. In particular, distinguish verified facts, inferences, and
  assumptions; test the most expensive failure modes; and attack the proposed
  conclusion with at least one targeted disconfirming check.
- Keep changes small and tied to an MVP requirement or an accepted decision.
- Add measurable latency and quality instrumentation to the voice pipeline.
- Test components separately as well as end to end: ASR, response quality, TTS,
  turn detection, interruption handling, and network recovery.
- Native Tiv-speaker evaluation is required for claims about correctness,
  naturalness, pronunciation, or cultural fit.
- Update relevant documentation in the same change whenever behavior, scope,
  setup, architecture, data handling, or licensing changes.
- Do not convert a provisional decision in `docs/DECISIONS.md` into a permanent
  dependency without recording the evidence and accepting the decision.

## Changing an agreed direction

An agent must not quietly override an existing guardrail. If evidence suggests a
change:

1. Describe the problem and evidence.
2. List the consequences and alternatives.
3. Add a proposed entry to `docs/DECISIONS.md` marked `Proposed`.
4. Obtain explicit project-owner agreement for material product, funding,
   privacy, licensing, or scope changes.
5. Update every affected source-of-truth document before implementation.
