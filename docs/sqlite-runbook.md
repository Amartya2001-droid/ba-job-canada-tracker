# SQLite Runbook

## Goal

Use SQLite as the lightweight working database for both healthcare projects before moving polished outputs into Power BI.

## Commands

1. Download the source archives:
   `./scripts/download_healthcare_data.sh`
2. Extract the raw files:
   `./scripts/extract_healthcare_data.sh`
3. Build the SQLite database:
   `./scripts/build_healthcare_sqlite.sh`
4. Run the analysis exports:
   `./scripts/run_healthcare_queries.sh`

## Expected Outputs

- `data/processed/healthcare_analytics.sqlite`
- `reports/sqlite/wait_times_summary.csv`
- `reports/sqlite/province_facility_coverage.csv`

## Current Note

If the raw files are missing or the database tables are empty, the runner stops early with a clear message instead of producing misleading outputs.
