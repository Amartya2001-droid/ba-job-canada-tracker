-- Project 1: KPI and analysis queries using verified StatCan column names
-- Assumes imported column names are normalized to snake_case names.

-- 1. Median and high-percentile wait times by service type
SELECT
  service_type,
  percentile_label,
  value AS wait_time_weeks
FROM wait_times_raw
WHERE geo = 'Canada'
  AND characteristic_label = 'Waiting time, weeks'
  AND percentile_label IN (
    '50th percentile, median waiting time',
    '90th percentile, median waiting time',
    '95th percentile, median waiting time'
  )
ORDER BY service_type, percentile_label;

-- 2. Highest-delay services based on 95th percentile waits
SELECT
  service_type,
  value AS p95_wait_weeks
FROM wait_times_raw
WHERE geo = 'Canada'
  AND characteristic_label = 'Waiting time, weeks'
  AND percentile_label = '95th percentile, median waiting time'
ORDER BY value DESC;

-- 3. KPI-ready wide output for Power BI
SELECT
  service_type,
  MAX(CASE
    WHEN percentile_label = '50th percentile, median waiting time' THEN value
  END) AS p50_wait_weeks,
  MAX(CASE
    WHEN percentile_label = '90th percentile, median waiting time' THEN value
  END) AS p90_wait_weeks,
  MAX(CASE
    WHEN percentile_label = '95th percentile, median waiting time' THEN value
  END) AS p95_wait_weeks
FROM wait_times_raw
WHERE geo = 'Canada'
  AND characteristic_label = 'Waiting time, weeks'
GROUP BY service_type
ORDER BY p95_wait_weeks DESC;
