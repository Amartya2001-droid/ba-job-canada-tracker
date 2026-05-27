# Final Interview Walkthrough Kit

Use this as the final speaking package for the healthcare BA portfolio.

## Project 1: Wait Times Analysis

### 30-Second Version

I built a healthcare wait-times analysis project using Statistics Canada data and a SQLite workflow. The main insight was that non-emergency surgeries had the worst long-tail delay, with a 95th percentile wait time of 34.7 weeks. That matters because median wait time alone would understate patient access pressure.

### 60-Second Version

This project answered a practical healthcare question: where do wait times look manageable on average but become much worse for patients at the tail? I used Statistics Canada wait-time data, cleaned and structured it with SQL and SQLite, and generated a compact output showing p50, p90, and p95 wait times by service type. The key finding was that non-emergency surgeries had the worst long-tail delay at 34.7 weeks on the 95th percentile measure. For a stakeholder, that matters because median-only reporting can hide serious access problems that affect planning and communication.

### 90-Second Version

This project started with a healthcare operations question that is very relevant in Canada: how do wait times differ across specialized services, and where do patient delays become severe even if the median looks reasonable? I used a Statistics Canada public dataset and built a small SQLite pipeline to structure the data, calculate percentile-based comparisons, and generate a dashboard-ready summary. The strongest result was that non-emergency surgeries had a p95 wait time of 34.7 weeks, which was much more severe than the median suggested. What makes the project useful for a Business Analyst context is that it goes beyond charting. It frames the result as a reporting and decision-support problem, where stakeholders need to see both central tendency and extreme cases before deciding how to prioritize operational attention.

## Project 2: Healthcare Access Coverage

### 30-Second Version

I built a healthcare access coverage project that combined facility data with population context to compare provinces on facilities per 100,000 residents. The key insight was that Prince Edward Island ranked highest at 52.01, Ontario was included at 16.58 after source normalization, and Alberta ranked lowest at 5.91. The project shows why normalized metrics are more useful than raw counts.

### 60-Second Version

This project focused on a healthcare planning question: which provinces appear relatively better or worse covered when facility supply is normalized by population? I combined Canadian healthcare facility data with a 2025 population extract and used SQL and SQLite to generate a province-level facilities-per-100k output. The strongest result was the spread between Prince Edward Island at 52.01 and Alberta at 5.91, with Ontario included at 16.58 after resolving a source-label issue. For a stakeholder, the value is that raw facility totals can mislead, while normalized coverage gives a more decision-ready picture of access differences across regions.

### 90-Second Version

This project started with a business question that fits healthcare operations and planning: how do you compare facility access across provinces without relying on raw counts that ignore population size? I combined the Statistics Canada ODHF facility dataset with a population extract and built a SQLite workflow to calculate facilities per 100,000 residents by province. One important challenge was that Ontario appeared under a different source label, `Ontario by Ontario Health Region`, so I normalized that label to province-level `Ontario` to keep the comparison consistent. The final output showed Prince Edward Island highest at 52.01, Ontario at 16.58, and Alberta lowest at 5.91. For a Business Analyst role, the value is not just the metric itself; it is the process of defining the right comparison, resolving data-shape issues, and presenting the result in a form that helps stakeholders reason about access coverage rather than raw supply counts.

## STAR-Style Answers

### Challenge Story: Ontario Source Label

- Situation: The population source used a different label for Ontario, which meant the access dashboard would understate the province comparison if left unresolved.
- Task: Keep the project province-level and make the output consistent across provinces.
- Action: I inspected the source shape, identified `Ontario by Ontario Health Region` as the matching row, normalized it to province-level `Ontario`, regenerated the extract, and rebuilt the report output.
- Result: Ontario was included in the final coverage CSV at 16.58 facilities per 100,000 residents and the outdated caveat was removed from the portfolio docs.
- Business Meaning: Stakeholders need confidence that province comparisons are complete and not distorted by inconsistent source labels.

### Communication Story: Wait-Time Percentiles

- Situation: A median-only view of wait times would make the access problem look smaller than it really is.
- Task: Show a stakeholder why tail delays matter, not just averages or medians.
- Action: I compared p50, p90, and p95 by service type and framed the output around where long-tail delays become operationally meaningful.
- Result: Non-emergency surgeries stood out with a p95 wait of 34.7 weeks.
- Business Meaning: Better reporting changes prioritization because it highlights severe delays that would otherwise be hidden.

## Final Rehearsal Notes

- Keep each answer tied to a business question first, toolset second.
- Mention SQL/SQLite as the workflow, but lead with the operational problem.
- Use the preview visuals or final Power BI exports while speaking whenever possible.
- Keep Ontario framed as a resolved normalization step, not as a lingering problem.
