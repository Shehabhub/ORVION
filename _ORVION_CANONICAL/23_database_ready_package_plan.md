# Database-Ready Package Plan

Version: 0.1
Status: Draft
Canonical: Yes

---

# Purpose

This document defines the execution plan for converting ORVION's canonical business decisions into a database-ready specification package.

The package must be practical, limited, and suitable for a first working SaaS version.

---

# Package Objective

Create enough specification to design the first database schema without guessing.

This package does not produce SQL yet.

It produces the final documents needed before SQL.

---

# Execution Order

## Step 1: Entity Registry

Output:

- `24_entity_registry.md`

Purpose:

Define every first-version entity and its responsibility.

Rule:

No columns yet except identity-level notes.

---

## Step 2: Catalog Registry

Output:

- `25_catalog_registry.md`

Purpose:

Define controlled values that must not be entered freely by employees.

Rule:

Every dropdown-like value must come from a controlled catalog.

---

## Step 3: State Machines

Output:

- `26_state_machines.md`

Purpose:

Define allowed status transitions before database constraints and workflow logic.

Rule:

No free status movement.

---

## Step 4: Event Catalog

Output:

- `27_event_catalog.md`

Purpose:

Define meaningful immutable events.

Rule:

Events record business milestones, not every UI click.

---

## Step 5: Permissions Matrix

Output:

- `28_permissions_matrix.md`

Purpose:

Define what each role can do and at what scope.

Rule:

Permissions must consider tenant, branch, department, assignment, and subscription plan.

---

## Step 6: Relationship Map

Output:

- `29_relationship_map.md`

Purpose:

Define how entities relate before designing physical tables.

Rule:

Relationships must be clear enough to create foreign keys later.

---

## Step 7: Database Conventions

Output:

- `30_database_conventions.md`

Purpose:

Define technical database standards.

Rule:

Conventions must be simple and enforceable.

---

## Step 8: Schema Draft

Output:

- `31_schema_draft.md`

Purpose:

Create the first logical schema draft.

Rule:

No SQL migration until the schema draft is reviewed.

---

# Review Points

The project owner reviews after:

1. Entity Registry
2. Catalog Registry
3. State Machines
4. Schema Draft

Other documents may be reviewed briefly unless a major decision appears.

---

# Scope Limits

The first package must not include:

- Full ERP expansion
- Advanced tax engine
- GDS implementation
- Full BI/data warehouse
- Full workflow engine implementation
- Marketplace/plugin architecture
- Complex HR/payroll

---

# Completion Criteria

This package is complete when:

- All first-version entities are named.
- All first-version catalogs are listed.
- Core statuses have allowed transitions.
- Core events are defined.
- Core permissions are mapped.
- Core relationships are clear.
- Database conventions are fixed.
- Schema draft can be written without guessing.

