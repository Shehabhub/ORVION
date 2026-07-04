# Change Request — SPEC-038

## Status

[ ] Draft
[ ] Approved
[x] In Progress
[ ] Complete
[ ] Cancelled

Allowed values are exactly these five. Do not use any other status word anywhere in a Change Request.

---

## Assigned Model Tier

[ ] Tier 1 — Strong reasoning model
[x] Tier 2 — Local execution agent (Qwen3.8B)
    Permitted modes: IMPLEMENT only

---

## Objective

Create migration 8, `create_crm_core_tables`, defining `customers`, `customer_contact_methods`, `customer_identity_signals`, `customer_identity_merges`, `customer_notes`, `leads`, `lead_assignments`, and `lead_interactions` per `31_schema_draft.md` section 3 and `30_database_conventions.md`.

---

## Business Reason

`33` migration 8 is the CRM core. `customers` is created before `leads` (`leads.customer_id` is nullable; customers has no dependency on leads). `customers.preferred_language_code` is the first foreign key into the reference data layer (`languages`, SPEC-037). Structure only.

---

## Risks

Moderate (8 tables, many foreign keys), mitigated by a clean `db reset` verification and Migration CI. All prerequisites live (`tenants`, `branches`, `departments`, `users`, `languages`). Type/status/source codes are plain text (SPEC-030); `preferred_language_code` is a real FK to `languages(code)`. Physical choices not fixed by the canon are in Notes.

---

## Supersedes / Depends On

Depends On: `SPEC-029` (tenants/branches/departments), `SPEC-032` (users), `SPEC-037` (languages), `SPEC-028` (moddatetime) — all Complete.

---

## Scope — Files Allowed to Modify

- supabase/migrations/202607042100_create_crm_core_tables.sql

---

## Out of Scope — Files Forbidden to Modify

- _ORVION_CANONICAL/** ; supabase/config.toml ; any existing migration ; any later migration ; seed data

---

## Minimum Reading List

- _ORVION_CANONICAL/31_schema_draft.md
- _ORVION_CANONICAL/30_database_conventions.md
- _ORVION_CANONICAL/33_sql_migration_plan.md

---

## Implementation Steps

1. Verification check: if any file matches `supabase/migrations/*_create_crm_core_tables.sql`, record Already Applied. Otherwise create `supabase/migrations/202607042100_create_crm_core_tables.sql` with exactly:

```sql
-- Migration: create_crm_core_tables
-- Plan reference: 33_sql_migration_plan.md migration 8
-- CRM core (customers + detail tables, leads + detail tables) per 31 section 3 and 30.
-- customers before leads (leads.customer_id nullable). preferred_language_code is a real FK to
-- languages(code) (SPEC-037). Other type/status/source codes are plain text (SPEC-030).
-- Archive fields on customers/customer_notes/leads. All FKs restrict/no action.

create table customers (
    id uuid primary key default gen_random_uuid(),
    tenant_id uuid not null references tenants (id) on delete restrict on update no action,
    customer_type_code text not null,
    first_name text,
    family_name text,
    full_name text not null,
    company_name text,
    primary_phone text,
    primary_email text,
    preferred_language_code text references languages (code) on delete restrict on update no action,
    preferred_contact_method_code text,
    marketing_opt_in boolean not null default false,
    first_registered_branch_id uuid references branches (id) on delete restrict on update no action,
    last_interaction_branch_id uuid references branches (id) on delete restrict on update no action,
    last_interaction_user_id uuid references users (id) on delete restrict on update no action,
    last_interaction_at timestamptz,
    created_by uuid references users (id) on delete restrict on update no action,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now(),
    is_archived boolean not null default false,
    archived_at timestamptz,
    archived_by uuid references users (id) on delete restrict on update no action,
    archive_reason text
);

create table customer_contact_methods (
    id uuid primary key default gen_random_uuid(),
    tenant_id uuid not null references tenants (id) on delete restrict on update no action,
    customer_id uuid not null references customers (id) on delete restrict on update no action,
    contact_method_type_code text not null,
    value text not null,
    is_primary boolean not null default false,
    is_verified boolean not null default false,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now()
);

create table customer_identity_signals (
    id uuid primary key default gen_random_uuid(),
    tenant_id uuid not null references tenants (id) on delete restrict on update no action,
    customer_id uuid not null references customers (id) on delete restrict on update no action,
    signal_type_code text not null,
    signal_value text not null,
    source_entity_type text,
    source_entity_id uuid,
    created_at timestamptz not null default now()
);

create table customer_identity_merges (
    id uuid primary key default gen_random_uuid(),
    tenant_id uuid not null references tenants (id) on delete restrict on update no action,
    source_customer_id uuid not null references customers (id) on delete restrict on update no action,
    target_customer_id uuid not null references customers (id) on delete restrict on update no action,
    merged_by uuid references users (id) on delete restrict on update no action,
    reason text,
    created_at timestamptz not null default now()
);

create table customer_notes (
    id uuid primary key default gen_random_uuid(),
    tenant_id uuid not null references tenants (id) on delete restrict on update no action,
    customer_id uuid not null references customers (id) on delete restrict on update no action,
    note_text text not null,
    is_pinned boolean not null default false,
    is_confidential boolean not null default false,
    created_by uuid references users (id) on delete restrict on update no action,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now(),
    is_archived boolean not null default false,
    archived_at timestamptz,
    archived_by uuid references users (id) on delete restrict on update no action,
    archive_reason text
);

create table leads (
    id uuid primary key default gen_random_uuid(),
    tenant_id uuid not null references tenants (id) on delete restrict on update no action,
    branch_id uuid not null references branches (id) on delete restrict on update no action,
    department_id uuid not null references departments (id) on delete restrict on update no action,
    owner_user_id uuid references users (id) on delete restrict on update no action,
    owner_department_id uuid references departments (id) on delete restrict on update no action,
    owner_branch_id uuid references branches (id) on delete restrict on update no action,
    lead_source_code text not null,
    lead_status_code text not null,
    priority_code text,
    closure_reason_code text,
    customer_id uuid references customers (id) on delete restrict on update no action,
    assigned_user_id uuid references users (id) on delete restrict on update no action,
    title text not null,
    requested_service_type_code text,
    expected_value numeric(14, 2),
    next_follow_up_at timestamptz,
    last_contact_at timestamptz,
    customer_phone_snapshot text,
    customer_name_snapshot text,
    source_payload jsonb,
    created_by uuid references users (id) on delete restrict on update no action,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now(),
    closed_at timestamptz,
    is_archived boolean not null default false,
    archived_at timestamptz,
    archived_by uuid references users (id) on delete restrict on update no action,
    archive_reason text
);

create table lead_assignments (
    id uuid primary key default gen_random_uuid(),
    tenant_id uuid not null references tenants (id) on delete restrict on update no action,
    lead_id uuid not null references leads (id) on delete restrict on update no action,
    assigned_user_id uuid not null references users (id) on delete restrict on update no action,
    assigned_by uuid references users (id) on delete restrict on update no action,
    assigned_at timestamptz not null default now(),
    unassigned_at timestamptz,
    assignment_reason text,
    is_current boolean not null default true
);

create table lead_interactions (
    id uuid primary key default gen_random_uuid(),
    tenant_id uuid not null references tenants (id) on delete restrict on update no action,
    lead_id uuid not null references leads (id) on delete restrict on update no action,
    user_id uuid references users (id) on delete restrict on update no action,
    interaction_type_code text not null,
    interaction_at timestamptz not null default now(),
    summary text,
    metadata jsonb,
    created_at timestamptz not null default now()
);

-- Indexes (30 Index Standard: FKs, tenant filtering, status, assignment queues, dedup).
create index customers_tenant_phone_idx on customers (tenant_id, primary_phone);
create index customer_contact_methods_customer_id_idx on customer_contact_methods (customer_id);
create index customer_identity_signals_customer_id_idx on customer_identity_signals (customer_id);
create index customer_identity_merges_source_idx on customer_identity_merges (source_customer_id);
create index customer_identity_merges_target_idx on customer_identity_merges (target_customer_id);
create index customer_notes_customer_id_idx on customer_notes (customer_id);
create index leads_tenant_status_idx on leads (tenant_id, lead_status_code);
create index leads_tenant_assigned_user_idx on leads (tenant_id, assigned_user_id);
create index leads_customer_id_idx on leads (customer_id);
create index leads_branch_id_idx on leads (branch_id);
create index lead_assignments_lead_id_idx on lead_assignments (lead_id);
create index lead_interactions_lead_id_idx on lead_interactions (lead_id);

-- updated_at triggers (only tables with an updated_at column).
create trigger customers_set_updated_at before update on customers for each row execute function moddatetime(updated_at);
create trigger customer_contact_methods_set_updated_at before update on customer_contact_methods for each row execute function moddatetime(updated_at);
create trigger customer_notes_set_updated_at before update on customer_notes for each row execute function moddatetime(updated_at);
create trigger leads_set_updated_at before update on leads for each row execute function moddatetime(updated_at);
```

---

## Acceptance Criteria

- [ ] `supabase/migrations/202607042100_create_crm_core_tables.sql` exists with exactly the Step 1 content.
- [ ] `npx supabase db reset` applies every migration on a clean database with no error.
- [ ] All eight tables exist.
- [ ] `customers.preferred_language_code` has a foreign key to `languages(code)`; all foreign keys are `restrict`/`no action`; there is no FK on any type/status/source code column.
- [ ] `updated_at` triggers exist on `customers`, `customer_contact_methods`, `customer_notes`, `leads` (4), and on none of the other four tables.
- [ ] `leads.expected_value` is `numeric(14,2)`; `leads.source_payload` and `lead_interactions.metadata` are `jsonb`.

---

## Execution Log

### 2026-07-05 01:41 — Claude Code (Opus 4.8), IMPLEMENT

Outcome: Complete

Step results:
- Step 1: Applied — created `supabase/migrations/202607042100_create_crm_core_tables.sql` with the specified content.

Verification (clean `db reset`, Postgres 17): all eight tables exist; `customers.preferred_language_code` → `languages(code)` (the first reference-data-layer FK); 0 foreign keys with an action other than restrict; 0 foreign keys on any type/status/source code column; `updated_at` triggers on exactly `customers`, `customer_contact_methods`, `customer_notes`, `leads` (4); `leads.expected_value` = `numeric(14,2)`.

Commits: this Implement commit. No other migration or canonical document changed.

---

## Verification Notes

### 2026-07-05 01:44 — Claude Code (Opus 4.8), REVIEW

Verdict: Confirmed Complete

Findings: Re-verified independently against a fresh `db reset` and live schema.
- All eight CRM tables exist; `customers.preferred_language_code` → `languages` foreign key present (reference-data layer in use).
- 0 foreign keys on the eight tables with an action other than restrict; `updated_at` triggers on exactly `customers`, `customer_contact_methods`, `customer_notes`, `leads` (4).
- Scope: only the migration file and this Change Request changed. Depends-On all Complete.

Recommendation to human: Set Status to Complete.

---

## Review Gate

- [ ] Every change matches the Implementation Steps.
- [ ] No file outside Scope was modified.
- [ ] Every Acceptance Criteria item is confirmed true.
- [ ] The repository is in a clean, releasable state.

---

## Notes

Physical decisions: `primary_phone`/`primary_email` nullable (a customer may have only one channel); `full_name` not null (display name); `first_name`/`family_name`/`company_name` nullable (individual vs company); `expected_value numeric(14,2)`; `lead_assignments.is_current` default true; polymorphic `customer_identity_signals.source_entity_type`/`source_entity_id` are plain columns (no FK). Only `customers`/`customer_contact_methods`/`customer_notes`/`leads` carry `updated_at` (per `31`).

Findings (Recommended, not added — surfaced): a partial unique for one primary contact method per customer, and one current `lead_assignments` per lead, are implied but not stated in `31`; left to future decisions rather than added silently.
