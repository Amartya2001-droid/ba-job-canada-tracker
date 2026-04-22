# Power BI Export Pack

Use this after building the two Power BI pages. The goal is to create assets that can be attached to applications, referenced in the frontend dashboard, and reviewed quickly by a recruiter.

## Export Folder

Save final visuals here:

- `assets/screenshots/wait-times-dashboard-preview.svg`
- `assets/screenshots/access-coverage-dashboard-preview.svg`
- `assets/screenshots/wait-times-dashboard.png`
- `assets/screenshots/access-coverage-dashboard.png`
- `assets/screenshots/healthcare-ba-portfolio.pdf`

The SVG files are repo-native previews. The PNG and PDF files should come from the final Power BI export.

## Page 1: Wait Times Screenshot

Before exporting, confirm the screenshot shows:

- Title: `Canadian Healthcare Wait Times by Service Type`
- KPI card for highest p95 wait: `34.7 weeks`
- Clustered bar chart comparing p50, p90, and p95 by service type
- Insight note explaining that non-emergency surgeries have the longest tail wait
- Source note for Statistics Canada wait-time data

Recommended file name:

```text
assets/screenshots/wait-times-dashboard.png
```

## Page 2: Access Coverage Screenshot

Before exporting, confirm the screenshot shows:

- Title: `Canadian Healthcare Facility Coverage by Province`
- KPI card for highest coverage: `Prince Edward Island`
- KPI card for lowest coverage: `Alberta`
- Ranked bar chart by `facilities_per_100k`
- Ontario source-normalization note

Recommended file name:

```text
assets/screenshots/access-coverage-dashboard.png
```

## PDF Export

Export both pages as one PDF when the screenshots are final.

Recommended file name:

```text
assets/screenshots/healthcare-ba-portfolio.pdf
```

## Quality Gate

Use this checklist before putting screenshots into the repo:

- Numbers are readable at laptop width.
- Chart labels are not cut off.
- No placeholder text remains.
- Both pages use the same color palette.
- Both pages include the business question or source note.
- The access dashboard does not overclaim quality of care; it only discusses coverage.
- The Ontario source-normalization note is visible on the access dashboard.

## Application Use

When applying, use these assets like this:

- Resume: mention the healthcare BA portfolio and SQL + Power BI workflow.
- Cover note: link the GitHub repo and mention the two exported dashboard pages.
- Interview: describe the business question, data source, transformation, and recommendation.
- Frontend dashboard: link the screenshots once files are added to `assets/screenshots/`.
