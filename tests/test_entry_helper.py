import csv
import io
import pathlib
import subprocess
import unittest

ROOT = pathlib.Path(__file__).resolve().parents[1]

class EntryTests(unittest.TestCase):
    def test_comma_and_quote_fields(self):
        values = {'company': 'Health, Inc.', 'role': 'Analyst', 'location': 'Halifax, NS',
                  'job-link': 'https://example.com/job', 'required-tools': 'SQL, Excel',
                  'matching-tools': 'SQL', 'stack-match-score': '4/5', 'domain-fit': 'Healthcare',
                  'proof-asset': 'preview.svg', 'status': 'shortlist', 'notes': 'Said "hello", today'}
        args = [str(ROOT / 'scripts/add_application_entry.sh')]
        for key, value in values.items():
            args.extend(['--' + key, value])
        output = subprocess.check_output(args, text=True)
        row = next(csv.reader(io.StringIO(output.split('CSV row:\n', 1)[1])))
        self.assertEqual(len(row), 13)
        self.assertEqual(row[1], values['company'])
        self.assertEqual(row[12], values['notes'])
