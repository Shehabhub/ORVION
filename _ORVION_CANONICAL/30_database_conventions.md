# Database Conventions

Version: 0.2
Status: Draft
Canonical: Yes

---

# Purpose

This document defines database conventions for ORVION before writing the first schema draft.

The goal is a practical PostgreSQL/Supabase design that supports tenant isolation, events, permissions, and daily travel agency operations.

---

# Database Principles

- Prefer PostgreSQL-native features.
- Use simple normalized tables.
- Avoid unnecessary abstraction.
- Every tenant-owned business table must include `tenant_id`.
- Important records are archived, not physically deleted.
- Every meaningful business action creates an event.
- RLS must enforce tenant isolation.
- Database design must support practical implementation, not theoretical completeness.

---

# Naming Rules

## Tables

Use plural snake_case.

Examples:

- tenants
- branches
- leads
- booking_items
- journal_entries

## Columns

Use snake_case.

Examples:

- tenant_id
- created_at
- assigned_user_id
- booking_status

## Primary Keys

Use `id` as UUID primary key.

## Foreign Keys

Use `{entity}_id`.

Examples:

- tenant_id
- branch_id
- customer_id
- booking_id

## Catalog Codes

Use `{catalog}_code` for stable machine code values.

Examples:

- lead_status_code
- document_type_code
- subscription_plan_code

---

# Primary Key Standard

Every main table uses:

```sql
id uuid primary key default gen_random_uuid()
```

UUID strategy: UUIDs must be generated server-side using `gen_random_uuid()` (pgcrypto). Ensure the database enables the `pgcrypto` extension in migrations before creating tables.

---

# Identity Key Standard

A `users` row is a person's membership in one tenant, not a global human identity. The shared human identity is `auth.users` (one login per person); a human may hold at most one membership per tenant, so `auth_user_id` is unique per tenant — `unique (tenant_id, auth_user_id)` — not globally, and the same human may hold memberships in several tenants, each a separate `users` row referencing the shared `auth.users` identity. `auth_user_id` is nullable and is set (uniquely within its tenant) on activation (see `31_schema_draft.md`, `# 13. Review Required` item 3). The physical key strategy implementing that relationship is fixed here, once, because it is read by multiple independently-authored artifacts — the `users` table migration, the RLS identity-lookup function, and any future application code resolving `auth.uid()` to a business user — that must all agree on the same pattern.

Decision: `users` uses its own independently-generated `id` (per the Primary Key Standard above), plus a separate column:

```sql
auth_user_id uuid references auth.users(id)
```

Do not set `users.id = auth.users.id` as a shared primary key. `auth_user_id` is the sole link between an ORVION membership and the Supabase Auth identity backing it. Authentication-layer facts (credentials, trusted devices, MFA enrolment, global suspension) belong to the human identity (`auth.users`); business-layer facts (profile, roles, activity, per-company status, audit) belong to the membership (`users`).

Rationale: a separate column keeps `users.id` stable and provider-independent, since every other table's foreign key already points at `users.id`. It also allows a `users` row to exist before its corresponding `auth.users` row does (for example, an invited-but-not-yet-activated employee), and leaves room for a future second identity provider (for example, enterprise SSO) without a breaking migration to the primary key every other table already references.

The RLS identity lookup function SHALL resolve `auth.uid()` together with the active tenant context to the corresponding membership (`auth_user_id = auth.uid()` and `tenant_id` = the active tenant), not through a shared primary key. The function's exact implementation — its full body, return shape, and any additional identity or role context it resolves in the same call — belongs to RLS/migration planning (migration 19), not to this convention.

---

# Tenant Scope Standard

Every tenant-owned business table must include:

```sql
tenant_id uuid not null references tenants(id)
```

Examples:

- branches
- departments
- users/profile extension
- leads
- customers
- bookings
- booking_items
- suppliers
- documents
- payments
- events

Global system tables may not include tenant_id.

Examples:

- system catalog definitions
- global subscription plan definitions

---

# Timestamp Standard

Every main table should include:

```sql
created_at timestamptz not null default now()
updated_at timestamptz not null default now()
```

Business lifecycle tables may include additional timestamps.

Examples:

- assigned_at
- approved_at
- archived_at
- expires_at
- sent_at

Maintaining `updated_at`:

`updated_at` is maintained by the database, not by application code, so that every update — including direct SQL and service-role writes that bypass the application — advances it. The convention is the guarantee: every table that has an `updated_at` column has a `before update` trigger that sets it to the current time. The recommended implementation is the `moddatetime` extension (a standard PostgreSQL contrib module supported by Supabase); an equivalent hand-written `plpgsql` trigger function that produces the same result is acceptable. Example using the recommended `moddatetime`:

```sql
-- enabled once, in a migration, before the first trigger that uses it:
create extension if not exists moddatetime;

-- per table that has an updated_at column:
create trigger <table>_set_updated_at
    before update on <table>
    for each row execute function moddatetime(updated_at);
```

Whichever mechanism is used, it is enabled or created in a migration before the first trigger that depends on it. `created_at` remains a plain `default now()` and is never modified after insert. Application code does not set `updated_at` directly.

---

# Actor Standard

Where useful, operational tables should include:

```sql
created_by uuid references users(id)
updated_by uuid references users(id)
```

For immutable event tables, actor is stored as:

```sql
actor_user_id uuid null references users(id)
```

System-generated events may have no actor.

---

# Archive Standard

Important business records are not physically deleted.

Use:

```sql
is_archived boolean not null default false
archived_at timestamptz null
archived_by uuid null references users(id)
archive_reason text null
```

Applies to:

- leads
- customers
- bookings
- booking_items
- suppliers
- documents
- financial records where legal/business policy allows archive marking

Do not archive immutable events.

---

# Status Standard

Status fields should store stable code values.

Example:

```sql
lead_status_code text not null
```

Status values must match the catalog registry and state machines.

Decision — physical enforcement of status/type codes:

Status and type code columns (for example `lead_status_code`, `booking_status_code`, `department_type_code`) are stored as plain `text` and are not required to carry a database foreign key. A single code column cannot reference `catalog_values`' composite key `(catalog_type_code, code)`, and these codes are written by application code at fixed call sites and governed by the state machines in `26_state_machines.md` — not typed freely by users into a form.

Each such column belongs to exactly one catalog family registered in `25_catalog_registry.md` (for example `lead_status`, `booking_status`, `invoice_status`), identified by its `catalog_type_code`. That registry — not this document — is the authoritative list of families; the `(catalog_type_code, code)` scoping already guarantees that codes in different families never collide.

Code validity is guaranteed by (1) the seeded catalog values in `catalog_values`, and (2) application logic and state-machine enforcement — consistent with `26_state_machines.md`: "validated by application logic and, where practical, database constraints." This is safe without a foreign key because catalog codes are stable: per the Catalog Standard they are never renamed and never physically deleted once used — a deprecated value is marked inactive (`is_active = false`) — so a status value stored in event, report, or audit data stays valid permanently.

Enforcement is domain-dependent: no single mechanism is mandated for every status field. The default is application plus state-machine validation. Optional hard database enforcement may be added for a specific column where it genuinely warrants it (for example a tenant-extendable dropdown that must reject invalid values at the database), chosen and justified per column in that column's own migration, using either:

- a `before insert/update` validation trigger checking the `(catalog_type_code, code)` pair against `catalog_values`; or
- a stored constant `catalog_type_code` column on the referencing table plus a composite foreign key to `catalog_values(catalog_type_code, code)`.

The composite UNIQUE `(catalog_type_code, code)` on `catalog_values` remains required — it supports the optional composite-foreign-key technique above and general catalog integrity. What is corrected here is the earlier statement that a single status column carries that composite foreign key as "the canonical strategy": it cannot; the composite foreign key is an optional per-column technique, not the mandated pattern for every status field.

---

# Catalog Standard

System catalogs should support:

- code
- label
- description
- is_active
- sort_order
- ownership type where applicable

Tenant catalogs should include:

- tenant_id
- code
- label
- is_active
- created_by

Catalog codes should not be renamed after use.

Deactivate instead.

Reference Data cross-reference:
- See `_ORVION_CANONICAL/25_catalog_registry.md` for authoritative guidance on Reference Data (countries, cities, currencies, languages, nationalities, airports). That document recommends using dedicated reference tables for stable public datasets rather than storing them in generic `catalog_values`, unless there is a clear tenant-specific customization requirement.
 
Catalog values uniqueness requirement:
- `catalog_values` MUST enforce a unique constraint on the composite `(catalog_type_code, code)` to support the composite FK pattern described in the Status Standard. This is a documentation requirement to guide schema design (no SQL is applied here).

---

# Event Table Standard

Events should support:

- tenant_id
- event_type_code
- severity_code
- actor_user_id
- entity_type
- entity_id
- previous_state
- new_state
- reason
- payload
- created_at

Events are immutable.

Application code should not update event rows except rare system repair by platform administrator.

Events are the main way to reconstruct lead and booking timelines.

Event payload guidance (decision):
- Limit `payload` size to a practical maximum (recommendation: 8 KiB / 8192 bytes) to keep event rows compact and performant. Larger structured snapshots should be stored in dedicated audit or snapshot tables.
- Do not rely on JSON/`payload` fields for critical query predicates, joins, or RLS enforcement. Any field required for querying, filtering, or access control must be stored in a dedicated column on the event or related table.

Rationale: keeping the payload small prevents performance and index bloat and avoids mixing denormalized queryable data with opaque audit blobs.

---

# Financial Record Standard

Financial records must be auditable.

Avoid physical delete.

Corrections should use:

- adjustment
- reversal
- new journal entry
- event

Do not overwrite approved financial actions silently.

---

# Money Standard

Amounts should be stored as numeric, not floating point.

Recommended:

```sql
amount numeric(19, 4)
```

Currency code should be stored separately.

Recommended:

```sql
currency_code text not null
```

`currency_code` values must reference `currencies.code` (see `31_schema_draft.md`, Reference Tables). The `numeric(19, 4)` standard (widened from `numeric(14, 2)` by SPEC-118 / DC-1) carries scale 4 so it stores the minor unit of 3-decimal currencies (KWD/BHD/OMR/JOD, `currencies.decimal_places = 3`) without truncation, with headroom to ISO 4217's maximum minor unit of 4; precision 19 preserves at least 15 integer digits. `currencies.decimal_places` still governs display/rounding per currency.

Exchange rates should be numeric with sufficient precision.

Recommended:

```sql
exchange_rate numeric(18, 8)
```

---

# Multi-Currency Standard

Booking item stores its own currency.

Payment stores its own currency.

Exchange rate records store rate snapshot and authority.

After issuance/execution, exchange rate changes require Exchange Rate Adjustment.

---

# RLS Standard

RLS must enforce:

- Tenant scope
- Branch scope
- Department scope
- Assignment scope where applicable
- Role/permission constraints in application and/or database helper functions

Minimum rule:

RLS must enforce the canonical isolation hierarchy: Tenant → Branch → Department. Assignment and permission rules are built on top of that baseline.

System or platform-level access must be granted through explicit approved roles or policies, not by weakening the base isolation hierarchy.

---

# Boolean Naming Standard

Boolean columns must use the `is_` or `has_` prefix to indicate true/false semantics (for example, `is_active`, `is_archived`, `has_expired`). Avoid ambiguous boolean names like `enabled` without context. Prefer descriptive names that read naturally in boolean checks.

---

# Index Standard

Create indexes only where needed for:

- Foreign keys
- Tenant filtering
- Status filtering
- Assignment queues
- Timeline queries
- Duplicate detection
- Attribution matching

Avoid indexing every column.

Expected useful indexes:

- tenant_id
- tenant_id + status
- tenant_id + assigned_user_id
- tenant_id + customer_id
- tenant_id + booking_id
- event entity lookup
- customer primary phone
- GCLID/click id where applicable

---

# Unique Constraint Standard

Use unique constraints for true business uniqueness.

Examples:

- tenant slug
- branch slug inside tenant
- primary customer phone inside tenant where not exceptional
- role code
- permission key
- catalog code

Avoid unique constraints where business exceptions are common unless exception model exists.

---

# Polymorphic Link Rule

Polymorphic links may be used for:

- events
- document_links
- offline conversion outcome targets

But critical relationships should use direct foreign keys where possible.

Rule:

Use polymorphic links for timelines and flexible attachments.

Use explicit foreign keys for core workflow dependencies.

---

# Referential Action Standard

Every foreign key declares its `on delete` and `on update` behaviour explicitly. The default, used unless a migration documents otherwise for a specific foreign key, is:

```sql
references <parent> (<column>) on delete restrict on update no action
```

Rationale:

- `on delete restrict` matches this repository's archive-not-delete philosophy (see Archive Standard and Deletion Rule): important parent records are archived, never physically deleted, so a referenced parent must not be removable while children still reference it.
- `on update no action` is safe because every primary key in this schema is immutable: surrogate keys are UUIDs (Primary Key Standard) and natural keys are stable codes that are never renamed (Catalog Standard; `currencies.code`). A parent key value never changes, so cascading updates never occur.

Permitted deviations, each stated explicitly on the specific foreign key in its own migration (never applied silently or as a blanket default):

- `on delete cascade` — only for a dependent child/detail row that has no independent existence and is physically deleted together with its parent (for example a pure junction or line-item table whose rows are meaningless without the parent).
- `on delete set null` — only for a nullable, optional reference where clearing the link is the correct behaviour when the referenced row is removed; never on a `not null` foreign key.

A migration that uses `cascade` or `set null` for a foreign key states, in that migration, why the default `restrict` does not apply.

---

# Deletion Rule

Physical delete is allowed only for:

- Failed drafts with no business history
- Temporary technical records after expiry
- OTP challenges after retention period if security policy allows
- Cache-like records

Physical delete is not allowed for:

- leads
- customers
- bookings
- booking_items
- finance approvals
- payments
- invoices
- receipts
- refunds
- documents
- events

---

# Migration Rule

Every database change must be made through migration files.

Migration naming:

```text
YYYYMMDDHHMM_description.sql
```

Example:

```text
202606271700_create_core_identity_tables.sql
```

---

# Seed Data Rule

System catalogs should be seeded.

Tenant-specific data should not be hardcoded except default setup templates.

---

# Next Step

Create `31_schema_draft.md`.
