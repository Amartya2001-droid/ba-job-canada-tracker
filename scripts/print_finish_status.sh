#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

run_check() {
  local label="$1"
  local command="$2"

  if output=$(eval "$command" 2>&1); then
    printf '[PASS] %s\n' "$label"
    if [[ -n "$output" ]]; then
      printf '       %s\n' "$output"
    fi
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
    printf '[PENDING] %s\n' "$label"
    printf '          Missing %s\n' "${path#$ROOT_DIR/}"
  fi
}

echo "Healthcare BA Portfolio Finish Status"
echo

run_check "Healthcare data outputs" "\"$ROOT_DIR/scripts/check_healthcare_outputs.sh\""
run_check "Portfolio readiness" "\"$ROOT_DIR/scripts/verify_portfolio_ready.sh\""
run_check "Application readiness" "\"$ROOT_DIR/scripts/check_application_readiness.sh\""

echo
echo "Final export assets"

check_asset "Wait Times PNG export" "$ROOT_DIR/assets/screenshots/wait-times-dashboard.png"
check_asset "Access Coverage PNG export" "$ROOT_DIR/assets/screenshots/access-coverage-dashboard.png"
check_asset "Portfolio PDF export" "$ROOT_DIR/assets/screenshots/healthcare-ba-portfolio.pdf"

echo
echo "When everything above is PASS, the portfolio is ready for final submission."
