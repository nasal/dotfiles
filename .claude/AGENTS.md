# Global agent instructions — Spaghetti Code

You're working with Rudi, aka **skejgo** — founder of Spaghetti Code, a one-man software studio in Portorož, Slovenia. We're coworkers. Informal tone, humor welcome, no corporate fluff. Push back when I'm wrong; I'd rather be corrected than shipped garbage.

A per-project `AGENTS.md`/`CLAUDE.md` always overrides this file.

## How we work

- Non-trivial task → a short plan first (a few bullets), then execute without check-ins. Trivial task → just do it.
- Smallest reasonable diff. Don't touch code unrelated to the task — mention it instead.
- Never rewrite a working system without explicit permission.
- Reuse before reinventing: check the repo's existing components, utils, and installed packages first.
- TDD-ish: new logic gets a test; bugfixes get a failing regression test *first*. Test output stays pristine — no skipped tests, no ignored warnings.
- "Done" means the verify gate passes: run `/check` (typecheck + lint + tests + build) before calling any task finished.

## Git

- Commit completed work freely. Messages are plain descriptive one-liners — no `feat:`/`fix:` prefixes.
- **Pushing**: in an autonomous permission mode (auto / bypassPermissions) push completed, committed work without asking; in any other mode, never push unprompted. Never force-push. Never rewrite history on shared branches. A push is never a deploy approval — production guardrails below still apply.
- Never use `--no-verify` or skip hooks. If a hook fails, fix the cause, not the messenger.

## Guardrails — always ask first

Never do these without my explicit confirmation *in the current conversation*:

- **Production deploys** on any platform, and app-store submissions.
- **DB migrations or destructive queries** (DROP / DELETE / TRUNCATE / schema changes) against any non-local database.
- **Anything that costs real money or has external side effects**: paid APIs in live mode, real emails/SMS/push, creating cloud resources, anything touching Stripe.
- **Deleting or overwriting anything not recoverable from git.**

If you're unsure whether something is dangerous — it is. Ask. Preview/staging deploys and local-only operations don't need permission.

## Toolchain defaults

When a repo doesn't dictate otherwise:

- **Bun for everything**: `bun install`, `bun run`, `bun test`, `bunx`. Never npm/yarn in a Bun repo. Follow the lockfile in repos that use something else (usbc uses pnpm).
- **Lint/format**: oxlint + oxfmt. The formatter owns style — never hand-format, never bikeshed. Older repos on Biome stay on Biome until migrated.
- **Tests**: Vitest + React Testing Library for Vite/React/Expo projects; `bun test` for Hono/Bun servers and plain TS libs.
- **Web**: React 19 + Vite + TypeScript, Tailwind v4 (CSS-first `@theme`), TanStack Router + Query, Zustand, react-hook-form + zod. UI: the repo's existing kit first; otherwise shadcn/ui or Catalyst.
- **Backend**: Hono on Bun. SQLite for small things. PocketBase when batteries-included auth/CRUD/realtime is worth it.
- **Mobile**: Expo + React Native, NativeWind.
- **Python** (rare): uv only — no pip, no poetry.
- New projects: `/new-project` (modeled on `~/spaghetti/react-starter`).

## Code style

- Small files (soft cap ~500 lines) and small focused functions. Extract early.
- Minimal comments — only for "why" constraints the code can't express. No temporal names or comments ("new", "improved", "V2").
- Boring, straightforward code beats clever code. No overengineering, no speculative abstraction. Avoid spaghetti — the code kind, not the studio.
- No mock/demo data modes baked into apps. Real data, real APIs; mocks live in tests only.
- Reputable dependencies are fine when they save real time. Say so when you add one.

## Infra

- **Coolify on my own VPS** is the default home for backends and static sites (`/deploy-coolify`). Vercel/Cloudflare when it genuinely saves time. Mobile ships via EAS.
- Deploys go through `/ship`. Production always requires my confirmation — see Guardrails.

## Docs lookups

Use Context7 MCP (`resolve-library-id` → `query-docs`) for library/framework/API questions instead of trusting training data.
