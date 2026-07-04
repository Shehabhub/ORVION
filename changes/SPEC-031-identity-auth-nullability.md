# Change Request — SPEC-031

## Status

[ ] Draft
[ ] Approved
[x] In Progress
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

Resolve the canonical contradiction in the `users` ↔ `auth.users` relationship by making `auth_user_id` nullable and reconciling every statement of a "mandatory one-to-one" relationship to an optional one-to-one (linked once activated), across `30_database_conventions.md`, `31_schema_draft.md`, and the Architecture Decision Records.

---

## Business Reason

The Migration 5 Design Review Gate found a contradiction that blocks correctly building the `users` table: `30_database_conventions.md`'s Identity Key Standard specifies `auth_user_id uuid not null unique references auth.users(id)` and calls the relationship "mandatory one-to-one," yet the same standard's rationale requires that a `users` row may exist before its corresponding `auth.users` row (an invited-but-not-yet-activated employee). A `NOT NULL` foreign key to `auth.users` makes that impossible. If `users` were built this way, ORVION could never support invited-but-not-activated employees without a future breaking migration. A verification pass found the same contradiction expressed in five places — `30`'s DDL and its "mandatory" wording, `31_schema_draft.md`'s `users` Notes and its `# 13` item 3, and ADR-0004 (seeded from the `30` text). This Change Request reconciles all five so the identity model is internally consistent before any identity table is implemented. It is the sibling of SPEC-030 (a canonical contradiction resolved before its migration).

---

## Risks

Low. Documentation-only change across two canonical documents and one report; no SQL, no schema structure, no data. Making `auth_user_id` nullable is strictly more permissive and does not weaken integrity: the `UNIQUE` constraint still enforces one-to-one for activated users (PostgreSQL allows multiple NULLs, so multiple pending invitations coexist), and the FK still guarantees any non-null value references a real `auth.users` row. The RLS lookup (`auth.uid()` → `users` via `auth_user_id`) is unaffected — an invited user has no auth session until activation. The activation/invitation lifecycle modeling is deliberately out of scope (see Findings F1).

---

## Supersedes / Depends On

None. This Change Request supersedes the `auth_user_id` nullability portion of the decision recorded in `31_schema_draft.md` `# 13` item 3, as that section explicitly permits ("unless a future approved Change Request explicitly supersedes it").

---

## Scope — Files Allowed to Modify

- _ORVION_CANONICAL/30_database_conventions.md
- _ORVION_CANONICAL/31_schema_draft.md
- reports/architecture-decision-records.md

---

## Out of Scope — Files Forbidden to Modify

- All other `_ORVION_CANONICAL/**` documents
- supabase/migrations/** (no SQL; the `users` migration is authored later, in Migration 5)
- The activation/invitation lifecycle model (invitation records, `invited_at`/`activated_at`, `invited_by`, user status) — deferred to the Future Backlog per Finding F1
- Any changes/SPEC-*.md file other than this one

---

## Minimum Reading List

- _ORVION_CANONICAL/30_database_conventions.md
- _ORVION_CANONICAL/31_schema_draft.md
- reports/architecture-decision-records.md

---

## Implementation Steps

1. In `30_database_conventions.md`'s Identity Key Standard, verification check: search for `auth_user_id uuid not null unique references auth.users(id)`. If absent, record Already Applied. If present, replace exactly:

`auth_user_id uuid not null unique references auth.users(id)`

with:

`auth_user_id uuid unique references auth.users(id)`

2. In `30_database_conventions.md`, verification check: search for `mandatory one-to-one relationship with `auth.users``. If absent, record Already Applied. If present, replace exactly:

``users` has a mandatory one-to-one relationship with `auth.users` (see`

with:

``users` has an optional one-to-one relationship with `auth.users` — exactly one once activated, and none while an employee is invited but not yet activated, so `auth_user_id` is nullable and is set (uniquely) on activation (see`

3. In `31_schema_draft.md`'s `users` Notes, verification check: search for `This table has a mandatory one-to-one relationship with `auth.users`.`. If absent, record Already Applied. If present, replace exactly:

`This table has a mandatory one-to-one relationship with `auth.users`.`

with:

`This table has an optional one-to-one relationship with `auth.users`: exactly one once activated, and none while an employee is invited but not yet activated (`auth_user_id` is null until activation, then set uniquely).`

4. In `31_schema_draft.md` `# 13. Review Required` item 3, verification check: search for `RESOLVED: `users` has a mandatory one-to-one relationship with `auth.users`.`. If absent, record Already Applied. If present, replace exactly:

`RESOLVED: `users` has a mandatory one-to-one relationship with `auth.users`.`

with:

`RESOLVED: `users` has an optional one-to-one relationship with `auth.users` — exactly one once activated, and none while invited-but-not-yet-activated (`auth_user_id` is nullable, set uniquely on activation).`

5. In `reports/architecture-decision-records.md` (ADR-0004), verification check: search for `a separate `auth_user_id uuid not null unique references auth.users(id)` is the sole link`. If absent, record Already Applied. If present, replace exactly:

`a separate `auth_user_id uuid not null unique references auth.users(id)` is the sole link to Supabase Auth. `users.id` is NOT set equal to `auth.users.id`.`

with:

`a separate `auth_user_id uuid unique references auth.users(id)` (nullable) is the sole link to Supabase Auth. `users.id` is NOT set equal to `auth.users.id`. `auth_user_id` is null while an employee is invited but not yet activated, and set uniquely on activation.`

---

## Acceptance Criteria

- [ ] `30_database_conventions.md`'s Identity Key Standard shows `auth_user_id uuid unique references auth.users(id)` with no `not null`.
- [ ] `30_database_conventions.md` no longer describes the relationship as "mandatory one-to-one"; it describes an optional one-to-one linked on activation.
- [ ] `31_schema_draft.md`'s `users` Notes no longer say "mandatory one-to-one"; they describe the optional relationship with a nullable `auth_user_id`.
- [ ] `31_schema_draft.md` `# 13` item 3 no longer says "mandatory one-to-one"; it describes the optional relationship.
- [ ] `reports/architecture-decision-records.md` ADR-0004 shows `auth_user_id` as nullable, consistent with the above.
- [ ] The phrase "mandatory one-to-one relationship with `auth.users`" no longer appears anywhere in the repository.
- [ ] No other content in the three files is altered, and no other file is modified.

---

## Execution Log

[Appended by the executing agent (Tier 2) after each run against this Change Request, before
IMPLEMENT is considered complete, per synchronization as defined in AGENTS.md's Agent Handoff
Protocol — this file is always implicitly in scope for this section.
Append-only — never edit or delete a prior entry, including a Blocked or Failed one.
Leave this section's bracketed instructions in place in an unused template; remove them
only in a CR that has at least one real entry.]

### 2026-07-04 21:06 — Claude Code (Opus 4.8), IMPLEMENT

Outcome: Complete

Step results:
- Step 1: Applied — `30` Identity Key Standard DDL changed `auth_user_id uuid not null unique references auth.users(id)` → `auth_user_id uuid unique references auth.users(id)`.
- Step 2: Applied — `30` "mandatory one-to-one" → "optional one-to-one … `auth_user_id` is nullable and is set (uniquely) on activation".
- Step 3: Applied — `31` `users` Notes "mandatory one-to-one" → optional one-to-one with nullable `auth_user_id`.
- Step 4: Applied — `31` `# 13` item 3 "RESOLVED: … mandatory one-to-one" → optional one-to-one, nullable `auth_user_id`.
- Step 5: Applied — ADR-0004 updated to nullable `auth_user_id`, consistent with the above.

Verification against Acceptance Criteria:
- No `auth_user_id uuid not null` remains anywhere (grep 0) — confirmed.
- The phrase "mandatory one-to-one relationship with `auth.users`" no longer appears in the repository (grep 0) — confirmed.
- "optional one-to-one relationship with `auth.users`" now present in `30` (×1) and `31` (×2) — confirmed.
- ADR-0004 shows nullable `auth_user_id` — confirmed.
- `git diff --stat` shows only the three scoped files changed (`30`, `31`, ADR) — confirmed. No SQL.

Commits: this Implement commit (modifies the three scoped documentation files and synchronizes this Change Request).

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

The relationship remains a genuine one-to-one for activated users: `auth_user_id` is `UNIQUE`, so at most one `users` row links to any `auth.users` row, and (via the FK) any non-null `auth_user_id` references a real auth identity. What changes is that the link is optional (nullable) rather than mandatory, which is what the Identity Key Standard's own rationale already required. PostgreSQL's `UNIQUE` permits multiple NULLs, so any number of invited-but-not-activated users coexist, each with `auth_user_id = null`, until activation assigns a distinct auth identity.

This keeps ADR-0004 and the two canonical documents in agreement, eliminating the contradiction in all five places it was expressed.

---

## Findings

- **F1 — Activation/invitation lifecycle is under-modeled (deferred, not part of this Change Request).** The schema represents "invited-but-not-activated" only implicitly (`users.is_active = false` plus `auth_user_id = null`). There is no invitation record, no `invited_at`/`activated_at` timestamps, no `invited_by`/`created_by` on `users`, and no user status or state machine (`26_state_machines.md` has no user lifecycle). This is a feature-modeling gap, not a blocking contradiction: nullable `auth_user_id` is the minimal enabler and the `users` migration can proceed with it. A richer invitation/activation model (records, timestamps, inviter, optional user status) should be evaluated as its own future Change Request. **Classification: Recommended / Future.** To be recorded in `reports/future-backlog.md`.
- **F2 — No other identity contradictions found.** The verification pass across `30`, `31`, `26`, `28_permissions_matrix.md`, `29_relationship_map.md`, `PROJECT_CONTEXT.md`, the ADRs, and `33` found the `auth_user_id` nullability issue to be the only contradiction. RBAC (global roles/permissions, tenant-scoped assignments, authorization in ORVION not JWT), tenant ownership, audit fields, and authentication identity are internally consistent. **Classification: Informational.**
