---
name: split-file
description: Apply the 500-line rule — split an oversized runtime source file using the preferred extraction order (pure helpers → hooks/services → presentation subcomponents). Use when a file exceeds 500 lines, when extending a file that is already over, or when asked to break up a large file.
---

# Split an Oversized Source File

Scope: runtime/application `.ts`/`.tsx` only. Excluded: tests, generated files (`*.gen.*`, router trees), `dist/`, CSS/HTML/Markdown, pure type-only files.

## The rule

- New runtime source files stay ≤ **500 lines**; component files ≤ **200 lines**.
- Extending a file already over the limit? Extract first (or in the same commit) — never grow it further.

## Extraction order (preferred)

1. **Pure helpers** — side-effect-free functions → sibling `<name>.utils.ts`. Cheapest to move, easiest to test.
2. **Hooks / services** — stateful logic, API calls, subscriptions → `use<Thing>.ts` next to the consumer.
3. **Presentation subcomponents** — render chunks → sibling PascalCase files in the same feature folder. One component per file.

Keep extractions in the same feature folder unless genuinely shared — feature folders, not type folders. In monorepos, promote to a shared package only when used across 3+ packages. Don't create a barrel unless the folder has 3+ public components.

## Mechanics

- Move code verbatim first; refactor in a separate commit so review stays tractable.
- Extracted units get colocated tests when they contain logic worth testing in isolation.
- Run the `check` workflow after the split.
- If the repo tracks oversized files (e.g. `docs/large-source-files.md` in usbc-web), keep that list in sync: remove entries you fixed, add an entry with a split plan when forced to leave a file oversized.
