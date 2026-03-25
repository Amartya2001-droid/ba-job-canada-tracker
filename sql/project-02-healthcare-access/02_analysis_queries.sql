-- Project 2: KPI and analysis queries using verified column names
-- Assumes imported column names are normalized to snake_case names.

-- 1. Facility counts by province and type
SELECT
  UPPER(province) AS province_code,
  odhf_facility_type,
  COUNT(*) AS facility_count
FROM facilities_raw
GROUP BY UPPER(province), odhf_facility_type
ORDER BY province_code, odhf_facility_type;

-- 2. Total facilities by province
SELECT
  UPPER(province) AS province_code,
  COUNT(*) AS total_facilities
FROM facilities_raw
GROUP BY UPPER(province)
ORDER BY total_facilities DESC;

-- 3. Province-level population extract
WITH province_population AS (
  SELECT
    ref_date,
    geography,
    population_value
  FROM population_raw
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
    CASE UPPER(province)
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
  FROM facilities_raw
  GROUP BY UPPER(province)
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
