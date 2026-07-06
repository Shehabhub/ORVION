# Change Request — SPEC-069

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

Phase 4 (CRM Core) — customer creation + duplicate detection (`05_customer_identity.md`). `app.create_customer(...)` (CREATE_CUSTOMER-gated; seeds identity signals; enforces in-tenant primary-phone uniqueness with an approved-exception override) and `app.find_customer_duplicates(...)` (read-only candidate search across identity signals). The sensitive `MERGE_CUSTOMER_IDENTITY` merge (must emit an event and re-point references) is a separate deferred CR.

---

## Business Reason

`05_customer_identity.md`: customer uniqueness is enforced inside the tenant; each customer has one primary phone that must be unique in-tenant unless an approved exception exists; duplicate detection must use identity signals (phone / additional phones / whatsapp / email / social / passport / official document) and never name alone. Customers are foundational to the CRM and are required by the lead→customer link and `won → converted` (SPEC-068 deferred). This CR delivers creation + detection; merge follows separately.

---

## Risks

Low. Two `SECURITY INVOKER` RPCs; RLS (tenant_isolation) is the backstop. No table/schema change. Primary-phone uniqueness is enforced at the RPC layer (not a DB constraint) precisely because `05` allows an approved exception — the `p_allow_duplicate` override, available to a CREATE_CUSTOMER holder. Detection is read-only and returns only rows the caller's RLS already permits.

---

## Supersedes / Depends On

Depends On: catalog seed (`customer_type`, `contact_method_type`, `customer_identity_signal_type`), RBAC seed (`CREATE_CUSTOMER`), `app.authorize` (SPEC-062). Unblocks: lead→customer link + `won → converted`. Deferred follow-up: `app.merge_customer_identity` (MERGE_CUSTOMER_IDENTITY; sensitive; emits event; re-points leads/contacts/signals/notes; archives source; writes `customer_identity_merges`).

---

## Scope — Files Allowed to Modify

- supabase/migrations/202607044800_customer_identity.sql
- _ORVION_CANONICAL/manifest.md (state update)

---

## Out of Scope — Files Forbidden to Modify

- Any existing migration ; table structure ; RBAC/catalog seed data ; customer merge ; lead→customer link ; passenger/passport records

---

## Minimum Reading List

- _ORVION_CANONICAL/05_customer_identity.md (scope, primary phone, duplicate signals, person/company)
- _ORVION_CANONICAL/28_permissions_matrix.md (CREATE_CUSTOMER, MERGE_CUSTOMER_IDENTITY)
- supabase/migrations/202607042100_create_crm_core_tables.sql (customers, customer_identity_signals) ; 202607044300_create_lead.sql (authorize + catalog-validation pattern)

---

## Implementation Steps

1. Create `supabase/migrations/202607044800_customer_identity.sql`:
   - `app.find_customer_duplicates(p_phone, p_email, p_whatsapp, p_passport_number, p_document_number)` — `SECURITY INVOKER`, `language sql stable`, returns `(customer_id, full_name, matched_signal_type, matched_value)` from customers' own `primary_phone`/`primary_email` and from `customer_identity_signals` matching any provided value (never name).
   - `app.create_customer(...)` — `SECURITY INVOKER`, `app.authorize('CREATE_CUSTOMER')`; validate `customer_type` + optional `contact_method_type` catalogs + branch-in-tenant; enforce in-tenant primary-phone uniqueness unless `p_allow_duplicate`; insert the customer; seed `customer_identity_signals` for the provided phone / whatsapp / email; return the id.

---

## Acceptance Criteria

- [x] Migration exists; `npx supabase db reset` applies cleanly; smoke-test still passes.
- [x] `create_customer` creates a customer and seeds one identity signal per provided phone/whatsapp/email; returns the id.
- [x] A second `create_customer` with the same primary phone is rejected (`unique_violation`) unless `p_allow_duplicate => true`, which succeeds.
- [x] `find_customer_duplicates` returns the existing customer when queried by its phone, whatsapp, or email; returns nothing for an unrelated value.
- [x] `create_customer` is denied to a caller lacking `CREATE_CUSTOMER` (42501); unknown `customer_type_code` is rejected.

---

## Execution Log

### 2026-07-06 — Claude (Tier 1)

Outcome: Complete

Step results:
- Step 1: Applied — `app.find_customer_duplicates(...)` and `app.create_customer(...)` added. `npx supabase db reset` applied cleanly; `scripts/verify_database.sql` reports ALL CHECKS PASSED.

Behavioral test (Cara = senior_employee with CREATE_CUSTOMER; Dan = trainee without it):
- `create_customer('person', 'Ann Ali', phone '+201', whatsapp '+202', email 'ann@x')` → customer created; three identity signals seeded (phone/whatsapp/email).
- Duplicate primary phone `+201` without override → `unique_violation`; with `p_allow_duplicate => true` → second customer created.
- `find_customer_duplicates(p_phone => '+201')` returns both matching customers; by whatsapp `+202` and by email `ann@x` returns the first; by an unrelated phone returns 0 rows.
- Unknown `customer_type_code 'robot'` → rejected. `create_customer` as Dan (no CREATE_CUSTOMER) → 42501.

Commits: recorded at Complete.

Blocker: none.

---

## Verification Notes

### 2026-07-06 — Claude (independent review)

Verdict: Confirmed Complete

Findings: Duplicate detection matches on identity signals and profile phone/email only — never on name — per `05`. Primary-phone uniqueness is enforced in the RPC (not a hard DB constraint), correctly modelling `05`'s "unique unless an approved exception exists" via the CREATE_CUSTOMER-gated `p_allow_duplicate` override. Identity signals are seeded on creation so detection has data. Catalogs (`customer_type`, `contact_method_type`) and branch-in-tenant are validated; `authorize` composes the MFA policy. Both RPCs are `SECURITY INVOKER` behind tenant_isolation RLS. Merge is correctly deferred (it is the sensitive, event-emitting, reference-repointing operation). No schema change; no file outside Scope modified.

Recommendation to human: Set Status to Complete

---

## Review Gate

- [x] Every change matches the Implementation Steps.
- [x] No file outside Scope was modified.
- [x] Every Acceptance Criteria item is confirmed true.
- [x] The repository is in a clean, releasable state.

---

## Notes

Person vs company are separate identities (`05`); `full_name` is required (NOT NULL) while `first_name`/`family_name`/`company_name` are optional and validated per business rules "defined later" — this CR keeps name validation light and does not synthesise `full_name`. Passport / official-document signals are accepted by `find_customer_duplicates` for detection, but passport records themselves live at the passenger level (`16`) — not created here. Cross-branch awareness summary fields (`last_interaction_*`) exist on `customers` and are populated by interaction flows, not at creation. The merge RPC (source→target re-pointing of leads, contact methods, signals, notes; `customer_identity_merges` row; `customer_merged` event; source archive) is the next deferred CR and is where `MERGE_CUSTOMER_IDENTITY` and the mandatory event apply.
