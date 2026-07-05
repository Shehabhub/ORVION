# Change Request — SPEC-046

## Status

[ ] Draft
[x] Approved
[ ] In Progress
[ ] Complete
[ ] Cancelled

Allowed values are exactly these five. Do not use any other status word anywhere in a Change Request.

---

## Assigned Model Tier

[x] Tier 1 — Strong reasoning model
[ ] Tier 2 — Local execution agent (Qwen3.8B)

---

## Objective

Establish a canonical **Authentication & Identity Principles** document and align the downstream canon that must follow from it, so that Migration 16 (and every future auth decision) is derived from stated principles rather than re-litigated per table.

---

## Business Reason

Owner directive: the authentication philosophy was distributed across ADR-0011, `20_authentication_security_model.md`, and backlog notes. Consolidating it into one principles document lets the schema fall out as a consequence ("which principle owns this responsibility?"). The immediate consequence is re-homing the authentication support tables to the Human Identity per ADR-0011, unblocking Migration 16.

---

## Risks

Low. Documentation + canonical amendment only; no DDL in this CR. The schema amendment (auth-support tables key to `auth_user_id`) is the minimal, already-approved consequence of ADR-0011, not new design. Migration 16 (SPEC-047) implements it separately.

---

## Supersedes / Depends On

Builds on ADR-0011 (SPEC-033). Precedes SPEC-047 (Migration 16). No CR superseded.

---

## Scope — Files Allowed to Modify

- _ORVION_CANONICAL/34_authentication_and_identity_principles.md (new)
- _ORVION_CANONICAL/31_schema_draft.md (section 9 only)
- _ORVION_CANONICAL/33_sql_migration_plan.md (migration 16 row only)
- README.md (First Reading Order entry only)
- reports/architecture-decision-records.md (append ADR-0012)
- reports/future-backlog.md (close the migration-16 re-homing item)

---

## Out of Scope — Files Forbidden to Modify

- Any migration file ; supabase/config.toml ; any other canonical section ; any other CR

---

## Minimum Reading List

- reports/architecture-decision-records.md (ADR-0011)
- _ORVION_CANONICAL/20_authentication_security_model.md
- _ORVION_CANONICAL/31_schema_draft.md section 9
- _ORVION_CANONICAL/30_database_conventions.md (Identity Key + Referential Action Standards)

---

## Implementation Steps

1. Create `_ORVION_CANONICAL/34_authentication_and_identity_principles.md` — twelve principles (Human Identity, Tenant Membership, Authentication, Authorization, Session Ownership, Trusted Devices, MFA/OTP/TOTP, Tenant Selection, Membership Resolution, Platform Security, Global vs Tenant-scoped Security, Security Audit Philosophy) plus an application rule and the informative schema consequence. Principles only — no specification or implementation detail duplicated from `20`/`31`.
2. Amend `31_schema_draft.md` section 9: `trusted_devices`/`otp_challenges`/`totp_enrollments` key to `auth_user_id` → `auth.users(id)`, drop `tenant_id` and membership `user_id`, cascade on human-identity deletion.
3. Amend `33_sql_migration_plan.md` migration 16 row to reflect the `auth.users` dependency and re-homed keys.
4. Add the principles document to README's First Reading Order.
5. Append ADR-0012 recording the decision.
6. Close the migration-16 re-homing item in `reports/future-backlog.md`.

---

## Acceptance Criteria

- [x] `34_authentication_and_identity_principles.md` exists, is marked Canonical, and defines the twelve principles without duplicating `20`/`31` detail.
- [x] `31` section 9 keys all three tables to `auth_user_id` with no `tenant_id`/membership `user_id`.
- [x] `33` migration 16 row reflects the amended model.
- [x] README First Reading Order references the new document.
- [x] ADR-0012 appended; migration-16 re-homing backlog item closed.

---

## Execution Log

### 2026-07-05 — Claude (Tier 1)

Outcome: Complete

Step results:
- Steps 1–6: Applied — principles doc created; `31` §9, `33` row 16, README, ADR-0012, and future-backlog updated. No DDL. No migration touched.

Commits: recorded at Complete.

Blocker: none.

---

## Verification Notes

### 2026-07-05 — Claude (independent review)

Verdict: Confirmed Complete

Findings: The principles document is declarative and non-duplicative; each of the twelve concepts the owner named is present. The `31` §9 amendment is internally consistent with the principles doc and with ADR-0011/0012 (auth_user_id keying, no tenant_id, cascade). The plan row 16 dependency now correctly points at the `auth` schema rather than migration 5. README and ADR updated; the backlog item is closed with a pointer to ADR-0012. Scope respected — no migration or unrelated canon touched.

Recommendation to human: Set Status to Complete

---

## Review Gate

- [x] Every change matches the Implementation Steps.
- [x] No file outside Scope was modified.
- [x] Every Acceptance Criteria item is confirmed true.
- [x] The repository is in a clean, releasable state.

---

## Notes

No expansion or redesign was introduced. The re-homing is the minimal consequence already approved in ADR-0011; this CR only makes the governing principles explicit and aligns the three canon docs that reference them. Migration 16 DDL is implemented separately in SPEC-047, derived directly from `34`.
