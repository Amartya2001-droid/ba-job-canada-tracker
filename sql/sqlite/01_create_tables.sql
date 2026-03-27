DROP TABLE IF EXISTS wait_times_raw;
CREATE TABLE wait_times_raw (
  "REF_DATE" TEXT,
  "GEO" TEXT,
  "DGUID" TEXT,
  "Type of specialized service" TEXT,
  "Percentile" TEXT,
  "Characteristics" TEXT,
  "UOM" TEXT,
  "UOM_ID" INTEGER,
  "SCALAR_FACTOR" TEXT,
  "SCALAR_ID" INTEGER,
  "VECTOR" TEXT,
  "COORDINATE" TEXT,
  "VALUE" REAL,
  "STATUS" TEXT,
  "SYMBOL" TEXT,
  "TERMINATED" TEXT,
  "DECIMALS" INTEGER
);

DROP TABLE IF EXISTS population_raw;
CREATE TABLE population_raw (
  "REF_DATE" TEXT,
  "GEO" TEXT,
  "DGUID" TEXT,
  "Age group" TEXT,
  "Gender" TEXT,
  "UOM" TEXT,
  "UOM_ID" INTEGER,
  "SCALAR_FACTOR" TEXT,
  "SCALAR_ID" INTEGER,
  "VECTOR" TEXT,
  "COORDINATE" TEXT,
  "VALUE" REAL,
  "STATUS" TEXT,
  "SYMBOL" TEXT,
  "TERMINATED" TEXT,
  "DECIMALS" INTEGER
);

DROP TABLE IF EXISTS facilities_raw;
CREATE TABLE facilities_raw (
  "index" INTEGER,
  "facility_name" TEXT,
  "source_facility_type" TEXT,
  "odhf_facility_type" TEXT,
  "provider" TEXT,
  "unit" TEXT,
  "street_no" TEXT,
  "street_name" TEXT,
  "postal_code" TEXT,
  "city" TEXT,
  "province" TEXT,
  "source_format_str_address" TEXT,
  "CSDname" TEXT,
  "CSDuid" TEXT,
  "Pruid" TEXT,
  "latitude" REAL,
  "longitude" REAL
);
