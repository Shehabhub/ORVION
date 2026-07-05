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
- Decision: `users` keeps its own `id`; a separate `auth_user_id uuid references auth.users(id)` (nullable, **unique per tenant** — `unique (tenant_id, auth_user_id)`) links the membership to Supabase Auth. `users.id` is NOT set equal to `auth.users.id`. `auth_user_id` is null while invited-but-not-activated, and set on activation. See ADR-0011 for the membership model.
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

## ADR-0011 — `users` is a tenant membership; `auth.users` is the human
- Date: 2026-07 · Status: Accepted · Source: SPEC-033; Migration 5 identity review
- Decision: a `users` row is a human's **membership/employment in one tenant**, not a global human identity. The human identity is `auth.users` (one login per person). `auth_user_id` is **unique per tenant** (`unique (tenant_id, auth_user_id)`), so one human may hold at most one membership per tenant and may hold memberships in several tenants — each a separate `users` row referencing the shared `auth.users`.
- Why: multi-tenant SaaS must support one person across several organizations (employees changing agencies, consultants/contractors, franchises, parent/multi-entity operators). Fixing this on an empty table costs one constraint; retrofitting it after ~70 tables reference `users` and RLS is built is a foundational migration. The MVP single-membership experience is behaviourally identical.
- Consequences: (1) authentication-layer facts (credentials, trusted devices, MFA, global suspension) belong to `auth.users`; business-layer facts (roles, activity, per-company status, audit) belong to the membership. (2) RLS resolves `auth.uid()` **plus an active-tenant context** to the membership (migration 19) — degrades to the single membership when a human has one. (3) Disabling a user (`is_active=false`) is company-scoped; global ban is an `auth.users` action. (4) `trusted_devices`/`otp_challenges`/`totp_enrollments` are authentication-layer and should attach to the human identity, not the per-tenant membership — a migration-16 concern (Future Backlog). Supersedes the global-uniqueness portion of ADR-0004.

## ADR-0012 — Authentication & Identity Principles are canonical; auth-support tables re-home to the human identity
- Date: 2026-07 · Status: Accepted · Source: Owner directive; SPEC-046; builds on ADR-0011
- Decision: the authentication/identity/security philosophy is consolidated into one canonical document, `34_authentication_and_identity_principles.md`, whose twelve principles govern every future auth-related decision ("which principle owns this responsibility?" precedes schema). Its direct schema consequence: `trusted_devices`, `otp_challenges`, `totp_enrollments` key to `auth_user_id` referencing `auth.users(id)` (Human Identity), carry no `tenant_id` and no membership `user_id`, and cascade on human-identity deletion. `31` §9 and `33` migration 16 are amended accordingly.
- Why: the philosophy was previously distributed across ADR-0011, `20_authentication_security_model.md`, and backlog notes, forcing the "where does this table belong?" question to be re-litigated per table. A principles document lets the schema fall out as a consequence. Re-homing follows Principles 1/6/7: device trust, OTP, and MFA prove *who the human is* and are established before tenant selection, so a person must not re-trust devices or re-enrol MFA once per company.
- Consequences: (1) auth-support RLS (migration 19) is row-ownership by `auth.uid()`, with no tenant scoping — simpler than tenant-scoped policies. (2) the *requirement* to present a factor stays role-driven through RBAC, decoupled from the artifact's storage. (3) migration 16 depends only on the Supabase-provided `auth.users`, not on `users`. Closes the migration-16 Future-Backlog item.

## ADR-0013 — Tenant Isolation & Data Access Principles are canonical (consolidate RLS decisions)
- Date: 2026-07 · Status: Accepted · Source: Owner directive; SPEC-050; consolidates ADR-0011, `30` Tenant Scope + Identity Key Standards, `31 §13` item 3
- Decision: the tenant-isolation/RLS philosophy is consolidated into one canonical document, `35_tenant_isolation_and_data_access_principles.md`, governing Migration 19. It restates the settled decisions (database-enforced default-deny isolation by `tenant_id`; `SECURITY DEFINER` RBAC resolution, never JWT claims; MVP degrades to the single membership) and adds the derivable engineering rule that **every table policy references one resolution primitive** so the resolution mechanism evolves in one place, plus: helper functions are `SECURITY DEFINER` in a non-API schema; `catalog_values` is readable when `tenant_id is null` OR = resolved tenant; platform/support access is the `service_role` (RLS-bypassing) backend, not per-table policy; audit logs are append-only (insert + tenant-scoped select, no update/delete).
- Why: the RLS decisions were scattered (ADR-0011, two `30` Standards, `31 §13`), forcing "where does this rule live?" per table — the same situation auth had before Migration 16. A principles doc lets the policies fall out as a consequence and prevents ~70 policies from hardcoding resolution.
- Consequences: (1) subscription-state gating is kept **distinct** from tenant isolation (authority = `subscription_status`, not `tenants.status`; enforced at service layer for MVP or a later separate predicate). (2) the deferred F2 FKs (`catalog_values.tenant_id`/`created_by`) should land before/with Migration 19. (3) multi-membership active-tenant plumbing, when it ships, touches only the resolution function. No genuinely unresolved question blocks Migration 19.
