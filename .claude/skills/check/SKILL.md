---
name: check
description: The "done" gate — run typecheck, lint, tests, and build for this repo and get everything green. Use before every commit, at the end of every task, and whenever asked "is this done?".
---

# Check — verify gate

Nothing is "done" until this passes. No exceptions, no "the failures are unrelated" (if they're unrelated, say so explicitly and ask — don't silently skip).

## Steps

1. **Detect the toolchain** from lockfile: `bun.lock`/`bun.lockb` → bun, `pnpm-lock.yaml` → pnpm, `package-lock.json` → npm. Read `package.json` scripts to find the repo's actual script names (`typecheck`, `lint`, `test`, `build`, `fmt:check` vary per repo).

2. **Run in this order**, fail fast:
   1. Typecheck (`typecheck` script, else `tsc --noEmit`, else `bunx tsc --noEmit`)
   2. Lint (`lint` script, else `oxlint`; if the repo uses Biome, `biome check`)
   3. Format check if a script exists (`fmt:check` / `oxfmt --check`)
   4. Tests — the full suite, not just the files you touched
   5. Build, when the repo has a build output that could break (`build` script). In monorepos with built packages (`@usbc/*` pattern), rebuild changed packages so apps consume fresh `dist/`.

3. **Monorepos** (turbo.json / pnpm-workspace.yaml / workspaces field): prefer the repo's pipeline (`turbo run check` etc.) or scope to changed packages plus their dependents.

4. **On failure**: fix the root cause and re-run. Hard rules:
   - Never weaken, skip, or delete a test to make it pass.
   - Never add lint-ignore comments or loosen configs to silence errors.
   - Never `--no-verify`.
   - If a failure may pre-exist your change, verify against `HEAD` in a temporary worktree or another non-destructive baseline. Never stash, reset, or overwrite the user's working tree without permission.

5. **Report** one line per gate: pass/fail, and what you fixed.
