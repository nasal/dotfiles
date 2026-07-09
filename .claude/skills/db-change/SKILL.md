---
name: db-change
description: Plan, implement, and verify safe database schema or data changes. Use for migrations, indexes, constraints, backfills, data cleanup, Prisma or Drizzle schema changes, PocketBase migrations, raw SQL changes, or any DROP, DELETE, TRUNCATE, ALTER, or production-data operation.
---

# Database Change

Treat an unproven target as non-local. Creating migration files locally is ordinary code work; applying them to a non-local database crosses the explicit confirmation boundary.

## Workflow

1. **Identify the target and contract**
   - Read the applicable `AGENTS.md`, schema, migration history, database tooling, and deployment path.
   - Classify the target as disposable local/test, staging, or production. Do not infer safety from a command name or an environment variable existing.
   - Use credentials already available to the process without printing them or reading credential files into model context.

2. **Classify the change**
   - Separate schema changes, indexes or constraints, backfills, destructive data operations, and application compatibility work.
   - Identify locking, table-scan, downtime, data-loss, and mixed-version deployment risks.
   - Prefer expand-and-contract changes when old and new application versions may overlap.

3. **Design rollback and verification**
   - Make the migration reversible when the database and change permit it.
   - For irreversible changes, define backup and restore steps before execution.
   - Define measurable postconditions: schema shape, row counts, invariants, query behavior, and application checks.
   - Batch large backfills and make retries idempotent where practical.

4. **Test locally first**
   - Add or update application tests before implementation when behavior changes.
   - Apply the migration to a disposable local database or snapshot from the previous schema.
   - Test both a fresh database and an upgrade path when the repository supports both.
   - Run the affected tests and the full check workflow.

5. **Preview any non-local execution**
   - State the exact environment, command or statements, migration identifier, expected impact, backup status, rollback path, and verification plan.
   - Obtain explicit confirmation immediately before any non-local migration, schema change, backfill, or destructive query.
   - Treat an unclear target, missing backup, or missing rollback plan as a stop condition.

6. **Execute and verify**
   - Use the repository's migration tool and committed migration files instead of ad hoc live schema edits.
   - Use transactions where supported and appropriate; do not assume DDL is transactional.
   - Stop on the first unexpected result. Never blind-retry a partially applied migration.
   - Verify every defined postcondition and run the application health checks.

## Hard Rules

- Never run `DROP`, `DELETE`, `TRUNCATE`, schema changes, or bulk rewrites against a non-local database without current-conversation confirmation.
- Never use `db push`-style schema synchronization against production when the repository uses versioned migrations.
- Never log secrets, connection strings, raw PII, or sensitive row contents.
- Never mark a migration complete merely because the command exited successfully; verify the data and application behavior.

## Report

Record the migration identifier, target environment, approval boundary, backup and rollback status, verification results, and any follow-up monitoring needed. Never record credentials.
