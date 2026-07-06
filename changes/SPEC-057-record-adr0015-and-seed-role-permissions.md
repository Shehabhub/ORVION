# Change Request — SPEC-057

## Status

[ ] Draft
[ ] Approved
[ ] In Progress
[x] Complete
[ ] Cancelled

Allowed values are exactly these five. Do not use any other status word anywhere in a Change Request.

---

## Assigned Model Tier

[x] Tier 1 — Strong reasoning model
[ ] Tier 2 — Local execution agent (Qwen3.8B)

---

## Objective

Record the owner-approved permission-model decision as ADR-0015 (binary `role_permissions`, Option A, current operational model) and seed `role_permissions` with the strict "Yes" grants transcribed from `28_permissions_matrix.md`.

---

## Business Reason

SPEC-056 seeded the flat `roles` and `permissions` vocabularies but left `role_permissions` empty pending an owner decision on how the scope-aware / conditional / plan-gated matrix realizes onto the binary mapping table. The owner approved Option A: keep the frozen binary schema; enforce scope/conditional/plan at point-of-use (RLS + RPC + subscription logic); treat this as the current operational model with a standing evidence-based escalation trigger. This CR records that decision and populates the role→permission grants ORVION's future authorization checks will read.

---

## Risks

Low. One ADR append (documentation) + one idempotent seed migration (data only, no DDL). Grants are transcribed strictly from the canonical matrix using a mechanical rule (strict "Yes" only). Nothing consumes `role_permissions` yet, so there is no live authorization impact; the seed simply makes the canonical grants present and auditable.

---

## Supersedes / Depends On

Depends On: `SPEC-056` (roles + permissions seeded), `SPEC-052` (RLS scope enforcement), `28_permissions_matrix.md` (grant source). Establishes ADR-0015. Precedes any `has_permission()` enforcement function.

---

## Scope — Files Allowed to Modify

- reports/architecture-decision-records.md (append ADR-0015)
- supabase/migrations/202607043600_seed_role_permissions.sql

---

## Out of Scope — Files Forbidden to Modify

- _ORVION_CANONICAL/** ; supabase/config.toml ; any existing migration ; table structure (no columns added to role_permissions) ; roles/permissions seed data ; any enforcement function

---

## Minimum Reading List

- _ORVION_CANONICAL/28_permissions_matrix.md (grant source of truth)
- reports/architecture-decision-records.md (ADR-0013, ADR-0014)
- supabase/migrations/202607043500_seed_roles_and_permissions.sql (roles/permissions seed)

---

## Implementation Steps

1. Append ADR-0015 to `reports/architecture-decision-records.md` (binary `role_permissions`; scope/conditional/plan enforced at point-of-use; strict-"Yes"-only seeding rule; current operational model + evidence-based escalation trigger).
2. Create `supabase/migrations/202607043600_seed_role_permissions.sql`: for each permission in `28`, insert one `role_permissions` row per role whose matrix cell is a strict "Yes" (Optional / Assigned-only / Limited / "Own branch" / "Branch only" / "Finance related" / "Assigned related only" / plan-only / No → no row). Idempotent `on conflict (role_id, permission_id) do nothing`.

---

## Acceptance Criteria

- [x] ADR-0015 recorded with decision, rationale, rejected alternatives, consequences, and the escalation trigger.
- [x] The seed migration exists; `npx supabase db reset` applies cleanly.
- [x] `role_permissions` contains exactly the strict-"Yes" grants of `28` (spot-verified: owner has broad grants but NOT the 5 plan/platform-gated permissions; system_administrator has zero rows — all its cells are Optional; finance-only permissions grant exactly owner/ceo/finance_manager).
- [x] Re-applying the migration neither duplicates nor errors (idempotent).
- [x] The Phase 2 verification smoke-test still passes.

---

## Execution Log

### 2026-07-06 — Claude (Tier 1)

Outcome: Complete

Step results:
- Step 1: Applied — ADR-0015 appended.
- Step 2: Applied — created the seed migration; `npx supabase db reset` applied all migrations cleanly. `role_permissions` seeded with **239 grants across 59 permissions**. **5 permissions correctly have zero role rows** — MANAGE_SUBSCRIPTION (Owner/CEO = Limited), REVIEW_SUBSCRIPTION_PAYMENT (platform-owner only), ACCESS_API_READ_ONLY, ACCESS_API_FULL (plan-gated columns), and VIEW_ADVANCED_DASHBOARDS (appears only in the plan feature table, no role cell in any permission table). Idempotent re-apply returned INSERT 0 0; count unchanged at 239.

Spot-checks (all passed): owner grant count = 59 and ceo = 59 (every permission except the 5 plan/platform-gated ones); system_administrator = 0 (all its cells are Optional); trainee = 0 (all its cells are Limited/No); finance_manager = 15 (ALLOW_ISSUE_WITH_NEGATIVE_BALANCE + 11 finance + UPLOAD/ARCHIVE/CREATE_DOCUMENT_VERSION); the finance-only permissions resolve to exactly {owner, ceo, finance_manager}; employee holds only its 7 strict-Yes cells (CREATE_LEAD, VIEW_ASSIGNED_LEADS, CREATE_CUSTOMER, CREATE_TASK, VIEW_ASSIGNED_TASKS, CREATE_COMPLAINT, CREATE_SERVICE_REQUEST) — not ASSIGN_LEAD (Optional→no) nor CLOSE_LEAD (Assigned-only→no).

Correction to the pre-execution estimate: the draft anticipated ~247 grants / 60 perms / 4 zero-grant; the verified figures are 239 / 59 / 5. The extra zero-grant permission is VIEW_ADVANCED_DASHBOARDS, which the matrix gates purely by plan (no role "Yes"), so it correctly receives no role row under the strict-"Yes" rule.

Commits: recorded at Complete.

Blocker: none.

---

## Verification Notes

### 2026-07-06 — Claude (independent review)

Verdict: Confirmed Complete

Findings: ADR-0015 faithfully records the approved Option A and the evidence-based escalation trigger. The seed applies the strict-"Yes" rule mechanically and consistently across all eight matrix tables; reconciled the permission that appears in two tables (VIEW_FINANCIAL_DOCUMENTS — owner/ceo/finance_manager in both). Conditional and scoped-conditional cells are correctly excluded, deferring their enforcement to the RPC layer per ADR-0015. `role_permissions` gains no columns (frozen schema respected). Idempotent; smoke-test still passes. No file outside Scope modified.

Recommendation to human: Set Status to Complete

---

## Review Gate

- [x] Every change matches the Implementation Steps.
- [x] No file outside Scope was modified.
- [x] Every Acceptance Criteria item is confirmed true.
- [x] The repository is in a clean, releasable state.

---

## Notes

Seeding rule (mechanical, auditable): a `role_permissions` row is created only where the role's cell in `28` is exactly "Yes". Every conditional or narrowed cell — Optional, Assigned only, Limited, "Own branch", "Branch only", "Own department", "Department only", "Finance related", "Assigned related only" — and every plan-only column (API) and "No" cell produces no row. Those capabilities are not lost: under ADR-0015 they are enforced (and, where a role legitimately holds them conditionally) resolved at the point of use when the guarding RPC is built — at which point the corresponding grant rows are added by that capability's own CR. This keeps the seed a faithful, non-lossy transcription of the *unconditional* grants while honouring the earn-it principle for the conditional ones.
