import pathlib
import shutil
import sqlite3
import subprocess
import tempfile
import unittest

ROOT = pathlib.Path(__file__).resolve().parents[1]

@unittest.skipUnless(shutil.which('zsh') and shutil.which('sqlite3'), 'Requires zsh and sqlite3')
class ReportRunnerTests(unittest.TestCase):
    def test_outside_repo_and_sql_failure(self):
        with tempfile.TemporaryDirectory() as directory:
            root = pathlib.Path(directory) / 'repo'
            for folder in ('scripts', 'sql/sqlite', 'data/processed'):
                (root / folder).mkdir(parents=True)
            script = root / 'scripts/run_wait_times_reports.sh'
            shutil.copy2(ROOT / 'scripts/run_wait_times_reports.sh', script)
            with sqlite3.connect(root / 'data/processed/wait_times_analysis.sqlite') as db:
                db.executescript('CREATE TABLE wait_times_csv (value); INSERT INTO wait_times_csv VALUES (1);')
            sql = root / 'sql/sqlite/05_wait_times_reports.sql'
            sql.write_text('.output reports/sqlite/wait_times_summary.csv\nSELECT 42;\n')
            subprocess.run([str(script)], cwd=directory, check=True, capture_output=True)
            self.assertEqual((root / 'reports/sqlite/wait_times_summary.csv').read_text(), '42\n')
            sql.write_text('SELECT * FROM missing_table;\n')
            result = subprocess.run([str(script)], cwd=directory, capture_output=True)
            self.assertNotEqual(result.returncode, 0)
