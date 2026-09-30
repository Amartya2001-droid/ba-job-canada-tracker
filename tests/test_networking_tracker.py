import csv
import pathlib
import sys
import tempfile
import unittest

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parents[1] / 'scripts'))
from networking_tracker import HEADER, read_rows, validate

class NetworkingTrackerTests(unittest.TestCase):
    def row(self):
        row = dict.fromkeys(HEADER, 'value')
        row.update(date='2026-09-22', follow_up_date='2026-09-29',
                    notes='Comma, and\nnewline')
        return row

    def test_csv_round_trip(self):
        with tempfile.TemporaryDirectory() as directory:
            path = pathlib.Path(directory) / 'networking.csv'
            with path.open('w', newline='') as target:
                writer = csv.DictWriter(target, fieldnames=HEADER)
                writer.writeheader()
                writer.writerow(self.row())
            rows = read_rows(path)
            validate(rows)
            self.assertEqual(rows, [self.row()])

    def test_blank_follow_up_date_is_allowed(self):
        row = self.row()
        row['follow_up_date'] = ''
        validate([row])

    def test_invalid_date(self):
        row = self.row()
        row['date'] = '2026-02-30'
        with self.assertRaises(ValueError):
            validate([row])

    def test_missing_required_field(self):
        row = self.row()
        row['name'] = ''
        with self.assertRaises(ValueError):
            validate([row])

    def test_blank_rows_are_skipped(self):
        with tempfile.TemporaryDirectory() as directory:
            path = pathlib.Path(directory) / 'networking.csv'
            with path.open('w', newline='') as target:
                writer = csv.DictWriter(target, fieldnames=HEADER)
                writer.writeheader()
                writer.writerow(dict.fromkeys(HEADER, ''))
                writer.writerow(self.row())
            rows = read_rows(path)
            self.assertEqual(len(rows), 1)
