-- Migration: add_catalog_values_deferred_fks
-- Plan reference: closes SPEC-024 Finding F2 (deferred catalog_values foreign keys)
-- catalog_values.tenant_id and catalog_values.created_by were created as plain nullable uuid columns
-- in migration 2 because their targets (tenants, users) did not yet exist. Both targets are now live,
-- so the foreign keys are added here per the Referential Action Standard (on delete restrict on
-- update no action). Nullable columns: system catalog rows keep tenant_id/created_by null and remain
-- valid. This lands before Migration 19 so the tenant_id column that RLS depends on has integrity
-- (35_tenant_isolation_and_data_access_principles.md, Future Compatibility).

alter table catalog_values
    add constraint catalog_values_tenant_id_fkey
        foreign key (tenant_id) references tenants (id) on delete restrict on update no action,
    add constraint catalog_values_created_by_fkey
        foreign key (created_by) references users (id) on delete restrict on update no action;
