#!/bin/zsh

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
DB_PATH="$ROOT_DIR/data/processed/wait_times_analysis.sqlite"
WAIT_TIMES_CSV="$ROOT_DIR/data/raw/extracted/13100701.csv"

if [[ ! -f "$WAIT_TIMES_CSV" ]]; then
  echo "Missing wait-times CSV at $WAIT_TIMES_CSV"
  exit 1
fi

mkdir -p "$ROOT_DIR/data/processed"
rm -f "$DB_PATH"

sqlite3 "$DB_PATH" ".mode csv" ".import $WAIT_TIMES_CSV wait_times_csv"

sqlite3 "$DB_PATH" <<'SQL'
DROP VIEW IF EXISTS wait_times_clean;
CREATE VIEW wait_times_clean AS
SELECT
  "REF_DATE" AS ref_date,
  "GEO" AS geo,
  "DGUID" AS dguid,
  "Type of specialized service" AS service_type,
  "Percentile" AS percentile_label,
  "Characteristics" AS characteristic_label,
  "UOM" AS uom,
  CAST("VALUE" AS REAL) AS value
FROM wait_times_csv;
SQL

echo "Built wait-times SQLite database at $DB_PATH"
