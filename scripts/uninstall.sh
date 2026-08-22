#!/usr/bin/env bash
set -euo pipefail

INSTALL_ROOT="${GEE_WORKBENCH_INSTALL_ROOT:-$HOME/.local/share/gee-workbench}"
APP_DIR="${GEE_WORKBENCH_APP_DIR:-$HOME/Applications}"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/gee-workbench"

case "$INSTALL_ROOT" in
  ""|"/"|"$HOME") echo "Unsafe install root: $INSTALL_ROOT" >&2; exit 1 ;;
esac

rm -rf "$APP_DIR/GEE Workbench.app" "$INSTALL_ROOT"
if [[ "${1:-}" == "--purge-config" ]]; then
  rm -rf "$CONFIG_DIR"
else
  echo "Configuration preserved at: $CONFIG_DIR"
fi
echo "GEE Workbench removed."
