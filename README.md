# BA Job Canada Tracker

This repository tracks a 7-day sprint to become job-ready for a fresher Business Analyst role in Canada.

## Goal

Build proof of work for a Canadian healthcare focus, turn public data into portfolio-ready analysis, and track targeted applications.

## Current Portfolio Snapshot

- Built 2 healthcare-focused analysis projects with Canadian public data.
- Generated 2 SQLite-backed CSV outputs ready for Power BI.
- Added a local frontend dashboard to preview project progress and explore report outputs.
- Drafted recruiter-facing assets including resume bullets, interview stories, cover-note variants, and dashboard build notes.
- Maintained a commit trail so the repo shows consistent project progress.

## Sprint Focus

- Target role: Business Analyst
- Target market: Canada
- Timeline: 7 days
- Current industry focus: Healthcare
- Primary stack: SQL + Power BI
- Selected datasets:
  - Statistics Canada Table 13-10-0701-01 for healthcare wait times
  - Statistics Canada ODHF + Table 17-10-0157-01 for facility access analysis

## Dashboard Preview

Run the local dashboard from the repository root:

```bash
./scripts/serve_frontend.sh 4174
```

Then open:

```text
http://127.0.0.1:4174/frontend/index.html
```

The frontend includes project summaries, direct links to portfolio assets, a live CSV explorer that reads files from `reports/sqlite/`, a live finish gate for final export assets, and a live application board plus summary fed by `tracker/applications.csv`.

## Production Path

The frontend has been updated to use deploy-safe relative paths, and the repo now includes a GitHub Pages workflow for publishing the dashboard as a static portfolio site.

- Launch checklist: `docs/production-launch-checklist.md`
- Deployment guide: `docs/github-pages-deployment.md`
- Submission runbook: `docs/final-submission-runbook.md`
- Finish status script: `scripts/print_finish_status.sh`
- Verification script: `scripts/verify_portfolio_ready.sh`
- Application readiness script: `scripts/check_application_readiness.sh`
- Verification workflow: `.github/workflows/verify-portfolio.yml`
- Workflow: `.github/workflows/deploy-pages.yml`

## Visual Proof Assets

Repo-native dashboard previews are available while the final Power BI PNG/PDF exports are pending:

- `assets/screenshots/wait-times-dashboard-preview.svg`
- `assets/screenshots/access-coverage-dashboard-preview.svg`

## Finish Gate

Use `docs/project-finish-checklist.md` to see what is still left before the project is fully finished.

## Repo Structure

- `data/` - raw and processed data intake notes
- `docs/` - planning notes, learning notes, and strategy documents
- `frontend/` - local portfolio dashboard for browsing project progress and CSV outputs
- `projects/` - project briefs, dataset notes, and deliverables
- `reports/` - generated CSV outputs for analysis and dashboarding
- `sql/` - starter SQL scripts for staging, cleaning, and KPI generation
- `tracker/` - daily progress, applications, and networking logs
- `templates/` - reusable templates for LinkedIn posts and project writeups

## Immediate Priorities

Use `docs/final-5-day-finish-plan.md` for the current closing-stretch sequence.

1. Convert the SQLite outputs into two Power BI pages.
2. Add screenshots or exports back into the repo once the Power BI pages are built.
3. Build the final Power BI screenshots and save them in `assets/screenshots/`.
4. Keep the frontend dashboard updated as the portfolio homepage.
5. Publish the dashboard through GitHub Pages once the final QA pass is complete.
6. Apply only to jobs with 70%+ stack overlap once the project artifacts are polished.

## How We Will Use This Repo

- Update `tracker/daily-progress.md` every day.
- Update `tracker/applications.csv` for each application.
- Update `tracker/networking.csv` for each outreach.
- Create one folder per project inside `projects/`.
- Use `docs/healthcare-positioning.md` to keep resume, LinkedIn, and portfolio messaging aligned.
- Use `docs/sql-powerbi-workflow.md` as the default build process for both projects.
- Use `scripts/build_healthcare_sqlite.sh` to create a local SQLite database after the raw files are extracted.
- Use `scripts/check_healthcare_outputs.sh` after report generation to confirm the expected wait-time and province coverage outputs are present.
- Use `docs/application-proof-checklist.md` before sending applications so every role includes the right proof links.
- Use `docs/send-ready-application-package.md` when you are actually about to submit a role.
- Use `docs/production-launch-checklist.md` before publishing the dashboard publicly.
- Use `docs/github-pages-deployment.md` when enabling the public portfolio URL.
- Use `scripts/print_finish_status.sh` when you want one quick snapshot of what is still missing.
- Use `scripts/verify_portfolio_ready.sh` before pushing final launch changes.
- Use `scripts/check_application_readiness.sh` before sending the first real application batch.

## Next Step

Build the Power BI dashboard pages from `docs/powerbi-implementation-guide.md`, export the final PNG/PDF assets, and then publish the dashboard through GitHub Pages.
