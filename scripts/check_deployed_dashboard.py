"""Verify that public Pages assets match the files uploaded by this checkout."""
import argparse
import pathlib
import time
import urllib.request

ROOT = pathlib.Path(__file__).resolve().parents[1]
ASSETS = (
    'frontend/index.html',
    'frontend/app.js',
    'frontend/styles.css',
    'reports/portfolio/portfolio_snapshot.json',
    'reports/sqlite/wait_times_summary.csv',
    'reports/sqlite/province_facility_coverage.csv',
    'tracker/applications.csv',
    'tracker/networking.csv',
)


def verify(base_url, root=ROOT):
    for asset in ASSETS:
        url = base_url.rstrip('/') + '/' + asset
        request = urllib.request.Request(url, headers={'Cache-Control': 'no-cache'})
        with urllib.request.urlopen(request, timeout=20) as response:
            actual = response.read()
        if actual != (root / asset).read_bytes():
            raise ValueError(f'Deployed content differs: {asset}')
    print(f'Live dashboard and {len(ASSETS)} assets match this deployment: {base_url}')


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('base_url')
    args = parser.parse_args()
    for attempt in range(12):
        try:
            verify(args.base_url)
            return
        except (OSError, ValueError) as error:
            if attempt == 11:
                raise
            print(f'Waiting for Pages propagation: {error}', flush=True)
            time.sleep(5)


if __name__ == '__main__':
    main()
