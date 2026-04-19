# Power BI Implementation Guide

This guide turns the current CSV outputs into two portfolio-ready Power BI pages.

## Before You Start

- Open Power BI Desktop.
- Save a new file as `healthcare-ba-portfolio.pbix`.
- Import these two files:
  - `reports/sqlite/wait_times_summary.csv`
  - `reports/sqlite/province_facility_coverage.csv`
- Rename the tables:
  - `WaitTimes`
  - `FacilityCoverage`

## Shared Design Direction

- Keep both pages clean and single-purpose.
- Use one warm accent color and one teal accent color.
- Avoid crowded visuals.
- Prioritize readability for screenshots.

Suggested color palette:

- Primary warm: `#C75B39`
- Primary teal: `#147B72`
- Background: `#F8F4EC`
- Text: `#172128`
- Muted text: `#5F6F73`

Suggested font style:

- Title: bold sans-serif
- Labels: clean sans-serif
- Keep font sizes large enough for exported screenshots

## Page 1: Canadian Healthcare Wait Times Analysis

### Goal

Show that median wait times can hide much worse long-tail delays, especially in non-emergency surgeries.

### Data Table

Use the `WaitTimes` table with these columns:

- `service_type`
- `p50_wait_weeks`
- `p90_wait_weeks`
- `p95_wait_weeks`

### Measures To Create

```DAX
Highest P95 Wait = MAX(WaitTimes[p95_wait_weeks])
Lowest P50 Wait = MIN(WaitTimes[p50_wait_weeks])
Service Group Count = COUNTROWS(WaitTimes)
```

### Layout

Top section:

- Title text box:
  - `Canadian Healthcare Wait Times by Service Type`
- Subtitle text box:
  - `Source: Statistics Canada public wait-time data`

Middle section:

- 3 KPI cards:
  - `Highest P95 Wait`
  - `Lowest P50 Wait`
  - `Service Group Count`

Bottom section:

- Clustered column chart
  - Axis: `service_type`
  - Values:
    - `p50_wait_weeks`
    - `p90_wait_weeks`
    - `p95_wait_weeks`

Right or bottom text box:

- Short insight summary:
  - `Non-emergency surgeries show the strongest long-tail delay in the current output, with a p95 wait of 34.7 weeks.`

### Formatting

- Use warm tones for waits:
  - `p50`: light warm
  - `p90`: medium warm
  - `p95`: dark warm
- Turn on data labels.
- Sort by `p95_wait_weeks` descending if needed.
- Keep gridlines subtle.

### Screenshot Goal

Your final screenshot should make these facts instantly visible:

- non-emergency surgeries are worst at the tail
- median waits are much lower than p90 and p95 waits
- the chart is clean and readable without explanation

## Page 2: Canadian Healthcare Access Dashboard

### Goal

Show province-level facility access coverage using normalized facilities-per-100k metrics.

### Data Table

Use the `FacilityCoverage` table with these columns:

- `ref_date`
- `geography`
- `total_facilities`
- `population_value`
- `facilities_per_100k`

### Measures To Create

```DAX
Highest Coverage = MAX(FacilityCoverage[facilities_per_100k])
Lowest Coverage = MIN(FacilityCoverage[facilities_per_100k])
Total Facilities Represented = SUM(FacilityCoverage[total_facilities])
```

### Layout

Top section:

- Title text box:
  - `Canadian Healthcare Facility Coverage by Province`
- Subtitle text box:
  - `Coverage is shown as facilities per 100,000 residents`

Middle section:

- 3 KPI cards:
  - `Highest Coverage`
  - `Lowest Coverage`
  - `Total Facilities Represented`

Main visual:

- Ranked bar chart
  - Axis: `geography`
  - Values: `facilities_per_100k`
  - Sort descending by `facilities_per_100k`

Supporting visual:

- Table
  - `geography`
  - `total_facilities`
  - `population_value`
  - `facilities_per_100k`

Footer note:

- Text box:
  - `Ontario is included after normalizing the source label "Ontario by Ontario Health Region" to province-level Ontario.`

### Formatting

- Use teal for the hero metric.
- Turn on data labels for the bar chart.
- Format `population_value` with thousand separators.
- Format `facilities_per_100k` to 2 decimal places.
- Keep the table compact and screenshot-friendly.

### Screenshot Goal

Your final screenshot should make these facts instantly visible:

- Prince Edward Island leads current coverage
- Alberta is lowest in the current comparison
- normalized coverage is the key metric, not raw counts

## Final Export Checklist

- Export 1 screenshot per page for LinkedIn
- Export 1 PDF of the report for portfolio sharing
- Make sure no placeholder text remains
- Check that titles, numbers, and labels are readable on laptop width
- Confirm the source note appears on both pages

## Suggested Build Order

1. Build Page 1 fully
2. Export screenshot for Page 1
3. Build Page 2 fully
4. Export screenshot for Page 2
5. Update LinkedIn drafts with the final screenshot references
