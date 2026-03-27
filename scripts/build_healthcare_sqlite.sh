#!/bin/zsh

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
DB_PATH="$ROOT_DIR/data/processed/healthcare_analytics.sqlite"
EXTRACTED_DIR="$ROOT_DIR/data/raw/extracted"

WAIT_TIMES_CSV="$EXTRACTED_DIR/13100701.csv"
POPULATION_CSV="$EXTRACTED_DIR/17100157.csv"
FACILITIES_CSV="$EXTRACTED_DIR/ODHF_v1.1/odhf_v1.1.csv"

if [[ ! -f "$WAIT_TIMES_CSV" || ! -f "$POPULATION_CSV" || ! -f "$FACILITIES_CSV" ]]; then
  echo "Missing extracted source files in $EXTRACTED_DIR"
  echo "Run scripts/download_healthcare_data.sh and scripts/extract_healthcare_data.sh first."
  exit 1
fi

mkdir -p "$ROOT_DIR/data/processed"
rm -f "$DB_PATH"

sqlite3 "$DB_PATH" < "$ROOT_DIR/sql/sqlite/01_create_tables.sql"

sqlite3 "$DB_PATH" <<SQLITE_IMPORT
.mode csv
.import --skip 1 "$WAIT_TIMES_CSV" wait_times_raw
.import --skip 1 "$POPULATION_CSV" population_raw
.import --skip 1 "$FACILITIES_CSV" facilities_raw
SQLITE_IMPORT

sqlite3 "$DB_PATH" < "$ROOT_DIR/sql/sqlite/02_create_views.sql"

echo "Built SQLite database at $DB_PATH"
