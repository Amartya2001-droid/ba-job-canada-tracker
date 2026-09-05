# GitHub Pages Deployment Guide

Pages is live at `https://amartya2001-droid.github.io/ba-job-canada-tracker/frontend/index.html` (verified 2026-08-29). This guide covers how the deployment is set up and what to do if it ever needs re-enabling.

## What Was Prepared

- Root redirect at `index.html`
- Static dashboard files in `frontend/`
- Relative asset and document links so the site works from a repository subpath
- `.nojekyll` so folders with underscores are served correctly
- `.github/workflows/deploy-pages.yml` to publish on push to `main`
- Auto-enable support in the Pages workflow so the first deploy can bootstrap GitHub Pages
- Workflows opt into Node 24 action runtime behavior to avoid the GitHub runner deprecation warning

## One-Time GitHub Setup

1. Open the repository on GitHub.
2. Go to `Settings` -> `Pages`.
3. Under `Build and deployment`, choose `GitHub Actions`.
4. Save the setting.

If the first deploy happens before this setting is manually saved, the workflow now attempts to enable Pages automatically.

## Publish Flow

1. Push changes to `main`.
2. GitHub Actions runs `Verify Portfolio Readiness`.
3. GitHub Actions runs `Deploy Portfolio Dashboard`.
4. The live site at the URL above updates automatically.

## Remaining Launch Step

1. Add the final Power BI PNG/PDF assets to `assets/screenshots/`.
2. Push so the public site includes the final screenshots.
3. The URL is already in use in resume, cover notes, and application tracking; see `docs/portfolio-links.md`.

## Notes

- The live site is already valuable proof: the SVG previews, CSV explorer, and five real logged applications all show working evidence today.
- The only remaining gap is the exported Power BI PNG/PDF screenshots, which the live finish gate on the homepage tracks automatically.
