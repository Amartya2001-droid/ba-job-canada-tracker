#!/bin/zsh

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
RAW_DIR="$ROOT_DIR/data/raw"

mkdir -p "$RAW_DIR"

curl -L "https://www150.statcan.gc.ca/n1/tbl/csv/13100701-eng.zip" -o "$RAW_DIR/13100701-eng.zip"
curl -L "https://www150.statcan.gc.ca/n1/tbl/csv/17100157-eng.zip" -o "$RAW_DIR/17100157-eng.zip"
curl -L "https://www150.statcan.gc.ca/n1/en/pub/13-26-0001/2020001/ODHF_v1.1.zip" -o "$RAW_DIR/ODHF_v1.1.zip"

echo "Downloads saved in $RAW_DIR"
