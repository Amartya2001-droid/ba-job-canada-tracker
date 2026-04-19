#!/bin/zsh

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
TMP_DB="/tmp/population-province-2025.sqlite"
OUTPUT_CSV="$ROOT_DIR/data/raw/extracted/17100157_province_population_2025.csv"
SOURCE_CANDIDATES=(
  "$ROOT_DIR/data/raw/extracted/17100157.csv"
  "$ROOT_DIR/../ba-job-canada-tracker/data/raw/extracted/17100157.csv"
)

SOURCE_CSV=""
for candidate in "${SOURCE_CANDIDATES[@]}"; do
  if [[ -f "$candidate" && "$(wc -l < "$candidate" | tr -d ' ')" -gt 1 ]]; then
    SOURCE_CSV="$candidate"
    break
  fi
done

if [[ -z "$SOURCE_CSV" ]]; then
  echo "Missing full source CSV. Checked:"
  printf ' - %s\n' "${SOURCE_CANDIDATES[@]}"
  exit 1
fi

mkdir -p "$ROOT_DIR/data/raw/extracted"
rm -f "$TMP_DB"

sqlite3 "$TMP_DB" ".mode csv" ".import $SOURCE_CSV population_csv"
sqlite3 -header -csv "$TMP_DB" "
SELECT
  REF_DATE,
  CASE
    WHEN GEO = 'Ontario by Ontario Health Region' THEN 'Ontario'
    ELSE GEO
  END AS GEO,
  DGUID,
  \"Age group\",
  Gender,
  VALUE
FROM population_csv
WHERE REF_DATE = '2025'
  AND DGUID LIKE '2021A0002%'
  AND \"Age group\" = 'Total, all ages'
  AND Gender = 'Total - gender'
  AND (
    GEO IN (
      'Newfoundland and Labrador',
      'Prince Edward Island',
      'Nova Scotia',
      'New Brunswick',
      'Quebec',
      'Ontario',
      'Manitoba',
      'Saskatchewan',
      'Alberta',
      'British Columbia'
    )
    OR GEO = 'Ontario by Ontario Health Region'
  )
ORDER BY GEO;" > "$OUTPUT_CSV"

echo "Wrote filtered population extract to $OUTPUT_CSV"
