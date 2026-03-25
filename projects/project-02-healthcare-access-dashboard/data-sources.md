# Data Sources

## Primary Sources

1. Statistics Canada Open Database of Healthcare Facilities (ODHF)
   - Source page: https://www.statcan.gc.ca/en/lode/databases/odhf
   - Direct file URL: https://www150.statcan.gc.ca/n1/en/pub/13-26-0001/2020001/ODHF_v1.1.zip
   - Dataset scope: names, types, and locations of healthcare facilities across Canada
   - Notes:
     - Statistics Canada says the current ODHF version 1.1 contains approximately 7,000 records.
     - Facility types are harmonized into ambulatory health care services, hospitals, and nursing and residential care facilities.

2. Statistics Canada Table 17-10-0157-01
   - Source page: https://www150.statcan.gc.ca/t1/tbl1/en/tv.action?pid=1710015701
   - Direct file URL: https://www150.statcan.gc.ca/n1/tbl/csv/17100157-eng.zip
   - Dataset scope: population estimates by health region and peer group, 2023 boundaries
   - Release date on source page: 2026-02-18

## Why This Pair Works

- ODHF gives the supply-side view of healthcare facilities.
- Table 17-10-0157-01 gives the population baseline needed to normalize coverage.
- Together they support a more business-relevant access story than raw facility counts alone.

## Draft Join Strategy

- Start with province-level aggregation first for a clean MVP.
- If the ODHF geography fields align cleanly enough, extend to health-region level analysis later.
- Compute facility counts and facility-type counts per province.
- Join population estimates and calculate facilities per 100,000 residents.
