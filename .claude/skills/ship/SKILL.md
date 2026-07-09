---
name: ship
description: Test → commit → deploy pipeline. Resolves push effects, runs the full check gate, commits work, then deploys to the project's target. Production deploys always stop for explicit confirmation. Use when asked to ship, release, or deploy.
---

# Ship — test, commit, deploy

## Pipeline

1. **Resolve the deployment contract before any push**:
   1. Read the project's `AGENTS.md` Deploy section for target, environment, deploy branch, push effects, and deploy command.
   2. Fall back to config files: `Dockerfile`/Coolify → `deploy-coolify`; `vercel.json`/`.vercel/` → Vercel; `wrangler.toml` → Cloudflare; `eas.json` → EAS.
   3. If the environment or push effects are unknown, ask. Never assume a push is deployment-free.

2. **Gate**: run the `check` workflow. Red → fix or stop. Never ship red.
   For production-bound or risky changes, delegate an adversarial diff review — and exploratory QA when user-facing flows changed — when suitable subagents are available. Resolve severe findings before continuing.

3. **Commit**: if the working tree is dirty, commit with a plain descriptive one-liner.

4. **Approval boundary**:
   - **Preview/staging**: push or deploy autonomously only when the request already authorized shipping and the documented push effects are non-production.
   - **PRODUCTION**: STOP. State exactly what will happen ("push/deploy <commit> of <project> to <target> production") and wait for explicit yes immediately before the first production-triggering action. A general "ship it" earlier in the session does not carry over. This includes a push to an auto-deploy branch, `vercel --prod`, Coolify production apps, `wrangler deploy` to production routes, and `eas submit`.

5. **Push/deploy**: perform only the action required by the recorded deployment contract. Never push merely because a commit exists.

6. **Verify the deploy**: check deployment status/logs; hit the health/root URL. If it's broken, say so immediately and offer rollback — don't quietly retry.

7. **Record**: keep the project's Deploy section current, including environment, deploy branch, push effects, deploy command, target identifier, URL, and gotchas.

## Never

- Never ship with failing or skipped checks.
- Never run DB migrations as part of a deploy without separate explicit confirmation (see global guardrails).
- Never store tokens in the repo or in AGENTS.md — reference env var names only.
