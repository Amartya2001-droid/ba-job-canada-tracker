"""Application CSV reader and validation shared by command-line checks."""
import csv
from datetime import date
from pathlib import Path
import sys
from urllib.parse import urlsplit

HEADER = 'date,company,role,location,job_link,required_tools,matching_tools,stack_match_score,domain_fit,proof_asset,status,follow_up_date,notes'.split(',')

def read_rows(path):
    with Path(path).open(newline='', encoding='utf-8-sig') as source:
        reader = csv.DictReader(source, strict=True)
        if reader.fieldnames != HEADER:
            raise ValueError('Unexpected application tracker header.')
        rows = []
        for row in reader:
            if None in row or any(v is None for v in row.values()):
                raise ValueError(f'Malformed record near line {reader.line_num}.')
            if any(v.strip() for v in row.values()):
                rows.append({k: v.strip() for k, v in row.items()})
        return rows

def validate(rows):
    links = set()
    for number, row in enumerate(rows, 2):
        for field in HEADER:
            if field not in ('notes', 'follow_up_date') and not row[field]:
                raise ValueError(f'Row {number}: missing {field}.')
        for field in ('date', 'follow_up_date'):
            if row[field] and date.fromisoformat(row[field]).isoformat() != row[field]:
                raise ValueError(f'Row {number}: use YYYY-MM-DD for {field}.')
        link = row['job_link']
        parsed = urlsplit(link)
        if parsed.scheme not in ('http', 'https') or not parsed.netloc:
            raise ValueError(f'Row {number}: expected an HTTP(S) job URL.')
        if link in links:
            raise ValueError(f'Row {number}: duplicate job link.')
        links.add(link)

if __name__ == '__main__':
    try:
        validate(read_rows(sys.argv[1]))
    except (ValueError, OSError, csv.Error) as error:
        sys.exit(str(error))
    print('Tracker consistency checks passed.')
