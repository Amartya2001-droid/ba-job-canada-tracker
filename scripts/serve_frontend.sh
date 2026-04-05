#!/bin/zsh

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PORT="${1:-4173}"

echo "Serving frontend at http://127.0.0.1:$PORT"
python3 -m http.server "$PORT" -d "$ROOT_DIR/frontend"
