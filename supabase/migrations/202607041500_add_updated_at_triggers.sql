-- Migration: add_updated_at_triggers
-- Plan reference: SPEC-027 Finding F1 (retrofit) — precedes migration 4.
-- Enables the moddatetime extension (30_database_conventions.md Timestamp Standard,
-- recommended mechanism) and adds before-update triggers so updated_at advances on
-- every update for the existing updated_at tables.
--
-- catalog_types is intentionally excluded: it has no updated_at column
-- (31_schema_draft.md section 1; SPEC-024 Finding F3).

create extension if not exists moddatetime;

create trigger catalog_values_set_updated_at
    before update on catalog_values
    for each row execute function moddatetime(updated_at);

create trigger currencies_set_updated_at
    before update on currencies
    for each row execute function moddatetime(updated_at);
