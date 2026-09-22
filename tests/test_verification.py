import pathlib
import subprocess
import unittest

ROOT = pathlib.Path(__file__).resolve().parents[1]


class VerificationTests(unittest.TestCase):
    def test_verification_does_not_rewrite_snapshot(self):
        snapshot = ROOT / 'reports/portfolio/portfolio_snapshot.json'
        before = snapshot.read_bytes()
        subprocess.run([str(ROOT / 'scripts/verify_portfolio_ready.sh')], check=True)
        self.assertEqual(before, snapshot.read_bytes())
