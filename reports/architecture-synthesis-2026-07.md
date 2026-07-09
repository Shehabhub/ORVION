# ORVION Architecture Synthesis — One Coherent Truth (2026-07-09)

Status: **Synthesis of all prior reviews.** Analysis only; nothing implemented; no schema/canon/completed phase modified. Purpose: merge the Engineering Audit, Business Stress Test, Architecture Validations, Launch Readiness, Design Evolution Plan, Complete Platform Design Baseline, and Complete Platform Physical Design into one non-contradictory architectural model, resolving every overlap, dependency, and drift that only appears when the reports are merged.

Question answered: not "what is missing?" but **"what becomes inconsistent when all reports become one platform?"**

---

## 1. Report reconciliation — what supersedes what

| Prior framing | Status after synthesis |
|---|---|
| Design Evolution Plan's **A/B** and Baseline's **Complete-vs-Optional** labels | **OBSOLETE.** Replaced by the Physical-Design register's **Included / Excluded** (evidence, not assumed need). "Additive-later" is now a *property*, never a reason to defer *design*. |
| Audit: "no supplier-bill table; derived payable is acceptable (MVP)" | **SUPERSEDED** for the complete platform by the **AP subledger + `supplier_bills`**. `app.supplier_balance` (built) becomes the *interim/derived view*; the AP subledger becomes authoritative (see §3). |
| Backlog: "Customer Communications shape UNDECIDED" | **RESOLVED** — omnichannel, channel-typed conversations + templates + consent (Engagement domain). Close that backlog item. |
| Baseline/Physical: "tenant-group extends RLS in one place, no policy change" | **CORRECTED** (over-claim) — see §5. Franchise/group is a **consolidation/reporting** concern, not a change to per-tenant isolation. |
| Launch Readiness L-items, Audit A/B-items, Stress-test BF-items | **RETAINED** and folded into the single model below; each maps to a designed domain. |

**Rule going forward:** the Physical-Design register (`complete-platform-physical-design-2026-07.md`) is the domain source of truth; this synthesis is the consistency layer over it.

---

## 2. Duplicated concepts — merged to one canonical model

1. **Contact methods.** `customer_contact_methods` (built) **⨉** `party_contact_identities` (design). → **Canonical = `party_contact_identities`** (channel-typed, consent-bearing, inbound-routing key). `customer_contact_methods` is superseded (back-link + migrate; do not maintain two).
2. **Credit limit/terms.** BF-3 proposed `customers.credit_limit`; Party design puts terms on `party_roles`. → **Canonical = `party_roles` (ar_/ap_ credit_limit + payment_term).** Do **not** add a duplicate column to `customers`/`suppliers`.
3. **Document numbering.** Built `create_invoice`/`issue_receipt` hardcode `INV-`/`RCP-`; design adds `document_sequences`. → **Canonical = `document_sequences` + `app.next_document_number()`.** The built numbering becomes a **sequence config** (format preserved) — a refactor, not a re-spec.
4. **Payable.** Derived `supplier_balance` **⨉** `supplier_bills` (AP). → **One model:** AP subledger authoritative; `supplier_balance` re-defined to read AP (bills − payments) once bills exist (§3).
5. **Line-level amounts.** Three parallel header/line pairs — `bookings`↔`booking_items`, `invoices`↔(new)`invoice_lines`, `quotations`↔`quotation_items`, plus `price_components`. → **One rule:** header `total_amount` is always the **enforced roll-up of its lines**, and `price_components` decompose a *line* (never the header). No third amount source.
6. **Branch/department on postings.** `booking_items` owner branch/dept (built) **⨉** accounting `dimensions` branch/dept. → **Do not duplicate:** posting rules **derive** journal dimensions from the source record's owner fields + a cost-center mapping. Dimensions are a *projection*, not re-entered data.
7. **Product classification.** `booking_items.service_type_code` (built) **⨉** `products.product_type`. → **Two distinct axes, both kept:** `product_type` = {service|package|fixed_departure|ancillary}; `service_type` = {flight|hotel|visa|…}. A product of type `service` carries a `service_type`. Documented so they are never conflated.
8. **Refund ⨉ credit note.** Built `refunds` (cash out) **⨉** design `credit_notes` (receivable-reducing document). → **Distinct, related:** a credit note reduces the receivable (accounting doc); a refund is the cash disbursement it may trigger. Defined so `customer_balance` never double-counts (§3).

---

## 3. Hidden dependency — the derived finance primitives must evolve (define the invariant NOW)

`app.customer_balance` / `app.supplier_balance` / `app.booking_item_profit` (built, ADR-0021) currently read *header* amounts and derive balances. When **invoice_lines, tax, credit/debit notes, and AP bills** land, their definitions **must** evolve or they silently go wrong. **This is the single most important synthesis dependency.** Resolve now by fixing these invariants:

- **INV-1:** `invoices.total_amount = Σ invoice_lines.line_total (incl. tax)` — enforced; `customer_balance` keeps reading `total_amount` and stays correct.
- **INV-2:** `customer_balance.invoiced` extends to **`invoices − credit_notes`** and `refunded` stays completed customer refunds; credit notes must be included the moment they exist, or receivables overstate.
- **INV-3:** `supplier_balance` re-defines from "locked booking cost − supplier payments" (interim) to **"approved `supplier_bills` − supplier payments"** once AP bills exist; a bill must reconcile to its booking-item cost (link `supplier_bill_lines.booking_item_id`).
- **INV-4:** `booking_item_profit` = `Σ selling price_components − Σ cost` (once price_components exist), not the single `selling_amount`; the header roll-up keeps the current RPC valid interim.
- **ADR-0021 amendment:** record that these primitives are **contract-stable but source-evolving** — consumers keep calling them; their internal derivation upgrades as the finance model deepens. This prevents a future rewrite of every consumer.

---

## 4. Built-table additive retrofits — sequence these EARLY (the only near-term schema touches)

Merging all reports shows a small set of **additive columns on already-built tables**. They are cheap now and increasingly expensive as rows accumulate — the genuine "retrofit risk." Land them at the safest early point (they do not change existing behavior):

| Built table | Additive columns | Source finding |
|---|---|---|
| `events` | `schema_version int`, `correlation_id uuid`, `causation_id uuid` + immutability trigger | CDD-8 / B4 / RI contract |
| `journal_entry_lines` | `branch_id`, `department_id`, `cost_center_id`, `booking_id` (nullable → N/A member) | CDD-5 / dimensions |
| `invoices` | `invoice_lines` child + `total_amount` = roll-up invariant | CDD-3/4 |
| `booking_items` | `product_id`, `product_component_id`, `package_departure_id` + `booking_item_references` child (PNR/ticket) | CDD-2 / BF-1 |
| `attribution_clicks` | `gbraid`, `wbraid`, `consent_ad_user_data`, `consent_ad_personalization`; `leads.attribution_click_id` | A3 |
| `customers` / `suppliers` | `party_id` | CDD-1 |

Everything else in the platform is **new tables** (genuinely additive, no built-table touch). This table is the definitive "foundational hooks" list — nothing beyond it retrofits a built structure.

---

## 5. Corrections to my own earlier conclusions (challenged)

- **C1 — Tenant-group RLS over-claim.** Earlier: "group scope changes nothing per-table." **Correction:** the isolation policy `tenant_id = app.current_tenant_id()` returns **one** tenant; genuine cross-tenant *visibility* would need `IN (group tenants)`, which **is** a predicate change. **Resolved model:** per-tenant **isolation stays unchanged** (single tenant); **franchise/group consolidation is a separate read path** (a `SECURITY DEFINER` group-reporting function or `service_role` analytics), *not* a change to the isolation policies. Inter-company transactions post explicitly to each entity's ledger. This keeps ADR-0013 intact and removes the over-claim.
- **C2 — "Outbox is a projection over every event."** **Correction:** not every event needs delivery. **Resolved:** `event_outbox` rows are **enqueued selectively** (only events with an external destination), keyed by `dedup_key`; the `events` table remains the full audit record. Avoids unbounded outbox growth (matches outbox best practice: archive delivered rows).
- **C3 — Communications "undecided."** Now **decided** (Engagement domain); the backlog entry is closed, not open.
- **Strengthened:** ADR-0013's **single RLS primitive** looks even better after synthesis — it localizes the (few) tenant-resolution evolutions and made C1's correction clean. Keep and reaffirm.
- **Strengthened:** ADR-0021's **derived-not-stored** primitives look better, *provided* the §3 invariants are recorded — they let the finance model deepen without a consumer rewrite.

---

## 6. New inconsistencies that appear only at platform scale (emergent findings)

- **N1 — Orphan event codes.** `event_type_code` is free text (ADR-0006). Across ~30 domains the event surface is large; free text invites typos/orphans that break the RI/outbox contract. **Recommendation:** a **seeded `event_type` registry** (reference table or catalog) that `record_event` validates against — turns the RI contract from convention into enforcement. *(New; strengthens CDD-8.)*
- **N2 — Permission × Feature composition.** With `role_permissions` (ADR-0015) **and** `feature_entitlements`/`feature_flags`, a capability now needs **both**. **Rule:** guarded RPCs assert `app.authorize(perm)` **AND** `app.has_feature(feature)` where plan-gated. State this composition once so it isn't re-invented per RPC.
- **N3 — Permission catalog coherence.** The complete platform adds ~40 permissions; they must be seeded **grouped by domain** with the Earn-It "strict-Yes only" discipline retained (ADR-0015) — otherwise `role_permissions` seeding drifts. Design the permission catalog as one coherent set even though minting stays per-consumer.
- **N4 — Numbering ⨉ gapless ⨉ periods.** `document_sequences` (fiscal reset) must align with `accounting_periods` and the researched legal rule (unique+sequential, **not** necessarily gapless). One config governs both; don't let invoice numbering and fiscal periods diverge.
- **N5 — Consent is cross-domain.** Consent appears in Party (contact identities), Engagement (messaging), and Attribution (ad consent). **One `consent_records` model** owned by Party, referenced by Engagement and Attribution — not three consent stores.

---

## 7. Naming / ownership / boundary consistency (drift control)

- **Naming (folds Audit B6):** enforce one standard on **all new** tables and normalize the built exceptions — `<entity>_status_code` (not bare `status`; not unprefixed `status_code`), `_code` for catalog refs, `_id`/`_by`/`_at` conventions, `is_`/`has_` booleans. Apply to `tenants.status`, `company_assets.status`, and the unprefixed `status_code` columns as a naming-normalization CR *before code references them* (Audit B6 trigger).
- **Ownership map (single truth):** Party owns parties/identities/consent/credit-terms · Product owns catalog/inventory/rates/contracts · Finance owns GL/subledgers/dimensions/tax/treasury/numbering · Engagement owns conversations/templates/notifications · Integration owns providers/outbox/webhook-inbox/connectors · Platform owns tenant-group/subscription/feature-flags/entitlements · each operational domain (HR, Payroll, Procurement, Fleet, Assets, Loyalty, Insurance-claims, Workflow-engine, RI, AI, Reporting) owns only its own new aggregates.
- **Boundary rule:** a domain may **reference** another's aggregate by FK but never **write** it except through that domain's RPC (preserves the booking-orchestration-boundary principle platform-wide).

---

## 8. Orphan / missing checks (cleared)

- **Orphan tables:** none in the built schema; the register's new tables all have owners (§7).
- **Orphan permissions/events:** none built; the platform set is seeded per-consumer (N3) and validated (N1).
- **Missing relationships now added:** `leads→attribution_clicks`, `booking_items→products/references`, `journal_entry_lines→dimensions`, `supplier_bill_lines→booking_items`, `party_id` links — all in §4.
- **Missing indexes:** the Audit A2 list (18 `tenant_id`-only child tables) + the register's per-domain IX + the outbox partial index — consolidated into one indexing pass at the backend/API (pre-production) phase (Audit A1/A2).
- **Missing dimensions:** resolved by the single dimension model (§2.6), required-with-N/A.

---

## 9. Consolidated ADR set (deduped from the Baseline's 10)

Unchanged in intent; synthesis adds precision. Record when scope is approved:
1. Party/Account model · 2. Product/Packaging/Inventory/Supplier-contracts · 3. Pricing & Tax (price-components + tax_codes + margin scheme) · 4. **Accounting foundation** (dimensions-as-projection, subledger auto-posting, periods, AP bills, treasury, revaluation, `document_sequences`) — *incorporates the §3 invariants and amends ADR-0021* · 5. Tenant-hierarchy/Franchise — *as a consolidation read path, not an isolation change (C1)* · 6. Integration Layer + **selective** Transactional Outbox (C2) + webhook inbox · 7. Event contract + **`event_type` registry (N1)** + RI posture · 8. Engagement (omnichannel + one consent model N5) · 9. Subscription two-plane + feature flags + **permission×feature composition (N2)** · 10. Localization.

---

## 10. The one coherent truth (summary)

- **28 Included domains, 2 Excluded (Warehouse/MRP, Retail POS), 3 operational-not-schema** — unchanged and non-contradictory after merge.
- **Six built-table additive retrofits (§4)** are the *entire* near-term schema-touch surface; everything else is new tables.
- **The derived finance primitives evolve by contract (§3), not by rewrite** — the pivotal dependency, now pinned by invariants.
- **Two of my earlier claims corrected** (tenant-group RLS scope C1; outbox universality C2); **two foundations reaffirmed stronger** (single RLS primitive; derived primitives).
- **Five emergent platform-scale rules added** (event registry, permission×feature, permission-catalog coherence, numbering×periods, single consent model).
- **No completed phase requires rework.** The model is internally consistent and implementable phase-by-phase from here.

**This synthesis is the architectural baseline of record.** On your scope decision, I will: record the consolidated ADRs, apply the §2 merges + §7 naming rules + §3 invariants + §4 early hooks into the canonical docs (`24`–`31`, `35`) and roadmap (`32`), then resume phased execution — with no contradiction left to discover.

*End of synthesis. No implementation performed.*
