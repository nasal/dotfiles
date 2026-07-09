---
name: bugfix
description: Diagnose and fix reproducible software defects with a regression-test-first workflow. Use when the user reports a bug, regression, crash, flaky behavior, incorrect output, failing test, or asks to debug or fix behavior in an existing codebase.
---

# Bugfix

Fix the root cause with the smallest safe change. Do not patch symptoms or mix unrelated cleanup into the diff.

## Workflow

1. **Establish the failure**
   - Read the applicable `AGENTS.md`, current diff, relevant tests, and the execution path before editing.
   - Write down expected behavior, actual behavior, and a deterministic reproduction.
   - Reproduce the failure locally when possible. If it cannot be reproduced, gather more evidence instead of guessing.

2. **Add the regression first**
   - Add the smallest test that expresses the broken behavior at the closest stable test layer.
   - Run it and confirm it fails for the expected reason before changing implementation code.
   - For browser, native, timing, or environment failures that cannot be captured exactly, preserve a deterministic reproduction and test the lowest stable unit or integration boundary that covers the cause.

3. **Trace the root cause**
   - Follow callers, data transformations, state transitions, and error handling until the failure is explained.
   - Check recent history when it helps identify a regression, but never reset, stash, or overwrite the user's working tree.
   - Distinguish the first bad state from downstream symptoms.

4. **Apply the minimal fix**
   - Reuse existing helpers, components, and dependencies.
   - Preserve public behavior outside the reported defect.
   - Avoid speculative abstractions, broad rewrites, and drive-by formatting.

5. **Verify outward**
   - Run the new regression test.
   - Run the affected package or feature tests.
   - Run the full check workflow before calling the bug fixed.
   - Keep output pristine: no skipped tests, ignored warnings, weakened assertions, or lint suppressions.

## Hard Rules

- Never claim a fix without either a failing-before/passing-after test or a documented reproduction verified after the change.
- Never use production data or mutate an external system merely to reproduce a bug.
- Never add a dependency unless it materially reduces risk or complexity; say so when adding one.
- Stop and report the missing evidence when reproduction requires credentials, hardware, production access, or another unavailable dependency.

## Report

State the root cause, regression coverage, implementation change, and verification commands. Mention any part of the original report that remains unverified.
