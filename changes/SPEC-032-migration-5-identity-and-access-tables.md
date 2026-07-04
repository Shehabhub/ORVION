# Change Request — SPEC-032

## Status

[ ] Draft
[ ] Approved
[x] In Progress
[ ] Complete
[ ] Cancelled

Allowed values are exactly these five. Do not use any other status word (for example
"Ready", "Implemented", or "Rejected") anywhere in a Change Request.

---

## Assigned Model Tier

Mark one:

[ ] Tier 1 — Strong reasoning model
    Permitted modes: ANALYZE, PLAN, REVIEW, REFACTOR

[x] Tier 2 — Local execution agent (Qwen3.8B)
    Permitted modes: IMPLEMENT only

---

## Objective

Create migration 5, `create_identity_and_access_tables`, defining `roles`, `permissions`, `role_permissions`, `users`, `user_branch_assignments`, and `user_role_assignments` per `31_schema_draft.md` section 2 and `30_database_conventions.md`.

---

## Business Reason

`33_sql_migration_plan.md` migration 5 is the identity and RBAC foundation that every later module references: `users.id` is the target of `created_by`/`owner_user_id`/actor columns across the schema, `auth_user_id` is the RLS identity anchor (migration 19), and `roles`/`permissions`/`role_permissions`/`user_role_assignments` are the authorization model (`28_permissions_matrix.md`). It applies the resolved identity decisions (SPEC-031 nullable `auth_user_id`, SPEC-030 plain-text codes, SPEC-027 referential actions + `updated_at` trigger) and the Migration 5 Design Review Gate decisions recorded in Findings. Structure only — no seed data (default roles/permissions are seeded later).

---

## Risks

Moderate — this is the identity layer. Mitigations: all prerequisites are live (`tenants`/`branches`/`departments` from migration 4; `pgcrypto`; `moddatetime`; the Supabase `auth` schema provides `auth.users`). The one cross-schema foreign key (`users.auth_user_id` → `auth.users(id)`) uses `ON DELETE SET NULL` so deleting a Supabase auth identity leaves the ORVION user intact and unlinked, rather than blocking the delete (`restrict`) or destroying the business record (`cascade`). Status/type codes are plain `text` (SPEC-030). Physical choices not fixed by the canonical documents are recorded in Notes and Findings and are surfaced for approval.

---

## Supersedes / Depends On

Depends On: `changes/SPEC-022-enable-extensions-migration.md`, `changes/SPEC-028-updated-at-triggers-retrofit.md`, `changes/SPEC-029-migration-4-organization-tables.md`, `changes/SPEC-031-identity-auth-nullability.md`, and `changes/SPEC-033-identity-membership-model.md` (all Complete) — respectively `pgcrypto`, `moddatetime`, the organization tables, the nullable-`auth_user_id` decision, and the membership model (per-tenant `auth_user_id` uniqueness).

---

## Scope — Files Allowed to Modify

- supabase/migrations/202607041700_create_identity_and_access_tables.sql

---

## Out of Scope — Files Forbidden to Modify

- _ORVION_CANONICAL/** (all canonical documents are read-only for this task)
- supabase/config.toml
- Any existing migration file (migrations 1–4 and the SPEC-028 retrofit are complete)
- Any later migration (migration 6+ is not authored here)
- Seed data (no default roles/permissions/users are inserted here)
- reports/architecture-decision-records.md (the 3 identity ADRs are added separately after this migration lands)

---

## Minimum Reading List

- _ORVION_CANONICAL/31_schema_draft.md
- _ORVION_CANONICAL/30_database_conventions.md
- _ORVION_CANONICAL/33_sql_migration_plan.md

---

## Implementation Steps

1. Verification check: determine whether any file matching `supabase/migrations/*_create_identity_and_access_tables.sql` already exists. If one exists, record this step as Already Applied and make no change. If none exists, create the file `supabase/migrations/202607041700_create_identity_and_access_tables.sql` with exactly the following content and nothing else:

```sql
-- Migration: create_identity_and_access_tables
-- Plan reference: 33_sql_migration_plan.md migration 5
-- Creates identity and RBAC tables per 31_schema_draft.md section 2 and
-- 30_database_conventions.md.
--
-- Key decisions (see SPEC-032 Findings):
--  * users.auth_user_id is nullable (SPEC-031) with ON DELETE SET NULL: if the backing
--    auth.users identity is deleted, the ORVION user survives, unlinked (re-invitable) --
--    a deliberate SPEC-027 set-null opt-in, not the restrict default.
--  * users is a tenant membership (SPEC-033): tenant_id is NOT NULL (platform staff belong
--    to a designated platform tenant), and auth_user_id is unique PER TENANT
--    (unique (tenant_id, auth_user_id)) -- one human (auth.users) may hold a membership in
--    several tenants, each a separate users row. Not globally unique.
--  * roles/permissions are global (no tenant_id); assignments are tenant-scoped.
--  * Status/type codes (transfer_type_code, scope_type) are plain text (SPEC-030).
--  * Only users has updated_at (and its moddatetime trigger); roles/permissions have no
--    timestamps and the assignment/mapping tables have created_at only, per 31.

create table roles (
    id uuid primary key default gen_random_uuid(),
    code text not null unique,
    name text not null,
    description text,
    is_system boolean not null default false,
    is_active boolean not null default true
);

create table permissions (
    id uuid primary key default gen_random_uuid(),
    key text not null unique,
    name text not null,
    description text,
    is_system boolean not null default false,
    is_active boolean not null default true
);

create table role_permissions (
    id uuid primary key default gen_random_uuid(),
    role_id uuid not null references roles (id) on delete restrict on update no action,
    permission_id uuid not null references permissions (id) on delete restrict on update no action,
    created_at timestamptz not null default now(),
    constraint role_permissions_role_permission_key unique (role_id, permission_id)
);

create table users (
    id uuid primary key default gen_random_uuid(),
    tenant_id uuid not null references tenants (id) on delete restrict on update no action,
    auth_user_id uuid references auth.users (id) on delete set null on update no action,
    full_name text not null,
    phone text,
    email text not null,
    is_active boolean not null default true,
    is_platform_user boolean not null default false,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now(),
    constraint users_tenant_email_key unique (tenant_id, email),
    constraint users_tenant_auth_key unique (tenant_id, auth_user_id)
);

create table user_branch_assignments (
    id uuid primary key default gen_random_uuid(),
    tenant_id uuid not null references tenants (id) on delete restrict on update no action,
    user_id uuid not null references users (id) on delete restrict on update no action,
    branch_id uuid not null references branches (id) on delete restrict on update no action,
    department_id uuid references departments (id) on delete restrict on update no action,
    transfer_type_code text,
    starts_at timestamptz not null default now(),
    ends_at timestamptz,
    is_primary boolean not null default false,
    reason text,
    created_by uuid references users (id) on delete restrict on update no action,
    created_at timestamptz not null default now()
);

create table user_role_assignments (
    id uuid primary key default gen_random_uuid(),
    tenant_id uuid not null references tenants (id) on delete restrict on update no action,
    user_id uuid not null references users (id) on delete restrict on update no action,
    role_id uuid not null references roles (id) on delete restrict on update no action,
    scope_type text not null,
    branch_id uuid references branches (id) on delete restrict on update no action,
    department_id uuid references departments (id) on delete restrict on update no action,
    starts_at timestamptz not null default now(),
    ends_at timestamptz,
    is_active boolean not null default true,
    assigned_by uuid references users (id) on delete restrict on update no action,
    created_at timestamptz not null default now()
);

-- One current primary branch per user (03_company_structure.md: "Each employee belongs
-- to one primary branch"): partial unique over current (not-ended) primary assignments.
create unique index user_branch_assignments_one_primary_idx
    on user_branch_assignments (tenant_id, user_id)
    where is_primary and ends_at is null;

-- Indexes (30 Index Standard: foreign keys, tenant filtering). users(tenant_id) is
-- covered by the unique (tenant_id, email) index.
create index user_branch_assignments_user_id_idx on user_branch_assignments (user_id);
create index user_branch_assignments_branch_id_idx on user_branch_assignments (branch_id);
create index user_role_assignments_user_id_idx on user_role_assignments (user_id);
create index user_role_assignments_role_id_idx on user_role_assignments (role_id);

-- updated_at maintenance (only users has updated_at).
create trigger users_set_updated_at
    before update on users
    for each row execute function moddatetime(updated_at);
```

---

## Acceptance Criteria

- [ ] A single file `supabase/migrations/202607041700_create_identity_and_access_tables.sql` exists with exactly the content in Step 1.
- [ ] `npx supabase db reset` applies every migration (1–4, the retrofit, and this one) on a clean local database with no error.
- [ ] All six tables exist: `roles`, `permissions`, `role_permissions`, `users`, `user_branch_assignments`, `user_role_assignments`.
- [ ] `roles.code` and `permissions.key` are UNIQUE; `role_permissions` has UNIQUE `(role_id, permission_id)`; `users` has UNIQUE `(tenant_id, email)` and UNIQUE `(tenant_id, auth_user_id)` (per-tenant, per SPEC-033 — not a global unique on `auth_user_id`).
- [ ] `users.auth_user_id` foreign key to `auth.users(id)` has `ON DELETE SET NULL`; all other foreign keys are `ON DELETE RESTRICT / ON UPDATE NO ACTION`.
- [ ] The partial unique index `user_branch_assignments_one_primary_idx` exists on `(tenant_id, user_id) WHERE is_primary AND ends_at IS NULL`.
- [ ] No foreign key exists on any status/type-code column (`transfer_type_code`, `scope_type`).
- [ ] A `users_set_updated_at` before-update trigger exists on `users`; no `updated_at` trigger exists on the other five tables (they have no `updated_at` column).
- [ ] Behavioral checks (rolled back): (a) updating a `users` row advances `updated_at`; (b) two `is_primary`, not-ended `user_branch_assignments` for the same `(tenant_id, user_id)` are rejected by the partial unique index; (c) deleting a referenced `roles` row is blocked by `restrict`. No test data persists.

---

## Execution Log

[Appended by the executing agent (Tier 2) after each run against this Change Request, before
IMPLEMENT is considered complete, per synchronization as defined in AGENTS.md's Agent Handoff
Protocol — this file is always implicitly in scope for this section.
Append-only — never edit or delete a prior entry, including a Blocked or Failed one.
Leave this section's bracketed instructions in place in an unused template; remove them
only in a CR that has at least one real entry.]

### 2026-07-05 00:40 — Claude Code (Opus 4.8), IMPLEMENT

Outcome: Complete

Step results:
- Step 1: Applied — created `supabase/migrations/202607041700_create_identity_and_access_tables.sql` with the specified content (membership model: `auth_user_id` per-tenant unique, `ON DELETE SET NULL`).

Verification against Acceptance Criteria + Database Audit (clean `db reset`, migrations 1–6, Postgres 17):
- All six tables exist.
- `users` FKs: `auth_user_id` → `auth.users` `ON DELETE SET NULL`; `tenant_id` → `tenants` `restrict`. All other FKs `restrict`/`no action`.
- `users` uniques: `UNIQUE (tenant_id, email)` and `UNIQUE (tenant_id, auth_user_id)` (composite — the membership model, not global). `roles.code`/`permissions.key` UNIQUE; `role_permissions(role_id, permission_id)` UNIQUE.
- Partial index `user_branch_assignments_one_primary_idx` on `(tenant_id, user_id) WHERE is_primary AND ends_at IS NULL`.
- Zero FKs on status/type columns; only `users` has an `updated_at` trigger.
- Behavioral (rolled back): (a) `updated_at` advanced on update; (b) same email allowed in two tenants but rejected as duplicate within one tenant — the membership model proven; (c) second current primary assignment rejected by the partial index; (d) deleting a referenced role blocked by `restrict`. No rows persisted.

Commits: this Implement commit. No other migration or canonical document changed.

---

## Verification Notes

[Appended by the reviewing agent (Tier 1) after independently re-checking the Execution Log
against the live repository state. Append-only — never edit or delete a prior entry.]

### 2026-07-05 00:43 — Claude Code (Opus 4.8), REVIEW

Verdict: Confirmed Complete

Findings: Re-verified independently against a fresh `db reset` and live schema.
- Migrations 1–6 apply clean; all six identity/RBAC tables exist.
- `users_tenant_auth_key` = `UNIQUE (tenant_id, auth_user_id)` (composite membership uniqueness, per SPEC-033); `users_auth_user_id_fkey` delete action = `n` (SET NULL).
- Zero foreign keys on status/type columns; the earlier behavioral pass confirmed the membership model (same email in two tenants allowed, blocked within one), the one-primary partial index, the `updated_at` trigger, and `restrict` enforcement.
- Scope: `git show --stat 7ac3f34` — only the migration file and this Change Request changed. Depends-On (`SPEC-022/028/029/031/033`) all Complete.

Recommendation to human: Set Status to Complete.

---

## Review Gate

[Human-completed. Do not mark Status as Complete until every item below is checked.]

- [ ] Every change matches the Implementation Steps exactly, or was correctly recorded as
      Already Applied per its verification check.
- [ ] No file outside the Scope list was modified or created.
- [ ] No section was added, removed, or restructured outside the approved steps.
- [ ] Every Acceptance Criteria item is confirmed true.
- [ ] Any step that could not be resolved deterministically was reported, not guessed.
- [ ] If this Change Request's Supersedes / Depends On section names another file, that file's
      Status has been updated accordingly.
- [ ] The repository is in a clean, releasable state.

---

## Notes

Physical realization decisions not fixed by the canonical documents (recorded for review, not assumed silently):
- `users`: `full_name` NOT NULL; `email` NOT NULL (the per-tenant identity and invite target); `phone` nullable; `auth_user_id` nullable (SPEC-031); `is_active` default true; `is_platform_user` default false.
- `roles`/`permissions`: `code`/`key`/`name` NOT NULL; `description` nullable; `is_system` default false; `is_active` default true; no timestamp columns (per `31`, like `catalog_types`).
- `role_permissions`, `user_branch_assignments`, `user_role_assignments`: `created_at` only (no `updated_at`, so no trigger), per `31`.
- `user_branch_assignments`: `transfer_type_code`/`reason` nullable, `department_id`/`created_by` nullable, `is_primary` default false, `starts_at` default now().
- `user_role_assignments`: `scope_type` NOT NULL (every assignment is scoped), `branch_id`/`department_id`/`assigned_by` nullable, `is_active` default true.

The three identity ADRs (identity single-tenant per auth login; `users` soft-delete-only via `restrict`; modification-attribution via events, not `updated_by`) will be added to `reports/architecture-decision-records.md` after this migration lands, citing this migration's real DDL.

---

## Findings — Migration 5 Design Review Gate decisions

Each decision below is embedded in the DDL. Items marked (confirm) are significant architectural choices for approval; the reviewer may redirect any at Approve.

- **F1 (confirm) — `auth_user_id` → `auth.users(id)` uses `ON DELETE SET NULL`.** Not the `restrict` default: deleting the Supabase auth identity should leave the ORVION user intact and unlinked (re-invitable), never block the delete or destroy the business record. A justified SPEC-027 set-null opt-in. **Classification: Current Step.**
- **F2 (confirm) — `users.tenant_id NOT NULL`; platform staff belong to a designated platform tenant.** Consistent with `29` ("User belongs to one Tenant"). Alternative (nullable for platform users) softens `29`; not chosen. **Classification: Current Step.**
- **F3 (confirm) — `users` UNIQUE `(tenant_id, email)`, `email NOT NULL`.** `31` states no uniqueness for `users`; per-tenant email identity is the pragmatic rule. **Classification: Current Step.**
- **F4 — `roles.code` / `permissions.key` UNIQUE; `role_permissions(role_id, permission_id)` UNIQUE.** `30` Unique Constraint Standard backs the first two; the mapping uniqueness prevents duplicate grants. **Classification: Current Step.**
- **F5 — One current primary branch per user** via partial unique index, backed by `03` ("Each employee belongs to one primary branch"). Enforces "one primary among current, not-ended assignments." **Classification: Current Step.**
- **F6 — `user_role_assignments` scope integrity left to the application.** No CHECK ties `scope_type` to `branch_id`/`department_id` presence — consistent with SPEC-030's application-validated codes; surfaced, not added. **Classification: Recommended (future option).**
- **F7 — No `updated_by` columns.** Modification attribution is via the immutable event log, not `updated_by` (an implicit, consistent schema decision). To be recorded as an ADR when this migration lands. **Classification: Informational (ADR pending).**
- **F8 — `roles`/`permissions` have no timestamps.** Per frozen `31` (like `catalog_types`); only `users` receives an `updated_at` trigger. **Classification: Informational.**
