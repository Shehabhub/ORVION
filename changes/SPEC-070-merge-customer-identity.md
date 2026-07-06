# Change Request — SPEC-070

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

Phase 4 (CRM Core) — sensitive customer merge. `app.merge_customer_identity(source, target, reason)` re-points every reference to `customers(id)` from source to target using **dynamic FK discovery** from the PostgreSQL system catalogs (ADR-0019), writes a `customer_identity_merges` audit row, emits the mandated `customer_merged` event, and archives the source (soft). Establishes ADR-0019 and its participation-by-default architectural rule.

---

## Business Reason

`05_customer_identity.md`: duplicates must be linked to a single customer, not left split; `28_permissions_matrix.md`: customer merge is sensitive, requires `MERGE_CUSTOMER_IDENTITY`, and must create an event. `12_lead_statuses_and_rules.md`: duplicate leads link to the existing customer. A correct merge must re-point ALL customer references (leads, contacts, signals, notes, and future bookings/invoices/…); `customers(id)` already has ~14 referrers, so completeness must be structural, not a maintained list.

---

## Risks

Moderate (sensitive, mutating, hard to reverse) — mitigated. `SECURITY DEFINER` guarantees complete re-pointing regardless of caller RLS visibility; authorization is explicit (`app.authorize('MERGE_CUSTOMER_IDENTITY')` + MFA) and both customers are verified in-tenant; re-pointing keys on the globally-unique customer `id`, so it cannot cross tenants. Source is archived (soft), never deleted — history preserved. No table/schema change. Dynamic discovery excludes only the audit table `customer_identity_merges` (documented). Idempotency guard: an already-archived source is rejected (prevents double-merge).

---

## Supersedes / Depends On

Depends On: SPEC-069 (`create_customer`, identity signals), SPEC-065 (`record_event`), `app.authorize` (SPEC-062), the `customer_identity_merges` table (migration 8). Establishes **ADR-0019**. Unblocks: lead→customer link + `won → converted` (a converted lead can safely reference a merged/canonical customer).

---

## Scope — Files Allowed to Modify

- reports/architecture-decision-records.md (append ADR-0019)
- supabase/migrations/202607044900_merge_customer_identity.sql
- _ORVION_CANONICAL/manifest.md (state update)

---

## Out of Scope — Files Forbidden to Modify

- Any existing migration ; table structure ; RBAC/catalog seed data ; lead→customer link / won→converted ; value-level conflict resolution between merged customers (straight FK re-point only) ; physical deletion

---

## Minimum Reading List

- _ORVION_CANONICAL/05_customer_identity.md ; 12_lead_statuses_and_rules.md (duplicate rule) ; 28_permissions_matrix.md (MERGE_CUSTOMER_IDENTITY, sensitive+event)
- reports/architecture-decision-records.md (ADR-0019)
- supabase/migrations/202607044800_customer_identity.sql (create_customer, signals) ; 202607044400_round_robin_lead_assignment.sql (record_event)

---

## Implementation Steps

1. Append ADR-0019 (dynamic FK-driven re-pointing; participation-by-default rule).
2. Create `supabase/migrations/202607044900_merge_customer_identity.sql`: `app.merge_customer_identity(p_source_customer_id, p_target_customer_id, p_reason)` — `SECURITY DEFINER`, `set search_path=''`. Guard: active tenant; `app.authorize('MERGE_CUSTOMER_IDENTITY')`; source≠target; both customers in-tenant; source not already archived. Loop over `pg_constraint` foreign keys with `confrelid = customers` (schema `public`), excluding `customer_identity_merges`, and `execute format('update public.%I set %I = $1 where %I = $2', ...)` re-pointing source→target. Insert the `customer_identity_merges` audit row; archive the source (`is_archived`, `archived_at/by`, `archive_reason`); emit `customer_merged` (warning) via `record_event` with both ids in the payload. `revoke` from public; `grant execute … to authenticated`.

---

## Acceptance Criteria

- [x] Migration exists; ADR-0019 appended; `npx supabase db reset` applies cleanly; smoke-test still passes.
- [x] Referrers of the source (e.g. a lead, a contact method, an identity signal) are re-pointed to the target; the `customer_identity_merges` audit table is NOT re-pointed.
- [x] A `customer_identity_merges` row (source, target, merged_by, reason, timestamp) is written and one `customer_merged` event is emitted (payload carries both ids).
- [x] The source customer is archived (soft); it is not physically deleted.
- [x] `merge_customer_identity` is denied without `MERGE_CUSTOMER_IDENTITY` (42501) and denied to a MERGE-holder whose session is not `aal2` (MFA); source=target and already-archived source are rejected.

---

## Execution Log

### 2026-07-06 — Claude (Tier 1)

Outcome: Complete

Step results:
- Step 1: Applied — ADR-0019 appended.
- Step 2: Applied — `app.merge_customer_identity(...)` added. `npx supabase db reset` applied cleanly; `scripts/verify_database.sql` reports ALL CHECKS PASSED.

Behavioral test (owner Olivia at aal2 holds MERGE_CUSTOMER_IDENTITY; source S with a lead + contact method + identity signal; target T):
- After `merge_customer_identity(S, T, 'duplicate')`: the lead, the contact method, and the identity signal all re-pointed to T (0 rows still reference S); `customer_identity_merges` row present (S→T, merged_by Olivia, reason recorded); exactly one `customer_merged` event with payload `{source, target}`; S `is_archived=true` with archived_at/by + reason, and S still exists (not deleted).
- Dynamic discovery re-pointed all live referrers; the `customer_identity_merges` audit row correctly still references S as source (not re-pointed).
- `source = target` rejected; re-merging the already-archived S rejected.
- Merge by an employee lacking MERGE_CUSTOMER_IDENTITY → 42501; merge by Olivia at `aal1` (no MFA) → 42501 (MFA policy).

Commits: recorded at Complete.

Blocker: none.

---

## Verification Notes

### 2026-07-06 — Claude (independent review)

Verdict: Confirmed Complete

Findings: Merge completeness is structural, not a maintained list — referrers are discovered from `pg_constraint` at run time (ADR-0019), so future tables participate automatically; only the merge audit table is excluded (documented), and the test confirms it is not re-pointed while live referrers are. `SECURITY DEFINER` guarantees complete re-pointing past RLS visibility, with authorization (`MERGE_CUSTOMER_IDENTITY` + MFA) and same-tenant verification enforced at entry; keying on the globally-unique `id` keeps it tenant-safe. Full auditability: an immutable `customer_merged` event plus the `customer_identity_merges` row (source/target/by/reason/time). Source is soft-archived, never deleted. No schema change; no file outside Scope modified.

Recommendation to human: Set Status to Complete

---

## Review Gate

- [x] Every change matches the Implementation Steps.
- [x] No file outside Scope was modified.
- [x] Every Acceptance Criteria item is confirmed true.
- [x] The repository is in a clean, releasable state.

---

## Notes

This CR performs a straight FK re-point (source→target) — it does not resolve value-level conflicts between the two customer profiles (e.g. differing primary phones/emails), which is deliberately out of scope: the target profile is authoritative and the source is archived. If a future referrer must not be blindly re-pointed (needs conflict resolution, dedup, or a transformation), ADR-0019's escalation rule applies: add it to the documented exclusion list and handle it explicitly. Duplicate identity signals created by re-pointing (target may already hold the same phone) are harmless (signals are not unique-constrained) and keep the full signal history. Lead→customer link and `won → converted` remain the next capability; a converted lead can now safely target a canonical (post-merge) customer.
