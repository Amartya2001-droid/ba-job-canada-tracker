# Project Status

| Project | Status | Current Focus | Next Action |
| --- | --- | --- | --- |
| Canadian Healthcare Wait Times Analysis | Analysis ready | SQLite build and report pipeline works locally | Build the Power BI page and export a portfolio screenshot |
| Canadian Healthcare Access Dashboard | Analysis ready | Province population extract includes Ontario after source-label normalization | Build the Power BI page and include the Ontario normalization note |
| Portfolio Frontend Dashboard | Deploy-ready | Dashboard now works locally and from a repository subpath, with project summaries, assets, live CSV outputs, a finish coach, export locker, persistent entry helper draft, export workflow, and a live finish gate | Publish through GitHub Pages after final QA and screenshot export |
| Portfolio Snapshot Feed | Ready | A machine-readable snapshot can now be generated for frontend and validation use | Refresh it after tracker or asset changes so the homepage stays current |
| Public Portfolio Deployment | Ready to enable | GitHub Pages workflow, `.nojekyll`, launch checklist, deployment guide, and verification workflow are in place | Enable Pages in repo settings, confirm verification passes, and confirm the public URL |
| Application Readiness Gate | Passing | The first five real healthcare roles are logged and all placeholder checks pass as of 2026-08-16 | Keep the gate green as new applications are appended |
| Tracker Consistency Gate | Ready | Duplicate job links, malformed follow-up dates, and weak application rows can now be caught before submission | Run it before trusting the first tracked application batch |
| Live Application Board | Ready | Frontend now reads `applications.csv` and can surface the first real roles plus application summary metrics directly in the portfolio | Fill real application rows so the board turns into visible proof of selective job targeting |
| Application Entry Helper | Ready | Frontend can now generate copy-ready CSV and markdown snippets for a real job entry, save draft values locally, and preload a healthcare sample row | Use it to fill the first five application rows faster and with less formatting friction |
| CLI Application Entry Helper | Ready | Terminal helper can now generate, append CSV, and append numbered worksheet blocks for a real application row | Use it when adding real roles directly into the tracker files |
| Finish Status Summary | Ready | One command now summarizes validators plus final asset presence | Use it during the final week to track what is still blocking completion |
| Power BI Export Pack | Preview-ready | SVG previews exist and final PNG/PDF paths are documented | Build dashboards and save polished Power BI exports into `assets/screenshots/` |
| Final 5-Day Finish Plan | Active | Remaining work is sequenced into export, story, application, interview, and outreach days | Execute Day 1 by exporting the final Power BI visuals |
| Job Application System | Targets logged | First five real healthcare roles are shortlisted with links, posted dates, and stretch scores in the tracker | Apply to PHSA first, then work down the shortlist once Power BI exports are done |
| Networking Outreach Workflow | Ready | Field standards and a personalized message template with target-company openers now exist for `tracker/networking.csv` | Log the first real networking message once sent |
| Networking Tracker Validator | Ready | `scripts/check_networking_tracker.sh` catches malformed dates and incomplete rows without blocking the finish gate | Run it after logging each networking row |
