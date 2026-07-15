# Repository Synchronization & Integrity Audit — 2026-07-15

Class: **HISTORICAL-IMMUTABLE** (dated review record; do not edit after this session — supersede with a newer dated report).
Type: **Non-canonical working record.** Owner-directed final Repository Synchronization & Integrity Phase performed *before* any new feature implementation. Not an ADR, not canon, not a Change Request.
Method: ground-truth repository evidence only (no chat memory). File-system inventory + source inspection of migrations, canon, and living registers, cross-validated against the two prior dated audits (`pre-phase8-readiness-audit-2026-07-13.md` live-DB pass; `session-discovery-checkpoint-2026-07-14.md` 5-specialist pass). Every prior finding was **re-verified against the current file state**, not trusted.
Governs continuation: read after the boot sequence to see the consolidated correction state; then execute the Recovery Plan (§4) only after owner approval.

---

## 0. How to read this report (One-Authority note)

This audit does **not** create a second findings authority. ORVION already has authoritative finding IDs in `MASTER_GAP_REGISTER.md` (DC-*, R-*, A*, B*, CDD-*, N*, …) and consolidated synchronization IDs in the 2026-07-14 checkpoint (S-EVENT, S1–S9, C1–C7, G1–G4, A1–A4, V). This report:

1. **Re-verifies** those findings against the current repository (proving they are still live, not stale), and
2. Adds only the **new/refined** observations this pass produced.

Every issue below cites its existing ID where one exists. New observations are prefixed **N-AUDIT-**. The Recovery Plan (§4) is a priority-ordering of the *existing* two-track plan (checkpoint §9), not a replacement for it.

---

## 1. Verdict

**Repository integrity is HIGH. No forgotten architecture, no surviving architectural contradiction, and no data-loss risk was found.** The core is clean and machine-guarded (money precision, RLS + InitPlan wrapping, DML grants, append-only immutability, CI gating with `ON_ERROR_STOP`). A completely fresh AI session **can** cold-boot from README → AGENTS → manifest → active-CR/roadmap and reach the same architectural understanding — the boot chain, the ai-map, and the two prior dated audits are all present and consistent.

What remains is **synchronization debt, not design debt**: stale status/date fields in the living registers, un-annotated canonical supersessions, and **one genuine structural gap** — the event vocabulary is unenforced free text and actively drifting (S-EVENT). All are correctable; none blocks a fresh session's comprehension. **This confirms the 2026-07-14 verdict and adds that nothing has regressed or been fixed in the interim** (git tree clean since; the only intervening commits were governance docs).

**Recommendation:** approve the Recovery Plan (§4). Track 1 (agent-authority `reports/**` + living-manifest fixes) can be applied immediately on go; Track 2 (protected-doc diffs) requires per-diff owner sign-off. No further from-scratch verification pass is warranted.

---

## 2. Verification coverage (the 15 mandated targets)

| # | Target | Method | Result |
|---|---|---|---|
| 1 | Every canonical document | inventoried 39 files in `_ORVION_CANONICAL/`; statuses cross-checked vs `ai-map.json` | Present & indexed. Supersession-annotation debt only (C-series). |
| 2 | Every ADR | `architecture-decision-records.md` ADR-0001…0021; next = **0022** | Append-only, cross-linked. Overlay reconcile pending (A3). |
| 3 | Every Master report | 13 files in `reports/master/` | Present. Status/date staleness (S1–S9). |
| 4 | Every roadmap | `32_execution_roadmap.md` + `MASTER_EXECUTION_PLAN.md` | Phases 2–7 COMPLETE; Phase 8 next. Resequence proposals (P1–P3) pending. |
| 5 | Every migration | **76 files** in `supabase/migrations/` (was 74 at 07-13; +SPEC-118 DC-1, +SPEC-119 R5) | Linear, ordered. No orphan migration. Neither addition changes table count. |
| 6 | Every schema document | canon `24–33` + `31` Frozen Baseline | Intent vs as-built consistent (table parity 71). |
| 7 | Every architecture layer | ADR-0014 substrate; identity/CRM/booking/finance/document | Coherent; each ADR reconciled by a later ADR/SPEC. |
| 8 | Every integration layer | Google/Meta/WhatsApp/Framer/n8n | Design-researched (checkpoint §6); **not yet built** (schema-first). |
| 9 | Every business domain | canon `00–23` | No live contradiction; annotation debt (C1–C7). |
| 10 | Every execution phase | roadmap `32` | Phase statuses consistent; app/access phase absent (P1). |
| 11 | Every dependency graph | `MASTER_DEPENDENCY_GRAPH.md` | Consistent with execution plan; CDD-7/N1 pre-staged. |
| 12 | Every report | `reports/` root + master + evidence + history | Indexed in `reports/README.md`, incl. 07-13 & 07-14. |
| 13 | Every protected document | AGENTS, README, canon | Intact. §6 protected-list omission (G1). |
| 14 | Every reference document | `PROJECT_CONTEXT`, `CODING_STANDARDS`, `llms.txt`, `ai-map.json` | Present; ai-map auto-gen has cosmetic UTF-8 mojibake (N-AUDIT-3). |
| 15 | Every execution note | `changes/` 118 SPECs + TEMPLATE; manifest Execution state | Handoff-through-repo intact; manifest→PROTOCOL pointer stale (G2). |

**Live-DB targets deferred (method limitation, honest):** Docker Desktop is not running this session, so `npx supabase start`/`db reset` and Postgres-MCP queries could not run. The count-reconciliation items (RLS policy 76-vs-63; RPC ~54/55/66; catalog 65/395) therefore **remain PENDING live verification** (V-series). They were confirmed at the 07-13 live-DB pass; nothing since could have changed them (no migration touching those objects landed after 07-13 except DC-1/R5, which add no policy/RPC/catalog). Re-run at the next `db reset`.

---

## 3. Findings register (classified; source-verified this session)

Fields per issue: **Evidence · Affected · Root cause · Arch impact · Impl impact · Future risk · Correction · Autonomous? · Owner-gated?**

### 3.1 HIGH

**S-EVENT — Event vocabulary is unenforced free text and drifting** *(existing ID; re-confirmed from source)*
- **Evidence:** `202607042600_create_event_and_notification_tables.sql:13` → `event_type_code text not null` with **no FK, no CHECK**; `grep "create table … event_type(s)"` across all migrations returns nothing → **no `event_types` catalog table exists**. Emitted codes diverge from canon-27: `internal_supplier_linked` (canon `internal_supplier_link_created`), `receipt_issued` (canon `receipt_created`); `invoice_issued/invoice_paid/invoice_partially_paid/supplier_payment_recorded/refund_requested` emitted but **absent from canon-27**.
- **Affected:** `events` table; every RPC calling `app.record_event`; `27_event_catalog.md`; the future outbox (CDD-7) that will key on `event_type`.
- **Root cause:** no single authority governs event codes; canon-27 is a prose catalog, never bound to the column.
- **Arch impact:** the event backbone (which Booking-orchestration, Self-Healing, Self-Learning, and offline-conversion delivery all consume) has no integrity floor — a typo'd code is silently accepted forever.
- **Impl impact:** consumers cannot trust `event_type_code`; Phase-8 delivery + reconciliation would inherit the drift.
- **Future risk:** compounds with every new emitter; unrecoverable analytics/attribution errors downstream.
- **Correction:** implement **N1** (seed `event_types` catalog + FK **or** a pgTAP guard asserting emitted ∈ canon) **and** a one-authority reconcile of canon-27 ↔ emitters. This is exactly the P2/N1 substrate — elevate its urgency from "substrate" to "arrests live drift."
- **Autonomous?** No — introduces a schema object + canon edit (new decision, ADR-adjacent). **Owner-gated?** Yes (ADR + canon).

**S3 — Certification gate requires a DEFERRED item (unsatisfiable gate)** *(refined this session to HIGH)*
- **Evidence:** `MASTER_CERTIFICATION_STATUS.md:13,21` list **DC-13 (UUIDv7)** as a Batch-0 condition for unconditional certification; but `MASTER_GAP_REGISTER.md:11,34` record DC-13 as **DEFERRED / MOVED→PENDING** (session-4 validation; benefit only at millions of rows; Supabase=PG17). The gate can therefore never be satisfied as written.
- **Affected:** `MASTER_CERTIFICATION_STATUS.md`.
- **Root cause:** half-propagation — the deferral updated the gap register but not the cert gate.
- **Arch impact:** the certification milestone is logically blocked on an item the project decided not to do.
- **Impl impact:** any "are we production-certifiable?" check reads a false blocker.
- **Future risk:** wasted effort chasing an un-closable gate; erodes trust in the cert ledger.
- **Correction:** remove DC-13 from the Batch-0 cert gate; add the UUIDv7-at-PG18 trigger (A4). Also fold in DC-1/R5 completion (S4).
- **Autonomous?** Yes (`reports/**` is agent-writable). **Owner-gated?** No.

**S1/S2 — Gap-register status column contradicts its own detail blocks & the execution plan** *(existing IDs; re-confirmed)*
- **Evidence, verified in the live file:** `MASTER_GAP_REGISTER.md` — DC-16 row = **OPEN** while its detail block (line 157) = **✅ IMPLEMENTED (SPEC-113)**; A1 = **VERIFIED-OPEN** though SPEC-117 landed it; A2 = **OPEN** though SPEC-114 landed bare indexes (composite deferred); B5 = **OPEN** though grants exist in `202607043400` (OK-4). Header (line 7) still "Last updated 2026-07-11."
- **Affected:** `MASTER_GAP_REGISTER.md` (rows + header date).
- **Root cause:** status column not advanced after SPEC-113/114/117 and the B5 grant migration.
- **Arch/Impl impact:** a reader trusting the status column mis-plans already-done work.
- **Future risk:** duplicate implementation; exactly the drift the governance-lint hook (§11) would prevent.
- **Correction:** flip DC-16 → ✅; A1 → VERIFIED/RESOLVED; A2 → partial-resolved (note composite deferred); B5 → RESOLVED (OK-4); refresh header date.
- **Autonomous?** Yes. **Owner-gated?** No.

### 3.2 MEDIUM

**S4/S5/S6/S7/S8/S9 — Master-suite staleness** *(existing IDs; re-confirmed present)*
- **Evidence:** cert gate not updated for DC-1/R5 completion (S4); `MASTER_COVERAGE_SCORE` still deducts for resolved R5/DC-1/A1, 82% not recomputed (S5); 82%-vs-84% completion split across Coverage/Domain-Catalog (S6); catalog-type count **61 (Masters) vs 65 (roadmap + seed `202607043100`, verified correct)** (S7); design-checklist not advanced for DC-16/DC-1/R5/A1/A2 (S8); "12-vs-13 Masters" (S9).
- **Affected:** `MASTER_CERTIFICATION_STATUS`, `MASTER_COVERAGE_SCORE`, `MASTER_DOMAIN_CATALOG`, `MASTER_DESIGN_CHECKLIST`.
- **Root cause:** half-propagation after SPEC-118/119 (11 Master files still dated 07-11).
- **Impact/risk:** metric confusion; not a design defect.
- **Correction:** the S4–S9 sweep (checkpoint §8). **Autonomous?** Yes (`reports/**`). **Owner-gated?** No (F8 checklist-interpretation needs one owner call — see §5).

**C1–C7 — Canonical annotation debt** *(existing IDs; re-confirmed)*
- **Evidence:** plan names Basic/Integrated/Complete (`09`) vs Starter/Professional/Enterprise (`17/25/14`) — real wrong-impl hazard (C1); Excel permitted (`01/08`) vs forbidden MVP (`16`) (C2); auth prose in `09/19/20/10` predates ADR-0017 (C3); dangling "activation code" idea (`09`) (C4); subscription grace/read-only home (C5); `15` role list omits Finance Manager + System Administrator vs authoritative `28` (C6); `18` integration order diverges from roadmap `32` (C7).
- **Affected:** `_ORVION_CANONICAL/09,01,08,16,19,20,10,15,18`.
- **Root cause:** later ADRs/SPECs superseded prose that was never annotated.
- **Impact/risk:** an implementer reading canon prose alone could follow a superseded rule (C1 is the sharpest — plan names drive seeded data).
- **Correction:** add "superseded by ADR-XXXX" banners / pointers; C4/C5 need an owner disposition (backlog vs rejected).
- **Autonomous?** **No** — `_ORVION_CANONICAL/**` is protected. **Owner-gated?** Yes (all C-series).

**G1/G3/G4 — Governance structural (protected)** *(existing IDs; re-confirmed)*
- **Evidence:** `AGENTS.md §6` protected-resources list (line 91) names only AGENTS/README/`_ORVION_CANONICAL` — **omits GOVERNANCE.md + CR_LIFECYCLE.md** (G1); `AGENTS.md:83` hardcodes "71 tables" — drift risk vs `verify_database.sql` (currently both say 71, so consistent *now*; risk is future) (G3); the Impl→Discovery→…→Sync loop lives in **both** `GOVERNANCE §18` and is pointed to from `AGENTS:36` — persist owner principles as **pointers not restated bodies** to avoid a One-Authority violation (G4).
- **Affected:** `AGENTS.md`.
- **Correction:** add a pointer from §6 to the GOVERNANCE §5 registry (not a second list); replace "71 tables" with a pointer to the verify script's expected count; keep the loop in one home.
- **Autonomous?** **No** — AGENTS.md is protected. **Owner-gated?** Yes.

### 3.3 LOW

**G2 — manifest points a fresh session at retired PROTOCOL.md** *(existing ID; re-confirmed)*
- **Evidence:** `manifest.md:49` — "Engineering principles, execution rules, and workflow — `AGENTS.md` and `PROTOCOL.md`." PROTOCOL.md is a retired tombstone.
- **Correction:** drop "and `PROTOCOL.md`." **Autonomous?** Yes (manifest is routine-editable). **Owner-gated?** No.

**N-AUDIT-1 — Prior dated audit's file-count line is now numerically stale (no action; immutable-correct)**
- **Evidence:** `pre-phase8-readiness-audit-2026-07-13.md:12` says "273/74 — 74 migrations." There are now **76** migration files (SPEC-118/119 added after that dated report).
- **Assessment:** **NOT a defect.** Historical-Immutable reports are a snapshot of their date and must not be edited (GOVERNANCE §4/§6.3). Recorded here so a reader reconciles. No correction.

**N-AUDIT-2 — Airports/airlines owner-promotion not yet realized in backlog**
- **Evidence:** `future-backlog.md:109` still lists Airlines/Aircraft-Types under "Future Candidates — Domain Reference Layer Expansion"; the owner's 2026-07-14 §7 promotion to first-class reference domains is approved-direction but not yet applied.
- **Assessment:** consistent with "pending owner sign-off" (checkpoint A2) — **not drift**, un-applied approved direction. Realize under Track 2 when the package is approved.

**N-AUDIT-3 — ai-map.json cosmetic UTF-8 mojibake**
- **Evidence:** `ai-map.json` renders em-dashes as `â€"` (encoding artifact from `generate-ai-map.ps1`).
- **Assessment:** LOW/cosmetic; auto-generated (never hand-edit). **Correction:** fix the generator's output encoding to UTF-8 and regenerate. **Autonomous?** Yes (script + regen). **Owner-gated?** No.

---

## 4. Architectural synchronization matrix (does every layer know its dependents?)

| Layer | Knows its dependents? | Evidence / gap |
|---|---|---|
| Business / Domain | ✅ | canon `00–23`; no live contradiction |
| Application / Access | ⚠️ | **no app/API phase in roadmap** (P1); 55 RPCs have no consumer surface; DC-23 open |
| Identity | ✅ | ADR-0015/0016/0017; principles `34` |
| CRM | ✅ | lead→customer→booking readiness handoff (`app.lead_booking_readiness`) |
| Revenue / Finance | ✅ | finance-gate ADR-0020/0021; money precision closed (DC-1) |
| Tracking / Attribution | ✅ (capture) | R5 landed (SPEC-119); delivery layer pending (P6) |
| Offline Conversion | ⚠️ | schema-first; transport undecided → ADR (P6) |
| Marketing / Google / Meta / WhatsApp / Framer / Forms / n8n | ⚠️ | designed (checkpoint §6), **not built**; single `ingest_lead` write-path pending (P4) |
| AI / Dashboards / Reporting | ⚠️ | 0 views (V6); RC-4 read-model unbuilt; resequence proposal P3 |
| Automation / Outbox | ⚠️ | CDD-7 outbox + N1 registry **required before Phase-8 delivery** (P2); **S-EVENT drift live now** |
| Self-Healing / Self-Learning | ✅ (as direction) | thin native capabilities on ADR-0018 substrate; almost nothing built now (checkpoint §4/§5); Self-Learning needs a §3 decision-lifecycle entry before ADR |
| Reference Data | ✅ core / ⚠️ travel | core reference layer DONE; airports/airlines promoted-not-realized (N-AUDIT-2) |
| Security / Permissions / RLS | ✅ | RLS 71/71 + InitPlan wrapping (A1); ADR-0013 single primitive |
| Events | ❌ integrity floor | **S-EVENT** — no catalog/FK/CHECK |
| Observability | ⚠️ | OPS-1 open (structured logging/metrics/RPO-RTO) |
| CI/CD / Testing | ✅ | `migration-ci.yml` gates; pgTAP harness (SPEC-113); smoke-test self-arms (SPEC-116) |
| Documentation / Roadmap / Governance | ✅ | boot chain coherent; staleness = §3 debt only |

**Reading:** ✅ layers are synchronized and self-aware. ⚠️ layers are *designed and dependency-aware but unbuilt* (expected — pre-implementation). The single ❌ is the Events integrity floor (S-EVENT), the highest-priority correction.

---

## 5. Repository quality & cold-boot continuity

- **Naming / folder / file organization:** ✅ consistent — `NN_name.md` canon, `2026MMDDHHMM_name.sql` migrations (linear), `SPEC-NNN` changes, `reports/{master,evidence,history}` by class.
- **Discoverability / navigation / boot sequence:** ✅ README → AGENTS → manifest → active-CR/roadmap is intact and consistent across README, AGENTS §4, `llms.txt`, and `ai-map.json`. Retired docs (PROTOCOL, global-rules) and deprecated docs (codex, SYSTEM_PROMPT) are correct tombstones/pointers; GEMINI.md is a thin pointer. **No orphan/empty/placeholder files found.**
- **Cold-boot continuity (the key test):** ✅ **A fresh AI session with no chat history CAN reach the same architectural understanding.** The one caveat: it must read the two prior dated audits + this one to learn the *pending* state (P1–P7, S-series), because those decisions are approved-direction not yet in canon — which is exactly what the manifest's Session-Checkpoint pointer directs it to do. So continuity holds *through the documented pointer*, not in spite of it.
- **Maintainability / scalability:** ✅ Maintenance-Mode discipline (GOVERNANCE §18) is holding — three sessions produced only sync-level fixes. The recurring failure mode is **half-propagation of status after a SPEC completes** (S1–S9), which the owner-gated governance-lint hook (§11) would mechanically end. **This is the single highest-leverage preventive.**

---

## 6. Recovery Plan (priority-ordered; NOT executed — awaits owner approval)

Ordered highest architectural priority → lowest. Tracks mirror checkpoint §9 (One Authority — same plan, prioritized).

**P0 — Arrest live drift (highest).**
1. **S-EVENT / N1** — event-type integrity floor (catalog + FK or pgTAP guard) + canon-27 ↔ emitters reconcile. *Owner-gated (ADR + canon).* Rationale: the only ❌ layer; every downstream consumer inherits it; cheapest before Phase-8 delivery is designed.

**P1 — Track 1: agent-authority sync sweep (apply immediately on "go"; `reports/**` + living manifest).**
2. S3 — remove DC-13 from cert gate (unsatisfiable) + A4 UUIDv7-at-PG18 trigger note.
3. S1/S2 — gap-register rows: DC-16 ✅, A1 VERIFIED, A2 partial, B5 RESOLVED; header date.
4. S4–S9 — cert gate DC-1/R5, coverage recompute, 82/84 align, catalog 61→65, design-checklist, 12/13 Masters.
5. G2 — manifest: drop retired-PROTOCOL pointer.
6. N-AUDIT-3 — fix `generate-ai-map.ps1` encoding + regenerate ai-map.json.
7. Write the S-EVENT reconciliation plan into `MASTER_GAP_REGISTER.md` (record, don't yet implement).

**P2 — Track 2: protected-doc diffs (present each diff for owner sign-off BEFORE writing).**
8. G1/G3/G4 — AGENTS.md: §6 pointer to GOVERNANCE §5 registry; "71 tables" → verify-script pointer; persist owner principles as pointers (loop stays single-home).
9. C1–C7 — canon supersession annotations (C1 plan-names first — data-seeding hazard); C4/C5 owner disposition.
10. P1/P2/P3 + A1/A2 — roadmap resequence decision (app/access phase; outbox-before-Phase-8; reporting-vs-offline-conversion order); realize airports/airlines promotion.
11. New ADRs 0022+ (app/access phase; CDD-7+N1; unified `ingest_lead`+consent; Google Data Manager transport; self-learning posture; airports/airlines) + ADR-0002 amendment (UUIDv7).

**P3 — Deferred verification (next `db reset`, Docker up).**
12. V-series live-DB counts: RLS policy (76-vs-63), RPC (~54/55/66), catalog (65/395).

**Governance preventive (owner-gated, recommended alongside P1):** adopt the governance-lint hook (§11) so status half-propagation (S1–S9's root cause) cannot recur.

---

## 7. Owner decisions required to unblock (unchanged from checkpoint §10, restated for action)

1. Approve this Recovery Plan (all, or item-by-item), incl. G4 (loop→pointer) and A4 (UUIDv7 commit-now/swap-at-PG18).
2. Phase 8 next, or adopt **P3** (reporting first)? — determines whether "Start Phase 8" is the true next move.
3. C4/C5 dispositions (activation-code idea; subscription grace/read-only home).
4. F8 interpretation (does a SPEC-complete design-checklist item read `[✓]`?).
5. Airline data license (OpenFlights ~$100 / Wikidata CC0 / IATA / airports-only) — blocker for airline seed only.

---

## 8. What was NOT changed

Per instruction: **nothing was committed and no correction was applied.** This report + its index entry in `reports/README.md` are the only additions (both agent-authority Living docs, GOVERNANCE §8). No protected document, no canon, no migration, no manifest state field was modified. Implementation begins only after owner approval of §6.

End of audit. Nothing from this pass exists only in chat.
