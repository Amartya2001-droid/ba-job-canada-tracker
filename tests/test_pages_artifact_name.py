"""Prevent Pages reruns from selecting artifacts from earlier attempts."""
import pathlib
import re
import unittest

ROOT = pathlib.Path(__file__).resolve().parents[1]


class PagesArtifactTests(unittest.TestCase):
    def test_upload_and_deploy_select_only_current_attempt(self):
        workflow = (ROOT / '.github/workflows/deploy-pages.yml').read_text()
        upload = workflow.split('uses: actions/upload-pages-artifact@v3', 1)[1].split('\n      - name:', 1)[0]
        deploy = workflow.split('uses: actions/deploy-pages@v4', 1)[1].split('\n      - name:', 1)[0]
        uploaded_name = re.search(r'^\s+name: (.+)$', upload, re.MULTILINE).group(1)
        selected_name = re.search(r'^\s+artifact_name: (.+)$', deploy, re.MULTILINE).group(1)
        self.assertEqual(uploaded_name, selected_name)
        self.assertIn('${{ github.run_attempt }}', uploaded_name)
        # Simulate retained artifacts from multiple attempts of the same run.
        artifacts = [uploaded_name.replace('${{ github.run_attempt }}', str(n)) for n in (1, 2)]
        current = selected_name.replace('${{ github.run_attempt }}', '2')
        self.assertEqual(artifacts.count(current), 1)
        self.assertNotEqual(artifacts[0], current)
