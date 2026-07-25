#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
APPLICATIONS_CSV="$ROOT_DIR/tracker/applications.csv"

usage() {
  cat <<'EOF'
Usage:
  ./scripts/add_application_entry.sh \
    --company "Nova Scotia Health" \
    --role "Business Analyst" \
    --location "Halifax, NS" \
    --job-link "https://example.com/job" \
    --required-tools "SQL, Power BI, Excel" \
    --matching-tools "SQL, Power BI, Excel" \
    --stack-match-score "4/5" \
    --domain-fit "Healthcare operations analytics" \
    --proof-asset "wait-times-dashboard-preview.svg" \
    --status "shortlist" \
    --follow-up-date "2026-07-28" \
    --notes "Strong healthcare fit, reporting-heavy role" \
    [--append-csv]

Required flags:
  --company
  --role
  --location
  --job-link
  --required-tools
  --matching-tools
  --stack-match-score
  --domain-fit
  --proof-asset
  --status

Optional flags:
  --follow-up-date
  --notes
  --append-csv      Append the generated CSV row to tracker/applications.csv
  --help            Show this help text

This helper prints:
  1. A CSV row for tracker/applications.csv
  2. A markdown block for tracker/first-five-applications.md
EOF
}

csv_escape() {
  local value="${1:-}"
  if [[ "$value" == *","* || "$value" == *'"'* || "$value" == *$'\n'* ]]; then
    value="${value//\"/\"\"}"
    printf '"%s"' "$value"
  else
    printf '%s' "$value"
  fi
}

company=""
role=""
location=""
job_link=""
required_tools=""
matching_tools=""
stack_match_score=""
domain_fit=""
proof_asset=""
status=""
follow_up_date=""
notes=""
append_csv="false"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --company) company="${2:-}"; shift 2 ;;
    --role) role="${2:-}"; shift 2 ;;
    --location) location="${2:-}"; shift 2 ;;
    --job-link) job_link="${2:-}"; shift 2 ;;
    --required-tools) required_tools="${2:-}"; shift 2 ;;
    --matching-tools) matching_tools="${2:-}"; shift 2 ;;
    --stack-match-score) stack_match_score="${2:-}"; shift 2 ;;
    --domain-fit) domain_fit="${2:-}"; shift 2 ;;
    --proof-asset) proof_asset="${2:-}"; shift 2 ;;
    --status) status="${2:-}"; shift 2 ;;
    --follow-up-date) follow_up_date="${2:-}"; shift 2 ;;
    --notes) notes="${2:-}"; shift 2 ;;
    --append-csv) append_csv="true"; shift ;;
    --help) usage; exit 0 ;;
    *)
      echo "Unknown argument: $1" >&2
      usage
      exit 1
      ;;
  esac
done

required_values=(
  "$company"
  "$role"
  "$location"
  "$job_link"
  "$required_tools"
  "$matching_tools"
  "$stack_match_score"
  "$domain_fit"
  "$proof_asset"
  "$status"
)

for value in "${required_values[@]}"; do
  if [[ -z "$value" ]]; then
    echo "Missing one or more required flags." >&2
    usage
    exit 1
  fi
done

today="$(date +%F)"

csv_row="$(
  printf '%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s' \
    "$(csv_escape "$today")" \
    "$(csv_escape "$company")" \
    "$(csv_escape "$role")" \
    "$(csv_escape "$location")" \
    "$(csv_escape "$job_link")" \
    "$(csv_escape "$required_tools")" \
    "$(csv_escape "$matching_tools")" \
    "$(csv_escape "$stack_match_score")" \
    "$(csv_escape "$domain_fit")" \
    "$(csv_escape "$proof_asset")" \
    "$(csv_escape "$status")" \
    "$(csv_escape "$follow_up_date")" \
    "$(csv_escape "$notes")"
)"

markdown_block=$(cat <<EOF
- company: $company
- role: $role
- location: $location
- job link: $job_link
- why it fits: $domain_fit
- matching tools: $matching_tools
- stack match score: $stack_match_score
- project bullet to emphasize: $notes
- proof asset to link: $proof_asset
- status: $status
EOF
)

echo "CSV row:"
echo "$csv_row"
echo
echo "Markdown block:"
echo "$markdown_block"

if [[ "$append_csv" == "true" ]]; then
  echo "$csv_row" >> "$APPLICATIONS_CSV"
  echo
  echo "Appended row to tracker/applications.csv"
fi
