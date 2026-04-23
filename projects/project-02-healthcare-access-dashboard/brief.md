# Project Brief

## Title

Canadian Healthcare Access Dashboard

## Business Question

Which provinces or health regions appear relatively underserved when we compare healthcare facility coverage with population size?

## Industry

Healthcare

## Dataset Source

- Statistics Canada Open Database of Healthcare Facilities (ODHF)
- Statistics Canada Table 17-10-0157-01 Population estimates, July 1, by health region and peer group, 2023 boundaries

## Stakeholder

Healthcare planners, operations analysts, and policy teams

## KPIs

- Facilities per 100,000 residents
- Hospitals by province
- Nursing and residential care facilities by province
- Ambulatory facilities by province

## Deliverable

Dashboard-ready access coverage report with CSV output and preview asset:

- `reports/sqlite/province_facility_coverage.csv`
- `assets/screenshots/access-coverage-dashboard-preview.svg`

The current output includes Ontario after normalizing the source label `Ontario by Ontario Health Region` to province-level `Ontario`.
