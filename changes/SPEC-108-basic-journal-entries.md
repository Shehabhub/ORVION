# Change Request — SPEC-108

## Status

[ ] Draft
[ ] Approved
[ ] In Progress
[x] Complete
[ ] Cancelled

---

## Assigned Model Tier

[x] Tier 1 — Strong reasoning model

[ ] Tier 2 — Local execution agent (Qwen3.8B)

---

## Objective

Add basic double-entry journal entries: `app.seed_default_chart_of_accounts()` (per-tenant default chart) and `app.create_journal_entry(...)` (balanced entry with lines) — the final Phase-6 Finance Core output.

---

## Business Reason

Phase 6 Finance Core "Basic journal entries" (07/14). Requires a chart of accounts (`chart_of_accounts` was unseeded and is per-tenant + customizable per canon 14), so a researched minimal travel-agency default chart is seeded per tenant as a starting point, and journal entries are recorded as balanced double-entry lines against it.

---

## Risks

Low. Additive: one unique index (`chart_of_accounts(tenant_id, code)`) + two `SECURITY INVOKER` RPCs; no table/column change. The default chart is `is_system_default` and idempotent; entries are validated balanced (Σdebit = Σcredit > 0), each line one-sided against an existing in-tenant active account. Both guarded by `CREATE_JOURNAL_ENTRY`. Chart content is a documented default and per-tenant customizable (canon 14), not an owner-lock. Verified by clean `db reset`, smoke-test, and behavioral tests: seed chart, a balanced entry, unbalanced/unknown-account/one-sided rejections, and the authority guard.

---

## Supersedes / Depends On

Depends on the finance foundation tables (`chart_of_accounts`/`journal_entries`/`journal_entry_lines`, migration 6) and the seeded `CREATE_JOURNAL_ENTRY`. Closes Phase 6 Finance Core. Supersedes nothing.

---

## Scope — Files Allowed to Modify

- supabase/migrations/202607047800_journal_entries.sql
- _ORVION_CANONICAL/manifest.md
- changes/SPEC-108-basic-journal-entries.md

---

## Out of Scope — Files Forbidden to Modify

- Any other `supabase/migrations/**` file (all applied migrations are immutable, incl. `202607043700_provision_tenant_and_has_permission.sql` — provisioning is NOT modified; the chart is seeded on demand); any `_ORVION_CANONICAL/**` except the manifest; AGENTS.md, CR_LIFECYCLE.md, README.md, `reports/**`. `32_execution_roadmap.md` is updated only by the separate `Freeze Phase 6` / `Start Phase 7` governance step, not this CR.

---

## Minimum Reading List

- _ORVION_CANONICAL/14_finance_rules.md (chart of accounts; customizable per company)
- supabase/migrations/202607041800_create_finance_foundation_tables.sql (chart/journal tables)

---

## Implementation Steps

1. Verify `202607047800_journal_entries.sql` does not exist. Add it: (a) unique index `chart_of_accounts_tenant_code_key on chart_of_accounts (tenant_id, code)`; (b) `app.seed_default_chart_of_accounts() returns integer` — `security invoker`, tenant via `app.current_tenant_id()`, `app.authorize('CREATE_JOURNAL_ENTRY')`, idempotent insert of the minimal default chart (asset/liability/equity/revenue/expense; `is_system_default`); (c) `app.create_journal_entry(p_source_type_code text, p_entry_date date, p_description text, p_lines jsonb, p_source_entity_id uuid default null) returns uuid` — `app.authorize('CREATE_JOURNAL_ENTRY')`; insert header; iterate jsonb lines validating non-negative, one-sided, and an existing active in-tenant account; enforce Σdebit = Σcredit > 0; emit `journal_entry_created`. Both `grant execute ... to authenticated`.
2. Sync `manifest.md` per `CR_LIFECYCLE.md §9` (trimmed).

---

## Acceptance Criteria

- [x] `npx supabase db reset` applies all migrations cleanly including `202607047800`.
- [x] Smoke-test `scripts/verify_database.sql` still reports ALL CHECKS PASSED (71 tables).
- [x] Behavioral: `seed_default_chart_of_accounts()` creates the default chart (returns 10) and is idempotent (returns 0 on re-run).
- [x] Behavioral: a balanced entry (DR Accounts Receivable 1000 / CR Sales Revenue 1000) is created and emits `journal_entry_created`; an unbalanced entry, a one-sided-violation line, and an unknown account code are rejected.
- [x] Behavioral: a caller without `CREATE_JOURNAL_ENTRY` (senior_employee) is blocked.
- [x] No canonical doc other than the manifest modified.

---

## Execution Log

### 2026-07-09 — Claude (Opus 4.8), Phase 6 execution

Outcome: Complete

Step results:
- Step 1: Applied — migration `202607047800_journal_entries.sql` created (unique index + two RPCs).
- Step 2: Applied — manifest synced (trimmed).

Verification: `npx supabase db reset` clean incl. `202607047800`; smoke-test → ALL CHECKS PASSED (71 tables). Behavioral (rolled back): `seed_default_chart_of_accounts()` → 10 accounts, re-run → 0 (idempotent); balanced DR AR 1000 / CR Sales 1000 → entry id + `journal_entry_created`; unbalanced (1000/900) → `not balanced`; one-sided violation (a line with both debit and credit) → rejected; unknown account code → rejected; senior_employee → `permission denied: CREATE_JOURNAL_ENTRY`.

Commits: (recorded on commit)

---

## Verification Notes

### 2026-07-09 — Claude (Opus 4.8)

Verdict: Confirmed Complete

Findings: Independently verified against live DB — `db reset` clean, smoke ALL CHECKS PASSED (71 tables). The default chart seeds idempotently per tenant; `create_journal_entry` enforces balance and per-line integrity against in-tenant accounts, emits its event, and rejects unbalanced/one-sided/unknown-account/unauthorized cases. Additive; provisioning untouched; no canon change beyond the manifest. Chart content is a researched, customizable default (canon 14), not a new architectural lock.

Recommendation to human: Set Status to Complete (autonomous per `CR_LIFECYCLE.md` §5). This is the last Phase-6 output; `Freeze Phase 6` may now apply.

---

## Review Gate

- [x] Every change matches the Implementation Steps exactly, or was correctly recorded as Already Applied.
- [x] No file outside the Scope list was modified or created.
- [x] No section was added, removed, or restructured outside the approved steps.
- [x] Every Acceptance Criteria item is confirmed true.
- [x] Any step that could not be resolved deterministically was reported, not guessed.
- [x] Supersedes / Depends On handled (nothing to supersede).
- [x] The repository is in a clean, releasable state.

---

## Notes

Completes Phase 6 Finance Core (all `32` Phase-6 outputs delivered). Automatic journal posting from finance events (invoice/payment/refund → entries) is a deferred future enhancement — this slice provides the manual balanced-entry primitive and the default chart. `Freeze Phase 6` + `Start Phase 7` follow as a governance step. Research: minimal travel-agency chart per Antravia/BooksTime/Gridlex references.
