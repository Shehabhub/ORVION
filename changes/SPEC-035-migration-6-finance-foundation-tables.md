# Change Request — SPEC-035

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

[ ] Tier 1 — Strong reasoning model
[x] Tier 2 — Local execution agent (Qwen3.8B)
    Permitted modes: IMPLEMENT only

---

## Objective

Create migration 6, `create_finance_foundation_tables`, defining `exchange_rates`, `chart_of_accounts`, and `financial_accounts` per `31_schema_draft.md` section 5 and `30_database_conventions.md`.

---

## Business Reason

`33_sql_migration_plan.md` migration 6 is the finance foundation, pulled earlier than the main finance group because `booking_items.exchange_rate_id` (migration 10) requires `exchange_rates` to exist. These three tables establish tenant exchange rates, the chart of accounts, and bank/cash accounts. Structure only — no seed data.

---

## Risks

Low. Three new tables; all prerequisites live (`currencies` mig 3, `tenants` mig 4, `users` mig 5). `currency_code`/`from_currency_code`/`to_currency_code` are real foreign keys to `currencies(code)` (Money Standard); `chart_of_accounts.parent_account_id` is a nullable self-reference; type codes are plain text (SPEC-030). Money precision per Money Standard: `numeric(18,8)` for rates, `numeric(14,2)` for balances. Physical choices not fixed by the canon are in Notes.

---

## Supersedes / Depends On

Depends On: `SPEC-025` (currencies), `SPEC-029` (tenants), `SPEC-032` (users, for `set_by`), and `SPEC-028` (moddatetime) — all Complete.

---

## Scope — Files Allowed to Modify

- supabase/migrations/202607041800_create_finance_foundation_tables.sql

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

1. Verification check: if any file matches `supabase/migrations/*_create_finance_foundation_tables.sql`, record Already Applied. Otherwise create `supabase/migrations/202607041800_create_finance_foundation_tables.sql` with exactly:

```sql
-- Migration: create_finance_foundation_tables
-- Plan reference: 33_sql_migration_plan.md migration 6
-- Creates exchange_rates, chart_of_accounts, financial_accounts per 31_schema_draft.md
-- section 5 and 30_database_conventions.md. currency_code columns are real foreign keys to
-- currencies.code (Money Standard). account_type / financial_account_type_code are plain
-- text (SPEC-030). Money precision: numeric(18,8) rates, numeric(14,2) balances.
-- exchange_rates has no updated_at (rates are immutable snapshots) -> no trigger.

create table exchange_rates (
    id uuid primary key default gen_random_uuid(),
    tenant_id uuid not null references tenants (id) on delete restrict on update no action,
    from_currency_code text not null references currencies (code) on delete restrict on update no action,
    to_currency_code text not null references currencies (code) on delete restrict on update no action,
    rate numeric(18, 8) not null,
    effective_at timestamptz not null,
    set_by uuid references users (id) on delete restrict on update no action,
    created_at timestamptz not null default now()
);

create table chart_of_accounts (
    id uuid primary key default gen_random_uuid(),
    tenant_id uuid not null references tenants (id) on delete restrict on update no action,
    code text not null,
    name text not null,
    parent_account_id uuid references chart_of_accounts (id) on delete restrict on update no action,
    account_type text not null,
    is_system_default boolean not null default false,
    is_active boolean not null default true,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now()
);

create table financial_accounts (
    id uuid primary key default gen_random_uuid(),
    tenant_id uuid not null references tenants (id) on delete restrict on update no action,
    financial_account_type_code text not null,
    name text not null,
    currency_code text not null references currencies (code) on delete restrict on update no action,
    opening_balance numeric(14, 2) not null default 0,
    is_active boolean not null default true,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now()
);

-- Indexes (30 Index Standard: foreign keys, tenant filtering).
create index exchange_rates_tenant_id_idx on exchange_rates (tenant_id);
create index chart_of_accounts_tenant_id_idx on chart_of_accounts (tenant_id);
create index chart_of_accounts_parent_account_id_idx on chart_of_accounts (parent_account_id);
create index financial_accounts_tenant_id_idx on financial_accounts (tenant_id);

-- updated_at triggers (exchange_rates excluded -- immutable rate snapshots, no updated_at).
create trigger chart_of_accounts_set_updated_at
    before update on chart_of_accounts
    for each row execute function moddatetime(updated_at);

create trigger financial_accounts_set_updated_at
    before update on financial_accounts
    for each row execute function moddatetime(updated_at);
```

---

## Acceptance Criteria

- [ ] `supabase/migrations/202607041800_create_finance_foundation_tables.sql` exists with exactly the Step 1 content.
- [ ] `npx supabase db reset` applies every migration (1–7) on a clean database with no error.
- [ ] `exchange_rates`, `chart_of_accounts`, `financial_accounts` exist.
- [ ] `currency_code` FKs exist: `exchange_rates.from_currency_code`/`to_currency_code` and `financial_accounts.currency_code` → `currencies(code)`; `chart_of_accounts.parent_account_id` self-references `chart_of_accounts(id)`; all FKs `restrict`/`no action`.
- [ ] `exchange_rates.rate` is `numeric(18,8)`; `financial_accounts.opening_balance` is `numeric(14,2)`.
- [ ] Triggers exist on `chart_of_accounts` and `financial_accounts`; `exchange_rates` has none.
- [ ] No FK on `account_type` or `financial_account_type_code`.

---

## Execution Log

### 2026-07-05 01:05 — Claude Code (Opus 4.8), IMPLEMENT

Outcome: Complete

Step results:
- Step 1: Applied — created `supabase/migrations/202607041800_create_finance_foundation_tables.sql` with the specified content.

Verification (clean `db reset`, migrations 1–7, Postgres 17):
- Three tables exist; migrations apply with no error.
- 8 foreign keys, all `del=r` (restrict): `exchange_rates` from/to `currency_code`→currencies, `set_by`→users, `tenant_id`→tenants; `chart_of_accounts` `parent_account_id`→chart_of_accounts (self-ref), `tenant_id`→tenants; `financial_accounts` `currency_code`→currencies, `tenant_id`→tenants.
- Money types: `exchange_rates.rate numeric(18,8)`, `financial_accounts.opening_balance numeric(14,2)`.
- `updated_at` triggers on `chart_of_accounts` and `financial_accounts` only; `exchange_rates` has none (immutable rate snapshots).
- Zero foreign keys on `account_type` / `financial_account_type_code`.

Commits: this Implement commit. No other migration or canonical document changed.

---

## Verification Notes

### <YYYY-MM-DD HH:MM> — <agent identifier>

Verdict: Confirmed Complete | Discrepancy Found | Needs Corrective Change Request

Findings: <what was independently re-checked>

Recommendation to human: Set Status to Complete | Set Status to Cancelled

---

## Review Gate

- [ ] Every change matches the Implementation Steps.
- [ ] No file outside Scope was modified.
- [ ] Every Acceptance Criteria item is confirmed true.
- [ ] The repository is in a clean, releasable state.

---

## Notes

Physical decisions: `set_by` nullable (system-set rates have no actor); `opening_balance` default 0; `account_type`/`financial_account_type_code` plain text (SPEC-030); `is_system_default`/`is_active` boolean defaults. `exchange_rates` intentionally has no `updated_at` (immutable rate snapshots, per `31`).

Findings (Recommended, not added — surfaced): `chart_of_accounts` could carry a `unique (tenant_id, code)` and `exchange_rates` a dedup unique; neither is stated in `31`, so both are left to a future decision rather than added silently.
