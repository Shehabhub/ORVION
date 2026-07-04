# Change Request — SPEC-041

## Status

[ ] Draft
[x] Approved
[ ] In Progress
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

Create migration 11, `create_crm_extension_tables`, defining `tasks`, `complaints`, `service_requests`, `conversations`, and `conversation_messages` per `31_schema_draft.md` section 3 and `30_database_conventions.md`.

---

## Business Reason

`33` migration 11 adds the CRM-extension work records. `complaints`, `service_requests`, and `conversations` carry nullable `booking_id`/`booking_item_id` foreign keys, so they must follow Booking (migration 10). Structure only.

---

## Risks

Low–moderate (5 tables). Prerequisites live (`customers`, `leads`, `bookings`, `booking_items`, `users`, `branches`, `departments`). Type/status/channel codes plain text (SPEC-030). Archive fields on `tasks`/`complaints`/`service_requests`. `tasks` owner triple is NOT NULL. Physical choices in Notes.

---

## Supersedes / Depends On

Depends On: `SPEC-038` (customers/leads), `SPEC-040` (bookings/booking_items), `SPEC-029` (branches/departments), `SPEC-032` (users), `SPEC-028` (moddatetime) — all Complete.

---

## Scope — Files Allowed to Modify

- supabase/migrations/202607042400_create_crm_extension_tables.sql

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

1. Verification check: if any file matches `supabase/migrations/*_create_crm_extension_tables.sql`, record Already Applied. Otherwise create `supabase/migrations/202607042400_create_crm_extension_tables.sql` with exactly:

```sql
-- Migration: create_crm_extension_tables
-- Plan reference: 33_sql_migration_plan.md migration 11
-- Creates tasks, complaints, service_requests, conversations, conversation_messages per 31
-- section 3 and 30. Type/status/channel/direction codes plain text (SPEC-030). Archive fields on
-- tasks/complaints/service_requests. updated_at triggers on those plus conversations (not
-- conversation_messages). tasks owner triple NOT NULL (31 + one-responsible-employee rule).

create table tasks (
    id uuid primary key default gen_random_uuid(),
    tenant_id uuid not null references tenants (id) on delete restrict on update no action,
    owner_user_id uuid not null references users (id) on delete restrict on update no action,
    owner_department_id uuid not null references departments (id) on delete restrict on update no action,
    owner_branch_id uuid not null references branches (id) on delete restrict on update no action,
    related_entity_type text,
    related_entity_id uuid,
    task_type_code text not null,
    task_status_code text not null,
    priority_code text,
    title text not null,
    description text,
    due_at timestamptz,
    completed_at timestamptz,
    created_by uuid references users (id) on delete restrict on update no action,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now(),
    is_archived boolean not null default false,
    archived_at timestamptz,
    archived_by uuid references users (id) on delete restrict on update no action,
    archive_reason text
);

create table complaints (
    id uuid primary key default gen_random_uuid(),
    tenant_id uuid not null references tenants (id) on delete restrict on update no action,
    customer_id uuid not null references customers (id) on delete restrict on update no action,
    booking_id uuid references bookings (id) on delete restrict on update no action,
    booking_item_id uuid references booking_items (id) on delete restrict on update no action,
    owner_user_id uuid references users (id) on delete restrict on update no action,
    owner_department_id uuid references departments (id) on delete restrict on update no action,
    owner_branch_id uuid references branches (id) on delete restrict on update no action,
    complaint_category_code text not null,
    complaint_severity_code text not null,
    complaint_status_code text not null,
    title text not null,
    description text,
    resolution_notes text,
    resolved_at timestamptz,
    closed_at timestamptz,
    created_by uuid references users (id) on delete restrict on update no action,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now(),
    is_archived boolean not null default false,
    archived_at timestamptz,
    archived_by uuid references users (id) on delete restrict on update no action,
    archive_reason text
);

create table service_requests (
    id uuid primary key default gen_random_uuid(),
    tenant_id uuid not null references tenants (id) on delete restrict on update no action,
    customer_id uuid not null references customers (id) on delete restrict on update no action,
    booking_id uuid references bookings (id) on delete restrict on update no action,
    booking_item_id uuid references booking_items (id) on delete restrict on update no action,
    owner_user_id uuid references users (id) on delete restrict on update no action,
    owner_department_id uuid references departments (id) on delete restrict on update no action,
    owner_branch_id uuid references branches (id) on delete restrict on update no action,
    service_request_type_code text not null,
    service_request_severity_code text,
    service_request_status_code text not null,
    title text not null,
    description text,
    requested_at timestamptz not null default now(),
    resolved_at timestamptz,
    created_by uuid references users (id) on delete restrict on update no action,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now(),
    is_archived boolean not null default false,
    archived_at timestamptz,
    archived_by uuid references users (id) on delete restrict on update no action,
    archive_reason text
);

create table conversations (
    id uuid primary key default gen_random_uuid(),
    tenant_id uuid not null references tenants (id) on delete restrict on update no action,
    customer_id uuid references customers (id) on delete restrict on update no action,
    lead_id uuid references leads (id) on delete restrict on update no action,
    booking_id uuid references bookings (id) on delete restrict on update no action,
    booking_item_id uuid references booking_items (id) on delete restrict on update no action,
    owner_user_id uuid references users (id) on delete restrict on update no action,
    owner_department_id uuid references departments (id) on delete restrict on update no action,
    owner_branch_id uuid references branches (id) on delete restrict on update no action,
    current_branch_id uuid references branches (id) on delete restrict on update no action,
    current_department_id uuid references departments (id) on delete restrict on update no action,
    channel_code text not null,
    conversation_status_code text not null,
    external_conversation_id text,
    started_at timestamptz not null default now(),
    closed_at timestamptz,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now()
);

create table conversation_messages (
    id uuid primary key default gen_random_uuid(),
    tenant_id uuid not null references tenants (id) on delete restrict on update no action,
    conversation_id uuid not null references conversations (id) on delete restrict on update no action,
    sender_type_code text not null,
    sender_user_id uuid references users (id) on delete restrict on update no action,
    message_direction_code text not null,
    message_text text,
    external_message_id text,
    sent_at timestamptz,
    received_at timestamptz,
    metadata jsonb,
    created_at timestamptz not null default now()
);

-- Indexes (30 Index Standard: FKs, tenant filtering, status).
create index tasks_tenant_status_idx on tasks (tenant_id, task_status_code);
create index tasks_owner_user_id_idx on tasks (owner_user_id);
create index complaints_tenant_status_idx on complaints (tenant_id, complaint_status_code);
create index complaints_customer_id_idx on complaints (customer_id);
create index complaints_booking_id_idx on complaints (booking_id);
create index service_requests_tenant_status_idx on service_requests (tenant_id, service_request_status_code);
create index service_requests_customer_id_idx on service_requests (customer_id);
create index service_requests_booking_id_idx on service_requests (booking_id);
create index conversations_tenant_status_idx on conversations (tenant_id, conversation_status_code);
create index conversations_customer_id_idx on conversations (customer_id);
create index conversation_messages_conversation_id_idx on conversation_messages (conversation_id);

-- updated_at triggers.
create trigger tasks_set_updated_at before update on tasks for each row execute function moddatetime(updated_at);
create trigger complaints_set_updated_at before update on complaints for each row execute function moddatetime(updated_at);
create trigger service_requests_set_updated_at before update on service_requests for each row execute function moddatetime(updated_at);
create trigger conversations_set_updated_at before update on conversations for each row execute function moddatetime(updated_at);
```

---

## Acceptance Criteria

- [ ] `supabase/migrations/202607042400_create_crm_extension_tables.sql` exists with exactly the Step 1 content.
- [ ] `npx supabase db reset` applies every migration on a clean database with no error.
- [ ] All five tables exist; all foreign keys `restrict`/`no action`; no FK on any type/status/channel/direction code column.
- [ ] `updated_at` triggers exist on `tasks`, `complaints`, `service_requests`, `conversations` (4), and not on `conversation_messages`.
- [ ] `tasks.owner_user_id`, `owner_department_id`, `owner_branch_id` are NOT NULL.

---

## Execution Log

### 2026-07-05 — Claude (Tier 2 execution)

Outcome: Complete

Step results:
- Step 1: Applied — created `supabase/migrations/202607042400_create_crm_extension_tables.sql`; `npx supabase db reset` applied all 13 migrations cleanly.

Database Audit: 5 tables present; no FK deviates from restrict/no-action; no FK on any `_code` column; `updated_at` triggers on tasks/complaints/service_requests/conversations only (not conversation_messages); `tasks` owner triple all NOT NULL. Behavioral: cross-transaction update advanced `updated_at` (moddatetime); `conversation_messages.conversation_id` FK rejected a missing parent (restrict).

Commits: recorded at Complete.

Blocker: none.

---

## Verification Notes

### 2026-07-05 — Claude (independent review)

Verdict: Confirmed Complete

Findings: Re-checked the five tables against `31` section 3 — column sets, nullability, and the archive-fields-on-work-records / no-archive-on-conversation(_messages) split match. Referential Action Standard upheld (all FKs restrict/no-action). Status/type/channel/direction codes are plain text with no FK (SPEC-030). `updated_at` triggers present on the four tables carrying `updated_at` and absent on `conversation_messages`. `tasks` owner triple NOT NULL per the one-responsible-employee rule. Clean `db reset` and behavioral tests reproduced. No file outside Scope modified.

Recommendation to human: Set Status to Complete

---

## Review Gate

- [ ] Every change matches the Implementation Steps.
- [ ] No file outside Scope was modified.
- [ ] Every Acceptance Criteria item is confirmed true.
- [ ] The repository is in a clean, releasable state.

---

## Notes

Physical decisions: `tasks` owner triple NOT NULL (per `31` and the "every pending task belongs to exactly one responsible employee" rule); `complaints`/`service_requests`/`conversations` owner fields nullable (per `31`); polymorphic `tasks.related_entity_type`/`related_entity_id` are plain columns (no FK); `conversation_messages.metadata` is `jsonb`. `conversations`/`conversation_messages` have no archive fields (per `31`).
