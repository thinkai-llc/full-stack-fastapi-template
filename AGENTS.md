# Agent context map

This file is the entry point for AI-assisted development. Long-lived project context lives in the documents below—not in chat history. Read the relevant guides before making changes.

## Canonical context sources

| Topic | Document |
| --- | --- |
| Local development, Docker Compose, linting, tests | [development.md](development.md) |
| Production deployment, Traefik, CI/CD | [deployment.md](deployment.md) |
| Backend layout, models, API, uv workflow | [backend/README.md](backend/README.md) |
| Frontend stack, Vite/React, client generation | [frontend/README.md](frontend/README.md) |
| Contribution workflow, PR expectations, AI use | [CONTRIBUTING.md](CONTRIBUTING.md) |

The root [README.md](README.md) summarizes the stack and how to use the template.

## Conventions for agents

- Prefer small, focused changes; match existing patterns in the touched area.
- Run or update tests when changing behavior; see [development.md](development.md) for how to run the stack and test suites.
- Do not commit secrets (`.env`, credentials) or skip hooks unless the user explicitly asks.
- Follow [CONTRIBUTING.md](CONTRIBUTING.md) for discussions, PR scope, and meaningful human review of AI-assisted work.
