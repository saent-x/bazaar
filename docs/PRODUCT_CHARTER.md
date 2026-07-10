# Product charter

## Vision

Create an accessible Tiv voice assistant that feels like a natural live
conversation rather than a form, translator, or push-to-talk utility. The larger
mission is to strengthen an open Tiv language-technology ecosystem through
useful software, community participation, evaluation resources, and responsibly
collected data.

## Intended experience

A user starts a conversation once and then speaks naturally. The assistant:

- Listens for Tiv speech without requiring a button for every turn.
- Understands common Tiv/English code-switching.
- Responds promptly in understandable Tiv speech.
- Remembers the recent conversation.
- Stops speaking when the user interrupts.
- Makes it apparent that the user is interacting with AI.

The long-term aspiration is continuous, full-duplex behavior: listening and
speaking at the same time, handling pauses naturally, acknowledging without
stealing the turn, and delegating complex work while keeping the conversation
flowing. The MVP may approximate this experience with streaming components.

## Community and funding model

- Access should remain free.
- Voluntary donations may fund hosting, development, community work, and data
  collection.
- Donors receive no privileged core capability.
- No advertising, sale of personal data, or hidden monetization is part of the
  current vision.
- Project finances and significant uses of donated funds should be transparent.
- Open-source application code and reusable community resources are preferred
  where licensing and privacy allow.

## Principles

1. Tiv speakers judge Tiv quality. Automated scores assist but do not replace
   native-speaker review.
2. Start with existing resources. Benchmark before fine-tuning, and fine-tune
   before considering training a foundational model from scratch.
3. Protect agency. Users control whether their recordings are retained or
   donated.
4. Design for replacement. Models, providers, and infrastructure will change.
5. Measure the conversation, not just the components. Meaning preservation,
   latency, turn-taking, interruptions, and comfort all matter.
6. Serve realistic conditions. Affordable Android hardware and unreliable or
   expensive connectivity are first-class constraints.
