# SQLite Runbook

## Goal

Use SQLite as the lightweight working database for both healthcare projects before moving polished outputs into Power BI.

## Commands

1. Download the source archives:
   `./scripts/download_healthcare_data.sh`
2. Extract the raw files:
   `./scripts/extract_healthcare_data.sh`
3. Filter the population extract to province-level 2025 rows (only needed if the extracted `17100157.csv` doesn't already have it):
   `./scripts/extract_population_province_2025.sh`
4. Build the SQLite database:
   `./scripts/build_healthcare_sqlite.sh`
5. Run the analysis exports:
   `./scripts/run_healthcare_queries.sh`

## Expected Outputs

- `data/processed/healthcare_analytics.sqlite`
- `reports/sqlite/wait_times_summary.csv`
- `reports/sqlite/province_facility_coverage.csv`

## Current Note

If the raw files are missing or the database tables are empty, the runner stops early with a clear message instead of producing misleading outputs.

## Legacy Prototype Scripts

`scripts/build_wait_times_sqlite.sh` and `scripts/run_wait_times_reports.sh` build an earlier, project-1-only database (`data/processed/wait_times_analysis.sqlite`) using `sql/sqlite/05_wait_times_reports.sql`. This predates the unified pipeline above and produces the same `wait_times_summary.csv` output that `build_healthcare_sqlite.sh` + `run_healthcare_queries.sh` already generate via `sql/sqlite/03_analysis_queries.sql`. They are kept for build history rather than deleted, but the numbered steps above are the current, authoritative pipeline — use those, not the legacy pair.
