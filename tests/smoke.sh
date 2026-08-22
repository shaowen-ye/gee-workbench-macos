#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP_ROOT="$(mktemp -d)"
trap 'rm -rf "$TMP_ROOT"' EXIT

export HOME="$TMP_ROOT/home"
export GEE_WORKBENCH_INSTALL_ROOT="$TMP_ROOT/install"
export GEE_WORKBENCH_APP_DIR="$TMP_ROOT/Applications"
export GEE_WORKBENCH_SKIP_PYTHON_INSTALL=1
mkdir -p "$HOME"

bash "$ROOT/scripts/install.sh"

test -d "$GEE_WORKBENCH_APP_DIR/GEE Workbench.app"
test -f "$GEE_WORKBENCH_INSTALL_ROOT/notebooks/public_demo.ipynb"
test -f "$HOME/.config/gee-workbench/config.toml"
test ! -e "$GEE_WORKBENCH_INSTALL_ROOT/.env"
test ! -e "$GEE_WORKBENCH_INSTALL_ROOT/.git"
codesign --verify --deep --strict "$GEE_WORKBENCH_APP_DIR/GEE Workbench.app"

echo "Temporary-home installation smoke test passed."
