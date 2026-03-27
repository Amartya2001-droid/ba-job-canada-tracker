DROP VIEW IF EXISTS wait_times_clean;
CREATE VIEW wait_times_clean AS
SELECT
  "REF_DATE" AS ref_date,
  "GEO" AS geo,
  "DGUID" AS dguid,
  "Type of specialized service" AS service_type,
  "Percentile" AS percentile_label,
  "Characteristics" AS characteristic_label,
  "UOM" AS uom,
  "VALUE" AS value
FROM wait_times_raw;

DROP VIEW IF EXISTS population_clean;
CREATE VIEW population_clean AS
SELECT
  "REF_DATE" AS ref_date,
  "GEO" AS geography,
  "DGUID" AS dguid,
  "Age group" AS age_group,
  "Gender" AS gender,
  "VALUE" AS population_value
FROM population_raw;

DROP VIEW IF EXISTS facilities_clean;
CREATE VIEW facilities_clean AS
SELECT
  "index" AS facility_index,
  facility_name,
  source_facility_type,
  odhf_facility_type,
  provider,
  city,
  UPPER(province) AS province_code,
  "CSDname" AS csd_name,
  "CSDuid" AS csd_uid,
  "Pruid" AS pruid,
  latitude,
  longitude
FROM facilities_raw;
