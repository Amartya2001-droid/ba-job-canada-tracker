# Networking Outreach Workflow

Use this when logging outreach into `tracker/networking.csv`. Networking is part of the healthcare BA positioning strategy: a warm introduction at a target organization (Sunnybrook, PHSA, Partners Community Health, or similar) often outperforms a cold application.

## Minimum Standard For Each Row

- `date` — the day you sent the message, `YYYY-MM-DD`
- `name` — the real contact's name
- `company` — their organization
- `platform` — LinkedIn, email, event, referral, etc.
- `purpose` — why you reached out (e.g. "learn about BA hiring at PHSA", "referral request")
- `status` — `sent`, `replied`, `call-booked`, `no-response`, `closed`
- `follow_up_date` — `YYYY-MM-DD` if a follow-up is planned, blank otherwise
- `notes` — one line on the conversation or next step

## Message Source

Start from `templates/networking-message-template.md` and personalize the opening line with something specific from the contact's profile or recent post. Never send the template unedited.

## Weekly Target

Two networking messages per week, per `docs/job-search-rhythm.md`. Prioritize contacts at organizations already in the application shortlist (`docs/application-shortlist-rationale.md`) — a reply there can inform or accelerate that specific application.

## Field Formatting Rules

Same rules as the application tracker (see `docs/application-tracker-workflow.md`):

- No commas inside any field — use semicolons for lists.
- Dates must be `YYYY-MM-DD`.
- Do not log a row until the message has actually been sent.

## Validation

Run:

```bash
./scripts/check_networking_tracker.sh
```

This checks for malformed dates and rows missing required fields. It does not gate the finish status script — networking is an ongoing activity, not a one-time finish blocker.
