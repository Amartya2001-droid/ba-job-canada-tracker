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
