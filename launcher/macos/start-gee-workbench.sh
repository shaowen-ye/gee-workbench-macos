#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
PYTHON_BIN="$ROOT_DIR/.venv/bin/python"
NOTEBOOK="$ROOT_DIR/notebooks/public_demo.ipynb"

if [[ ! -x "$PYTHON_BIN" ]]; then
  echo "Python environment not found: $PYTHON_BIN" >&2
  echo "Run scripts/install.sh again." >&2
  exit 1
fi

if command -v jlab >/dev/null 2>&1; then
  JLAB_BIN="$(command -v jlab)"
elif [[ -x "/Applications/JupyterLab.app/Contents/Resources/app/jlab" ]]; then
  JLAB_BIN="/Applications/JupyterLab.app/Contents/Resources/app/jlab"
else
  echo "JupyterLab Desktop CLI not found. Install JupyterLab Desktop first." >&2
  exit 1
fi

exec "$JLAB_BIN" \
  --python-path "$PYTHON_BIN" \
  --working-dir "$ROOT_DIR" \
  "$NOTEBOOK"
