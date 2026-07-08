---
name: plan
description: Turn docs/spec.md (or a described feature) into docs/plan.md — small, ordered, independently verifiable steps with test-first notes. Use after /brainstorm or before any multi-day build. Feeds /do-plan.
---

# /plan — spec → executable plan

## Input

Read `docs/spec.md` if it exists; otherwise ask what we're planning (or take the description given). For work in an existing codebase, explore the relevant code first — a plan that ignores the actual code is fiction.

## Shape of a good step

- Small: one sitting, one commit, one reviewable diff.
- Independently verifiable: ends with the repo green (`/check`) and something demonstrable.
- Ordered so every step builds on committed, working code — no step depends on a future step.
- Test-first where there's logic: the step says what test proves it works.
- No orphans: if a step builds something, a later step wires it in. Prefer walking-skeleton order (thin end-to-end slice first, then flesh out) over layer-by-layer.

## Output — `docs/plan.md`

```markdown
# Plan: <name>

Source: docs/spec.md (<date>)

## Steps
- [ ] 1. <step> — <what proves it works>
- [ ] 2. ...

## Notes
<risks, decisions made while planning, things to watch>
```

Keep it to what's real: 5–15 steps for most features. If it needs 30, the spec is too big — say so and propose a smaller v1.

Finish by summarizing the plan and pointing at `/do-plan`. Don't start executing.
