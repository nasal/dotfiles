---
name: do-plan
description: Execute docs/plan.md step by step — test first, implement, run the full verify gate, commit, tick the box. Use to continue work on a planned feature ("continue the plan", "next step").
---

# Do Plan — execute the plan

## Loop

1. Read `docs/plan.md`. No plan → point at the `plan` workflow and stop.
2. Take the **first unchecked step**. Re-read the touched code first — the codebase may have moved since planning.
3. Execute TDD-ish: failing test first where the step has logic, implement until green, keep the diff scoped to the step. For steps with meaty logic, delegate the red phase to a test-writer subagent when one is available and delegation is useful.
4. Run the `check` workflow — full gate, not just the new test.
5. Commit (plain one-liner) and mark the step `[x]` in `docs/plan.md` (include the tick in the commit).
6. One-line progress note, then continue to the next step.

## When to stop mid-plan

- The next step hits a global guardrail (prod, migrations, money) → ask.
- Reality diverged from the plan (step is now wrong/unnecessary/much bigger) → update `docs/plan.md` with a note, tell the user what changed and why, continue only if the fix is obvious.
- Something the plan assumed doesn't exist → same: revise plan, surface it.
- All boxes ticked → final summary of what shipped, suggest the `ship` or `cleanup` workflow if warranted.

Never mark a step done that didn't pass the full verify gate. Never batch multiple steps into one commit — the per-step rhythm is the point.
