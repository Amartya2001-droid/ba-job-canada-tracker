# Final Submission Runbook

Use this when you are about to finish the portfolio and start sending real applications.

## 0. Quick Status Snapshot

Run:

```bash
./scripts/print_finish_status.sh
```

This gives one summary view of:

- healthcare output validation
- portfolio readiness
- application readiness
- tracker consistency
- final PNG/PDF export presence

## 1. Confirm Data Outputs

Run:

```bash
./scripts/check_healthcare_outputs.sh
```

This confirms the healthcare CSV outputs are still valid.

## 2. Confirm Portfolio Readiness

Run:

```bash
./scripts/verify_portfolio_ready.sh
```

This confirms the frontend, required docs, preview assets, and report outputs are in place.

## 3. Confirm Application Readiness

Run:

```bash
./scripts/check_tracker_consistency.sh
./scripts/check_application_readiness.sh
```

These confirm:

- `tracker/first-five-applications.md` no longer has placeholders
- `tracker/applications.csv` has at least 5 real rows
- key application fields are filled for each real row
- duplicate job links are not being tracked twice
- follow-up dates stay in `YYYY-MM-DD` format

If you want help generating a real row quickly, use:

```bash
./scripts/add_application_entry.sh --help
```

This prints a copy-ready CSV row and markdown block for one real job entry, and it can also append to both tracker files directly.

If you want the homepage snapshot to reflect your latest state, run:

```bash
./scripts/export_portfolio_snapshot.sh
```

## 4. Final Manual Checks

- Final Power BI PNG exports exist in `assets/screenshots/`
- Final Power BI PDF export exists in `assets/screenshots/`
- GitHub Pages is enabled and the public dashboard URL loads
- Resume and cover note link the repo or public dashboard URL

## 5. Ready To Apply

Once all three commands pass and the manual checks are done, the portfolio is ready for selective applications.
