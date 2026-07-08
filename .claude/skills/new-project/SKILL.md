---
name: new-project
description: Scaffold a new Spaghetti Code project — React web app (from ~/spaghetti/react-starter), Expo mobile app, or Hono/Bun backend — with tests, lint, thin AGENTS.md, and git initialized. Use when starting any new project or prototype.
---

# /new-project — scaffolder

Args: project name (kebab-case), and optionally type + backend. If missing, ask ONE question with the choices below, then proceed.

- **Type**: `react` (web, default) | `expo` (mobile) | `api` (backend only)
- **Backend** (react only): `none` (default) | `pocketbase` | `hono`

Target directory: `~/spaghetti/<name>` unless told otherwise.

## React web app

Blueprint is `~/spaghetti/react-starter` — copy it, don't recreate it:

1. `cp -r ~/spaghetti/react-starter ~/spaghetti/<name>` then `rm -rf .git node_modules`.
2. Rename: `package.json` name, `index.html` title, README heading.
3. **Scrub starter artifacts**:
   - Remove stale `biome-ignore` comments (repo uses oxlint/oxfmt now); re-add as `oxlint-disable-next-line` only if the lint error is real.
   - In `pocketbase/` hooks: replace hardcoded Stripe `price_...` IDs with env vars — never leave them in a fresh project.
4. **Backend choice**:
   - `none` → delete `pocketbase/` dir.
   - `pocketbase` → keep `pocketbase/`, document setup in README.
   - `hono` → delete `pocketbase/`, scaffold `server/` per the "Hono API" section below (same repo, separate package).
5. **Add tests** (starter ships without a runner): `bun add -d vitest @testing-library/react @testing-library/jest-dom jsdom`, add `"test": "vitest run"` + `"test:watch": "vitest"` scripts, a `vitest.config.ts` (jsdom, `@` alias matching vite), and one real smoke test (render a route, assert content) so the suite is green from commit one.
6. Write a thin `AGENTS.md` from `~/dotfiles/.claude/templates/AGENTS.project.md` (fill in name, stack, commands, deploy target), then `ln -s AGENTS.md CLAUDE.md`.
7. `bun install`, then run `/check` — everything must be green.
8. `git init -b main`, initial commit.

## Expo mobile app

No starter repo yet — scaffold fresh, apply house conventions:

1. `bunx create-expo-app@latest <name>` (default template, TypeScript), Expo Router.
2. Add NativeWind (Tailwind for RN) — check Context7 for current setup steps.
3. House conventions (from eubc-native): every screen respects safe-area insets; light/dark handled from day one (`useColorScheme`); haptics on meaningful interactions (expo-haptics); MMKV for local storage when persistence is needed; reuse components across screens — build a small `components/ui/` kit early instead of one-off styling.
4. Tests: vitest is not the RN norm — use `jest-expo` preset + React Native Testing Library, one smoke test.
5. oxlint + oxfmt, scripts, thin AGENTS.md + CLAUDE.md symlink, git init, `/check`.

## Hono API (standalone `api` type, or `server/` inside a react project)

1. `bun init`, add `hono` and `zod`.
2. Structure: `src/index.ts` (Bun.serve + Hono app), `src/routes/`, `src/db.ts` (`bun:sqlite`, WAL mode), `src/env.ts` (zod-validated, fail fast at startup).
3. `bun test` with one real test hitting the app via `app.request()`.
4. `Dockerfile` (oven/bun slim, non-root) + healthcheck route `GET /health` — Coolify-ready.
5. Thin AGENTS.md + CLAUDE.md symlink, git init, `/check`.

## Always

- No secrets in the repo: `.env.example` documented, real `.env` gitignored.
- Finish by printing: dir, how to run dev, how to run tests, what was scaffolded.
- Do NOT create a GitHub repo or push — that's the user's move.
