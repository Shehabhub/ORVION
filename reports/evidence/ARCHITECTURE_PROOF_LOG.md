# ORVION ARCHITECTURE PROOF LOG

Status: **Permanent traceability log.** Every finding's path through the 9-stage evidence pipeline. Append-only; nothing disappears. Columns: S1 Discovery / S2 Evidence / S3 External / S4 Counter-proof / S5 Owner-impact / S6 Class / S7 Confidence / S8 Priority / S9 Decision. ✅ pass · ⚠ conditional · ✗ fail · — n/a.

Last updated: 2026-07-11 (session 4). Prior sessions established the findings; this session ran them through validation.

## DC-series (validated this session)
| ID | S2 evidence | S3 external | S4 counter-proof | S6 class | S7 conf | S9 decision |
|---|---|---|---|---|---|---|
| DC-1 | ✅ schema (decimal_places=3 vs numeric(14,2)) | ✅ R-01,R-02 | ⚠ minor-units alt exists | REQUIRED | 100% | REGISTER (Batch 0) |
| DC-2 | ✅ RPCs lack key | ✅ Stripe pattern | ⚠ unique keys cover some | REQUIRED | 90% | REGISTER |
| DC-3 | ✅ CK≠concurrency | ✅ PG locking/SERIALIZABLE | ✅ solution optionised | REQUIRED | 95% | REGISTER |
| DC-4 | ✅ raw PII + immutable events | ✅ R-03 | ⚠ legal-basis retention | REQUIRED | 90% | REGISTER |
| DC-5 | ✅ Storage separate surface | ✅ Supabase Storage RLS | ⚠ app-only insufficient | REQUIRED | 90% | REGISTER |
| DC-6 | ✅ no read log | ✅ R-03 (GDPR≠read-log) | ✗ not mandated | OPTIONAL | 70% | → PENDING |
| DC-7 | ✅ no deadline col | ✅ IATA fare-hold | ✅ structured+reminder | REQUIRED | 90% | REGISTER |
| DC-8 | ✅ no reconcilers | — | ✗ symptom of integrity, not domain | OPTIONAL | 70% | → PENDING |
| DC-9 | ✅ no tz anchor | ✅ timestamptz semantics | ⚠ tenant-default may suffice | REQUIRED(low) | 80% | REGISTER (low) |
| DC-10 | ✅ provisioning greenfield | — | ✗ journals already cover | OPTIONAL | 75% | → PENDING |
| DC-11 | ✅ alloc rate unposted | ✅ R-02 double-entry | ⚠ cash-basis absorbs | REQUIRED* | 85% | REGISTER |
| DC-12 | ✅ no passenger graph | ✅ KSA mahram rule | ✅ simplified to self-FK | REQUIRED | 85% | REGISTER (simplified) |
| DC-13 | ✅ ADR-0002 v4 | ✅ R-05 | ✗ benefit only at M+ rows; PG17 | DEFERRED | 60% | → PENDING (out of Batch 0) |
| DC-14 | ✅ no export/purge | ✅ GDPR portability/SaaS | ⚠ manual export possible | REQUIRED | 80% | REGISTER |
| DC-15 | ✅ service_role RLS-bypass | ✅ least-privilege | ⚠ backend inherently trusted | REQUIRED | 85% | REGISTER |
| DC-16 | ✅ manual verify only | ✅ pgTAP standard | ✅ (reclassified process) | REQUIRED(proc) | 95% | REGISTER |
| DC-17 | ✅ no realtime scope | ✅ Supabase Realtime | ✗ polling works; feature choice | OPTIONAL | 75% | → PENDING(existing) |
| DC-18 | ✅ no pgvector | ✅ RAG standard | ✗ AI optional | OPTIONAL | — | REGISTER(Optional) |
| DC-19 | ✅ single book | ✅ SAP multi-book | ✗ single book fine for SME | OPTIONAL | — | REGISTER(Optional) |
| DC-20 | ✅ no custom fields | ✅ Salesforce/HubSpot | ✗ vertical product may not need | OPTIONAL | 70% | → PENDING |
| DC-21 | ✅ Gregorian only | ✅ Hijri/Hajj season | ✅ presentation-layer, ~0 schema | REQUIRED(UX) | 85% | REGISTER (presentation) |
| DC-22 | ✅ single region | ✅ R-04 (but applicability?) | ✗ Egyptian tenants→Egypt PDPL | NEEDS-EVIDENCE | 75% | → PENDING (keep region hook) |
| DC-23 | ✅ no API contract | ✅ API-versioning norms | ⚠ no consumer yet | REQUIRED(design) | 80% | REGISTER |
| DC-24 | ✅ global roles | ✅ enterprise RBAC | ✗ ADR-0015 simple; vertical | OPTIONAL | 70% | → PENDING |
| DC-25 | ✅ no retention policy | ✅ R-03 minimization | ✗ keep-all valid | OPTIONAL | 75% | → PENDING |
| DC-27 | ✅ implicit stance | ✅ ES/CQRS refs | ✅ record ADR (cheap) | REQUIRED(ADR) | 95% | REGISTER |
| DC-28 | ✅ forward-only, no import | ✅ ETL/ADR-0019 merge | ⚠ overlaps DC-10 | REQUIRED | 80% | REGISTER |
| DC-29 | ✅ online-only | — | ✗ client concern, optional | OPTIONAL | — | REGISTER(Optional) |

## Inherited findings (R/A/B/BF/CDD/N/INV/RC/OPS)
S1–S2 satisfied by their source reports; S3 done where external (audit cites Supabase/Google/IATA/TOMS); S4 performed in `architecture-synthesis` (C1/C2 corrections) and `business-stress-test` (disproof-first). **Decision: VALIDATED** (see `VALIDATED_ARCHITECTURE_DECISIONS.md` §B). Confidence 85–100%. No item overturned this session.

## Session-4 outcome summary
- **Promoted to VALIDATED-REQUIRED:** DC-1,2,3,4,5,7,9,11,12,14,15,16,21(UX),23,27,28.
- **Demoted to PENDING:** DC-6,8,10,13,20,22,24,25 (with triggers).
- **Confirmed OPTIONAL (already):** DC-17,18,19,26,29.
- **Rejected sub-solutions:** RJ-1…RJ-8 (`REJECTED_ARCHITECTURE_DECISIONS.md`).
- **Net:** Batch-0 required-now structural set reduced to **R1–R8 + DC-1**. Fewer, stronger findings — the phase's goal.
