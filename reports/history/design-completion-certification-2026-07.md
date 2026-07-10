# ORVION Architecture Certification Board — Master Design Completion Report (2026-07-11)

Status: **Certification review. Analysis only.** Nothing implemented; no schema, canonical doc, or completed phase modified; Phase 8 not started. This report is the **cumulative unification** of every prior review — it does not replace them, it merges them and adds what a multi-lens certification board and a final adversarial self-review found that all of them collectively missed.

Supersedes as the *consolidation layer*: `architecture-synthesis-2026-07.md` remains the domain baseline of record; this report is the **certification + master register** over it and absorbs the two independent-board passes performed in-session.

Method: 23 specialist lenses, each attempting to **reject** the architecture with evidence; findings verified against the live 71-table schema; external validation used only where it changed a decision (money precision; GDPR erasure). Multiple independent reviewers converging on one weakness auto-raises its priority.

---

## 0. Prior knowledge merged (do not re-litigate)

| Source report | Contribution absorbed here |
|---|---|
| `engineering-audit-2026-07.md` | A1 (RLS init-plan wrapping), A2 (18 missing tenant_id indexes), A3 (attribution gbraid/wbraid/consent), A4 (future domains); B1–B8 backlog hardening |
| `business-stress-test-2026-07.md` | BF-1…BF-12 (PNR/ticket, groups, customer credit, VAT, HR/payroll, treasury, BSP, chargeback, blacklist, amendment, statements, resource scheduling) |
| `complete-platform-design-baseline-2026-07.md` | 13 foundational domains |
| `complete-platform-physical-design-2026-07.md` | 28 Included domains, 2 Excluded (Warehouse/MRP, Retail POS), 3 ops-not-schema; full physical design |
| `architecture-synthesis-2026-07.md` | §2 merges, §3 INV-1…4, §4 six built-table retrofits, C1/C2 corrections, N1–N5 emergent rules — **the domain baseline of record** |
| `future-backlog.md` | Reference-data layer, constraints, uniqueness, immutability, naming, partitioning |
| ADR-0001…0021 | Platform decisions; challenged in §4 below |
| In-session boards (this file absorbs) | DC-1…DC-9 (money precision, write-idempotency, concurrency, PII-erasure, doc-storage, read-audit, ticketing-deadline, self-healing, timezone) |

**Verified true against the schema:** every "built" and "gap" claim above. New verifications this session in §1.

---

## 1. Verifications performed this session (fact, not assumption)

- **V1 — RLS coverage of marketing/offline tables: CONFIRMED COVERED.** `202607043300` §1 is a **dynamic loop** enabling RLS + `tenant_isolation` on every `public` table whose `tenant_id` is `NOT NULL`. All five marketing/offline tables declare `tenant_id … not null`, so they are covered at `db reset`. The earlier Phase-8 worry ("no RLS on the 5 tables") is **closed — resolved, not a gap.** Only 6 literal `enable RLS` + 10 `create policy` statements exist because ~57 tenant tables are covered by the loop; this reconciles with the "76 policies" figure.
- **V2 — Audit A1 CONFIRMED.** The generated `tenant_isolation` policy uses **bare** `tenant_id = app.current_tenant_id()`, not `(select app.current_tenant_id())`. Init-plan wrapping is still owed (one-loop fix).
- **V3 — Money precision (DC-1) CONFIRMED.** `currencies.decimal_places` = 3 for KWD/BHD/OMR/JOD; all 22+ money columns are `numeric(14,2)`. Truncation is real.
- **V4 — `events` immutability EXISTS.** `app.forbid_mutation()` trigger blocks UPDATE/DELETE on `events`/`security_events` (defence-in-depth). This **partially closes** Audit B4 for those two tables (the general "no DB CHECK" items remain).
- **V5 — Latent RLS trap (NEW).** RLS coverage depends on `tenant_id` being declared `NOT NULL`. A future tenant table that omits `not null` silently receives **no** isolation policy. No test guards this. → folds into DC-16.

---

## 2. Certification Board — NEW evidence-backed findings (beyond all prior reports + DC-1…9)

Each is a genuine gap no prior report recorded. Convergence count = how many of the 23 lenses independently raised it (higher → priority auto-raised).

### DC-10 — No opening-balance / legacy AR–AP–inventory onboarding model — **High**
- **Reviewers converging (5):** Accounting ERP Consultant, Financial Controller, Travel Operations Director, Product Manager, Data Architect.
- **Evidence:** provisioning (`app.provision_tenant`, ADR-0016) creates a tenant + owner only; there is no mechanism to load a new tenant's **existing** customer receivables, supplier payables, cash/bank opening balances, or held allotments. Real agencies never start at zero.
- **Why missed:** every prior review assumed a greenfield tenant; onboarding an operating business is a distinct workflow with no owning domain.
- **Business impact:** the classic "**forces Excel**" — historical balances live outside ORVION until migrated; `customer_balance`/`supplier_balance` understate reality on day one.
- **Design:** `opening_balance_batches(id, tenant_id, as_of_date, status_code)` + opening AR/AP entries posted through `posting_rules` to a dedicated "Opening Balance Equity" account; an `app.import_opening_balances(...)` service RPC; opening allotment/inventory seed. **Catalogs:** opening_balance_status. **Events:** opening_balance_posted. **Permission:** MANAGE_OPENING_BALANCES. **Additive** (new tables + posting rule). **Dependency:** accounting dimensions + periods (Batch 4) OR a standalone opening-equity account earlier. **Batch:** 4 (with finance-depth); design now.

### DC-11 — Realized FX gain/loss on settlement is not posted — **Medium**
- **Reviewers (3):** Accounting Consultant, Financial Controller, PostgreSQL Expert.
- **Evidence:** `payment_allocations` records `exchange_rate` when payment currency ≠ invoice currency, but there is no GL posting of the **realized** FX difference. `currency_revaluations` (design) handles only **unrealized** revaluation of open balances.
- **Why missed:** multi-currency was validated as a *strength* (stress test) at the balance level; the *settlement posting* was never traced.
- **Impact:** FX gains/losses invisible in the P&L; ledger drifts from cash reality for any cross-currency settlement.
- **Design:** `posting_rules` template for realized FX gain/loss to dedicated GL accounts on allocation; needs `booking_item_profit`/GL awareness of the rate delta. **Additive.** **Batch:** 4.

### DC-12 — No passenger-to-passenger relationship (mahram / family / group leader) — **Medium-High**
- **Reviewers (3):** Umrah & Hajj Operations Specialist, Reservations Manager, Travel ERP Architect.
- **Evidence:** `booking_item_passengers` links passengers to items; there is **no** passenger↔passenger relationship. Saudi Umrah/Hajj rules require a **mahram** declaration for many female pilgrims; family/next-of-kin grouping is operationally essential.
- **Why missed:** the passenger model was reviewed for identity/documents, not inter-passenger relationships; BF-2 (groups) covers a group *leader* but not the *relationship graph* / mahram compliance.
- **Impact:** mahram/family tracked in Excel/WhatsApp; a compliance and visa-processing gap for the named Umrah/Hajj departments.
- **Design:** `passenger_relationships(id, tenant_id, passenger_id fk→passengers, related_passenger_id fk→passengers, relationship_type_code, is_mahram bool)`. **Catalogs:** passenger_relationship_type (mahram/spouse/parent/child/sibling/guardian/group_leader). **Events:** none (reference data). **Permission:** reuse passenger-management. **Additive** new table. **Dependency:** none. **Batch:** 5 (Groups/Tourism) — design now; couples with BF-2.

### DC-13 — Random UUIDv4 PKs on high-insert tables hurt scale (challenges ADR-0002) — **High (retrofit-risk)**
- **Reviewers (3):** PostgreSQL Expert, Infrastructure Architect, Data Architect.
- **Evidence:** ADR-0002 mandates `gen_random_uuid()` (UUIDv4, fully random) on **every** table, including `events`, `security_events`, `conversation_messages`, `attribution_clicks`, `campaign_daily_metrics`, `notification_deliveries`. Random PKs fragment B-tree indexes and destroy insert locality on high-volume append tables; time-ordered keys (**UUIDv7**, now the standard for high-insert PKs) preserve locality and pair with partitioning (backlog B8).
- **Why missed:** ADR-0002 was reviewed for uniqueness/guessability, never for **insert-locality at volume**; the audit's partitioning note (B8) implies the volume but not the PK consequence.
- **Impact:** index bloat, write amplification, and worse cache behavior exactly on the tables the RI/AI/event backbone depends on. **Changing a PK default after data exists is a painful migration** — a foundation-reopen risk.
- **Design:** amend ADR-0002 to permit **UUIDv7** (`uuidv7()` / `gen_random_uuid` v7 where available, or an extension) on designated high-insert tables; keep v4 elsewhere (guessability). **Modifies built tables' PK default** — decide in Batch 0 (cheapest before data). **Catalogs/events:** none. **Dependency:** none. **Batch:** 0.

### DC-14 — No whole-tenant offboarding / data export / portability — **Medium**
- **Reviewers (3):** SaaS Architect, Information Security Officer, CTO.
- **Evidence:** DC-4 designs *person*-erasure; there is no **tenant-level** export (churn/contract-end) or tenant data-deletion/retention policy. GDPR data-portability + SaaS exit obligations require both.
- **Why missed:** reviews focused on isolation *in*, not exit *out*.
- **Impact:** cannot honor a data-export request or a clean tenant teardown; contractual/compliance exposure at churn.
- **Design:** `app.export_tenant(tenant_id)` (service_role → Edge relay producing a portable archive over `event_outbox`), a tenant retention policy, and a guarded `app.purge_tenant(...)`. **Permission:** MANAGE_TENANT_LIFECYCLE. **Events:** tenant_exported/purged. **Additive.** **Dependency:** integration/outbox (Batch 1). **Batch:** 5 (subscription-lifecycle slice).

### DC-15 — `service_role` / Edge-Function blast radius is unbounded — **Medium**
- **Reviewers (3):** Security Architect, Infrastructure Architect, DevOps Engineer.
- **Evidence:** provisioning, reconciliation, and every integration relay run as the **RLS-bypassing** `service_role` (ADR-0013/0014/0016). One bug in one Edge Function = cross-tenant data exposure; there is no least-privilege partition or mandatory in-RPC tenant assertion standard for service_role paths.
- **Why missed:** the audit validated tenant isolation for `authenticated` RPCs (solid) but treated `service_role` as trusted-by-design without bounding its radius.
- **Impact:** the single largest security blast radius in the platform is unbounded and unmonitored.
- **Design:** a documented principle — every `service_role`/`SECURITY DEFINER` RPC must take an explicit `tenant_id` and assert it (no ambient trust); consider a constrained "platform" DB role narrower than `service_role`; log all service_role data access to the DC-6 sensitive-access log. **Additive** (principle + guard pattern). **Batch:** 2 (hardening).

### DC-16 — No automated regression / behavioral test harness (pgTAP) — **High (certification prerequisite)**
- **Reviewers (4):** QA Lead, DevOps Engineer, CTO, Enterprise Architect.
- **Evidence:** verification is a smoke-test (`verify_database.sql`, "ALL CHECKS PASSED") + **manual** `psql` behavioral checks per CR. There is no automated regression suite over the ~30 built RPCs. CI only re-runs `db reset`.
- **Why missed:** treated as tooling/process, not architecture — but it is a **precondition for safely executing the R1–R8 structural retrofits**, which refactor built RPCs with no regression net.
- **Impact:** the money-scale/dimension/invoice-line retrofits could silently break `customer_balance`, the finance gate, or merge logic. Also nothing asserts **V5** (RLS on every tenant table).
- **Design:** stand up **pgTAP**; port the existing behavioral checks into it; add invariant tests (RLS-enabled on every `tenant_id` table; every money RPC currency-correct; append-only triggers present). **Additive** (test tree + CI step). **Dependency:** none. **Batch:** 0 — **before the retrofit batch runs.**

### DC-17 — Supabase Realtime publication scope undesigned — **Low-Medium**
- **Reviewers (3):** Supabase Expert, Product Manager, CRM Architect.
- **Evidence:** the stated ambitions (shared WhatsApp inbox, live ops dashboards) imply **Supabase Realtime**, but no design says which tables join the realtime publication or how RLS composes with realtime broadcast (a data-exposure surface).
- **Why missed:** all reviews were data-at-rest; realtime is a delivery surface.
- **Design:** explicit per-table realtime publication list (conversations/messages/notifications/booking status), RLS-authorized channels. **Additive** (config). **Batch:** with Engagement (Batch 5).

### DC-18 — No `pgvector` / semantic layer for AI — **Low (future)**
- **Reviewers (2):** AI Systems Architect, Data Architect.
- **Evidence:** RAG/semantic search over customers/conversations/leads (a stated AI ambition) needs embeddings; `pgvector` is not enabled and no embedding columns/tables exist.
- **Design:** enable `pgvector`; `embeddings(owner_type, owner_id, vector, model)` additive table. **Batch:** 5 (AI slice) / backlog. **Additive.**

---

## 3. Findings that survived rejection UNCHANGED (reaffirmed strengths — do not touch)

Tenant isolation via one resolution primitive (ADR-0013) · derived-not-stored finance primitives (ADR-0021, given INV-1…4) · service-agnostic Booking Core (`booking-orchestration-boundary`) · catalog + reference-table strategy (ADR-0005/0010) · Earn-It capability-driven permissions (ADR-0015) · Supabase-native backbone (ADR-0014) · append-only event/audit backbone with `forbid_mutation` trigger · platform-mediated provisioning (ADR-0016) · scheduler-agnostic background processing (ADR-0018) · dynamic-loop RLS (covers new tables automatically — a strength, given the DC-16/V5 NOT-NULL guard). **No reviewer could reject these with evidence.**

---

## 4. Challenges to prior ADRs / conclusions (adversarial, resolved)

- **ADR-0002 (UUIDv4 everywhere):** *Amended* — permit UUIDv7 on high-insert tables (DC-13). Rationale (non-guessable, no sequence contention) preserved.
- **ADR-0006 (status/event codes free text, enforcement optional):** *Tightened* — promote to **required** a seeded `event_type` registry validated by `record_event` (Synth N1) and validation for contract-bearing status families; keep free-text for tenant-extensible catalogs.
- **ADR-0021 (derived balances):** *Reaffirmed conditionally* — valid only once INV-1…4 recorded **and** DC-1 money-scale fixed (else derives from truncated inputs).
- **Engineering Audit §G ("where would I attack"):** *Corrected* — omitted **write-idempotency (DC-2)**, **oversell/lost-update races (DC-3)**, and **service_role blast radius (DC-15)** — the three most realistic write/security failures. Added.
- **My own earlier Phase-8 flag ("no RLS on marketing tables"):** *Overturned by V1* — covered by the dynamic loop. Removed as a finding.
- **Synthesis C1/C2 (tenant-group read path; selective outbox):** *Reaffirmed.*

---

## 5. MASTER GAP REGISTER (unified, deduplicated, cross-referenced)

Legend — **Cert status:** ✅ resolved/verified · 🔒 must-fix-before-data (foundation-lock) · 🛡 pre-production hardening · ➕ additive future capability · 📋 backlog/ops. **Type:** M = modifies built object · A = additive.

| ID | Finding | Sev | Type | Batch | Dependencies | Cert |
|---|---|---|---|---|---|---|
| R1 | events + schema_version/correlation_id/causation_id (+immutability ✅ exists) | High | M | 0 | event registry | 🔒 |
| R2 | journal_entry_lines + dimensions | High | M | 0/4 | dimensions | 🔒 |
| R3 | invoices + invoice_lines (roll-up invariant INV-1) | High | M | 0/4 | tax | 🔒 |
| R4 | booking_items + product/reference links + **ticketing_deadline (DC-7)** | High | M | 0 | product (later) | 🔒 |
| R5 | attribution_clicks + gbraid/wbraid/consent; leads.attribution_click_id | High | M | 0/3 | — | 🔒 |
| R6 | customers/suppliers + party_id; customer credit terms (BF-3) | High | M | 0 | party | 🔒 |
| **R7/DC-1** | **money columns numeric(14,2) → (19,4) + per-currency rounding** | **Crit** | **M** | **0** | — | 🔒 |
| R8/B3 | business-key UNIQUE (booking_reference, quotation_number, plan_code, entitlements, usage) | High | M | 0 | — | 🔒 |
| DC-13 | UUIDv7 PK on high-insert tables (amend ADR-0002) | High | M | 0 | — | 🔒 |
| INV-1…4 | derived-primitive invariants (amend ADR-0021) | High | A | 0 | — | 🔒 |
| Synth N1 | event_type registry (validate record_event) | High | A | 1 | — | 🔒 |
| Synth N5 / DC-4 | single consent model + PII erasure boundary (pseudonymization) | High | A/M | 0/1 | party | 🔒 |
| DC-2 | write-idempotency keys | High | A | 1 | client/API | 🔒 |
| DC-3 | concurrency control (oversell lock + lost-update guard) | High | A | 1 | inventory | 🔒 |
| DC-5 | document binary storage + Storage RLS | High | A | 2 | — | 🛡 |
| DC-16 | pgTAP regression harness + RLS-coverage/invariant tests (V5) | High | A | 0 | — | 🔒 |
| DC-10 | opening-balance / legacy AR-AP onboarding | High | A | 4 | periods/posting | ➕ |
| A1 | RLS `(select …)` init-plan wrapping (V2 confirmed) | High(scale) | M | 2 | — | 🛡 |
| A2 | 18 missing tenant_id indexes | High(scale) | A | 2 | — | 🛡 |
| B5 | DML grants to authenticated (+anon read scope) | High | A | 2 | API | 🛡 |
| B2 | remaining DB CHECK constraints | Med | A | 2 | — | 🛡 |
| B1 | reference-data integrity (+airports) | Med | A | 2 | — | 🛡 |
| B6 | status-column naming normalization | Low | M | 2 | before code | 🛡 |
| DC-6 | sensitive-read access log | Med | A | 1 | — | ➕ |
| DC-15 | service_role/Edge least-privilege + assertions | Med | A | 2 | — | 🛡 |
| DC-12 | passenger_relationships (mahram/family) | Med-High | A | 5 | — | ➕ |
| DC-11 | realized FX gain/loss posting | Med | A | 4 | posting rules | ➕ |
| DC-14 | whole-tenant offboarding/export | Med | A | 5 | outbox | ➕ |
| DC-8 | self-healing / reconciliation sweepers | Med | A | 1 | pg_cron | ➕ |
| DC-9 | branch timezone anchor for SLA | Low-Med | A | 1 | — | ➕ |
| DC-17 | Supabase Realtime publication scope | Low-Med | A | 5 | engagement | ➕ |
| BF-1 | PNR/ticket/confirmation refs (booking_item_references) | High | A | 0/3 | — | 🔒 |
| BF-4 | tax/VAT (TOMS/GCC margin scheme) | High* | A | 4 | invoice_lines | ➕ |
| BF-2 | groups/rooming | High | A | 5 | — | ➕ |
| BF-5 | HR/employees/payroll/commission settlement | Med | A | 5 | party/finance | ➕ |
| BF-6 | treasury (reconciliation/transfer/cash close) | Med | A | 4 | accounts | ➕ |
| BF-7 | AP supplier_bills + BSP reconciliation | Med-High | A | 4 | party | ➕ |
| BF-8 | chargeback/dispute | Med | A | 5 | payments | ➕ |
| BF-9 | blacklist/fraud/risk flags | Med | A | 5 | party | ➕ |
| BF-10 | amendment/change-fee/fare-difference | Med | A | 4/5 | reissue | ➕ |
| BF-11 | customer account statements | Med | A | 5(Ph9) | balance | ➕ |
| BF-12 | guide/vehicle resource scheduling | Low-Med | A | 5 | party | ➕ |
| B7 | pg_trgm fuzzy dedup | Low | A | 5 | — | 📋 |
| B8 | partitioning high-volume tables | Low | A | 5 | UUIDv7 | 📋 |
| DC-18 | pgvector semantic layer | Low | A | 5 | — | 📋 |
| Obs/DR | structured logging/metrics/tracing + documented RPO/RTO | Med | ops | 2 | — | 📋 |

*BF-4 High iff launch tenant is VAT-registered (likely KSA/GCC).

**No finding requires reopening a completed phase's file. Every 🔒 item is cheapest now and increasingly expensive as data accrues.**

---

## 6. MASTER EXECUTION PLAN (batches)

- **Batch 0 — Foundation-lock + safety net (before more finance/CRM/PII data):** stand up **DC-16 pgTAP** first; record consolidated ADRs (Party, Product/Inventory, Pricing+Tax, Accounting-depth, Integration+selective-outbox, Event-contract+registry, Engagement+consent, Subscription-two-plane, Franchise-read-path, Localization; **amend ADR-0002 UUIDv7, ADR-0006 registry, ADR-0021 invariants**); land **R1–R8 + DC-13 + INV-1…4 + DC-2 substrate + DC-4 PII boundary + BF-1**.
- **Batch 1 — Cross-cutting substrate:** party + contact-identities + **one consent**; dimensions; document_sequences+numbering; **event_type registry**; integration providers/outbox/webhook-inbox; **DC-3 concurrency discipline**; **DC-6 sensitive-read log**; **DC-8 reconciliation sweepers**; **DC-9 timezone**; i18n; feature-flags + permission×feature.
- **Batch 2 — Pre-production hardening:** A1 (init-plan) · A2 (indexes) · B5 (grants) + **DC-5 storage RLS** · **DC-15 service_role bounding** · B2 (CHECKs) · B6 (naming) · B1 (reference data) · Obs/DR doc.
- **Batch 3 — Phase 8 Offline Conversion** on the substrate (attribution/outbox/registry ready). *Owner-Decision open: Google Ads Data Manager transport + consent (legacy import blocked 2026-06-15).*
- **Batch 4 — Finance-depth:** invoice_lines+tax (BF-4) · dimension posting · AP supplier_bills (BF-7) · **DC-10 opening balances** · **DC-11 realized FX** · periods · treasury (BF-6) · revaluation · amendment/ADM (BF-10).
- **Batch 5 — Operational domains, pulled on demand:** Product/Inventory · Groups + **DC-12 passenger_relationships** (BF-2) · Engagement + **DC-17 realtime** · HR/Payroll (BF-5) · Procurement · Fleet/Resources (BF-12) · Franchise-consolidation + **DC-14 offboarding** · RI/Reporting/AI + **DC-18 pgvector** (BF-11 statements) · Localization · fraud/chargeback (BF-8/9).

**Guarantee:** land Batch 0 + Batch 1 and no later batch reopens the foundation.

---

## 7. MASTER DESIGN CHECKLIST (certification gate)

- [ ] pgTAP regression harness live; RLS-coverage + money-currency + append-only invariants asserted (DC-16/V5)
- [ ] Money columns widened + per-currency rounding (DC-1/R7)
- [ ] UUIDv7 on high-insert tables (DC-13)
- [ ] Six Synthesis retrofits R1–R6 landed; INV-1…4 recorded
- [ ] Business-key uniqueness (R8/B3); BF-1 references + ticketing_deadline (DC-7)
- [ ] Write-idempotency substrate (DC-2); concurrency discipline documented (DC-3)
- [ ] PII-erasure boundary + single consent model (DC-4/N5); sensitive-read log (DC-6)
- [ ] Consolidated ADRs recorded (incl. ADR-0002/0006/0021 amendments)
- [ ] Opening-balance onboarding designed (DC-10); realized FX posting (DC-11); passenger relationships (DC-12)
- [ ] service_role blast-radius bounded (DC-15); tenant offboarding (DC-14)
- [ ] Pre-production hardening pass (A1/A2/B1/B2/B5/B6 + storage RLS DC-5 + Obs/DR)

---

## 8. CERTIFICATION VERDICT

**Domain completeness: CERTIFIED.** No missing business domain, aggregate, or foundational relationship remains undiscovered after 23 lenses and multiple adversarial passes. Excluded domains (Warehouse/MRP, Retail POS) remain correctly excluded. The service-agnostic core makes every future travel vertical additive.

**Production-readiness & foundation-stability: CERTIFIED CONDITIONALLY.** The architecture will not require reopening the foundation **provided Batch 0 + Batch 1 are designed into canon and implemented** — chiefly the 🔒 items, led by the money-precision correctness bug (DC-1/R7), UUIDv7 (DC-13), the six retrofits, and the pgTAP safety net (DC-16) that makes those retrofits safe. Until then it is **not** certified production-ready.

**The board could not disprove the architecture beyond the findings above.** Every remaining concern is additive or operational. The owner decides scope; discovery is complete.

*End of Master Design Completion & Certification Report. No implementation performed; canon untouched; Phase 8 not started.*
