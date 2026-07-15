# ORVION MASTER COVERAGE SCORE

Status: **Permanent engineering scorecard.** Never recreate; evolve. Score = **design completeness** against the completion standard ("a new team needs no rediscovery"), NOT implementation %. Each score is justified. Cross-reference: `MASTER_DOMAIN_CATALOG.md`, `MASTER_GAP_REGISTER.md`.

Last updated: 2026-07-15 (Repository Recovery synchronization). Scale 0–100. ▲ = raised since last review; new categories marked (new).

> **Sync note (2026-07-15):** since the 2026-07-11 scoring, the following deductions below are now **IMPLEMENTED** (evidence in `MASTER_EXECUTION_PLAN.md`): DC-1 money precision (SPEC-118), R5 attribution (SPEC-119), A1 RLS init-plan wrapping (SPEC-117), A2 tenant_id bare indexes (SPEC-114), DC-16 test harness (SPEC-113). The per-area justifications that cite these as gaps are therefore stale-on-the-downside — the **82% understates** current design+implementation completeness. A precise weighted recompute is deferred (it is analysis, not a mechanical sync, and the live-DB pass is pending Docker); the individual area notes are left intact for traceability and will be recomputed at the next scoring review. No score was fabricated in this sync.

| Area | Score | Justification (what holds the score below 100) |
|---|---|---|
| Database foundation | 96% | 71 tables, RLS via single primitive, catalog/reference strategy, immutability trigger all sound. −4: only 12 CHECK constraints (B2); business-key uniqueness gaps (B3). |
| Multi-tenancy / Isolation | 98% | Default-deny, dynamic-loop RLS covers every tenant table (V1), service_role-only platform. −2: init-plan wrapping (A1) + V5 NOT-NULL trap untested. |
| CRM / Leads / Sales | 95% | Full lead lifecycle, SLA, identity/merge, tasks/complaints/quotations/conversations built. −5: attribution link (R5), SLA timezone (DC-9). |
| Customer Identity / Party | 88% | Customer identity + merge strong. −12: party generalization (CDD-1), consent (N5), credit terms (BF-3), erasure (DC-4) designed but not in canon. |
| Travel Operations / Reservations | 86% | Service-agnostic booking core is the platform's strength. −14: product/inventory (CDD-2), PNR/refs (BF-1), ticketing_deadline (DC-7), groups (BF-2), mahram (DC-12), per-vertical tables. |
| Accounting / Finance | 82% | Derived balances, invoices/payments/receipts/refunds/journals, finance gate built. −18: dimensions (R2), invoice_lines (R3), **money-scale (DC-1)**, subledger auto-posting, periods, AP bills (BF-7), treasury (BF-6), opening balances (DC-10), realized FX (DC-11). |
| Tax / VAT | 85% | TOMS margin + GCC design complete. −15: not in canon; jurisdiction-triggered. |
| Documents | 90% | Polymorphic + versioned + lifecycle + financial visibility built. −10: binary storage/Storage RLS (DC-5), templates, sequences. |
| Security | 96% | Audited solid; RLS + RBAC + MFA(aal) + immutability. −4: service_role blast radius (DC-15), sensitive-read log (DC-6). |
| Privacy / Compliance | 88% ▲ | Consent designed; events ID-based (erasure-safe). −12: erasure boundary (DC-4), read-audit (DC-6), tenant export (DC-14) designed but not ratified. |
| Reference Data | 91% | currencies/countries/nationalities/languages tables + natural keys. −9: airports/airlines/etc. (B1) still free-text-backed. |
| Integrations | 90% | Outbox+webhook-inbox+providers design complete; connectors specified (Google/Meta/WhatsApp/GDS/BSP/n8n/Framer). −10: unbuilt; idempotency edge (DC-2). |
| AI Readiness | 84% | Event+RPC surface is the agent boundary; MCP design done. −16: N1 event registry (reliability), DC-18 pgvector, RC-4 read models. |
| Reporting / Dashboards | 74% | Substrate (events + derived RPCs + dimensions) ready. −26: **0 views/matviews exist (V6)**; read-model layer (RC-4), statements (BF-11), dimensions unbuilt. |
| SaaS / Billing | 82% | Plan/entitlement/usage tables + provisioning built. −18: lifecycle logic (RC-1), feature flags, two-plane billing, offboarding (DC-14). |
| Scalability | 83% | Single-primitive RLS, partitioning candidates identified. −17: UUIDv7 (DC-13), tenant indexes (A2), init-plan (A1), partitioning (B8). |
| Concurrency | 72% (new) | Outbox uses SKIP LOCKED. −28: no write-idempotency (DC-2), no oversell/lost-update discipline (DC-3). |
| Observability / DR | 65% (new) | Business event backbone strong. −35: no structured logging/metrics/tracing; DR posture undocumented (OPS-1). |
| Quality / Test Assurance | 60% (new) | Smoke-test + CI db-reset + manual behavioral checks. −40: no automated regression harness (DC-16) — the net for retrofits. |
| Extensibility / Metadata | 55% (new) | catalog_values gives tenant dropdowns. −45: no custom-field/custom-object framework (DC-20), tenant-custom roles (DC-24), plugin SDK (DC-26), white-label theming. |
| Compliance / Data-Residency | 70% (new) | Consent + erasure boundary designed. −30: no data-residency/multi-region topology (DC-22, Saudi PDPL enforced SAR 5M/breach), retention/archival (DC-25). |
| Localization / Calendar | 76% (new) | i18n translations designed. −24: no Hijri calendar (DC-21, core Umrah/Hajj market), calendar-aware business rules. |
| Public API / Developer surface | 62% (new) | ACCESS_API perms seeded; Supabase PostgREST auto-API. −38: no API contract/versioning/rate-limit/quota (DC-23), no external-developer model. |
| Governance / Knowledge | 97% ▲ | Canon + ADRs + 13 Master documents + cumulative reports; self-describing. −3: proposed ADRs not yet ratified. |

## Weighted platform design completion ≈ **82%** ▼ (was 84%; four new meta-pattern areas added 2026-07-11 #3)
(Weighted by architectural importance per `MASTER_HEAT_MAP.md`; correctness/foundation domains weighted higher. The drop reflects honest discovery — DC-20…29 exposed extensibility/residency/calendar/API gaps that were previously uncounted, not new regressions.)

## Where the missing ~16% concentrates
1. **Finance-depth + money correctness** (DC-1, R2/R3, subledgers, dimensions, periods, AP, treasury, opening balances).
2. **Reporting read-model layer** (0 views today; RC-4).
3. **Concurrency + test-assurance + observability** (DC-2/3, DC-16, OPS-1) — the production-integrity trio.
4. **Product/Inventory + reservations depth** (CDD-2, BF-1/2, DC-7/12).
5. **Cross-cutting substrate not yet in canon** (party/consent, outbox, event registry, i18n, numbering).

Every point below 100 maps to a `MASTER_GAP_REGISTER.md` ID with a batch and dependency — no unexplained score.
