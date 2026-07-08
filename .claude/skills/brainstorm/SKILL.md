---
name: brainstorm
description: Turn a fuzzy idea into a concrete spec by asking one question at a time, then save docs/spec.md. Use at the very start of a feature or project, before any code. Feeds /plan.
---

# /brainstorm — idea → spec

The user has an idea; your job is to sharpen it into something buildable. Interview first, write second.

## Interview

- **One question at a time.** Short, concrete, answerable. Prefer AskUserQuestion with real options over open-ended prompts.
- Build each question on the previous answer. Dig into: who uses it, the core flow (the ONE thing it must do well), data model, edge cases, what's explicitly OUT of scope, and any hard constraints (platform, deadline, existing systems).
- Challenge scope creep as it happens — "does v1 really need accounts?" is a great question.
- Stop when you can describe the MVP without hand-waving. Usually 5–10 questions. Don't interrogate past the point of usefulness.

## Output

Write `docs/spec.md`:

1. **What & why** — two sentences.
2. **Core flow** — the primary user journey, step by step.
3. **Requirements** — must-haves for v1, numbered.
4. **Out of scope** — explicit non-goals (this section prevents future scope fights).
5. **Data model sketch** — entities and relationships, rough.
6. **Stack & constraints** — per global defaults unless the answers said otherwise.
7. **Open questions** — anything deliberately deferred.

Then summarize the spec in a few lines and point at `/plan` as the next step. Don't start planning or coding — brainstorm ends at the spec.
