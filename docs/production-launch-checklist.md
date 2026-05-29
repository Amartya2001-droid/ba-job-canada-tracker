# Production Launch Checklist

Use this checklist during the final week before you start sharing the repo in real applications.

## 1. Portfolio Site Readiness

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

- Replace placeholders in `tracker/first-five-applications.md`.
- Fill `tracker/applications.csv` with five real target roles.
- Keep applications limited to healthcare, public-sector, or adjacent analyst roles with strong stack overlap.

## 4. Messaging QA

- Rehearse the 60-second and 90-second walkthrough for both projects.
- Confirm the Ontario note is described as a resolved source-normalization step.
- Confirm resume bullets, cover note language, and project summaries all tell the same healthcare BA story.

## 5. Public Launch

- Enable GitHub Pages in repository settings.
- Let the Pages workflow publish the repo.
- Add the public portfolio URL to:
  - resume
  - cover note
  - LinkedIn featured section
  - application notes

## Project Is Public-Ready When

- The frontend is deployable and published.
- The final PNG/PDF Power BI exports exist.
- Five real target roles are logged.
- The proof package can be sent without placeholders or caveats.
