"""Check links that exist locally but are excluded from the Pages artifact."""
from html.parser import HTMLParser
from pathlib import Path
import unittest
from urllib.parse import urlsplit

ROOT = Path(__file__).resolve().parents[1]


class LinkParser(HTMLParser):
    def __init__(self):
        super().__init__()
        self.links = []

    def handle_starttag(self, tag, attrs):
        self.links.extend(value for key, value in attrs if key in ('href', 'src'))


class FrontendDeploymentLinkTests(unittest.TestCase):
    def test_local_links_do_not_target_excluded_pages_directories(self):
        parser = LinkParser()
        parser.feed((ROOT / 'frontend/index.html').read_text())
        for link in parser.links:
            parsed = urlsplit(link)
            if parsed.scheme or parsed.netloc or not parsed.path:
                continue
            target = (ROOT / 'frontend' / parsed.path).resolve().relative_to(ROOT)
            self.assertNotIn(target.parts[0], ('.git', '.github'), link)
