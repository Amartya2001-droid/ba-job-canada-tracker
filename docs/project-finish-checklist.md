# Project Finish Checklist

Use this as the final completion gate for the healthcare BA portfolio.

## Already Done

- Two healthcare-focused SQL/SQLite projects are built.
- Wait-times and access-coverage CSV outputs are generated and validated.
- Ontario is included in the access coverage output after source-label normalization.
- Frontend dashboard is live locally and links the supporting portfolio assets.
- Frontend dashboard is now deploy-safe for static hosting and GitHub Pages.
- Frontend dashboard now includes a generated portfolio snapshot section and command center.
- Frontend dashboard now includes a live finish gate for final exports and application-row progress.
- Frontend dashboard now includes a finish coach and export locker so the next blocker is visible immediately.
- Frontend dashboard now includes a live application board and summary fed by `tracker/applications.csv`.
- Frontend dashboard now includes an application entry helper for generating CSV and markdown tracker entries, saving drafts locally, and preloading a healthcare sample row.
- A CLI application entry helper now exists for generating or appending real CSV rows.
- Dedicated frontend-link and tracker-consistency validators now exist for the final stretch.
- Repo-native dashboard preview SVGs exist for both projects.
- Resume, interview, application, and cover-note support docs exist.
- A final submission runbook and application-readiness validator now exist.
- A finish-status summary script now exists for one-command last-mile checks.
- The first five real application targets are logged as of 2026-08-16: `tracker/first-five-applications.md` and `tracker/applications.csv` both hold five verified healthcare postings with links, posted dates, stack-match scores, and follow-up dates. Rationale and apply order are documented in `docs/application-shortlist-rationale.md`.
- `scripts/check_application_readiness.sh` and `scripts/check_tracker_consistency.sh` both pass.

## Still Left Before Calling The Project Finished

### 1. Final Power BI exports

- Build the final Power BI page for wait times.
- Build the final Power BI page for access coverage.
- Export:
  - `assets/screenshots/wait-times-dashboard.png`
  - `assets/screenshots/access-coverage-dashboard.png`
  - `assets/screenshots/healthcare-ba-portfolio.pdf`

### 2. Final interview packaging

- Rehearse 60-second and 90-second stories for both projects.
- Be ready to explain:
  - why healthcare
  - why percentile waits matter
  - why normalized access metrics matter
  - how the Ontario source-label issue was resolved
- Use `docs/final-interview-walkthrough-kit.md` as the speaking script and rehearsal source.

### 3. Send-ready proof package

- Repo link
- Public dashboard URL
- Frontend dashboard
- Two preview SVGs
- Final Power BI PNGs
- Final Power BI PDF
- One tailored cover note

### 4. Public launch

- Enable GitHub Pages and confirm the public portfolio URL works.
- Run `docs/production-launch-checklist.md`.
- Confirm the published dashboard opens assets and CSV outputs correctly.

## Project Is Finished When

- The final Power BI PNG/PDF assets exist in `assets/screenshots/`.
- The dashboard is published and opens correctly from the public Pages URL.
- The application proof checklist can be completed without placeholders.
