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
.output stdout
