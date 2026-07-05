-- Migration: create_authentication_support_tables
-- Plan reference: 33_sql_migration_plan.md migration 16
-- Creates trusted_devices, otp_challenges, totp_enrollments per 31 section 9 (as amended by
-- 34_authentication_and_identity_principles.md, Principles 1/6/7). These prove *who the human is*,
-- so they belong to the Human Identity: keyed by auth_user_id -> auth.users(id), no tenant_id and no
-- membership user_id. on delete cascade is the documented opt-in to the Referential Action Standard
-- (a device/OTP/TOTP record has no meaning without its human; ADR-0012). Status codes plain text
-- (SPEC-030). No table carries updated_at, so there are no moddatetime triggers.

create table trusted_devices (
    id uuid primary key default gen_random_uuid(),
    auth_user_id uuid not null references auth.users (id) on delete cascade on update no action,
    device_identifier text not null,
    status_code text not null,
    first_seen_at timestamptz not null default now(),
    last_seen_at timestamptz not null default now(),
    verified_at timestamptz,
    revoked_at timestamptz,
    created_at timestamptz not null default now()
);

create table otp_challenges (
    id uuid primary key default gen_random_uuid(),
    auth_user_id uuid not null references auth.users (id) on delete cascade on update no action,
    status_code text not null,
    sent_to_email text not null,
    expires_at timestamptz not null,
    verified_at timestamptz,
    failed_attempts integer not null default 0,
    created_at timestamptz not null default now()
);

create table totp_enrollments (
    id uuid primary key default gen_random_uuid(),
    auth_user_id uuid not null references auth.users (id) on delete cascade on update no action,
    is_active boolean not null default true,
    enrolled_at timestamptz not null default now(),
    revoked_at timestamptz,
    created_at timestamptz not null default now()
);

-- Indexes (30 Index Standard: the auth_user_id FK is the primary lookup path).
create index trusted_devices_auth_user_id_idx on trusted_devices (auth_user_id);
create index otp_challenges_auth_user_id_idx on otp_challenges (auth_user_id);
create index totp_enrollments_auth_user_id_idx on totp_enrollments (auth_user_id);
