#!/bin/zsh

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
DB_PATH="$ROOT_DIR/data/processed/healthcare_analytics.sqlite"
REPORTS_DIR="$ROOT_DIR/reports/sqlite"

if [[ ! -f "$DB_PATH" ]]; then
  echo "Missing database at $DB_PATH"
  echo "Run scripts/build_healthcare_sqlite.sh first."
  exit 1
fi

mkdir -p "$REPORTS_DIR"

WAIT_COUNT=$(sqlite3 "$DB_PATH" "SELECT COUNT(*) FROM wait_times_raw;")
POP_COUNT=$(sqlite3 "$DB_PATH" "SELECT COUNT(*) FROM population_raw;")
FAC_COUNT=$(sqlite3 "$DB_PATH" "SELECT COUNT(*) FROM facilities_raw;")

if [[ "$WAIT_COUNT" == "0" || "$POP_COUNT" == "0" || "$FAC_COUNT" == "0" ]]; then
  echo "Database exists but one or more raw tables are empty."
  echo "wait_times_raw=$WAIT_COUNT population_raw=$POP_COUNT facilities_raw=$FAC_COUNT"
  exit 1
fi

sqlite3 "$DB_PATH" < "$ROOT_DIR/sql/sqlite/03_analysis_queries.sql"

echo "Generated SQLite reports in $REPORTS_DIR"
