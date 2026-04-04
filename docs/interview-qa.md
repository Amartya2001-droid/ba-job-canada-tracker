# Interview Q&A

## Why Business Analysis?

I like work that connects data to decisions. What draws me to Business Analysis is the combination of structured problem-solving, stakeholder communication, and measurable impact. I enjoy turning operational questions into clear metrics and practical recommendations.

## Why Healthcare?

Healthcare is one of the strongest sectors in Canada and it has a lot of measurable operational problems, especially around wait times, access, reporting, and regional differences. I chose healthcare because it is both relevant to the Canadian market and a strong fit for analytical work that supports decision-making.

## Tell Me About Your Wait Times Project

I used a Statistics Canada healthcare wait-times dataset and built a SQLite workflow to structure the data and generate KPI-ready outputs. The most important insight was that non-emergency surgeries had the worst long-tail delay in the current output, with a 95th percentile wait time of 34.7 weeks. That mattered because median performance alone would have hidden how severe delays were for a subset of patients.

## Tell Me About Your Healthcare Access Project

I combined healthcare facility data with population context to create a province-level access coverage dataset. The point was to normalize facility counts by population instead of relying on raw totals. In the current output, Prince Edward Island had the highest observed facility coverage at 52.01 facilities per 100,000 residents, while Alberta was lowest at 5.91. The project helped show how supply-side data becomes more useful when paired with demographic context.

## What Tools Did You Use?

I used SQL and SQLite to prepare the data, calculate KPIs, and generate summary outputs. I also designed the outputs to be easy to bring into Power BI for dashboard storytelling.

## What Was A Challenge You Ran Into?

One challenge was handling the healthcare population source because it was large and not perfectly aligned for a simple province-level comparison. I worked around that by building a filtered 2025 population extract for the specific dashboard use case, while also noting that Ontario needs special handling before final polish.

## How Would You Communicate Findings To A Non-Technical Stakeholder?

I would keep the message focused on the business question, the key metric, and the decision implication. For example, in the wait-times project I would avoid leading with SQL details and instead explain that median wait time alone can understate patient access pressure, especially for non-emergency surgeries.
