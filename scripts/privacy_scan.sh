#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

FILES=()
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  while IFS= read -r file; do FILES+=("$file"); done \
    < <(git ls-files | grep -Ev '^(scripts/privacy_scan\.sh)$')
else
  while IFS= read -r file; do FILES+=("$file"); done \
    < <(find . -type f -not -path './.git/*' -not -path './.venv/*' \
      -not -path './.pytest_cache/*' -not -path './.ruff_cache/*' \
      -not -path '*/__pycache__/*' \
      -not -path '*.egg-info/*' -not -name '*.pyc' \
      -not -path './scripts/privacy_scan.sh' | sed 's#^./##')
fi

if ((${#FILES[@]} == 0)); then
  echo "No files to scan." >&2
  exit 1
fi

PATTERN='/Users/[A-Za-z0-9._-]+|yes-gisclaw-ee|upper_yangtze|refresh_token|access_token|Authorization:[[:space:]]*Bearer|AIza[0-9A-Za-z_-]{20,}|sk-[0-9A-Za-z_-]{16,}|gh[opsu]_[0-9A-Za-z]{20,}'

if rg -n -i -e "$PATTERN" --glob '!*.png' --glob '!*.icns' -- "${FILES[@]}"; then
  echo "Privacy scan failed." >&2
  exit 1
fi

echo "Privacy scan passed (${#FILES[@]} files)."
