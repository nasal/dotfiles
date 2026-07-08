# <project-name>

<One or two sentences: what this is and who it's for.>

Global rules apply (~/.claude/CLAUDE.md). Only project-specific facts live here — if a rule is generic, it belongs in the global file, not in this one.

## Stack

<Only what differs from or pins the global defaults — e.g. "React 19 + Vite + TanStack, PocketBase backend in pocketbase/". Delete this section if the defaults fully apply.>

## Commands

- dev: `bun run dev`
- test: `bun run test`
- check: typecheck + lint + test via `/check`

## Deploy

<Filled in by /ship after the first successful deploy:>
- Target: <coolify | vercel | cloudflare | eas>
- App: <coolify app uuid / vercel project / etc.>
- URL: <https://...>
- Env vars: <names only, never values>

## Gotchas

<The stuff that will bite an agent that doesn't know the repo: quirky scripts, built-vs-source packages, preserved typos in APIs, files that must not be edited (generated), etc. This is the most valuable section — keep it honest and current.>
