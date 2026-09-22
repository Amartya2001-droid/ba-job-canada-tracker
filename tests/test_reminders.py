from datetime import date
import unittest
from test_application_tracker import TrackerTests
from followup_reminders import due_rows

class ReminderTests(unittest.TestCase):
    def test_cutoff_sorting_and_closed_status(self):
        base = TrackerTests().row()
        rows = [dict(base, follow_up_date=d, status=s) for d, s in [
            ('2026-09-29', 'shortlist'), ('2026-09-20', 'applied'),
            ('2026-09-21', 'Rejected'), ('2026-09-30', 'applied')]]
        actual = due_rows(rows, date(2026, 9, 22), 7)
        self.assertEqual([r['follow_up_date'] for r in actual], ['2026-09-20', '2026-09-29'])
