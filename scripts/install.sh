#!/usr/bin/env bash
set -euo pipefail

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "This installer currently supports macOS only." >&2
  exit 1
fi

SOURCE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
INSTALL_ROOT="${GEE_WORKBENCH_INSTALL_ROOT:-$HOME/.local/share/gee-workbench}"
APP_DIR="${GEE_WORKBENCH_APP_DIR:-$HOME/Applications}"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/gee-workbench"
APP_PATH="$APP_DIR/GEE Workbench.app"

case "$INSTALL_ROOT" in
  ""|"/"|"$HOME") echo "Unsafe install root: $INSTALL_ROOT" >&2; exit 1 ;;
esac

mkdir -p "$INSTALL_ROOT" "$APP_DIR" "$CONFIG_DIR"
rsync -a --delete \
  --exclude '.git/' --exclude '.venv/' --exclude '.env*' \
  --exclude '.jupyter/' --exclude '.ipynb_checkpoints/' \
  --exclude '__pycache__/' --exclude 'reports/' --exclude 'exports/' \
  "$SOURCE_ROOT/" "$INSTALL_ROOT/"

if [[ "${GEE_WORKBENCH_SKIP_PYTHON_INSTALL:-0}" != "1" ]]; then
  if [[ -z "${PYTHON_CMD:-}" ]]; then
    if [[ -x "/opt/homebrew/opt/python@3.12/libexec/bin/python3" ]]; then
      PYTHON_CMD="/opt/homebrew/opt/python@3.12/libexec/bin/python3"
    elif [[ -x "/usr/local/opt/python@3.12/libexec/bin/python3" ]]; then
      PYTHON_CMD="/usr/local/opt/python@3.12/libexec/bin/python3"
    else
      PYTHON_CMD="$(command -v python3)"
    fi
  fi
  "$PYTHON_CMD" -c 'import sys; assert sys.version_info >= (3, 11), "Python 3.11+ is required"'
  "$PYTHON_CMD" -m venv "$INSTALL_ROOT/.venv"
  "$INSTALL_ROOT/.venv/bin/python" -m pip install --upgrade pip
  "$INSTALL_ROOT/.venv/bin/python" -m pip install -e "$INSTALL_ROOT"
fi

if [[ ! -f "$CONFIG_DIR/config.toml" ]]; then
  cp "$INSTALL_ROOT/config/config.example.toml" "$CONFIG_DIR/config.toml"
fi

chmod u+x "$INSTALL_ROOT/launcher/macos/start-gee-workbench.sh"
rm -rf "$APP_PATH"
osacompile -o "$APP_PATH" "$INSTALL_ROOT/launcher/macos/GEE_Workbench.applescript"
cp "$INSTALL_ROOT/launcher/macos/assets/GEEWorkbench.icns" \
  "$APP_PATH/Contents/Resources/GEEWorkbench.icns"
plutil -replace CFBundleIconFile -string 'GEEWorkbench.icns' "$APP_PATH/Contents/Info.plist"
plutil -remove CFBundleIconName "$APP_PATH/Contents/Info.plist" 2>/dev/null || true
plutil -replace CFBundleDisplayName -string 'GEE Workbench' "$APP_PATH/Contents/Info.plist"
plutil -replace CFBundleName -string 'GEE Workbench' "$APP_PATH/Contents/Info.plist"
plutil -replace CFBundleIdentifier -string 'org.local.gee.workbench' "$APP_PATH/Contents/Info.plist"
plutil -replace CFBundleShortVersionString -string '0.1.0' "$APP_PATH/Contents/Info.plist"
plutil -replace CFBundleVersion -string '1' "$APP_PATH/Contents/Info.plist"
codesign --force --deep --sign - "$APP_PATH" >/dev/null
touch "$APP_PATH"

if command -v jlab >/dev/null 2>&1 && [[ -x "$INSTALL_ROOT/.venv/bin/python" ]]; then
  jlab config set pythonPath "$INSTALL_ROOT/.venv/bin/python" >/dev/null 2>&1 || true
  jlab config set defaultWorkingDirectory "$INSTALL_ROOT" >/dev/null 2>&1 || true
fi

echo "Installed: $APP_PATH"
echo "Configuration: $CONFIG_DIR/config.toml"
echo "Set your Cloud project ID before launching."
