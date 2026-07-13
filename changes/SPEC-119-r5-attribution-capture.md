# Change Request — SPEC-119

## Status

[ ] Draft
[ ] Approved
[ ] In Progress
[x] Complete
[ ] Cancelled

---

## Objective

Complete attribution capture (ARB finding R5): add `gbraid`/`wbraid` and Google consent signals to `attribution_clicks`, and a first-touch `attribution_click_id` anchor to `leads`.

---

## Business Reason

Closed-loop offline conversion (Phase 8) requires click IDs captured at lead intake — they are unrecoverable retroactively. `attribution_clicks` stored only `gclid` (no iOS/app `gbraid`/`wbraid`), no consent signals (required by `18_integration_priority.md` and Google Data Manager API), and `leads` had no guaranteed intake anchor. This lands the additive schema before Phase-8 logic builds on it.

---

## Risks

Low. All additive/nullable columns; consent CHECK permits NULL; the `leads` FK is `on delete restrict` per the `30` Referential Action Standard (verified by smoke CHECK 7). No existing data.

---

## Supersedes / Depends On

Depends on SPEC-118 (DC-1) being Complete. Closes gap R5.

---

## Scope — Files Allowed to Modify

- `supabase/migrations/202607048700_r5_attribution_capture.sql`
- `_ORVION_CANONICAL/21_offline_conversion_engine.md`
- `_ORVION_CANONICAL/31_schema_draft.md`
- `_ORVION_CANONICAL/manifest.md`
- `reports/master/MASTER_GAP_REGISTER.md`
- `changes/SPEC-119-r5-attribution-capture.md`

---

## Out of Scope — Files Forbidden to Modify

- any other `supabase/migrations/**` (terminal migrations never edited)
- any `reports/history/**` (immutable)
- `scripts/verify_database.sql` (the standard is authoritative; conform to it, never weaken it)

---

## Minimum Reading List

- `reports/master/MASTER_GAP_REGISTER.md` (R5 row)
- `_ORVION_CANONICAL/31_schema_draft.md` (`attribution_clicks`, `leads`)
- `_ORVION_CANONICAL/21_offline_conversion_engine.md` (Captured Click Data)

---

## Implementation Steps

1. Add migration `202607048700_r5_attribution_capture.sql`: `attribution_clicks` += `gbraid`, `wbraid`, `consent_ad_user_data`, `consent_ad_personalization` (CHECK granted/denied/unspecified, NULL allowed); `leads` += `attribution_click_id uuid` FK → `attribution_clicks(id)` `on delete restrict`, indexed. Verification: `db reset` clean; columns/FK/index exist.
2. Update canon `21` (Captured Click Data) and `31` (`attribution_clicks`, `leads` fields). Verification: `31` lists `gbraid`/`wbraid`/consent and `leads.attribution_click_id`.
3. Mark R5 implemented in the gap register; sync manifest. Verification: register R5 shows SPEC-119.

---

## Acceptance Criteria

- [x] Four new `attribution_clicks` columns present with the consent CHECK.
- [x] `leads.attribution_click_id` FK (`on delete restrict`) + index present.
- [x] Full smoke test passes (incl. CHECK 7 Referential Action Standard).
- [x] All 6 pgTAP tests green.
- [x] Canon `21`/`31` reflect the new fields.

---

## Execution Log

### 2026-07-13 — Claude (Opus 4.8)

Outcome: Complete

Step results:
- Step 1: Applied — migration `202607048700`; a first pass used the default FK action and smoke CHECK 7 flagged the deviation; corrected to `on delete restrict` and re-verified (Test-Before-Trust; the smoke test is the permanent guard).
- Step 2: Applied — canon `21`/`31` updated.
- Step 3: Applied — gap register R5 = SPEC-119; manifest `Last Completed` = SPEC-119.

Commits: (see push for this run)

---

## Verification Notes

### 2026-07-13 — Claude (Opus 4.8)

Verdict: Confirmed Complete

Findings: After `db reset`: `gbraid`/`wbraid`/`consent_ad_user_data`/`consent_ad_personalization` present on `attribution_clicks`; `leads.attribution_click_id` FK `confdeltype='r'` + index present; consent CHECK predicate accepts granted/denied/unspecified and NULL, rejects others; full smoke `ALL CHECKS PASSED (71 tables)` incl. CHECK 7; all 6 pgTAP tests green. No out-of-scope file modified.

Recommendation to human: Set Status to Complete.

---

## Review Gate

- [x] Every change matches the Implementation Steps exactly.
- [x] No file outside the Scope list was modified or created.
- [x] No section was added, removed, or restructured outside the approved steps.
- [x] Every Acceptance Criteria item is confirmed true.
- [x] The one deviation (FK action) was caught by the smoke guard and corrected, not guessed past.
- [x] Supersedes / Depends On (SPEC-118) is Complete.
- [x] The repository is in a clean, releasable state.

---

## Notes

Delivery transport (Google Data Manager API + consent mode; legacy Ads offline-import blocked 2026-06-15) remains an open owner decision recorded in `reports/future-backlog.md` and the 2026-07-13 audit report — out of scope for R5 (capture only).
