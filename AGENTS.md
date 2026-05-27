# Agent guide

Conventions for AI-assisted development in this repository. See [development.md](./development.md), [backend/README.md](./backend/README.md), and [frontend/README.md](./frontend/README.md) for full setup details.

## Non-interactive commands

Use these shell commands for CI-parity build and test (no prompts). Mirrors [.github/workflows/test-backend.yml](./.github/workflows/test-backend.yml) and lint hooks in [development.md](./development.md).

```bash
docker compose up -d db mailcatcher
cd backend && uv run bash scripts/prestart.sh && uv run bash scripts/tests-start.sh
uv run prek run --all-files
```

Run `uv run prek run --all-files` from the repository root. Run the `docker compose` and `backend` steps from the repository root as well.
