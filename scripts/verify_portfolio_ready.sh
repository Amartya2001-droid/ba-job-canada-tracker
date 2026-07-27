#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
FRONTEND_HTML="$ROOT_DIR/frontend/index.html"
FRONTEND_JS="$ROOT_DIR/frontend/app.js"

required_files=(
  "$ROOT_DIR/docs/production-launch-checklist.md"
  "$ROOT_DIR/docs/github-pages-deployment.md"
  "$ROOT_DIR/docs/project-finish-checklist.md"
  "$ROOT_DIR/docs/final-submission-runbook.md"
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

node --check "$FRONTEND_JS"
"$ROOT_DIR/scripts/check_healthcare_outputs.sh"
"$ROOT_DIR/scripts/check_frontend_links.sh"
"$ROOT_DIR/scripts/export_portfolio_snapshot.sh" >/dev/null

echo "Portfolio readiness checks passed."
