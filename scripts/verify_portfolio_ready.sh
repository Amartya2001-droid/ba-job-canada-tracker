#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
FRONTEND_HTML="$ROOT_DIR/frontend/index.html"
FRONTEND_JS="$ROOT_DIR/frontend/app.js"
ROOT_INDEX="$ROOT_DIR/index.html"

required_files=(
  "$ROOT_DIR/docs/production-launch-checklist.md"
  "$ROOT_DIR/docs/github-pages-deployment.md"
  "$ROOT_DIR/docs/project-finish-checklist.md"
  "$ROOT_DIR/reports/sqlite/wait_times_summary.csv"
  "$ROOT_DIR/reports/sqlite/province_facility_coverage.csv"
  "$ROOT_DIR/assets/screenshots/wait-times-dashboard-preview.svg"
  "$ROOT_DIR/assets/screenshots/access-coverage-dashboard-preview.svg"
)

for file in "${required_files[@]}"; do
  if [[ ! -f "$file" ]]; then
    echo "Missing required file: $file"
    exit 1
  fi
done

if grep -nE 'href="/|src="/' "$FRONTEND_HTML" >/dev/null; then
  echo "Frontend HTML still contains root-absolute asset links."
  exit 1
fi

if grep -nE 'url=/frontend|href="/frontend|content="0; url=/frontend' "$ROOT_INDEX" >/dev/null; then
  echo "Root index still redirects with a root-absolute frontend path."
  exit 1
fi

if grep -n 'fetch("/' "$FRONTEND_JS" >/dev/null; then
  echo "Frontend JS still fetches root-absolute paths."
  exit 1
fi

if ! grep -q '../docs/production-launch-checklist.md' "$FRONTEND_HTML"; then
  echo "Frontend launch checklist link is missing."
  exit 1
fi

if ! grep -q '../docs/github-pages-deployment.md' "$FRONTEND_HTML"; then
  echo "Frontend deployment guide link is missing."
  exit 1
fi

node --check "$FRONTEND_JS"
"$ROOT_DIR/scripts/check_healthcare_outputs.sh"

echo "Portfolio readiness checks passed."
