#!/usr/bin/env bash
# Suggest targeted pytest after backend shell edits. See .cursor/hooks/README.md
set -euo pipefail

repo_root="$(cd "$(dirname "$0")/../.." && pwd)"
input=$(cat)
hint=$(printf '%s' "$input" | REPO_ROOT="$repo_root" python3 -c '
import json, os, re, sys
from pathlib import Path

try:
    data = json.load(sys.stdin)
except json.JSONDecodeError:
    sys.exit(0)

command = data.get("command") or data.get("tool_input", {}).get("command") or ""
if not command:
    sys.exit(0)

repo = Path(os.environ["REPO_ROOT"])
matches = re.findall(r"backend/app/[\w./-]+\.py", command)
if not matches:
    sys.exit(0)

module_path = matches[-1]
stem = Path(module_path).stem
tests_dir = repo / "backend" / "tests"
if not tests_dir.is_dir():
    sys.exit(0)

candidates = sorted(tests_dir.rglob(f"test_{stem}.py"))
if not candidates:
    sys.exit(0)

rel = candidates[0].relative_to(repo / "backend")
print(f"If you changed {module_path}, consider: cd backend && uv run pytest {rel}")
' 2>/dev/null || true)

if [[ -n "${hint:-}" ]]; then
  python3 -c 'import json,sys; print(json.dumps({"additional_context": sys.argv[1]}))' "$hint"
else
  echo '{}'
fi

exit 0
