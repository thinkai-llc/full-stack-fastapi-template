# Agent instructions

Copy-paste commands for AI-assisted development. Run from the repository root unless a working directory is noted.

## Package roots

| Path | Role |
|------|------|
| `backend/` | FastAPI app, SQLModel, Alembic, Pytest (`backend/app/`, `backend/tests/`) |
| `frontend/` | Vite + React + TypeScript (`frontend/src/`, `frontend/tests/`) |

Root `pyproject.toml` is a uv workspace; Python dependencies live in `backend/pyproject.toml`. Frontend uses Bun workspaces via root `package.json` (`bun run --filter frontend …`).

## Backend — uv / pytest

Sync dependencies:

```bash
uv sync --all-packages
```

Run tests locally (DB + mailcatcher via Compose, then pytest in `backend/`):

```bash
docker compose down -v --remove-orphans
docker compose up -d db mailcatcher
cd backend && uv run bash scripts/prestart.sh && uv run bash scripts/tests-start.sh
```

Run pytest directly (stack must already be up and migrated):

```bash
cd backend && uv run pytest tests/
```

Stop on first failure:

```bash
cd backend && uv run pytest tests/ -x
```

Coverage (matches CI):

```bash
cd backend && uv run bash scripts/test.sh
cd backend && uv run coverage report --fail-under=90
```

## Lint / format — prek

Install git hooks (run once, from `backend/`):

```bash
cd backend && uv run prek install -f
```

Run all hooks on the repo:

```bash
cd backend && uv run prek run --all-files
```

CI-style diff (from repo root, after `uv sync --all-packages` and `bun ci`):

```bash
uvx prek run --from-ref origin/master --to-ref HEAD --show-diff-on-failure
```

Backend-only ruff (also invoked by prek):

```bash
cd backend && uv run ruff check --force-exclude .
cd backend && uv run ruff format --force-exclude .
```

## Docker Compose

Start the full dev stack (watch mode):

```bash
docker compose watch
```

Build and start detached:

```bash
docker compose build
docker compose up -d
```

Run backend tests inside the stack:

```bash
bash ./scripts/test.sh
```

Or, if the stack is already running:

```bash
docker compose exec backend bash scripts/tests-start.sh
docker compose exec backend bash scripts/tests-start.sh -x
```

Logs and teardown:

```bash
docker compose logs backend
docker compose down -v --remove-orphans
```

## Frontend — Bun

Install (repo root or `frontend/`):

```bash
bun install
```

Dev server:

```bash
bun run dev
```

Lint, build, and E2E (from repo root):

```bash
bun run lint
cd frontend && bun run build
bun run test
bun run test:ui
```

Playwright (backend must be up):

```bash
docker compose up -d --wait backend
cd frontend && bunx playwright test
cd frontend && bunx playwright test --ui
docker compose down -v
```

Regenerate OpenAPI client after backend schema changes:

```bash
bash ./scripts/generate-client.sh
```

## Safe conventions

- Do not commit secrets (`.env`, keys, passwords). Use `.env` locally; CI injects env vars.
- Prefer small, focused diffs; match existing Ruff/Biome style (prek enforces hooks).
- Regenerate `frontend/src/client/` only via `scripts/generate-client.sh` or `bun run generate-client` after API changes.
- Run `cd backend && uv run prek run --all-files` and relevant tests before opening a PR.
- Do not force-push `master` or skip git hooks unless explicitly requested.

## Further reading

- [development.md](development.md) — local Docker, Mailcatcher, prek
- [backend/README.md](backend/README.md) — migrations, container workflows
- [frontend/README.md](frontend/README.md) — client generation, Playwright
