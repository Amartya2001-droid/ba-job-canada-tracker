#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
NETWORKING_CSV="$ROOT_DIR/tracker/networking.csv"

if [[ ! -f "$NETWORKING_CSV" ]]; then
  echo "Missing tracker/networking.csv."
  exit 1
fi

exec python3 "$ROOT_DIR/scripts/networking_tracker.py" "$NETWORKING_CSV"
