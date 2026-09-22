import csv
import pathlib
import sys
import tempfile
import unittest

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parents[1] / 'scripts'))
from application_tracker import HEADER, read_rows, validate

class TrackerTests(unittest.TestCase):
    def row(self):
        row = dict.fromkeys(HEADER, 'value')
        row.update(date='2026-09-22', follow_up_date='2026-09-29',
                   job_link='https://example.com/job', notes='Comma, and\nnewline')
        return row

    def test_csv_round_trip(self):
        with tempfile.TemporaryDirectory() as directory:
            path = pathlib.Path(directory) / 'tracker.csv'
            with path.open('w', newline='') as target:
                writer = csv.DictWriter(target, fieldnames=HEADER)
                writer.writeheader()
                writer.writerow(self.row())
            rows = read_rows(path)
            validate(rows)
            self.assertEqual(rows, [self.row()])

    def test_invalid_date(self):
        row = self.row()
        row['follow_up_date'] = '2026-02-30'
        with self.assertRaises(ValueError):
            validate([row])

    def test_duplicates(self):
        with self.assertRaises(ValueError):
            validate([self.row(), self.row()])

    def test_invalid_url(self):
        row = self.row()
        row['job_link'] = 'javascript:alert(1)'
        with self.assertRaises(ValueError):
            validate([row])
