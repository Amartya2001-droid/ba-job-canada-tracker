# Project Finish Checklist

Use this as the final completion gate for the healthcare BA portfolio.

## Already Done

- Two healthcare-focused SQL/SQLite projects are built.
- Wait-times and access-coverage CSV outputs are generated and validated.
- Ontario is included in the access coverage output after source-label normalization.
- Frontend dashboard is live locally and links the supporting portfolio assets.
- Frontend dashboard is now deploy-safe for static hosting and GitHub Pages.
- Frontend dashboard now includes a live finish gate for final exports and application-row progress.
- Repo-native dashboard preview SVGs exist for both projects.
- Resume, interview, application, and cover-note support docs exist.
- A final submission runbook and application-readiness validator now exist.
- A finish-status summary script now exists for one-command last-mile checks.

## Still Left Before Calling The Project Finished

### 1. Final Power BI exports

- Build the final Power BI page for wait times.
- Build the final Power BI page for access coverage.
- Export:
  - `assets/screenshots/wait-times-dashboard.png`
  - `assets/screenshots/access-coverage-dashboard.png`
  - `assets/screenshots/healthcare-ba-portfolio.pdf`

### 2. First five real application targets

- Replace placeholders in `tracker/first-five-applications.md`.
- Fill `tracker/applications.csv` with real companies, job links, stack match, and follow-up dates.
- Keep applications limited to strong healthcare/public-sector/analytics fits.

### 3. Final interview packaging

- Rehearse 60-second and 90-second stories for both projects.
- Be ready to explain:
  - why healthcare
  - why percentile waits matter
  - why normalized access metrics matter
  - how the Ontario source-label issue was resolved
- Use `docs/final-interview-walkthrough-kit.md` as the speaking script and rehearsal source.

### 4. Send-ready proof package

- Repo link
- Public dashboard URL
- Frontend dashboard
- Two preview SVGs
- Final Power BI PNGs
- Final Power BI PDF
- One tailored cover note

### 5. Public launch

- Enable GitHub Pages and confirm the public portfolio URL works.
- Run `docs/production-launch-checklist.md`.
- Confirm the published dashboard opens assets and CSV outputs correctly.

### 6. Application validation

- Run `scripts/check_application_readiness.sh`.
- Confirm the first five worksheet has no placeholders.
- Confirm `applications.csv` has 5 real rows with key fields filled.

## Project Is Finished When

- The final Power BI PNG/PDF assets exist in `assets/screenshots/`.
- The dashboard is published and opens correctly from the public Pages URL.
- The first five target roles are filled with real links and notes.
- The application proof checklist can be completed without placeholders.
