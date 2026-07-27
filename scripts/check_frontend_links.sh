#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
FRONTEND_HTML="$ROOT_DIR/frontend/index.html"
ROOT_INDEX="$ROOT_DIR/index.html"
FRONTEND_JS="$ROOT_DIR/frontend/app.js"

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

required_frontend_refs=(
  '../docs/production-launch-checklist.md'
  '../docs/github-pages-deployment.md'
  '../docs/final-submission-runbook.md'
  '../tracker/first-five-applications.md'
  '../tracker/applications.csv'
  '../reports/portfolio/portfolio_snapshot.json'
)

for ref in "${required_frontend_refs[@]}"; do
  if ! grep -q "$ref" "$FRONTEND_HTML" && ! grep -q "$ref" "$FRONTEND_JS"; then
    echo "Missing expected frontend reference: $ref"
    exit 1
  fi
done

echo "Frontend link checks passed."
