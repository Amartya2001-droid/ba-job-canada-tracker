#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
OUTPUT_PATH="$ROOT_DIR/reports/portfolio/portfolio_snapshot.json"
APPLICATIONS_CSV="$ROOT_DIR/tracker/applications.csv"

mkdir -p "$(dirname "$OUTPUT_PATH")"

count_existing_files() {
  local count=0
  local path
  for path in "$@"; do
    if [[ -f "$path" ]]; then
      count=$((count + 1))
    fi
  done
  printf '%s' "$count"
}

json_escape() {
  local value="${1:-}"
  value="${value//\\/\\\\}"
  value="${value//\"/\\\"}"
  value="${value//$'\n'/\\n}"
  value="${value//$'\r'/\\r}"
  value="${value//$'\t'/\\t}"
  printf '%s' "$value"
}

count_application_rows() {
  if [[ ! -f "$APPLICATIONS_CSV" ]]; then
    printf '0'
    return
  fi

  tail -n +2 "$APPLICATIONS_CSV" | awk -F',' '
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
  '
}

final_asset_paths=(
  "$ROOT_DIR/assets/screenshots/wait-times-dashboard.png"
  "$ROOT_DIR/assets/screenshots/access-coverage-dashboard.png"
  "$ROOT_DIR/assets/screenshots/healthcare-ba-portfolio.pdf"
)

preview_asset_paths=(
  "$ROOT_DIR/assets/screenshots/wait-times-dashboard-preview.svg"
  "$ROOT_DIR/assets/screenshots/access-coverage-dashboard-preview.svg"
)

required_doc_paths=(
  "$ROOT_DIR/docs/production-launch-checklist.md"
  "$ROOT_DIR/docs/github-pages-deployment.md"
  "$ROOT_DIR/docs/project-finish-checklist.md"
  "$ROOT_DIR/docs/final-submission-runbook.md"
  "$ROOT_DIR/docs/application-proof-checklist.md"
)

final_assets_present="$(count_existing_files "${final_asset_paths[@]}")"
preview_assets_present="$(count_existing_files "${preview_asset_paths[@]}")"
required_docs_present="$(count_existing_files "${required_doc_paths[@]}")"
application_rows="$(count_application_rows)"
generated_at="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"

healthcare_outputs_ready="false"
if "$ROOT_DIR/scripts/check_healthcare_outputs.sh" >/dev/null 2>&1; then
  healthcare_outputs_ready="true"
fi

tracker_ready="false"
if "$ROOT_DIR/scripts/check_application_readiness.sh" >/dev/null 2>&1; then
  tracker_ready="true"
fi

frontend_ready="false"
if node --check "$ROOT_DIR/frontend/app.js" >/dev/null 2>&1; then
  frontend_ready="true"
fi

pending_items=()
if [[ "$final_assets_present" -lt 3 ]]; then
  pending_items+=("final_power_bi_exports")
fi
if [[ "$application_rows" -lt 5 ]]; then
  pending_items+=("first_five_real_applications")
fi
if [[ "$tracker_ready" != "true" ]]; then
  pending_items+=("application_readiness")
fi

pending_json=""
if [[ "${#pending_items[@]}" -gt 0 ]]; then
  local_items=()
  for item in "${pending_items[@]}"; do
    local_items+=("\"$(json_escape "$item")\"")
  done
  pending_json="$(IFS=,; printf '%s' "${local_items[*]}")"
fi

cat >"$OUTPUT_PATH" <<EOF
{
  "generated_at": "$(json_escape "$generated_at")",
  "industry_focus": "Healthcare",
  "primary_stack": "SQL + Power BI",
  "healthcare_outputs_ready": $healthcare_outputs_ready,
  "frontend_ready": $frontend_ready,
  "tracker_ready": $tracker_ready,
  "final_assets_present": $final_assets_present,
  "final_assets_expected": 3,
  "preview_assets_present": $preview_assets_present,
  "preview_assets_expected": 2,
  "required_docs_present": $required_docs_present,
  "required_docs_expected": 5,
  "application_rows": $application_rows,
  "application_rows_target": 5,
  "pending_items": [${pending_json}]
}
EOF

echo "Wrote reports/portfolio/portfolio_snapshot.json"
