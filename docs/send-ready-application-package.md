# Send-Ready Application Package

Use this file when you are about to submit a real application.

## What To Open Before Applying

- `docs/application-proof-checklist.md`
- `docs/application-shortlist-rationale.md` (apply order and why each role was chosen)
- `docs/final-interview-walkthrough-kit.md`
- `tracker/first-five-applications.md`
- `tracker/applications.csv`

## Proof Package

- GitHub repository
- Frontend dashboard
- Wait times preview SVG
- Access coverage preview SVG
- Final Power BI PNGs when available
- Final Power BI PDF when available

## Default Assets To Reference

- `assets/screenshots/wait-times-dashboard-preview.svg`
- `assets/screenshots/access-coverage-dashboard-preview.svg`
- `assets/screenshots/healthcare-ba-portfolio.pdf` once exported

## Minimum Application Standard

- The role has at least a 70% tool-stack match.
- The posting uses healthcare, reporting, KPI, operations, analytics, or stakeholder language.
- The application worksheet has a clear project bullet and proof asset selected.
- The CSV tracker row is filled before submitting.

## After Submitting

- Add a row to `tracker/applications.csv`
- Set a follow-up date
- Record any custom note about the role, hiring team, or screening question

## Tracking Follow-Ups

Run `./scripts/print_followup_reminders.sh` (optionally pass a window in days, e.g. `7`) to see which logged applications have a follow-up due or overdue.
