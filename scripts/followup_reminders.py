"""Print due reminders in date order without depending on platform date commands."""
from datetime import date, timedelta
import sys
import csv
from application_tracker import read_rows, validate

def due_rows(rows, today, window):
    cutoff = today + timedelta(days=window)
    active = []
    for row in rows:
        if row['status'].lower() in {'closed', 'rejected', 'withdrawn', 'accepted'}:
            continue
        value = row['follow_up_date']
        if value and date.fromisoformat(value) <= cutoff:
            active.append(row)
    return sorted(active, key=lambda row: row['follow_up_date'])

if __name__ == '__main__':
    try:
        rows = read_rows(sys.argv[1])
        validate(rows)
        today = date.today()
        window = int(sys.argv[2])
        due = due_rows(rows, today, window)
        print(f'Application follow-ups due through {today + timedelta(days=window)}')
        for row in due:
            marker = 'OVERDUE' if row['follow_up_date'] < today.isoformat() else 'due'
            print(f"  [{marker} {row['follow_up_date']}] {row['company']} - {row['role']} ({row['status']})")
        if not due:
            print('  No follow-ups due in this window.')
    except (ValueError, OSError, csv.Error, OverflowError) as error:
        sys.exit(str(error))
