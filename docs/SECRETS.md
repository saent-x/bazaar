# Secret handling

## Rules

- Never commit credentials, API tokens, private keys, consent exports, or real
  `.env` files.
- Never put secrets in command arguments that may enter shell history or process
  listings.
- Use service-specific, least-privilege credentials with separate development,
  staging, and pilot values.
- Store host secrets outside the repository in root- or service-readable files,
  or in an approved secret manager when one is selected.
- Reference secrets from systemd through protected environment/credential files;
  do not embed them in unit files.
- Rotate a secret immediately if it appears in logs, commits, chat, screenshots,
  test fixtures, or process output.
- Cloudflare API tokens must be scoped to the minimum account, zone, and product
  permissions needed. Do not use a Global API Key.
- Browser code may contain only public identifiers specifically designed for
  client exposure. Server-side validation secrets stay server-side.

## Repository protection

`.gitignore` reduces accidents but is not a security boundary. Before every
commit:

1. Review `git diff --cached`.
2. Search staged content for private-key headers, common token prefixes, and
   `.env` values.
3. Confirm no audio, model weights, datasets, databases, or infrastructure
   exports are staged.

A secret scanner will be added to CI when the first code scaffold is created.

## Local development

An eventual `.env.example` may document variable names and harmless sample
values. It must never contain working credentials, production hostnames that are
intended to remain private, or contributor data.

## Incident procedure

1. Revoke or rotate the exposed credential first.
2. Contain access and review provider/audit logs.
3. Remove the secret from current files and, when necessary, repository history.
4. Record affected systems and the remediation without reproducing the secret.
5. Test that the old credential no longer works.
