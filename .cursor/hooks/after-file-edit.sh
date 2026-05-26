#!/usr/bin/env bash
# Optional prek on agent-edited files. See .cursor/hooks/README.md
set -euo pipefail

if [[ "${CURSOR_RUN_PREK_ON_EDIT:-}" != "1" ]]; then
  exit 0
fi

input=$(cat)
file_path=$(printf '%s' "$input" | python3 -c '
import json, sys
try:
    data = json.load(sys.stdin)
except json.JSONDecodeError:
    sys.exit(0)
path = data.get("file_path") or data.get("path") or ""
if path:
    print(path)
' 2>/dev/null || true)

[[ -n "${file_path:-}" ]] || exit 0

repo_root="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$repo_root"

case "$file_path" in
  backend/*|frontend/*)
  ;;
  *)
    exit 0
    ;;
esac

if command -v uv >/dev/null 2>&1; then
  uv run prek run --files "$file_path" || true
fi

exit 0
