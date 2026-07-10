# MVP scope

## MVP outcome

A native Tiv speaker can start one voice session, speak naturally, receive an
understandable spoken Tiv response, continue for several turns, and interrupt
the assistant. The prototype captures consented feedback and enough timing data
to identify the weakest pipeline component.

## Included

- One-tap start and explicit end of a conversation session.
- Automatic speech/turn detection after the session begins.
- Streaming or near-streaming Tiv speech recognition.
- Multi-turn conversational context.
- Spoken Tiv responses.
- Barge-in: user speech stops assistant playback promptly.
- Visible listening, thinking, and speaking states.
- Text transcript for testing and accessibility.
- Native-speaker rating and transcript correction.
- Separate opt-in consent for donating audio and corrections.
- Component and end-to-end latency measurement.
- Recovery from ordinary connection interruption.

## Explicitly not in the first MVP

- True full-duplex generation or backchanneling while the user is speaking.
- Video, camera understanding, screen sharing, avatars, or image generation.
- Phone calling, WhatsApp integration, or smart-speaker hardware.
- A social network, public profiles, messaging platform, or content feed.
- Paid tiers, advertisements, donor-only features, or commercial data use.
- Voice cloning, custom cloned voices, or speaker impersonation.
- Broad autonomous agents or unrestricted tool execution.
- Authoritative medical, legal, financial, or emergency advice.
- Training ASR, an LLM, or TTS from scratch without benchmark evidence.
- Premature native mobile applications before the browser prototype validates
  the experience.

## Initial evaluation targets

These are working targets and must be refined with native Tiv speakers:

- The assistant begins audible response in approximately two seconds under good
  network conditions.
- Interruption stops playback quickly enough to feel responsive.
- At least 80% of pilot turns preserve the speaker's intended meaning.
- Most evaluated speech is rated understandable by native speakers.
- A ten-minute multi-turn session completes without a forced restart.
- Quality is reported across speakers, accents, devices, noise conditions, and
  code-switching rather than as one aggregate number.

## First pilot

Start with a private voice laboratory and approximately five native Tiv speakers
across about twenty conversations. Expand only after reviewing failure modes,
consent flow, data handling, and operating cost.
