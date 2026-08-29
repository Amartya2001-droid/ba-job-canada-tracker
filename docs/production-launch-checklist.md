# Production Launch Checklist

Use this checklist during the final week before you start sharing the repo in real applications.

## 1. Portfolio Site Readiness

- Run `./scripts/verify_portfolio_ready.sh`.
- Confirm the local dashboard opens from `frontend/index.html`.
- Confirm the dashboard works from a repository subpath, not only from localhost root.
- Confirm the CSV explorer loads both:
  - `reports/sqlite/wait_times_summary.csv`
  - `reports/sqlite/province_facility_coverage.csv`
- Confirm all portfolio asset links open from the dashboard.

## 2. Final Proof Assets

- Export `assets/screenshots/wait-times-dashboard.png`.
- Export `assets/screenshots/access-coverage-dashboard.png`.
- Export `assets/screenshots/healthcare-ba-portfolio.pdf`.
- Keep the SVG preview assets in place as secondary proof.

## 3. Application Inputs

- Done as of 2026-08-16: `tracker/first-five-applications.md` and `tracker/applications.csv` both hold five verified healthcare roles (see `docs/application-shortlist-rationale.md` for apply order).
- Keep applications limited to healthcare, public-sector, or adjacent analyst roles with strong stack overlap as new rows are added.
- Run `./scripts/print_followup_reminders.sh` before each application session to catch due follow-ups.

## 4. Messaging QA

- Rehearse the 60-second and 90-second walkthrough for both projects.
- Confirm the Ontario note is described as a resolved source-normalization step.
- Confirm resume bullets, cover note language, and project summaries all tell the same healthcare BA story.

## 5. Public Launch

- Enable GitHub Pages in repository settings.
- Confirm the `Verify Portfolio Readiness` workflow passes on `main`.
- Let the Pages workflow publish the repo.
- Add the public portfolio URL to:
  - resume
  - cover note
  - LinkedIn featured section
  - application notes

## Project Is Public-Ready When

- The frontend is deployable and published.
- The verification script and workflow both pass.
- The final PNG/PDF Power BI exports exist.
- Five real target roles are logged.
- The proof package can be sent without placeholders or caveats.
