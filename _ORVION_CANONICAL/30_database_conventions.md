# Database Conventions

Version: 0.1
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

Decision: Status foreign keys will use a composite reference pattern to `catalog_values` by (`catalog_type_code`, `code`) where applicable. This allows a stable mapping without introducing tight per-catalog table definitions. Example (logical):

```sql
-- catalog_values: (catalog_type_code, code)
-- booking: booking_status_code references catalog_values(catalog_type_code, code)
```

The canonical strategy is composite `(catalog_type_code, code)` referencing the seeded catalog values for stable status enforcement.

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
amount numeric(14, 2)
```

Currency code should be stored separately.

Recommended:

```sql
currency_code text not null
```

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

