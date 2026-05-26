# Cursor agent hooks

Project-level [Cursor hooks](https://cursor.com/docs/agent/hooks) automate checks around agent file edits and shell commands. Configuration lives in [`.cursor/hooks.json`](../hooks.json); scripts run from the repository root.

## Registered hooks

| Event | Script | Matcher | Purpose |
|-------|--------|---------|---------|
| `afterFileEdit` | `after-file-edit.sh` | `Write`, `StrReplace` | Optionally run [prek](https://prek.j178.dev/) on the edited file (lint/format aligned with `.pre-commit-config.yaml`). |
| `postToolUse` | `post-shell-hint.sh` | `Shell` | After shell commands, suggest targeted backend tests when a matching test file exists. |

Both hooks **fail open** (errors do not block the agent) unless you change the scripts or set `failClosed: true` in `hooks.json`.

## Opt-in: prek after agent edits

By default, `after-file-edit.sh` is a no-op so agent sessions stay fast. To run prek on each agent-edited file under `backend/` or `frontend/`:

```bash
export CURSOR_RUN_PREK_ON_EDIT=1
```

Requires `uv` on `PATH` (same as [development.md](../../development.md#pre-commits-and-code-linting)). Manual equivalent:

```bash
uv run prek run --files path/to/changed/file
```

## Post-shell test hints

After a `Shell` tool call that touches `backend/app/**/*.py`, `post-shell-hint.sh` looks for a corresponding `backend/tests/**/test_*.py` and returns `additional_context` suggesting:

```bash
cd backend && uv run pytest path/to/test_file.py
```

This does not run pytest automatically (tests may need Docker/DB). Run tests when you are ready.

## Adding or changing hooks

1. Edit `.cursor/hooks.json` (schema `version: 1`).
2. Add scripts under `.cursor/hooks/` with a shebang; make them executable (`chmod +x`).
3. Use the narrowest [hook event](https://cursor.com/docs/agent/hooks) and a `matcher` when possible.
4. Reload: save `hooks.json` or restart Cursor; verify in **Settings → Hooks** or the **Hooks** output channel.

Example — gate destructive git commands (`failClosed: true`):

```json
{
  "version": 1,
  "hooks": {
    "beforeShellExecution": [
      {
        "command": ".cursor/hooks/block-force-push.sh",
        "matcher": "git push.*--force",
        "failClosed": true
      }
    ]
  }
}
```

## Safety conventions

- Prefer **audit or suggest** over auto-running heavy commands (full `prek --all-files`, full pytest suite) during agent loops.
- Do not commit secrets; hooks read stdin JSON only — no credential files.
- Match [CONTRIBUTING.md](../../CONTRIBUTING.md) and pre-commit rules; hooks complement, not replace, `uv run prek install` before `git commit`.
