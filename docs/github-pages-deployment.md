# GitHub Pages Deployment Guide

This repo now includes a GitHub Pages workflow so the dashboard can be published as a static portfolio site.

## What Was Prepared

- Root redirect at `index.html`
- Static dashboard files in `frontend/`
- Relative asset and document links so the site works from a repository subpath
- `.nojekyll` so folders with underscores are served correctly
- `.github/workflows/deploy-pages.yml` to publish on push to `main`

## One-Time GitHub Setup

1. Open the repository on GitHub.
2. Go to `Settings` -> `Pages`.
3. Under `Build and deployment`, choose `GitHub Actions`.
4. Save the setting.

## Publish Flow

1. Push changes to `main`.
2. GitHub Actions runs `Deploy Portfolio Dashboard`.
3. After the workflow succeeds, GitHub provides the public Pages URL.

## Recommended Launch Order

1. Push the production-readiness changes.
2. Confirm the Pages site loads.
3. Add the final Power BI PNG/PDF assets.
4. Push again so the public site includes the final screenshots.
5. Use that Pages URL inside resume, cover notes, and application tracking.

## Notes

- The site is still valuable before the final Power BI exports because the SVG previews and CSV explorer already show working proof.
- The ideal final public version includes both the interactive dashboard and the exported Power BI screenshots.
