---
name: deploy-coolify
description: Deploy an app to Rudi's self-hosted Coolify instance via its REST API — trigger deploys, watch status, tail logs. Use when deploying to Coolify or when /ship resolves Coolify as the target.
---

# /deploy-coolify

Coolify is the default home for backends and static sites. Talks to the Coolify REST API (v1).

## Credentials

- Base URL: `$COOLIFY_URL`; token: `$COOLIFY_API_TOKEN`. Look in the shell env, then the project `.env` (gitignored), then `~/.env`.
- Missing → ask the user once for the instance URL and where the token lives; tell them to put it in `~/.env` as `COOLIFY_API_TOKEN`. **Never echo the token, never write it to any file yourself, never commit it.**
- Auth header: `Authorization: Bearer $COOLIFY_API_TOKEN`.

## First deploy of a project

1. `GET /api/v1/applications` — find the app by name/git URL. Not there → the app must be created in the Coolify UI first (creating resources = costs/infra = ask the user; offer to walk them through it).
2. Save what you learn to the project's `AGENTS.md` Deploy section: app **uuid**, environment (staging/production), public URL. Uuid and URL only — never the token.

## Deploying

1. Determine the app uuid (AGENTS.md Deploy section, else discover as above).
2. **Production app? Explicit confirmation required first** — global guardrail, no exceptions.
3. Coolify deploys from git: if the deploy needs your local commits and pushing is required, say so and get the push approved — never push silently.
4. Trigger: `GET /api/v1/deploy?uuid=<app-uuid>` (add `&force=true` to skip build cache when needed).
5. Poll `GET /api/v1/deployments/{deployment_uuid}` until finished/failed.
6. **Failed** → fetch deployment logs from the same endpoint, diagnose, report root cause. Don't blind-retry.
7. **Finished** → hit the app's health/root URL and confirm it responds before declaring success.

## Env vars on the app

`GET/PATCH /api/v1/applications/{uuid}/envs` — changing production env vars counts as a production change: confirm first, and remind that a redeploy/restart applies them.

API details change between Coolify versions — when a call 404s, check the instance's `/docs` (OpenAPI) or Context7 for the current spec.
