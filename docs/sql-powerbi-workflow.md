# SQL + Power BI Workflow

## Default Build Flow

1. Download source files into `data/raw/`.
2. Inspect columns, nulls, date fields, and geography fields.
3. Load the data into SQL tables for basic cleaning and KPI calculation.
4. Export cleaned outputs into `data/processed/` if needed.
5. Build Power BI visuals from the cleaned dataset or SQL output.
6. Write business-facing insights in each project `insights.md`.

## What SQL Should Handle

- column cleanup
- data type normalization
- filters for relevant years or categories
- calculated fields
- KPI tables for Power BI

## What Power BI Should Handle

- interactive filters
- comparison visuals
- KPI cards
- region and service drilldowns
- polished business dashboard layout

## Portfolio Standard

Every project should end with:

- a short problem statement
- 3 to 5 KPIs
- 2 to 4 strong visuals
- 3 business insights
- 1 screenshot ready for LinkedIn
