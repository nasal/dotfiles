---
name: deps-update
description: Update dependencies safely — patch/minor in one batch, majors one at a time with changelog review, and the full check workflow after every batch. Use for "update deps", "bump packages", or routine maintenance.
---

# Dependency Update

Strict protocol. An update that isn't tested is a downgrade.

## Steps

1. **Clean state required**: uncommitted changes → stop and ask (commit or stash first). Every batch must be revertable in isolation.

2. **Survey**: `bun outdated` (or the repo's package manager equivalent). Present the list grouped: patch, minor, major.

3. **Patch + minor — one batch**:
   1. Update all at once (`bun update` scoped, or `bunx npm-check-updates -u --target minor` + install).
   2. Run the `check` workflow (full gate: typecheck, lint, tests, build).
   3. Green → commit: `update dependencies (minor/patch)`.
   4. Red → bisect: revert half, re-check, isolate the offender; treat it like a major (below) or pin it and report.

4. **Majors — one package at a time**, riskiest last:
   1. Read the changelog/migration guide first (Context7, then the repo's GitHub releases). List the breaking changes that apply to this codebase.
   2. Update, apply required code migrations (use official codemods when they exist).
   3. Run the `check` workflow. Green → commit `upgrade <pkg> to v<X>`. Red and not trivially fixable → revert the package, report why, move on.

5. **Report**: table of updated / skipped-with-reason / needs-your-decision. Never leave the repo red — the final state must pass the full verify gate.

## Never

- Never update majors in bulk.
- Never delete or weaken tests to make an update pass.
- Never update in a dirty tree.
- Lockfile-only churn is fine to include; direct `package.json` changes are the ones that get scrutiny.
