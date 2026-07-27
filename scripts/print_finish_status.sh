#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

healthcare_outputs_ok=0
portfolio_ready_ok=0
application_ready_ok=0
tracker_consistency_ok=0
missing_assets=0

run_check() {
  local label="$1"
  local command="$2"
  local key="$3"

  if output=$(eval "$command" 2>&1); then
    printf '[PASS] %s\n' "$label"
    if [[ -n "$output" ]]; then
      printf '       %s\n' "$output"
    fi
    case "$key" in
      healthcare_outputs) healthcare_outputs_ok=1 ;;
      portfolio_ready) portfolio_ready_ok=1 ;;
      application_ready) application_ready_ok=1 ;;
      tracker_consistency) tracker_consistency_ok=1 ;;
    esac
  else
    printf '[PENDING] %s\n' "$label"
    printf '          %s\n' "$output"
  fi
}

check_asset() {
  local label="$1"
  local path="$2"

  if [[ -f "$path" ]]; then
    printf '[PASS] %s\n' "$label"
    printf '       %s\n' "${path#$ROOT_DIR/}"
  else
    missing_assets=$((missing_assets + 1))
    printf '[PENDING] %s\n' "$label"
    printf '          Missing %s\n' "${path#$ROOT_DIR/}"
  fi
}

echo "Healthcare BA Portfolio Finish Status"
echo

run_check "Healthcare data outputs" "\"$ROOT_DIR/scripts/check_healthcare_outputs.sh\"" "healthcare_outputs"
run_check "Portfolio readiness" "\"$ROOT_DIR/scripts/verify_portfolio_ready.sh\"" "portfolio_ready"
run_check "Application readiness" "\"$ROOT_DIR/scripts/check_application_readiness.sh\"" "application_ready"
run_check "Tracker consistency" "\"$ROOT_DIR/scripts/check_tracker_consistency.sh\"" "tracker_consistency"

echo
echo "Final export assets"

check_asset "Wait Times PNG export" "$ROOT_DIR/assets/screenshots/wait-times-dashboard.png"
check_asset "Access Coverage PNG export" "$ROOT_DIR/assets/screenshots/access-coverage-dashboard.png"
check_asset "Portfolio PDF export" "$ROOT_DIR/assets/screenshots/healthcare-ba-portfolio.pdf"

echo
echo "Next best move"

if (( missing_assets > 0 )); then
  echo "Export the final Power BI assets into assets/screenshots/."
elif (( application_ready_ok == 0 || tracker_consistency_ok == 0 )); then
  echo "Replace the placeholder application targets and log five real healthcare roles."
elif (( healthcare_outputs_ok == 1 && portfolio_ready_ok == 1 )); then
  echo "Run the final rehearsal and begin selective applications for strong-match roles."
else
  echo "Resolve the remaining validator output above before final submission."
fi

echo
echo "When everything above is PASS, the portfolio is ready for final submission."
