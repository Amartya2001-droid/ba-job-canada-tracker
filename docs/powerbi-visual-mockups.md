# Power BI Visual Mockups

Use these mockups as a simple page-building reference while working in Power BI Desktop.

## Page 1 Mockup: Wait Times Analysis

```text
+----------------------------------------------------------------------------------+
| Canadian Healthcare Wait Times by Service Type                                  |
| Source: Statistics Canada public wait-time data                                 |
+--------------------------+--------------------------+----------------------------+
| Highest P95 Wait         | Lowest P50 Wait          | Service Group Count        |
| 34.7 weeks               | 3.0 weeks                | 3                          |
+----------------------------------------------------------------------------------+
|                                                                              []  |
|  Clustered column chart: p50 vs p90 vs p95 by service type                      |
|                                                                                  |
|  Non-emergency surgeries |■■■■■■■■■■■■■■■■■■■■■■■■                              |
|  Specialist visits       |■■■■■■■■■■■■■■■■                                      |
|  Diagnostic tests        |■■■■■■■■■■■■■■■■                                      |
|                                                                                  |
+-------------------------------------------+--------------------------------------+
| What This Means                            | Interpretation note                  |
| Non-emergency surgeries show the strongest | Median performance can hide severe   |
| long-tail delay in the current output.     | access pressure in the delayed tail. |
+-------------------------------------------+--------------------------------------+
```

### Build Notes

- Make the chart the largest element on the page.
- Put KPI cards in a single horizontal row.
- Keep the insight box short enough to read in one glance.
- Use warm tones consistently across the chart and KPI cards.

## Page 2 Mockup: Healthcare Access Coverage

```text
+----------------------------------------------------------------------------------+
| Canadian Healthcare Facility Coverage by Province                                |
| Coverage is shown as facilities per 100,000 residents                           |
+--------------------------+--------------------------+----------------------------+
| Highest Coverage         | Lowest Coverage          | Total Facilities Represented|
| 52.01                    | 5.91                     | [sum of current set]        |
+------------------------------------------------------+---------------------------+
| Ranked bar chart: facilities per 100k by province                                 |
|                                                                                  |
| Prince Edward Island   |■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■                        |
| Saskatchewan           |■■■■■■■■■■■■■■■■■                                       |
| British Columbia       |■■■■■■■■■■■■                                            |
| New Brunswick          |■■■■■■■■■■                                              |
| Quebec                 |■■■■■■■■                                                |
| Alberta                |■■■                                                     |
+-----------------------------------------------+----------------------------------+
| Province table                                 | Data note                        |
| Province | Facilities | Population | Per 100k  | Ontario requires extra source   |
| ...                                           | handling before final polish.    |
+-----------------------------------------------+----------------------------------+
```

### Build Notes

- Make the ranked bar chart the hero visual.
- Keep the table narrow and readable.
- Use teal as the dominant visual color.
- Keep the data note visible but secondary to the main chart.

## Screenshot Advice

- Export both pages at a wide aspect ratio.
- Avoid slicers if they make the screenshot busier.
- Leave enough white space so the dashboard does not feel cramped.
- Before exporting, zoom out and ask whether the main takeaway is visible in 3 seconds.
