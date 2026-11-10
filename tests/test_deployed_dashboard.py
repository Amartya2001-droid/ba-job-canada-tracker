import functools
import http.server
import importlib.util
import pathlib
import tempfile
import threading
import unittest
import urllib.error

ROOT = pathlib.Path(__file__).resolve().parents[1]
SPEC = importlib.util.spec_from_file_location('deployed', ROOT / 'scripts/check_deployed_dashboard.py')
deployed = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(deployed)


class QuietHandler(http.server.SimpleHTTPRequestHandler):
    def log_message(self, *args):
        pass


class DeployedDashboardTests(unittest.TestCase):
    def setUp(self):
        self.directory = tempfile.TemporaryDirectory()
        self.addCleanup(self.directory.cleanup)
        self.root = pathlib.Path(self.directory.name)
        self.public = self.root / 'public'
        self.expected = self.root / 'expected'
        for folder in (self.public, self.expected):
            for asset in deployed.ASSETS:
                path = folder / asset
                path.parent.mkdir(parents=True, exist_ok=True)
                path.write_text('current content\n')
        handler = functools.partial(QuietHandler, directory=str(self.public))
        self.server = http.server.ThreadingHTTPServer(('127.0.0.1', 0), handler)
        self.thread = threading.Thread(target=self.server.serve_forever, daemon=True)
        self.thread.start()
        self.addCleanup(self.close_server)
        self.url = f'http://127.0.0.1:{self.server.server_port}/'

    def close_server(self):
        self.server.shutdown()
        self.server.server_close()
        self.thread.join()

    def test_current_deployment_passes(self):
        deployed.verify(self.url, self.expected)

    def test_stale_snapshot_fails(self):
        (self.public / 'reports/portfolio/portfolio_snapshot.json').write_text('stale')
        with self.assertRaisesRegex(ValueError, 'portfolio_snapshot.json'):
            deployed.verify(self.url, self.expected)

    def test_missing_dashboard_fails(self):
        (self.public / 'frontend/index.html').unlink()
        with self.assertRaises(urllib.error.HTTPError):
            deployed.verify(self.url, self.expected)
