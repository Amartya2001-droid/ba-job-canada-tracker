# Daily Progress

## Day 1

- [x] Created tracking repository
- [x] Confirm target industry: Healthcare
- [x] Pick primary tool stack: SQL + Power BI
- [x] Choose 2 Canadian datasets

## Day 2

- [x] Create data workspace structure
- [x] Create starter SQL workspace
- [x] Download source extracts
- [x] Inspect real columns and update SQL templates
- [x] Build first cleaned outputs

## Day 3

- [x] Recover repo into a healthy clone after local git metadata corruption
- [x] Create SQLite bootstrap workflow
- [x] Build a working Project 1 SQLite flow for wait times
- [x] Generate the first wait-times summary CSV
- [x] Extract a province-level 2025 population CSV for Project 2
- [x] Build the full healthcare SQLite database locally
- [x] Generate the first healthcare facility coverage CSV

## Day 4

- [x] Add a local frontend dashboard for the healthcare BA portfolio
- [x] Fix dashboard routing so buttons open repo assets through the local server
- [x] Add Power BI implementation notes, visual mockups, and paste-ready dashboard text
- [x] Add a live CSV explorer that reads generated SQLite report outputs
- [x] Add search, row counts, and download access to the CSV explorer
- [x] Refresh the README so the GitHub landing page reflects current progress

## Day 5

- [x] Finish the frontend portfolio dashboard and push the polished UI
- [x] Add a Power BI export pack with final screenshot and PDF naming rules
- [x] Create `assets/screenshots/` as the landing folder for final dashboard exports
- [x] Link the export pack and screenshot folder from the frontend dashboard
- [ ] Build/export the actual Power BI dashboard screenshots
- [x] Resolve the Ontario source-label issue for the access dashboard extract

## Day 6

- [x] Resolve the Ontario source-label issue end-to-end in the extract, report, frontend, and docs
- [x] Add a validation script for core healthcare report outputs
- [x] Create a final 5-day finish plan for the remaining delivery window
- [x] Add repo-native dashboard preview visuals for both healthcare projects
- [ ] Build and export the two final Power BI dashboard screenshots
- [ ] Fill the first five target applications using the completed proof package

## Notes

Use this file as the single source of truth for daily momentum, blockers, and wins.

Healthcare is the primary industry focus for this sprint. Retail can be revisited later as a secondary track after the first two healthcare projects are complete.

Selected datasets:
- Statistics Canada Table 13-10-0701-01 for wait times analysis
- Statistics Canada ODHF and Table 17-10-0157-01 for healthcare access and facility coverage analysis

Current state:
- Project 1 and Project 2 both have working SQLite-based report generation in the recovered repo.
- The frontend dashboard now gives a quick local preview of the portfolio story and generated CSV outputs.
- Power BI build guidance and export packaging now exist, but the actual Power BI pages still need to be built/exported.
- The Project 2 population extract now includes Ontario by normalizing the source label `Ontario by Ontario Health Region` to province-level `Ontario`.
- A final 5-day finish plan now defines the remaining work: export visuals, tighten story, prepare applications, rehearse interviews, and apply selectively.
- Repo-native SVG dashboard previews now exist in `assets/screenshots/`; final Power BI PNG/PDF exports are still pending.
