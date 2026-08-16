# Application Tracker Workflow

Use this when you start replacing placeholders with real healthcare roles.

## Goal

Keep every application row high-signal enough that it can double as portfolio proof.

## Minimum Standard For Each Role

- Real company name
- Real posting URL
- Real location
- Required tools from the posting
- Matching tools from the portfolio
- Stack match score
- Domain-fit note
- Proof asset to reference
- Status
- Follow-up date if the role is active

## Fastest CLI Path

Run:

```bash
./scripts/add_application_entry.sh --help
```

Useful options:

- `--append-csv` to append the row directly into `tracker/applications.csv`
- `--append-markdown` to append the matching block into `tracker/first-five-applications.md`
- `--application-number 1` through `--application-number 5` to label the worksheet section

## Fastest Frontend Path

Open the dashboard entry helper and:

1. Fill one real role
2. Copy the CSV row
3. Copy the markdown block
4. Paste both into the tracker files
5. Re-run the readiness checks

## Validation Commands

Run:

```bash
./scripts/check_tracker_consistency.sh
./scripts/check_application_readiness.sh
```

The first command catches duplicate links, malformed dates, and weak rows. The second command confirms the first five target batch is complete.

## Field Formatting Rules

Learned the hard way on 2026-08-16 while logging the first real batch:

- **No commas inside any field.** The validation scripts split CSV rows on raw commas, so a comma shifts column positions even when the helper quotes the field. Use semicolons for lists (`SQL; Power BI; Excel`) and drop the comma from locations (`Toronto ON`, not `Toronto, ON`). The CLI helper now rejects comma-containing fields with a clear error.
- **Quote dollar amounts carefully in the shell.** In a double-quoted `--notes` argument, `$43/hr` expands `$4` as a positional parameter and silently becomes `3/hr`. Use single quotes around notes that contain dollar signs, or escape them (`\$43/hr`).
- **Follow-up dates must be `YYYY-MM-DD`.** The consistency checker enforces this format.
- **Record the posted date in the notes.** Postings expire; the posted date makes it obvious when a link needs re-verification before applying.
