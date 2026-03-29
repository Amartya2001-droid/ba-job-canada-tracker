#!/bin/zsh

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
DB_PATH="$ROOT_DIR/data/processed/wait_times_analysis.sqlite"
REPORTS_DIR="$ROOT_DIR/reports/sqlite"

if [[ ! -f "$DB_PATH" ]]; then
  echo "Missing database at $DB_PATH"
  echo "Run scripts/build_wait_times_sqlite.sh first."
  exit 1
fi

mkdir -p "$REPORTS_DIR"
ROW_COUNT=$(sqlite3 "$DB_PATH" "SELECT COUNT(*) FROM wait_times_csv;")

if [[ "$ROW_COUNT" == "0" ]]; then
  echo "Wait-times table is empty."
  exit 1
fi

sqlite3 "$DB_PATH" < "$ROOT_DIR/sql/sqlite/05_wait_times_reports.sql"

echo "Generated wait-times report in $REPORTS_DIR/wait_times_summary.csv"
