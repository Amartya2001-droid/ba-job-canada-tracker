# Build Plan

## Goal

Turn a Statistics Canada wait-times table into a concise healthcare access analysis that shows where delays are most severe by service type.

## Minimum Viable Scope

- Use one clean source table
- Compare specialized service types
- Show percentile differences visually
- Summarize the long-tail access problem in plain language

## SQL Tasks

- Load the source extract into a staging table
- Standardize column names
- Filter to the most relevant service groups
- Compute sortable KPI outputs for percentile comparisons

## Power BI Tasks

- Build a service-type comparison chart
- Add KPI cards for highest and lowest waits
- Add a summary view that highlights service variability

## Final Output

- One report page
- One insights file
- One screenshot for LinkedIn
