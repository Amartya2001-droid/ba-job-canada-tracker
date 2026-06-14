# GitHub Pages Deployment Guide

This repo now includes a GitHub Pages workflow so the dashboard can be published as a static portfolio site.

## What Was Prepared

- Root redirect at `index.html`
- Static dashboard files in `frontend/`
- Relative asset and document links so the site works from a repository subpath
- `.nojekyll` so folders with underscores are served correctly
- `.github/workflows/deploy-pages.yml` to publish on push to `main`
- Auto-enable support in the Pages workflow so the first deploy can bootstrap GitHub Pages

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
4. After the workflow succeeds, GitHub provides the public Pages URL.

## Recommended Launch Order

1. Push the production-readiness changes.
2. Confirm the verification workflow is green.
3. Confirm the Pages site loads.
4. Add the final Power BI PNG/PDF assets.
5. Push again so the public site includes the final screenshots.
6. Use that Pages URL inside resume, cover notes, and application tracking.

## Notes

- The site is still valuable before the final Power BI exports because the SVG previews and CSV explorer already show working proof.
- The ideal final public version includes both the interactive dashboard and the exported Power BI screenshots.
