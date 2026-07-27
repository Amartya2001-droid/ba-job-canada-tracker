#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
APPLICATIONS_CSV="$ROOT_DIR/tracker/applications.csv"

if [[ ! -f "$APPLICATIONS_CSV" ]]; then
  echo "Missing tracker/applications.csv."
  exit 1
fi

duplicate_links="$(tail -n +2 "$APPLICATIONS_CSV" | awk -F',' '
  {
    link = $5
    if (link != "") {
      count[link] += 1
    }
  }
  END {
    duplicates = 0
    for (link in count) {
      if (count[link] > 1) {
        duplicates += 1
      }
    }
    print duplicates + 0
  }
')"

if [[ "$duplicate_links" -gt 0 ]]; then
  echo "Found $duplicate_links duplicate job link(s) in applications.csv."
  exit 1
fi

invalid_dates="$(tail -n +2 "$APPLICATIONS_CSV" | awk -F',' '
  {
    if ($12 != "" && $12 !~ /^[0-9]{4}-[0-9]{2}-[0-9]{2}$/) {
      invalid += 1
    }
  }
  END { print invalid + 0 }
')"

if [[ "$invalid_dates" -gt 0 ]]; then
  echo "Found $invalid_dates follow-up date value(s) outside YYYY-MM-DD format."
  exit 1
fi

low_signal_rows="$(tail -n +2 "$APPLICATIONS_CSV" | awk -F',' '
  {
    if ($2 != "" || $3 != "" || $5 != "") {
      if ($7 == "" || $8 == "" || $9 == "" || $10 == "") {
        weak += 1
      }
    }
  }
  END { print weak + 0 }
')"

if [[ "$low_signal_rows" -gt 0 ]]; then
  echo "Found $low_signal_rows low-signal tracker row(s) missing fit or proof fields."
  exit 1
fi

echo "Tracker consistency checks passed."
