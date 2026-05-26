---
name: deploy-compose
description: Guides Docker Compose local dev and production deployment with Traefik. Use when changing compose files, .env, domains, staging/production deploy, or Traefik routing.
---

# Deploy and Docker Compose

## Local development

- Start stack: `docker compose watch` (uses `compose.yml` + `compose.override.yml` + `.env`).
- Logs: `docker compose logs [service]`.
- After `.env` changes: restart with `docker compose watch`.
- Docs: `development.md` (ports, Mailcatcher, mixed local/Docker workflows).

Default URLs: frontend `http://localhost:5173`, API `http://localhost:8000`, Adminer `http://localhost:8080`.

## Compose layout

| File | Role |
|------|------|
| `compose.yml` | Base stack (db, backend, frontend, proxy labels) |
| `compose.override.yml` | Dev overrides (volumes, local Traefik) |
| `compose.traefik.yml` | Shared Traefik proxy for remote servers |
| `.env` | Secrets and `DOMAIN`, `STACK_NAME`, DB credentials |

## Production / staging

- Follow `deployment.md`: public Traefik on `traefik-public` network, wildcard DNS, `compose.traefik.yml` on the server.
- Set `DOMAIN` and stack name in `.env` before deploy; never commit real secrets to public repos.
- GitHub Actions workflows in `.github/workflows/` handle automated deploy when configured.

## Subdomain local test

Set `DOMAIN=localhost.tiangolo.com` in `.env`, then `docker compose watch` to exercise subdomain routing locally.

## Safety

- Do not force-push or change production secrets without explicit user request.
- Prefer `docker compose` over raw `docker run` so labels and networks stay consistent.
- Tear down test stacks cleanly (`docker compose down -v`) when scripts expect a fresh DB.
