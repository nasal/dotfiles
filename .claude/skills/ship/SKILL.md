---
name: ship
description: Test → commit → deploy pipeline. Runs the /check gate, commits work, then deploys to the project's target (Coolify, Vercel, Cloudflare, EAS). Production deploys always stop for explicit confirmation. Use when asked to ship, release, or deploy.
---

# /ship — test, commit, deploy

## Pipeline

1. **Gate**: run `/check`. Red → fix or stop. Never ship red.
   For production-bound or risky changes, also spawn the `code-reviewer` agent on the diff — and the `qa-tester` agent when the change touches user-facing flows — and resolve anything severe before continuing.

2. **Commit**: if the working tree is dirty, commit with a plain descriptive one-liner. Don't push unless the deploy target requires it (git-based deploys) — and say so when you do.

3. **Resolve the deploy target**, in order:
   1. The project's `AGENTS.md` "Deploy" section (authoritative — write one after the first successful deploy so next time is zero-discovery).
   2. Config files: `Dockerfile`/Coolify → `/deploy-coolify`; `vercel.json`/`.vercel/` → Vercel; `wrangler.toml` → Cloudflare; `eas.json` → EAS.
   3. Neither → ask. Default preference is Coolify.

4. **Deploy**:
   - **Preview/staging**: go ahead autonomously.
   - **PRODUCTION**: STOP. State exactly what will deploy where ("deploy <commit> of <project> to <target> production") and wait for explicit yes in this conversation. A general "ship it" earlier in the session does not carry over — ask at the moment of the prod deploy. This includes `vercel --prod`, Coolify production apps, `wrangler deploy` to prod routes, `eas submit`.

5. **Verify the deploy**: check deployment status/logs; hit the health/root URL. If it's broken, say so immediately and offer rollback — don't quietly retry.

6. **Record**: if the project's AGENTS.md has no Deploy section yet, add one (target, app identifier/uuid, URL, any gotchas).

## Never

- Never ship with failing or skipped checks.
- Never run DB migrations as part of a deploy without separate explicit confirmation (see global guardrails).
- Never store tokens in the repo or in AGENTS.md — reference env var names only.
