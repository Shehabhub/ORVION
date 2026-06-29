# Phase 1 Inventory Report — Guarded Consistency Review

Version: 0.1
Status: Draft

Summary:
- This Phase 1 inventory covers 14 review areas across canonical docs (00–32, codex, manifest, SYSTEM_PROMPT).
- Each finding below is tagged `[SAFE]` or `[NEEDS DECISION]` and cites canonical files.

**Terminology Consistency**:
- Observation: Core terms (`tenant`, `branch`, `booking`, `booking_item`, `passenger`) are used consistently across `codex.md`, `manifest.md`, and `24_entity_registry.md` — [SAFE].
- Issue: Passport/document storage appears in both `05_customer_identity.md` and `16_document_types_and_rules.md` with stronger statement in `16` (passport at passenger level) — confirm canonical source of truth — [NEEDS DECISION] (see [05_customer_identity.md](_ORVION_CANONICAL/05_customer_identity.md), [16_document_types_and_rules.md](_ORVION_CANONICAL/16_document_types_and_rules.md)).

**Master Data Classification**:
- Catalogs and classification rules are centralized in `25_catalog_registry.md` and referenced by `26_state_machines.md` and `30_database_conventions.md` — stable and coherent — [SAFE].
- Minor: `Reference Data` placement guidance exists but final storage choice (dedicated reference tables vs `catalog_values`) needs confirmation for country/airport datasets — [NEEDS DECISION] (see [25_catalog_registry.md](_ORVION_CANONICAL/25_catalog_registry.md)).

**Entity Criticality**:
- Finance, events, and customer entities are explicitly marked high-criticality in `07_finance_model.md`, `14_finance_rules.md`, and `27_event_catalog.md` — controls present — [SAFE].

**Boolean Naming Policy**:
- Current conventions include `is_active`, `is_archived` in `30_database_conventions.md` (archive standard) but no explicit boolean naming rule set (e.g., `is_` prefix for all booleans). Recommend adding a short boolean naming rule to conventions — [NEEDS DECISION] (see [30_database_conventions.md](_ORVION_CANONICAL/30_database_conventions.md)).

**JSON / Event Payload Policy**:
- `27_event_catalog.md` allows structured `payload` but warns it must not become the primary model; `31_schema_draft.md` includes `payload` field in events — conceptual alignment exists — [SAFE].
- Missing: concrete payload shape, size limits, and indexing guidance (searchable fields vs opaque JSON) — add policy to `30_database_conventions.md` or `27_event_catalog.md` — [NEEDS DECISION].

**Status Policy**:
- Statuses are centrally defined in `25_catalog_registry.md` and tied to `26_state_machines.md` — good centralization — [SAFE].
- Decision required: enforcement method for status integrity (FK to `catalog_values` vs check constraints vs enum) — `30_database_conventions.md` mentions both options but does not pick one — [NEEDS DECISION].

**Delete / Archive Policy**:
- Archive-not-delete is consistently documented (`30_database_conventions.md`, `16_document_types_and_rules.md`, `24_entity_registry.md`) and applied to business entities — [SAFE].

**Financial Immutability & Locking**:
- Finance immutability rules and locked-cost workflow are consistently documented (`14_finance_rules.md`, `07_finance_model.md`, `31_schema_draft.md`) — [SAFE].
- Clarify reversal/adjustment workflow scope for exchange-rate adjustments and which journal entries must be created/voided — more detail needed in `14_finance_rules.md` and `31_schema_draft.md` — [NEEDS DECISION].

**Event Consistency & Modeling**:
- Events are well-defined (`27_event_catalog.md`) and state machines require events on transitions (`26_state_machines.md`) — event-first philosophy is consistent — [SAFE].
- Decision: event referencing model (polymorphic `entity_type/entity_id` vs typed foreign keys) — `29_relationship_map.md` mentions both approaches; pick canonical pattern for event queries and RLS — [NEEDS DECISION].

**Event Classification (Severity)**:
- Severity taxonomy (`info`, `warning`, `risk`, `security`, `critical`) exists in `27_event_catalog.md` and is applied across event definitions — [SAFE].

**State Machine Consistency**:
- Core state machines (lead, booking, booking_item, finance approval) are specified and aligned with catalogs (`26_state_machines.md`, `25_catalog_registry.md`, `13_booking_statuses_and_rules.md`) — [SAFE].
- Edge cases: `reissue`, `void`, and refund transitions require exact allowed-from/to rules in the booking item machine (clarify in `26_state_machines.md`) — [NEEDS DECISION].

**Permission Consistency & Scope**:
- Roles and permission keys are defined and mapped (`28_permissions_matrix.md`, `15_permissions_roles.md`) — scope model (tenant/branch/department/assigned) is consistent — [SAFE].
- Decision: degree to which permissions are enforced in DB (RLS policies) vs application layer is recommended but not fixed — `30_database_conventions.md` references RLS; please confirm RLS coverage targets — [NEEDS DECISION].

**Database Conventions**:
- Naming, timestamps, tenant_id, UUID PK, and archive fields are defined in `30_database_conventions.md` and reflected in `31_schema_draft.md` — consistent baseline — [SAFE].
- Need explicit decision on UUID generation strategy (db-side `gen_random_uuid()` vs app-generated), RLS implementation pattern, and migration automation conventions — [NEEDS DECISION].

**Roadmap Consistency**:
- `32_execution_roadmap.md` and `manifest.md` align with current Phase 1 goals and the package plan in `23_database_ready_package_plan.md` — [SAFE].

Next Steps (checkpoint):
- Please review these `[NEEDS DECISION]` items and approve which items to resolve in Phase 2.
- If approved, Phase 2 will apply one change at a time with before/after diffs against the backup.

Files consulted (canonical):
- _ORVION_CANONICAL/00_project_charter.md through 32_execution_roadmap.md, codex.md, manifest.md, SYSTEM_PROMPT.md

End of Report.
