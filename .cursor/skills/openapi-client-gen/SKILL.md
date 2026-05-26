---
name: openapi-client-gen
description: Regenerates the TypeScript OpenAPI client for the React frontend after backend API changes. Use when routes, models, or request/response schemas change, or when frontend client types are out of sync.
---

# OpenAPI client generation

## When to run

After changing FastAPI routes, Pydantic models, or anything reflected in the OpenAPI schema consumed by the frontend.

## Regenerate (repo root)

```bash
bash ./scripts/generate-client.sh
```

This script:

1. Exports OpenAPI JSON from `app.main` via `backend` (`uv run python -c "import app.main; ..."`).
2. Writes `frontend/openapi.json`.
3. Runs `bun run --filter frontend generate-client` (`@hey-api/openapi-ts`).
4. Runs `bun run lint`.

Generated output: `frontend/src/client/` (`sdk.gen.ts`, `schemas.gen.ts`, `types.gen.ts`, etc.). Config: `frontend/openapi-ts.config.ts`.

## After generation

- Fix any frontend call sites that broke due to renamed operations or types.
- Commit `openapi.json` and generated client files together with backend changes.
- Do not hand-edit `*.gen.ts` files; change the API or generator config instead.

## Safety

- Run backend tests after API changes (`backend-testing` skill).
- Keep operation IDs stable when possible to reduce frontend churn.
