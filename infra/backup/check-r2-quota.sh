#!/usr/bin/env bash
set -euo pipefail

bucket="${R2_BACKUP_BUCKET:-bazaar-encrypted-backups}"
max_bytes="${R2_BACKUP_MAX_BYTES:-5000000000}"
incoming_bytes="${1:-0}"
wrangler_version="${WRANGLER_VERSION:-4.110.0}"

if ! [[ "$incoming_bytes" =~ ^[0-9]+$ ]]; then
  echo "incoming size must be a non-negative integer" >&2
  exit 2
fi

if ! [[ "$max_bytes" =~ ^[0-9]+$ ]] || [ "$max_bytes" -le 0 ]; then
  echo "R2_BACKUP_MAX_BYTES must be a positive integer" >&2
  exit 2
fi

info="$(npx --yes "wrangler@${wrangler_version}" r2 bucket info "$bucket")"
size_line="$(printf '%s\n' "$info" | awk -F: '/^bucket_size:/ {gsub(/^[ \t]+/, "", $2); print $2}')"

if [ -z "$size_line" ]; then
  echo "could not determine current bucket size" >&2
  exit 2
fi

current_bytes="$(node - "$size_line" <<'NODE'
const input = process.argv[2].trim();
const match = input.match(/^([0-9]+(?:\.[0-9]+)?)\s*(B|KiB|MiB|GiB|TiB)$/);
if (!match) process.exit(2);
const factors = { B: 1, KiB: 1024, MiB: 1024 ** 2, GiB: 1024 ** 3, TiB: 1024 ** 4 };
process.stdout.write(String(Math.ceil(Number(match[1]) * factors[match[2]])));
NODE
)"

projected_bytes=$((current_bytes + incoming_bytes))

if [ "$projected_bytes" -gt "$max_bytes" ]; then
  echo "R2 backup quota exceeded: current=${current_bytes} incoming=${incoming_bytes} projected=${projected_bytes} limit=${max_bytes}" >&2
  exit 3
fi

echo "R2 backup quota ok: current=${current_bytes} incoming=${incoming_bytes} projected=${projected_bytes} limit=${max_bytes}"
