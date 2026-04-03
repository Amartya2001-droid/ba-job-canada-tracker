# Power BI Build Checklist

## Project 1: Wait Times Dashboard

### Data Setup
- Load `reports/sqlite/wait_times_summary.csv`
- Confirm numeric typing for `p50_wait_weeks`, `p90_wait_weeks`, and `p95_wait_weeks`
- Rename fields into recruiter-friendly labels if needed

### Visual Build Order
1. Add a title block with project context and data source
2. Add three KPI cards:
   - highest p95 wait
   - lowest p50 wait
   - number of service groups
3. Add a clustered bar chart comparing p50, p90, and p95 by service type
4. Add a short insight box calling out non-emergency surgeries
5. Add a footer note with source and methodology

### Final Check
- Keep one page only
- Use healthcare-friendly colors with strong contrast
- Ensure labels are readable in a screenshot
- Export one clean image for LinkedIn and one PDF for portfolio use

## Project 2: Healthcare Access Dashboard

### Data Setup
- Load `reports/sqlite/province_facility_coverage.csv`
- Confirm numeric typing for `total_facilities`, `population_value`, and `facilities_per_100k`
- Add a note that Ontario handling is still a source-specific caveat

### Visual Build Order
1. Add a title block with the business question
2. Add three KPI cards:
   - highest facilities per 100k
   - lowest facilities per 100k
   - total facilities represented
3. Add a ranked bar chart by province
4. Add a supporting table with province, facilities, population, and normalized rate
5. Add a data note card explaining the coverage metric and Ontario caveat

### Final Check
- Keep the message focused on access coverage, not quality of care
- Make the normalized metric the hero visual
- Export one screenshot and one PDF-ready page
