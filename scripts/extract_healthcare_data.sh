#!/bin/zsh

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
RAW_DIR="$ROOT_DIR/data/raw"
EXTRACTED_DIR="$RAW_DIR/extracted"

mkdir -p "$EXTRACTED_DIR"

unzip -o "$RAW_DIR/13100701-eng.zip" -d "$EXTRACTED_DIR" >/dev/null
unzip -o "$RAW_DIR/17100157-eng.zip" -d "$EXTRACTED_DIR" >/dev/null
unzip -o "$RAW_DIR/ODHF_v1.1.zip" -d "$EXTRACTED_DIR" >/dev/null

echo "Extracted archives into $EXTRACTED_DIR"
