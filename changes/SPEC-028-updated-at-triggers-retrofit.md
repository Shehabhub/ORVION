# Change Request — SPEC-028

## Status

[ ] Draft
[x] Approved
[ ] In Progress
[ ] Complete
[ ] Cancelled

Allowed values are exactly these five. Do not use any other status word (for example
"Ready", "Implemented", or "Rejected") anywhere in a Change Request.

---

## Assigned Model Tier

Mark one:

[ ] Tier 1 — Strong reasoning model
    Permitted modes: ANALYZE, PLAN, REVIEW, REFACTOR

[x] Tier 2 — Local execution agent (Qwen3.8B)
    Permitted modes: IMPLEMENT only

---

## Objective

Create the retrofit migration that enables the `moddatetime` extension and adds `before update` triggers so `updated_at` advances on every update for the existing `updated_at` tables (`catalog_values`, `currencies`), before migration 4.

---

## Business Reason

`30_database_conventions.md`'s Timestamp Standard (established by SPEC-027) requires every table with an `updated_at` column to maintain it via a database `before update` trigger, with `moddatetime` as the recommended mechanism. `catalog_values` (SPEC-024) and `currencies` (SPEC-025) already have `updated_at` columns but no trigger, and no trigger mechanism is yet enabled (this is SPEC-027 Finding F1). This migration closes that gap. It must land before migration 4, because migration 4's tables carry `updated_at` and will add their own triggers, which requires the mechanism already enabled. `catalog_types` is intentionally excluded — per `31_schema_draft.md` section 1 it has no `updated_at` column (SPEC-024 Finding F3), so it needs no trigger.

---

## Risks

Low. One migration: enables one extension (`create extension if not exists moddatetime`, idempotent) and creates two triggers on existing tables. No table, column, or data is changed. `moddatetime` is the mechanism recommended by `30`'s Timestamp Standard; a hand-written `plpgsql` function is the permitted equivalent but is not used here (this migration adopts the recommended option). Verified during design that no existing migration creates a conflicting trigger.

---

## Supersedes / Depends On

Depends On: `changes/SPEC-024-migration-2-system-catalog-tables.md` and `changes/SPEC-025-migration-3-reference-tables.md` (the tables), and `changes/SPEC-027-referential-actions-updated-at.md` (the convention) — all Complete.

---

## Scope — Files Allowed to Modify

- supabase/migrations/202607041500_add_updated_at_triggers.sql

---

## Out of Scope — Files Forbidden to Modify

- _ORVION_CANONICAL/** (all canonical documents are read-only for this task)
- supabase/config.toml
- supabase/migrations/202607041200_enable_extensions.sql (migration 1, complete)
- supabase/migrations/202607041300_create_system_catalog_tables.sql (migration 2, complete)
- supabase/migrations/202607041400_create_reference_tables.sql (migration 3, complete)
- Any other migration file (migration 4+ is not authored here)
- catalog_types (has no updated_at column; correctly receives no trigger)

---

## Minimum Reading List

- _ORVION_CANONICAL/30_database_conventions.md
- changes/SPEC-027-referential-actions-updated-at.md

---

## Implementation Steps

1. Verification check: determine whether any file matching `supabase/migrations/*_add_updated_at_triggers.sql` already exists. If one exists, record this step as Already Applied and make no change. If none exists, create the file `supabase/migrations/202607041500_add_updated_at_triggers.sql` with exactly the following content and nothing else:

```sql
-- Migration: add_updated_at_triggers
-- Plan reference: SPEC-027 Finding F1 (retrofit) — precedes migration 4.
-- Enables the moddatetime extension (30_database_conventions.md Timestamp Standard,
-- recommended mechanism) and adds before-update triggers so updated_at advances on
-- every update for the existing updated_at tables.
--
-- catalog_types is intentionally excluded: it has no updated_at column
-- (31_schema_draft.md section 1; SPEC-024 Finding F3).

create extension if not exists moddatetime;

create trigger catalog_values_set_updated_at
    before update on catalog_values
    for each row execute function moddatetime(updated_at);

create trigger currencies_set_updated_at
    before update on currencies
    for each row execute function moddatetime(updated_at);
```

---

## Acceptance Criteria

- [ ] A single file `supabase/migrations/202607041500_add_updated_at_triggers.sql` exists with exactly the content specified in Step 1.
- [ ] `npx supabase db reset` applies all migrations (1, 2, 3, and this one) on a clean local database with no error.
- [ ] After reset, the `moddatetime` extension is enabled (`select 1 from pg_extension where extname = 'moddatetime';` returns one row).
- [ ] A `before update` trigger named `catalog_values_set_updated_at` exists on `catalog_values`, and `currencies_set_updated_at` exists on `currencies`.
- [ ] `catalog_types` has no trigger (it has no `updated_at` column).
- [ ] Functional check: within a rolled-back transaction, inserting a row and then updating it advances `updated_at` beyond `created_at` for both `catalog_values` and `currencies` (verifying the trigger fires); no test data persists.

---

## Execution Log

[Appended by the executing agent (Tier 2) after each run against this Change Request, before
IMPLEMENT is considered complete, per synchronization as defined in AGENTS.md's Agent Handoff
Protocol — this file is always implicitly in scope for this section.
Append-only — never edit or delete a prior entry, including a Blocked or Failed one.
Leave this section's bracketed instructions in place in an unused template; remove them
only in a CR that has at least one real entry.]

### <YYYY-MM-DD HH:MM> — <agent identifier>

Outcome: Complete | Blocked | Failed

Step results:
- Step 1: Already Applied | Applied | Failed — <one-line reason>

Commits: <commit hash(es) for this run>

Blocker: <only present if Outcome is Blocked or Failed. One factual paragraph describing
exactly which verification check produced an unanticipated result and where. Do not propose
or apply a guessed resolution.>

---

## Verification Notes

[Appended by the reviewing agent (Tier 1) after independently re-checking the Execution Log
against the live repository state. Append-only — never edit or delete a prior entry.]

### <YYYY-MM-DD HH:MM> — <agent identifier>

Verdict: Confirmed Complete | Discrepancy Found | Needs Corrective Change Request

Findings: <what was independently re-checked, and what was found>

Recommendation to human: Set Status to Complete | Set Status to Cancelled | Approve corrective
Change Request `changes/SPEC-00N-*.md`

---

## Review Gate

[Human-completed. Do not mark Status as Complete until every item below is checked.]

- [ ] Every change matches the Implementation Steps exactly, or was correctly recorded as
      Already Applied per its verification check.
- [ ] No file outside the Scope list was modified or created.
- [ ] No section was added, removed, or restructured outside the approved steps.
- [ ] Every Acceptance Criteria item is confirmed true.
- [ ] Any step that could not be resolved deterministically was reported, not guessed.
- [ ] If this Change Request's Supersedes / Depends On section names another file, that file's
      Status has been updated accordingly.
- [ ] The repository is in a clean, releasable state.

---

## Notes

This migration adopts the recommended `moddatetime` mechanism from `30`'s Timestamp Standard. Every table created from migration 4 onward includes its own `before update` trigger in its own migration; this retrofit only covers the two tables that were created before the convention existed.

Trigger naming follows the pattern `<table>_set_updated_at`, matching the example in `30`'s Timestamp Standard.

---

## Findings

- **F1 — `catalog_types` correctly excluded.** `catalog_types` has no `updated_at` column (`31_schema_draft.md` section 1; SPEC-024 F3), so it receives no trigger. Recorded to make the exclusion explicit rather than an oversight. **Classification: Informational** (no action).
