#!/bin/zsh

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
WAIT_TIMES_CSV="$ROOT_DIR/reports/sqlite/wait_times_summary.csv"
COVERAGE_CSV="$ROOT_DIR/reports/sqlite/province_facility_coverage.csv"

if [[ ! -f "$WAIT_TIMES_CSV" || ! -f "$COVERAGE_CSV" ]]; then
  echo "Missing one or more report CSV outputs."
  echo "Run scripts/run_healthcare_queries.sh first."
  exit 1
fi

WAIT_ROWS=$(tail -n +2 "$WAIT_TIMES_CSV" | wc -l | tr -d ' ')
COVERAGE_ROWS=$(tail -n +2 "$COVERAGE_CSV" | wc -l | tr -d ' ')

if [[ "$WAIT_ROWS" != "3" ]]; then
  echo "Expected 3 wait-time service rows, found $WAIT_ROWS."
  exit 1
fi

if [[ "$COVERAGE_ROWS" != "10" ]]; then
  echo "Expected 10 province coverage rows, found $COVERAGE_ROWS."
  exit 1
fi

if ! grep -q '"Non-emergency surgeries",4.3,26.0,34.7' "$WAIT_TIMES_CSV"; then
  echo "Wait-times output is missing the expected non-emergency surgery benchmark."
  exit 1
fi

if ! grep -q '^2025,Ontario,2695,16258260.0,16.58' "$COVERAGE_CSV"; then
  echo "Coverage output is missing the normalized Ontario row."
  exit 1
fi

echo "Healthcare report outputs passed validation."
