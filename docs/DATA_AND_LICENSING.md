# Data, consent, and licensing

## Consent model

The product must distinguish these actions:

1. Processing microphone audio to provide the live conversation.
2. Temporarily retaining data for reliability or debugging.
3. Donating audio, transcripts, corrections, or ratings for research and model
   improvement.
4. Publishing or sharing a derived dataset.

Consent for one action does not imply consent for another. Data donation must be
off by default, described in plain language, and recorded with the consent-text
version shown to the contributor.

## Collection rules

- Collect the minimum data needed for the stated purpose.
- Avoid collecting names and other direct identifiers with speech data.
- Provide deletion or withdrawal mechanisms where feasible.
- Define retention periods before collection begins.
- Restrict access to donated and operational audio.
- Never place real user recordings in source control, demos, fixtures, or logs.
- Do not use donated audio for voice cloning or identity inference.
- Include diverse speakers, accents, ages, devices, environments, and natural
  Tiv/English code-switching in evaluation and consented collection.

## Evaluation separation

Maintain a small, private, human-verified evaluation set that is not used for
training. Track speaker-level splits to prevent the same speaker leaking across
training and evaluation. Report both aggregate results and meaningful subgroup
breakdowns without exposing contributor identity.

## Dependency license register

Before integrating any model or dataset, record:

- Exact artifact and version.
- Source and owner.
- Code license and weight/data license separately.
- Permitted purposes, including any noncommercial restriction.
- Attribution and notice requirements.
- Modification and redistribution conditions.
- Data provenance and consent claims.
- Decision date and reviewer.

Meta MMS code/model artifacts and Tiv datasets require artifact-specific review;
do not infer permission from a repository README or from the word "open".
Donation-supported free operation may fit a noncommercial purpose, but that does
not remove attribution, privacy, or artifact-specific obligations.

## Project-created resources

Project code and repository documentation use Apache License 2.0, as established
by the remote repository's `LICENSE` file. Models, datasets, donated recordings,
and derived data do not automatically inherit that license.

Do not choose a dataset license until the consent language, contributor rights,
withdrawal policy, and intended downstream uses are aligned. A model's
restrictive license must not silently determine the license of independently
collected community data.
