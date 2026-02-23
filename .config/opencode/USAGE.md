# Sub-agent usage guide

## Best-use sequences

### 1) New feature (recommended)

1. `team-lead` -> break work into phases, assign subagents, track completion.
2. `architect` -> produce implementation plan, risks, validation checklist.
3. `frontend-feature-implementer` (or `ui-system-composer` if mostly UI) -> implement.
4. `review` -> severity-based review and fixes list.
5. `edit` -> apply review fixes with minimal diffs.

### 2) UI system/component work

1. `team-lead` -> define scope and acceptance criteria.
2. `ui-system-composer` -> implement reusable components and variants.
3. `review` -> accessibility, API, maintainability review.
4. `edit` -> patch review findings.

### 3) Performance/data issues

1. `team-lead` -> coordinate baseline, optimization tasks, validation gates.
2. `data-flow-and-performance-optimizer` -> optimize TanStack Query/Router + Zustand boundaries.
3. `review` -> verify safety, regressions, missing tests.
4. `edit` -> apply concrete fixes.

### 4) Bug fix / hotfix

1. `team-lead` -> contain scope and define rollback path.
2. `edit` -> implement minimal targeted fix.
3. `review` -> prioritize correctness and risk.
4. `edit` -> patch any critical findings.

## Agent prompt examples

## team-lead (agent/team-lead.md)

```
Own this feature from start to finish: add bulk actions to the Projects table. Break the work into architecture, implementation, and review phases; delegate each phase to the best subagent; run independent tasks in parallel; then return final status, risks, and next steps.
```

## architect (agent/architect.md)

```
Design a migration plan to move our auth flow from page-level guards to TanStack Router route guards. Keep behavior unchanged, call out risks, rollout strategy, and validation checklist.
```

## edit (agent/edit.md)

```
Implement the approved auth guard plan with minimal diffs. Update only the affected router/auth files, preserve current UX, and run targeted type checks/tests for touched paths.
```

## review (agent/review.md)

```
Review current uncommitted changes. Report findings by severity (blocker/high/medium/low), include impacted files/symbols, explain user impact, and suggest concrete fixes.
```

## frontend-feature-implementer (agent/frontend-feature-implementer.md)

```
Add a Project Activity page at /projects/$projectId/activity using TanStack Router + Query. Include loading/empty/error/success states, use shadcn UI + Tailwind, and keep shared state in Zustand only if it is cross-route.
```

## ui-system-composer (agent/ui-system-composer.md)

```
Create a reusable FilterBar component system (search input, status select, date range, reset
button) using shadcn primitives and Tailwind. Define a clean variant API and ensure keyboard/a11y support.
```

## data-flow-and-performance-optimizer (agent/data-flow-and-performance-optimizer.md)

```
Audit dashboard data flow: query keys, stale/cache behavior, invalidation, route prefetch, and rerenders. Propose and implement high-impact optimizations with measurable before/after expectations.
```
