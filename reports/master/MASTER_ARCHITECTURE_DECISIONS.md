# ORVION MASTER ARCHITECTURE DECISIONS (ARB overlay)

Status: **Permanent cumulative decision ledger.** Never recreate; evolve. This is the ARB's decision-tracking overlay; the **authoritative ADR log remains `architecture-decision-records.md`**. This file tracks: (a) accepted ADRs and any ARB-proposed amendments, and (b) decisions the ARB proposes but the **owner has not yet ratified** (proposed ADRs must be recorded per the owner policy — design is not withheld). No canonical/ADR file is modified until the owner approves.

Last updated: 2026-07-11.

## A. Accepted ADRs (authoritative in `architecture-decision-records.md`) — ARB status
| ADR | Title | ARB verdict |
|---|---|---|
| 0001 | PostgreSQL on Supabase | Reaffirmed |
| 0002 | UUIDv4 `gen_random_uuid()` PKs | **Reaffirmed (session 4).** DC-13 UUIDv7 amendment **DEFERRED** — evidence: v4 fine <millions of rows, native uuidv7 is PG18 (Supabase=PG17). Trigger recorded. |
| 0003 | Shared-schema multi-tenancy + RLS | Reaffirmed (V1 verified dynamic-loop coverage) |
| 0004 | `users`↔`auth.users` via auth_user_id | Reaffirmed |
| 0005 | Catalog lookups over enums | Reaffirmed |
| 0006 | Status/type codes plain text | **Tighten (N1):** require event_type registry validation for contract-bearing codes |
| 0007 | FK default restrict/no-action | Reaffirmed |
| 0008 | updated_at via moddatetime trigger | Reaffirmed |
| 0009 | Direct-to-main, publish on Complete | Reaffirmed (governs additive-migration rule) |
| 0010 | Reference data natural keys | Reaffirmed |
| 0011 | users = tenant membership | Reaffirmed |
| 0012 | Auth artifacts re-home to human identity | Reaffirmed |
| 0013 | Tenant isolation principles / single RLS primitive | Reaffirmed (**strengthened** by C1 group-as-read-path) |
| 0014 | Supabase-native backend | Reaffirmed (DC-2/3/5/8/15 realizable without a service) |
| 0015 | Binary role_permissions (Earn-It) | Reaffirmed (+N2 permission×feature composition) |
| 0016 | Platform-mediated provisioning | Reaffirmed (+DC-10 opening balances, DC-14 offboarding extend lifecycle) |
| 0017 | Supabase-native authentication | Reaffirmed |
| 0018 | Scheduler-agnostic background processing | Reaffirmed (hosts DC-8 reconciliation, DC-7 ticketing sweeps) |
| 0019 | Customer-merge dynamic FK discovery | Reaffirmed (extend to party-merge under CDD-1) |
| 0020 | Finance-approval gate; capability-driven booking perms | Reaffirmed |
| 0021 | Derived customer_balance primitive | **Amend (INV-1..4):** contract-stable, source-evolving; conditional on DC-1 money fix |

## B. Proposed ADRs — awaiting owner ratification (design recorded, not withheld)
Consolidated set (from Baseline/Physical/Synthesis §9, confirmed by ARB):
1. **Party/Account model** (CDD-1) — unified parties + roles; customers/suppliers projections.
2. **Product/Packaging/Inventory + Supplier contracts** (CDD-2).
3. **Pricing & Tax** (CDD-3/4) — price-components + tax_codes + TOMS margin scheme.
4. **Accounting foundation** (CDD-5) — dimensions-as-projection, subledger auto-posting, periods, AP bills, treasury, revaluation, document_sequences; **incorporates INV-1..4 + DC-10 opening balances + DC-11 realized FX**.
5. **Tenant hierarchy / Franchise** (CDD-9) — consolidation read path, not an isolation change (C1).
6. **Integration Layer + selective Transactional Outbox** (CDD-7) — providers/connections/outbox/webhook-inbox; secrets in Vault (C2 selective).
7. **Event contract + event_type registry** (CDD-8/N1) — versioned/correlated events; RI/AI consumers.
8. **Customer Engagement** (CDD-10) — omnichannel conversations/templates + **single consent model (N5)**.
9. **Subscription two-plane + feature flags** — platform-billing vs operations-billing; `has_feature`; **permission×feature (N2)**.
10. **Localization** (CDD-11).

ARB-added proposed decisions (new this session):
11. **Money-storage standard** (DC-1) — `numeric(19,4)`; rounding driven by `currencies.decimal_places`.
12. **Write-idempotency standard** (DC-2) — idempotency-key table + optional RPC param on all mutating RPCs.
13. **Concurrency-control standard** (DC-3) — `FOR UPDATE`/advisory locks for oversell-risk RPCs; optimistic guard for concurrent edits.
14. **Data-lifecycle & privacy** (DC-4/DC-6/DC-14) — pseudonymization erasure boundary; sensitive-read log; tenant export/purge.
15. **service_role least-privilege** (DC-15) — explicit tenant assertion in every privileged RPC; constrained platform role.
16. **Test-assurance standard** (DC-16) — pgTAP regression + invariant tests as a merge gate.

## C. Decision-making rule (standing)
Every genuinely architectural decision → a new ADR appended to `architecture-decision-records.md` (owner-ratified) AND its ARB status tracked here. Amendments supersede by pointer, never delete (ADR convention). Proposed ADRs remain in §B until ratified or rejected; a rejected ADR is recorded as Rejected with reasoning, never erased.
