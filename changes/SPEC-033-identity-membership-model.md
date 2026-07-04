# Change Request — SPEC-033

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

[x] Tier 1 — Strong reasoning model
    Permitted modes: ANALYZE, PLAN, REVIEW, REFACTOR

[ ] Tier 2 — Local execution agent (Qwen3.8B)
    Permitted modes: IMPLEMENT only

Note: this Change Request edits canonical governance/architecture documents (`30`, `31`) and the ADR record; it requires judgment about wording and placement, not mechanical insertion — Tier 1.

---

## Objective

Adopt ORVION's identity philosophy as canonical: a `users` row is a human's membership in one tenant, `auth.users` is the shared human identity, and `auth_user_id` is unique per tenant — superseding the global-uniqueness ("one person, one tenant") portion of the Identity Key Standard resolved in SPEC-031.

---

## Business Reason

The Migration 5 identity review established that ORVION must support the same human belonging to more than one tenant (employees changing agencies; consultants/contractors/franchise/parent-company operators working across agencies). The current canon makes `auth_user_id` globally unique, which forbids the same login from being an active member of multiple tenants. Deciding this now, before the `users` table exists and before ~70 tables reference it, is a one-constraint change on an empty table plus documentation; deciding it after is a foundational retrofit of the most-referenced table and the RLS/auth design. The MVP single-membership experience is behaviourally unchanged. This Change Request records the model canonically so migration 5 and RLS (migration 19) are built against it.

---

## Risks

Low. Documentation-only change to two canonical documents and the ADR record; no SQL, no schema. It is strictly more permissive (per-tenant uniqueness allows, but does not require, multiple memberships), so the MVP single-membership behaviour is identical. The only forward obligation it introduces — an active-tenant context for RLS — is inherent to multi-tenant isolation and is deferred to migration 19.

---

## Supersedes / Depends On

Supersedes the `auth_user_id` global-uniqueness portion of `31_schema_draft.md` `# 13` item 3 (which explicitly permits supersession by a future Change Request). Depends on `changes/SPEC-031-identity-auth-nullability.md` (Complete).

---

## Scope — Files Allowed to Modify

- _ORVION_CANONICAL/30_database_conventions.md
- _ORVION_CANONICAL/31_schema_draft.md
- reports/architecture-decision-records.md

---

## Out of Scope — Files Forbidden to Modify

- All other `_ORVION_CANONICAL/**` documents
- supabase/migrations/** (no SQL; migration 5's DDL is adjusted separately in SPEC-032)
- changes/SPEC-032-*.md (revised separately, after this Change Request)
- The authentication-support tables' re-homing (trusted_devices/otp_challenges/totp_enrollments → human identity) — recorded as a migration-16 Finding, not changed here

---

## Minimum Reading List

- _ORVION_CANONICAL/30_database_conventions.md
- _ORVION_CANONICAL/31_schema_draft.md
- reports/architecture-decision-records.md

---

## Implementation Steps

1. In `30_database_conventions.md`'s Identity Key Standard, replace the DDL line `auth_user_id uuid unique references auth.users(id)` with `auth_user_id uuid references auth.users(id)` and, immediately below that code block's closing fence, ensure the per-tenant uniqueness and membership meaning are stated. Concretely, replace the paragraph that begins ``users` has an optional one-to-one relationship with `auth.users` — exactly one once activated` with a paragraph establishing: a `users` row is a person's membership in one tenant; `auth.users` is the shared human identity (one login per person); a human may hold at most one membership per tenant, so uniqueness is `unique (tenant_id, auth_user_id)`, not global; the same human may hold memberships in several tenants, each a separate `users` row. Preserve the remainder of the paragraph (the "read by multiple independently-authored artifacts" rationale).

2. In `30_database_conventions.md`'s Identity Key Standard, update the RLS sentence beginning `The RLS identity lookup function SHALL resolve `auth.uid()`` so it resolves `auth.uid()` **together with the active tenant context** to the corresponding membership (`auth_user_id = auth.uid()` and `tenant_id = <active tenant>`).

3. In `30_database_conventions.md`'s Identity Key Standard, add one sentence establishing the layer split: authentication-layer facts (credentials, trusted devices, MFA enrolment, global suspension) belong to the human identity (`auth.users`); business-layer facts (profile, roles, activity, per-company status, audit) belong to the membership (`users`).

4. In `31_schema_draft.md`'s `users` Notes (the "optional one-to-one relationship with `auth.users`" sentence), reframe to the membership model: a `users` row is the human's membership in this tenant; `auth.users` is the shared identity; `auth_user_id` is unique per tenant and null until activation.

5. In `31_schema_draft.md` `# 13. Review Required` item 3, reframe the "optional one-to-one relationship" opening to the membership model, keeping the rest of the item (RBAC/JWT statement, physical-key deferral to `30`, supersession clause) intact.

6. In `reports/architecture-decision-records.md` ADR-0004, revise the Decision to per-tenant uniqueness (`unique (tenant_id, auth_user_id)`), and append a new **ADR-0011 — `users` is a tenant membership; `auth.users` is the human** capturing the two-layer philosophy, the per-tenant uniqueness, the RLS active-tenant requirement, and the note that authentication-support tables belong to the human identity (a migration-16 concern).

---

## Acceptance Criteria

- [ ] `30`'s Identity Key Standard shows `auth_user_id uuid references auth.users(id)` (no inline `unique`) and states uniqueness is `unique (tenant_id, auth_user_id)`.
- [ ] `30` describes a `users` row as a membership in one tenant and `auth.users` as the shared human identity, and states the authentication-vs-business layer split.
- [ ] `30`'s RLS sentence resolves `auth.uid()` together with the active tenant context to the membership.
- [ ] `31`'s `users` Notes and `# 13` item 3 both describe the membership model (no remaining "one-to-one … one tenant" identity framing that implies global uniqueness).
- [ ] ADR-0004 shows per-tenant uniqueness; ADR-0011 exists capturing the membership philosophy and the auth-support-table note.
- [ ] No other content is altered; no SQL or migration file is touched.

---

## Execution Log

### <YYYY-MM-DD HH:MM> — <agent identifier>

Outcome: Complete | Blocked | Failed

Step results:
- Step 1: Already Applied | Applied | Failed — <one-line reason>

Commits: <commit hash(es) for this run>

Blocker: <only present if Outcome is Blocked or Failed.>

---

## Verification Notes

### <YYYY-MM-DD HH:MM> — <agent identifier>

Verdict: Confirmed Complete | Discrepancy Found | Needs Corrective Change Request

Findings: <what was independently re-checked, and what was found>

Recommendation to human: Set Status to Complete | Set Status to Cancelled

---

## Review Gate

- [ ] Every change matches the Implementation Steps.
- [ ] No file outside Scope was modified.
- [ ] Every Acceptance Criteria item is confirmed true.
- [ ] The repository is in a clean, releasable state.

---

## Notes

Migration 5 (SPEC-032) is revised after this Change Request to make `users.auth_user_id` unique per tenant (`constraint users_tenant_auth_key unique (tenant_id, auth_user_id)`), replacing the inline global `unique`. All other SPEC-032 decisions (`ON DELETE SET NULL`, `tenant_id NOT NULL`, `(tenant_id, email)` unique) are already correct for this model.

Forward Finding (migration 16): `trusted_devices`, `otp_challenges`, `totp_enrollments` are authentication-layer concerns and, under this model, belong to the human identity rather than to the per-tenant membership; the current schema keys them to `(tenant_id, user_id)`. To be evaluated when the authentication-support tables are designed. Recorded in `reports/future-backlog.md`.
