.headers on
.mode csv

.output reports/sqlite/wait_times_summary.csv
SELECT
  service_type,
  MAX(CASE WHEN percentile_label = '50th percentile, median waiting time' THEN value END) AS p50_wait_weeks,
  MAX(CASE WHEN percentile_label = '90th percentile, median waiting time' THEN value END) AS p90_wait_weeks,
  MAX(CASE WHEN percentile_label = '95th percentile, median waiting time' THEN value END) AS p95_wait_weeks
FROM wait_times_clean
WHERE geo = 'Canada'
  AND characteristic_label = 'Waiting time, weeks'
GROUP BY service_type
ORDER BY p95_wait_weeks DESC;

.output reports/sqlite/province_facility_coverage.csv
WITH province_population AS (
  SELECT
    ref_date,
    geography,
    population_value
  FROM population_clean
  WHERE age_group = 'Total, all ages'
    AND gender = 'Total - gender'
    AND geography IN (
      'Newfoundland and Labrador',
      'Prince Edward Island',
      'Nova Scotia',
      'New Brunswick',
      'Quebec',
      'Ontario',
      'Manitoba',
      'Saskatchewan',
      'Alberta',
      'British Columbia'
    )
),
facility_counts AS (
  SELECT
    CASE province_code
      WHEN 'NL' THEN 'Newfoundland and Labrador'
      WHEN 'PE' THEN 'Prince Edward Island'
      WHEN 'NS' THEN 'Nova Scotia'
      WHEN 'NB' THEN 'New Brunswick'
      WHEN 'QC' THEN 'Quebec'
      WHEN 'ON' THEN 'Ontario'
      WHEN 'MB' THEN 'Manitoba'
      WHEN 'SK' THEN 'Saskatchewan'
      WHEN 'AB' THEN 'Alberta'
      WHEN 'BC' THEN 'British Columbia'
    END AS geography,
    COUNT(*) AS total_facilities
  FROM facilities_clean
  GROUP BY province_code
)
SELECT
  p.ref_date,
  p.geography,
  f.total_facilities,
  p.population_value,
  ROUND(f.total_facilities * 100000.0 / NULLIF(p.population_value, 0), 2) AS facilities_per_100k
FROM province_population p
JOIN facility_counts f
  ON p.geography = f.geography
ORDER BY facilities_per_100k DESC;

.output stdout
