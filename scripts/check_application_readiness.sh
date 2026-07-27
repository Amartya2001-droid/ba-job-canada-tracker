#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
APPLICATIONS_CSV="$ROOT_DIR/tracker/applications.csv"
FIRST_FIVE_MD="$ROOT_DIR/tracker/first-five-applications.md"

if [[ ! -f "$APPLICATIONS_CSV" || ! -f "$FIRST_FIVE_MD" ]]; then
  echo "Missing application tracker files."
  exit 1
fi

if grep -q '\[Paste posting URL\]' "$FIRST_FIVE_MD"; then
  echo "First five application worksheet still contains placeholder job links."
  exit 1
fi

if grep -q '\[Target ' "$FIRST_FIVE_MD"; then
  echo "First five application worksheet still contains placeholder company text."
  exit 1
fi

REAL_ROWS=$(tail -n +2 "$APPLICATIONS_CSV" | awk -F',' '
  {
    nonempty = 0
    for (i = 1; i <= NF; i++) {
      if ($i != "") {
        nonempty = 1
      }
    }
    if (nonempty) {
      count += 1
    }
  }
  END { print count + 0 }
')

if [[ "$REAL_ROWS" -lt 5 ]]; then
  echo "Expected at least 5 real application rows, found $REAL_ROWS."
  exit 1
fi

INVALID_ROWS=$(tail -n +2 "$APPLICATIONS_CSV" | awk -F',' '
  {
    if ($1 != "" || $2 != "" || $3 != "" || $5 != "") {
      if ($2 == "" || $3 == "" || $4 == "" || $5 == "" || $8 == "" || $10 == "" || $11 == "") {
        invalid += 1
      }
    }
  }
  END { print invalid + 0 }
')

if [[ "$INVALID_ROWS" -gt 0 ]]; then
  echo "Found $INVALID_ROWS incomplete application row(s) in applications.csv."
  exit 1
fi

"$ROOT_DIR/scripts/check_tracker_consistency.sh" >/dev/null

echo "Application readiness checks passed."
