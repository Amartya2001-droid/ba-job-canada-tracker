#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
if [[ $# -gt 1 || ! "${1:-7}" =~ ^[0-9]+$ ]]; then
  echo "Usage: $0 [window-days]" >&2
  exit 1
fi
exec python3 "$ROOT_DIR/scripts/followup_reminders.py" "$ROOT_DIR/tracker/applications.csv" "${1:-7}"
