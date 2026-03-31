#!/bin/zsh

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
DB_PATH="$ROOT_DIR/data/processed/healthcare_analytics.sqlite"
WAIT_TIMES_CSV="$ROOT_DIR/data/raw/extracted/13100701.csv"
POPULATION_CSV="$ROOT_DIR/data/raw/extracted/17100157_province_population_2025.csv"
FACILITIES_CSV="$ROOT_DIR/data/raw/extracted/ODHF_v1.1/odhf_v1.1.csv"

if [[ ! -f "$WAIT_TIMES_CSV" || ! -f "$POPULATION_CSV" || ! -f "$FACILITIES_CSV" ]]; then
  echo "Missing one or more required extracted CSV files."
  echo "Run scripts/extract_population_province_2025.sh if the filtered population CSV is missing."
  exit 1
fi

mkdir -p "$ROOT_DIR/data/processed"
rm -f "$DB_PATH"

sqlite3 "$DB_PATH" ".mode csv" ".import $WAIT_TIMES_CSV wait_times_csv" ".import $POPULATION_CSV population_csv" ".import $FACILITIES_CSV facilities_csv"

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

DROP VIEW IF EXISTS population_clean;
CREATE VIEW population_clean AS
SELECT
  "REF_DATE" AS ref_date,
  "GEO" AS geography,
  "DGUID" AS dguid,
  "Age group" AS age_group,
  Gender AS gender,
  CAST("VALUE" AS REAL) AS population_value
FROM population_csv;

DROP VIEW IF EXISTS facilities_clean;
CREATE VIEW facilities_clean AS
SELECT
  "index" AS facility_index,
  facility_name,
  source_facility_type,
  odhf_facility_type,
  provider,
  city,
  UPPER(province) AS province_code,
  "CSDname" AS csd_name,
  "CSDuid" AS csd_uid,
  "Pruid" AS pruid,
  latitude,
  longitude
FROM facilities_csv;
SQL

echo "Built SQLite database at $DB_PATH"
