import csv
import pathlib
import shutil
import subprocess
import tempfile
import unittest

ROOT = pathlib.Path(__file__).resolve().parents[1]

class ReadinessTests(unittest.TestCase):
    def test_multiline_note_does_not_count_as_extra_targets(self):
        with tempfile.TemporaryDirectory() as directory:
            root = pathlib.Path(directory)
            shutil.copytree(ROOT / 'scripts', root / 'scripts')
            (root / 'tracker').mkdir()
            (root / 'tracker/first-five-applications.md').write_text('Shortlist')
            with (ROOT / 'tracker/applications.csv').open(newline='') as source:
                reader = csv.DictReader(source)
                row = next(reader)
                header = reader.fieldnames
            row['notes'] = 'one\ntwo\nthree\nfour\nfive'
            with (root / 'tracker/applications.csv').open('w', newline='') as target:
                writer = csv.DictWriter(target, fieldnames=header)
                writer.writeheader()
                writer.writerow(row)
            result = subprocess.run([str(root / 'scripts/check_application_readiness.sh')], capture_output=True, text=True)
            self.assertNotEqual(result.returncode, 0)
            self.assertIn('found 1', result.stderr)
