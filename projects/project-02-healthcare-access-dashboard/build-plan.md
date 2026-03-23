# Build Plan

## Goal

Combine healthcare facility counts with population estimates to show where healthcare access coverage may be thinner across Canada.

## Minimum Viable Scope

- Aggregate facility counts by province
- Group by facility type
- Join province-level population estimates
- Calculate facilities per 100,000 residents

## SQL Tasks

- Load the ODHF facility data
- Group facilities by province and facility type
- Load the population table
- Join population and facility counts
- Calculate normalized coverage metrics

## Power BI Tasks

- Build a province comparison dashboard
- Add facility-type filters
- Add KPI cards for highest and lowest coverage
- Add a map or ranked bar chart if the geography fields are clean enough

## Final Output

- One dashboard page
- One insights file
- One screenshot for LinkedIn
