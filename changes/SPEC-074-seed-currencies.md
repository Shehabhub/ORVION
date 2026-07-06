# Change Request — SPEC-074

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

Reference-data layer (currencies slice). Seed the empty `currencies` global reference table with a curated, ISO-4217-correct set, unblocking Phase 5 Booking Core (`booking_items.currency_code` is `NOT NULL` and FK-references `currencies(code)`). Scope limited to currencies; countries/nationalities/languages remain deferred.

---

## Business Reason

Booking-item creation cannot proceed while `currencies` is empty (a `NOT NULL` FK). This is the reference-data layer's natural, evidence-driven trigger — anticipated by the roadmap/backlog and the Phase-4 retrospective ("bookings/finance will be where the reference-data layer is earned"). `decimal_places` must be correct per ISO 4217 because Finance Core will rely on it for money handling.

---

## Risks

Minimal. Data-only insert into a global system-reference table (`currencies`: no tenant_id; read-all authenticated, migration/platform-writes per RLS baseline), idempotent via `on conflict (code) do nothing`. No table/schema change. No behavior change beyond making valid currency codes available. Curated set (18 currencies) can be extended later by a follow-up seed without disruption.

---

## Supersedes / Depends On

Depends On: migration 6 (`currencies` table, `202607041400_create_reference_tables.sql`). Unblocks: SPEC-075 (booking item creation) and all later Booking/Finance money handling. Related: ADR-0016 (provisioning passes null currency precisely because this was empty — provisioning may pass a real default currency once tenants choose one; not changed here).

---

## Scope — Files Allowed to Modify

- supabase/migrations/202607045300_seed_currencies.sql
- _ORVION_CANONICAL/manifest.md (state update)

---

## Out of Scope — Files Forbidden to Modify

- Any existing migration ; table structure ; countries / nationalities / languages seeds (still deferred) ; provision_tenant default-currency behavior ; catalog seeds

---

## Minimum Reading List

- supabase/migrations/202607041400_create_reference_tables.sql (currencies) ; 202607042300_create_booking_core_tables.sql (booking_items.currency_code) ; 202607043300_create_rls_policies.sql (currencies is a global read-all reference table)

---

## Implementation Steps

1. Create `supabase/migrations/202607045300_seed_currencies.sql`: insert a curated ISO-4217 currency set (majors + travel/GCC/MENA: USD, EUR, GBP, SAR, AED, EGP, QAR, KWD, BHD, OMR, JOD, TRY, JPY, CNY, INR, CHF, CAD, AUD) with correct `decimal_places` (JPY=0; KWD/BHD/OMR/JOD=3; others 2) and symbols; idempotent `on conflict (code) do nothing`.

---

## Acceptance Criteria

- [x] Migration exists; `npx supabase db reset` applies cleanly; smoke-test still passes.
- [x] `currencies` is populated (18 rows) with correct `decimal_places` (JPY=0; KWD/BHD/OMR/JOD=3; the rest 2).
- [x] The seed is idempotent (re-running does not error or duplicate).
- [x] A `booking_items` insert can now satisfy the `currency_code` FK (e.g. 'USD', 'SAR').

---

## Execution Log

### 2026-07-06 — Claude (Tier 1)

Outcome: Complete

Step results:
- Step 1: Applied — 18 currencies seeded. `npx supabase db reset` applied cleanly; `scripts/verify_database.sql` reports ALL CHECKS PASSED.

Verification:
- `select count(*) from currencies` → 18; spot-checks: JPY `decimal_places=0`, KWD/BHD/OMR/JOD `=3`, USD/EUR/SAR `=2`.
- `on conflict` idempotency confirmed (re-insert of the same rows changes nothing).
- A booking_item insert with `currency_code='USD'` satisfies the FK (validated during SPEC-075).

Commits: recorded at Complete.

Blocker: none.

---

## Verification Notes

### 2026-07-06 — Claude (independent review)

Verdict: Confirmed Complete

Findings: Evidence-driven, minimally scoped reference-data slice — seeds only what the FK blocker requires (currencies), leaving countries/nationalities/languages deferred (their referencing columns are nullable). `decimal_places` is ISO-4217-correct, which Finance Core will depend on. Uses the correct mechanism (a seed migration on a global system-reference table, consistent with the catalog seeds and the RLS baseline) and is idempotent. No schema change; no file outside Scope modified.

Recommendation to human: Set Status to Complete

---

## Review Gate

- [x] Every change matches the Implementation Steps.
- [x] No file outside Scope was modified.
- [x] Every Acceptance Criteria item is confirmed true.
- [x] The repository is in a clean, releasable state.

---

## Notes

Currencies is the only reference table that hard-blocks current work; countries (`bookings.destination_country_code`) and languages (`customers.preferred_language_code`) are nullable and stay deferred until a real requirement earns them (Earn-It). The curated set is deliberately small and extensible; a tenant-configurable "enabled currencies" concept, exchange-rate seeding, and `provision_tenant` passing a real default currency are later, separately-earned refinements. This unblocks SPEC-075 (booking item creation) and lays correct groundwork for Finance Core money handling without introducing finance behavior now.
