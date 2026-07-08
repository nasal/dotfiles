---
name: cleanup
description: Repo housekeeping — dead code, unused deps and exports, stale config comments, leftover console.logs — verified with /check and committed in reviewable chunks. Use for "clean up", "tidy the repo", or after big migrations.
---

# /cleanup

Housekeeping only — zero behavior changes. If removing something would change behavior, it's not cleanup; flag it instead.

## Targets

1. **Unused code**: run `bunx knip` if the repo has no config objections — unused files, exports, and dependencies in one pass. Verify each hit before deleting (knip has false positives with dynamic imports and framework magic).
2. **Stale tool artifacts**: lint-ignore comments for tools no longer in the repo (e.g. `biome-ignore` after the Oxc migration), configs for removed tools, `.disabled` files nobody re-enabled (ask before deleting those — they were kept on purpose once).
3. **Debug leftovers**: `console.log`/`print` outside the repo's logger, commented-out code blocks, TODOs that are already done.
4. **Unused dependencies**: cross-check knip's list against actual imports, then `bun remove`.
5. **Dead branches** (local git): list merged branches, propose deletion — don't delete unmerged work.

## Rules

- One commit per category (`remove unused exports`, `drop stale biome-ignore comments`) — reviewable chunks, easy to revert.
- `/check` after every commit-sized chunk, full green before moving on.
- Never remove comments that explain *why* something is the way it is — only provably stale ones.
- Never touch code that works but looks ugly — that's `/simplify` or a refactor task, not cleanup.
- Finish with a short report: what was removed, what was suspicious but left alone (and why).
