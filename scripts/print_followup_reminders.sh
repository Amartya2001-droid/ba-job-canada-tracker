#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
APPLICATIONS_CSV="$ROOT_DIR/tracker/applications.csv"

WINDOW_DAYS="${1:-7}"

if [[ ! "$WINDOW_DAYS" =~ ^[0-9]+$ ]]; then
  echo "Usage: $0 [window-days]" >&2
  exit 1
fi

if [[ ! -f "$APPLICATIONS_CSV" ]]; then
  echo "Missing tracker/applications.csv."
  exit 1
fi

today="$(date +%F)"
if ! cutoff="$(date -v "+${WINDOW_DAYS}d" +%F 2>/dev/null)"; then
  cutoff="$(date -d "+${WINDOW_DAYS} days" +%F)"
fi

echo "Application follow-ups due through $cutoff"
echo

tail -n +2 "$APPLICATIONS_CSV" | awk -F',' \
  -v today="$today" -v cutoff="$cutoff" '
  {
    followup = $12
    status = $11
    if (followup == "" || status == "closed" || status == "rejected") {
      next
    }
    if (followup <= cutoff) {
      marker = (followup < today) ? "OVERDUE" : "due"
      printf "  [%s %s] %s - %s (%s)\n", marker, followup, $2, $3, status
      count += 1
    }
  }
  END {
    if (count == 0) {
      print "  No follow-ups due in this window."
    }
  }
'
