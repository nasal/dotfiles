---
name: deploy-coolify
description: Deploy an app to Rudi's self-hosted Coolify instance via its REST API — trigger deploys, watch status, tail logs. Use when deploying to Coolify or when the ship workflow resolves Coolify as the target.
---

# Deploy Coolify

Coolify is the default home for backends and static sites. Talks to the Coolify REST API (v1).

## Credentials

- Base URL: `$COOLIFY_URL`; token: `$COOLIFY_API_TOKEN`. Use values already exported into the process environment; never read `.env`, `~/.env`, shell history, or credential files into model context.
- Missing → ask the user to export or source the variables outside the agent session, then retry. **Never echo the token, write it to a file, or commit it.**
- Auth header: `Authorization: Bearer $COOLIFY_API_TOKEN`.

## First deploy of a project

1. `GET /api/v1/applications` — find the app by name/git URL. Not there → the app must be created in the Coolify UI first (creating resources = costs/infra = ask the user; offer to walk them through it).
2. Save what you learn to the project's `AGENTS.md` Deploy section: app **uuid**, environment, deploy branch, whether pushes auto-deploy, deploy command/API trigger, and public URL. Never store the token.

## Deploying

1. Determine the app uuid (AGENTS.md Deploy section, else discover as above).
2. Determine whether pushing the deploy branch triggers a deployment. Unknown means stop and ask before pushing.
3. **Production app or production-triggering push? Explicit confirmation required immediately before the first triggering action** — global guardrail, no exceptions.
4. Push only when the deployment contract requires it and the user has authorized that push in the current conversation.
5. Trigger when required: `GET /api/v1/deploy?uuid=<app-uuid>` (add `&force=true` to skip build cache when needed).
6. Poll `GET /api/v1/deployments/{deployment_uuid}` until finished/failed.
7. **Failed** → fetch deployment logs from the same endpoint, diagnose, report root cause. Don't blind-retry.
8. **Finished** → hit the app's health/root URL and confirm it responds before declaring success.

## Env vars on the app

`GET/PATCH /api/v1/applications/{uuid}/envs` — changing production env vars counts as a production change: confirm first, and remind that a redeploy/restart applies them.

API details change between Coolify versions — when a call 404s, check the instance's `/docs` (OpenAPI) or Context7 for the current spec.
