# Power BI Dashboard Specs

## Project 1: Canadian Healthcare Wait Times Analysis

### Page Title
Canadian Healthcare Wait Times by Service Type

### KPI Cards
- Highest 95th percentile wait time
- Lowest median wait time
- Number of service groups compared

### Recommended Visuals
- Clustered bar chart: service type vs p50, p90, p95 wait times
- KPI card strip for p50, p90, and p95 leader values
- Short narrative text box highlighting the gap between median and tail waits

### Filters
- Service type
- Percentile

### Key Message
Median performance can hide severe long-tail access delays, especially in non-emergency surgeries.

## Project 2: Canadian Healthcare Access Dashboard

### Page Title
Canadian Healthcare Facility Coverage by Province

### KPI Cards
- Highest facilities per 100k
- Lowest facilities per 100k
- Total facilities in current comparison set

### Recommended Visuals
- Ranked bar chart: province vs facilities per 100k
- Table: province, total facilities, population, facilities per 100k
- Stacked bar chart: province by facility type after the next enrichment step
- Data note card explaining Ontario source-label normalization

### Filters
- Province
- Facility type

### Key Message
Facility access should be normalized by population to reveal more realistic regional coverage differences.
