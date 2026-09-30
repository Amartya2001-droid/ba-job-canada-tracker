"""Networking CSV reader and validation, mirroring application_tracker.py."""
import csv
from datetime import date
from pathlib import Path
import sys

HEADER = 'date,name,company,platform,purpose,status,follow_up_date,notes'.split(',')
REQUIRED_FIELDS = ('date', 'name', 'company', 'platform', 'purpose', 'status')

def read_rows(path):
    with Path(path).open(newline='', encoding='utf-8-sig') as source:
        reader = csv.DictReader(source, strict=True)
        if reader.fieldnames != HEADER:
            raise ValueError('Unexpected networking tracker header.')
        rows = []
        for row in reader:
            if None in row or any(v is None for v in row.values()):
                raise ValueError(f'Malformed record near line {reader.line_num}.')
            if any(v.strip() for v in row.values()):
                rows.append({k: v.strip() for k, v in row.items()})
        return rows

def validate(rows):
    for number, row in enumerate(rows, 2):
        for field in REQUIRED_FIELDS:
            if not row[field]:
                raise ValueError(f'Row {number}: missing {field}.')
        for field in ('date', 'follow_up_date'):
            if row[field] and date.fromisoformat(row[field]).isoformat() != row[field]:
                raise ValueError(f'Row {number}: use YYYY-MM-DD for {field}.')

if __name__ == '__main__':
    try:
        rows = read_rows(sys.argv[1])
        validate(rows)
    except (ValueError, OSError, csv.Error) as error:
        sys.exit(str(error))
    if not rows:
        print('No networking rows logged yet. See docs/networking-outreach-workflow.md to get started.')
    else:
        print(f'Networking tracker checks passed ({len(rows)} row(s) logged).')
