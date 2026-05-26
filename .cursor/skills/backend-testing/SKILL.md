---
name: backend-testing
description: Runs and extends FastAPI backend pytest suites in Docker. Use when adding or fixing backend tests, debugging API regressions, or checking coverage under backend/tests/.
---

# Backend testing

## Stack

- Tests live in `backend/tests/` (pytest).
- Full CI-style run from repo root: `bash ./scripts/test.sh` (builds stack, runs tests, tears down).
- With stack already up: `docker compose exec backend bash scripts/tests-start.sh [pytest args]`.

## Workflow

1. Prefer existing helpers in `backend/tests/utils/` (`user.py`, `item.py`, `utils.py`) before duplicating setup.
2. Add tests next to the feature area under `backend/tests/`; follow existing naming (`test_*.py`).
3. Run a focused file: `docker compose exec backend bash scripts/tests-start.sh backend/tests/api/routes/test_items.py -x`.
4. After API schema or route changes, regenerate the OpenAPI client if the frontend depends on it (see `openapi-client-gen` skill).

## Coverage

- HTML report: `backend/htmlcov/index.html` after a test run.
- Do not commit coverage artifacts unless the project already tracks them.

## Safety

- Do not weaken assertions to make tests pass; fix behavior or fixtures.
- Avoid real external services; use test DB and fixtures provided by the stack.
