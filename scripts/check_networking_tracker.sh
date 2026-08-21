#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
NETWORKING_CSV="$ROOT_DIR/tracker/networking.csv"

if [[ ! -f "$NETWORKING_CSV" ]]; then
  echo "Missing tracker/networking.csv."
  exit 1
fi

row_count="$(tail -n +2 "$NETWORKING_CSV" | awk -F',' '{
  nonempty = 0
  for (i = 1; i <= NF; i++) { if ($i != "") nonempty = 1 }
  if (nonempty) count += 1
}
END { print count + 0 }')"

if [[ "$row_count" -eq 0 ]]; then
  echo "No networking rows logged yet. See docs/networking-outreach-workflow.md to get started."
  exit 0
fi

invalid_dates="$(tail -n +2 "$NETWORKING_CSV" | awk -F',' '
  {
    if ($1 != "" && $1 !~ /^[0-9]{4}-[0-9]{2}-[0-9]{2}$/) { invalid += 1 }
    if ($7 != "" && $7 !~ /^[0-9]{4}-[0-9]{2}-[0-9]{2}$/) { invalid += 1 }
  }
  END { print invalid + 0 }
')"

if [[ "$invalid_dates" -gt 0 ]]; then
  echo "Found $invalid_dates networking date value(s) outside YYYY-MM-DD format."
  exit 1
fi

incomplete_rows="$(tail -n +2 "$NETWORKING_CSV" | awk -F',' '
  {
    if ($1 != "" || $2 != "" || $3 != "") {
      if ($1 == "" || $2 == "" || $3 == "" || $4 == "" || $5 == "" || $6 == "") {
        incomplete += 1
      }
    }
  }
  END { print incomplete + 0 }
')"

if [[ "$incomplete_rows" -gt 0 ]]; then
  echo "Found $incomplete_rows incomplete networking row(s) missing date, name, company, platform, purpose, or status."
  exit 1
fi

echo "Networking tracker checks passed ($row_count row(s) logged)."
