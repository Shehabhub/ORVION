# Pre-Phase-8 Readiness Audit — 2026-07-13

Class: **HISTORICAL-IMMUTABLE** (dated review record; do not edit after this session — supersede with a new dated report).
Method: live-database audit via Postgres MCP (ground truth, `GOVERNANCE §2`) + two independent document sweeps (canonical `00–35`; `reports/` registers), cross-validated. Read-only except the promotions/corrections noted in §4.

## 1. Verdict
ORVION is mature and self-aware: comprehensive gap/risk registers, ~82% weighted design completion, **CONDITIONAL** certification ("certified for continued phased implementation, not production"). **Phase 8 may proceed** provided the two small additive prerequisites in §3 land first. The audit found no unknown problems — its value was verification, one correction, and promoting untracked orphans.

## 2. Verified by live DB (Test-Before-Trust)
- **RLS on 71/71 tables**, each ≥1 policy. Tenant isolation: no open risk (register concurs).
- **273 FKs**; **all 19 reference-code columns FK-backed** → backlog "Reference Data Layer (core)" is DONE (graduated).
- **273/74** — 74 migrations applied = 74 files; smoke `ALL CHECKS PASSED (71 tables)`.
- **55 `app` RPCs** cover lead→booking→finance→document; **no attribution/quotation/complaint/service_request RPCs** (those domains are schema-first).
- Constraints: 5 CHECK, 10 UNIQUE — confirms open gaps B2 (finance non-neg CHECKs) and R8/B3 (business-key UNIQUE).

## 3. Confirmed open, blocking or near-term (already tracked; IDs cited, not restated)
- **DC-1 / RK-01 (Critical):** 21 money columns are `numeric(14,2)` → truncates 3-dp GCC currencies; widen to `numeric(19,4)`. **Confirmed still open.** Cheapest now (empty tables); Batch-0 foundation-lock.
- **R5 (Phase-8 capture):** `attribution_clicks` has `gclid`+UTM but **`gbraid`/`wbraid` and consent (`ad_user_data`/`ad_personalization`) are unmodeled**; `leads` has no `attribution_click_id` intake anchor. Required by `18_integration_priority.md:69` + `future-backlog.md`. Click IDs are unrecoverable retroactively → small additive migration **before** Phase-8 logic.
- B2, R8/B3, `document_versions` single-current CHECK — open, cheap, per-table.

## 4. Corrections & promotions made this session
- **Correction:** an interim claim "money precision clean" was wrong (empty scale≠2 result misread); re-query confirmed DC-1 open. Recorded here so the error doesn't propagate.
- **Graduated:** backlog "Reference Data Layer (core)" → DONE; split travel-specific (cities/airports) to Future Candidates.
- **Promoted (were untracked):** five workflow orphans → `future-backlog.md` "Pre-Phase-8 Audit Orphans" (Quotations inert; `28` events not emitted; booking-item roll-up unconsumed; finance-gated booking transitions partial; `chart_of_accounts.account_type` no catalog).

## 5. Open owner decisions
- **Google Data Manager API** transport + consent mode for offline-conversion delivery (legacy Ads offline-import blocked 2026-06-15) — needs owner decision + Learn-Before-Designing research before Phase-8 delivery RPCs.
- Sequencing: whether DC-1 (money) + R5 (attribution columns) land as the first Phase-8-adjacent CRs (audit recommendation) — roadmap sequencing is owner-gated.

## 6. Data-hygiene note
`MASTER_GAP_REGISTER.md` status column lags its own detail blocks + `MASTER_EXECUTION_PLAN.md` (DC-16/A1/A2 show OPEN but are DONE per SPEC-113/117/114). Treat the Execution Plan as current truth. The governance-lint hook (`GOVERNANCE §11`, owner-gated) would mechanically prevent this drift.
