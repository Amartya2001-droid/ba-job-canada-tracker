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

python3 - "$ROOT_DIR" <<'PY'
import pathlib
import sys
sys.path.insert(0, str(pathlib.Path(sys.argv[1]) / 'scripts'))
from application_tracker import read_rows, validate
try:
    rows = read_rows(pathlib.Path(sys.argv[1]) / 'tracker/applications.csv')
    validate(rows)
    if len(rows) < 5:
        raise ValueError(f'Expected at least 5 valid target rows, found {len(rows)}.')
except (ValueError, OSError) as error:
    sys.exit(str(error))
PY

echo "Application readiness checks passed."
