# ORVION Architecture Decision Records (ADR)

Version: 0.1
Status: Living document (not a Change Request; preserves the reasoning behind major architectural decisions)
Convention: append-only. Each ADR is numbered and dated. A superseded ADR is marked Superseded and points to its replacement; it is never deleted (history is the record). New ADRs are added when a genuinely architectural decision is made — routine implementation choices stay in their Change Request.

---

## ADR-0001 — Platform: PostgreSQL on Supabase
- Date: 2026-07 · Status: Accepted · Source: PROJECT_CONTEXT.md §5
- Decision: ORVION's database is PostgreSQL, operated through Supabase (Auth, Data API, Storage, local CLI stack).
- Why: managed Postgres with built-in auth/RLS/storage matches a SaaS CRM's needs without building that infrastructure; local CLI gives reproducible migrations.
- Consequences: migrations authored for the Supabase CLI; auth integrates via the `auth` schema; RLS is the tenant-isolation mechanism.

## ADR-0002 — UUID primary keys via `gen_random_uuid()`
- Date: 2026-07 · Status: Accepted · Source: 30 Primary Key Standard; SPEC-022
- Decision: every main table uses `id uuid primary key default gen_random_uuid()`; `pgcrypto` is enabled first.
- Why: globally unique, non-guessable, generatable client- or server-side; avoids sequence contention in a multi-tenant/distributed future.
- Consequences: keys are immutable (supports `on update no action`); reference tables may instead use a stable natural key (see ADR-0010).

## ADR-0003 — Shared-schema multi-tenancy via `tenant_id` + RLS
- Date: 2026-07 · Status: Accepted · Source: 30 Tenant Scope + RLS Standards
- Decision: one schema; every tenant-owned table carries `tenant_id uuid not null references tenants(id)`; isolation enforced by RLS (Tenant → Branch → Department).
- Why: shared-schema scales to many tenants with low operational overhead; RLS enforces isolation in the database, not just the app.
- Consequences: RLS policies are required on every tenant table (planned migration 19); `tenants` is the isolation root.

## ADR-0004 — `users` links to `auth.users` via a separate `auth_user_id`
- Date: 2026-07 · Status: Accepted · Source: 30 Identity Key Standard; 31 §13 item 3; SPEC-009
- Decision: `users` keeps its own `id`; a separate `auth_user_id uuid not null unique references auth.users(id)` is the sole link to Supabase Auth. `users.id` is NOT set equal to `auth.users.id`.
- Why: keeps `users.id` stable and provider-independent (every other table FKs to it); allows a business user to exist before its auth row; leaves room for a second identity provider without a breaking PK migration.
- Consequences: RLS resolves `auth.uid()` → business user through `auth_user_id`; authorization stays in ORVION RBAC, not JWT claims.

## ADR-0005 — Catalog-based lookups over native enums
- Date: 2026-07 · Status: Accepted · Source: 25_catalog_registry.md; 30 Catalog/Status Standards
- Decision: dropdown/lookup values live in `catalog_types` / `catalog_values` (composite `(catalog_type_code, code)`), not PostgreSQL `enum` types. Stable public datasets use dedicated reference tables instead (ADR-0010).
- Why: enums are hard to alter and cannot hold tenant-specific values; catalog tables support system + tenant-extendable values and are queryable.
- Consequences: `catalog_values` needs the composite UNIQUE; codes are seeded (migration 18) and governed by 25.

## ADR-0006 — Status/type codes are plain text; DB enforcement optional per-column
- Date: 2026-07 · Status: Accepted · Source: 30 Status Standard (resolved); SPEC-030
- Decision: status/type code columns are plain `text`, validated by the seeded catalog + application/state-machine logic; a foreign key is not required. Hard DB enforcement (validation trigger, or constant type column + composite FK) is optional per column.
- Why: a single code column cannot reference `catalog_values`' composite key, and these codes are written by application code / state machines, not free-typed by users. Code stability (never renamed/deleted) keeps stored values valid for audit/history.
- Consequences: replaces the earlier un-implementable "composite FK is the canonical strategy" wording; each status column maps to one family registered in 25.

## ADR-0007 — Referential actions default to `on delete restrict on update no action`
- Date: 2026-07 · Status: Accepted · Source: 30 Referential Action Standard; SPEC-027
- Decision: every FK defaults to `on delete restrict on update no action`; `cascade`/`set null` are opt-in per FK with justification.
- Why: matches archive-not-delete philosophy (parents are archived, never physically deleted); UUID/natural keys are immutable so cascade-on-update is dead machinery.
- Consequences: deleting a referenced parent is blocked by default (proven in SPEC-029).

## ADR-0008 — `updated_at` maintained by a database trigger (`moddatetime`)
- Date: 2026-07 · Status: Accepted · Source: 30 Timestamp Standard; SPEC-027/028
- Decision: every table with `updated_at` has a `before update` trigger; `moddatetime` is the recommended mechanism (hand-written `plpgsql` allowed).
- Why: guarantees `updated_at` advances for every writer including direct SQL and the Supabase `service_role`, which bypass the application.
- Consequences: the trigger mechanism is enabled before the first trigger; each table adds its trigger in its own migration.

## ADR-0009 — Git workflow: direct-to-`main`, publish on Complete
- Date: 2026-07 · Status: Accepted · Source: Governance decision; SPEC-026
- Decision: Change Requests execute as linear commits on the current branch (direct-to-`main` in practice); branch/PR topology is intentionally undefined. Completing a CR pushes to the configured upstream.
- Why: "Git is the execution history"; the CR lifecycle already provides review gates; a linear history mirrors the state machine. Publishing on Complete removes a separately-remembered manual push.
- Consequences: no branch/PR governance is defined; a failed push does not invalidate a local Complete.

## ADR-0010 — Reference data uses stable natural keys
- Date: 2026-07 · Status: Accepted · Source: 25 (Reference Data); 31 §2a; SPEC-025
- Decision: stable public reference datasets (e.g., `currencies`) are dedicated tables keyed by their natural code (`currencies.code`), not surrogate UUIDs, and are FK targets for `*_code` columns.
- Why: the natural code is the stable, externally meaningful identifier every referencing column already uses.
- Consequences: a deliberate, documented deviation from ADR-0002 for reference tables; the reference-data layer (countries/languages/nationalities) is due before migrations 8–10.
