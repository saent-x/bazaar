# Architecture direction

## Guiding shape

The MVP is a modular streaming pipeline:

```text
Android-friendly web client
        |
        | WebRTC/WebSocket audio
        v
Turn and voice-activity detection
        v
Tiv ASR adapter
        v
Conversation/orchestration adapter
        v
Tiv TTS adapter
        |
        v
Streaming audio playback
```

When the client detects new user speech, it cancels current response generation
where possible and stops assistant playback immediately.

## Required boundaries

Define stable internal interfaces for:

- Audio transport and session lifecycle.
- Voice activity and end-of-turn detection.
- Partial and final ASR transcripts.
- Conversation generation and memory.
- Incremental or chunked TTS output.
- Cancellation and interruption.
- Consent, feedback, and optional data donation.
- Metrics and trace correlation.

Provider-specific objects must not leak across these boundaries.

## Provisional component candidates

- LiveKit or Pipecat for realtime orchestration and transport.
- Silero VAD for voice-activity detection.
- Meta MMS plus adapted streaming logic for Tiv ASR.
- An existing multilingual or open-weight language model for responses.
- Meta MMS-TTS and available Tiv speech datasets for initial synthesis tests.
- PostgreSQL for consent, metadata, corrections, and evaluation records.
- S3-compatible object storage for explicitly retained audio.

Candidates must pass quality, latency, licensing, privacy, maintenance, and cost
review. The system may temporarily compare an API-backed realtime model with the
open pipeline, but no provider is the product architecture.

## Delivery stages

1. **Offline feasibility:** benchmark ASR, response quality, and TTS separately
   using a held-out, human-verified evaluation set.
2. **Voice laboratory:** automatic turns, streamed pipeline, interruption,
   transcripts, corrections, consent, and timings in a browser client.
3. **Private pilot:** test realistic devices, networks, noise, accents, and
   Tiv/English code-switching.
4. **Quality improvement:** adapt only the measured bottleneck.
5. **Later live behavior:** explore full-duplex interaction, natural pauses,
   backchannels, and background task delegation after the basic experience is
   reliable.

## Performance accounting

Record at minimum:

- Speech start and detected end-of-turn time.
- First partial and final ASR time.
- First generated response token or chunk.
- First synthesized and first played audio.
- Interruption detection and playback-stop time.
- Errors, retries, cancellations, and reconnections.

Do not improve apparent latency by hiding recognition errors or making the
assistant interrupt users aggressively.
