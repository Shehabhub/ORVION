-- Migration: seed_roles_and_permissions
-- Phase 3 (Identity & Access). Seeds the two flat global RBAC catalogs from 25_catalog_registry.md:
--   roles (role_code, 9 values) and permissions (permission_key, 66 values).
-- System rows only (is_system true, is_active true). name is a deterministic placeholder
-- (initcap of the code/key with underscores as spaces) pending localization.
-- Idempotent: on conflict on the natural keys (roles.code, permissions.key) do nothing, so
-- db reset / CI re-application never duplicates or errors.
--
-- Scope note: role_permissions is intentionally NOT seeded here. The permission matrix (28) is
-- scope-aware, conditional, and plan-gated -- semantics the binary role_permissions table cannot
-- express -- so how it realizes is a separate owner-level decision, out of scope for this migration.

-- Roles (role_code per 25). name is a deterministic placeholder.
insert into roles (code, name, is_system, is_active)
select r.code, initcap(replace(r.code, '_', ' ')), true, true
from (values
    ('owner'),
    ('ceo'),
    ('branch_manager'),
    ('department_manager'),
    ('finance_manager'),
    ('senior_employee'),
    ('employee'),
    ('trainee'),
    ('system_administrator')
) as r(code)
on conflict (code) do nothing;

-- Permissions (permission_key per 25). name is a deterministic placeholder.
insert into permissions (key, name, is_system, is_active)
select p.key, initcap(replace(p.key, '_', ' ')), true, true
from (values
    ('ALLOW_ISSUE_WITH_NEGATIVE_BALANCE'),
    ('MANAGE_TENANT_SETTINGS'),
    ('MANAGE_BRANCHES'),
    ('MANAGE_DEPARTMENTS'),
    ('MANAGE_USERS'),
    ('MANAGE_ROLES'),
    ('MANAGE_PERMISSIONS'),
    ('VIEW_ALL_BRANCHES'),
    ('VIEW_BRANCH_DATA'),
    ('VIEW_ASSIGNED_LEADS'),
    ('VIEW_DEPARTMENT_QUEUE'),
    ('CREATE_LEAD'),
    ('ASSIGN_LEAD'),
    ('REASSIGN_LEAD'),
    ('CLOSE_LEAD'),
    ('CREATE_CUSTOMER'),
    ('MERGE_CUSTOMER_IDENTITY'),
    ('CREATE_BOOKING'),
    ('CREATE_BOOKING_ITEM'),
    ('APPROVE_FINANCE'),
    ('EDIT_LOCKED_COST'),
    ('SET_EXCHANGE_RATE'),
    ('CREATE_EXCHANGE_RATE_ADJUSTMENT'),
    ('VIEW_FINANCIAL_DOCUMENTS'),
    ('UPLOAD_DOCUMENT'),
    ('ARCHIVE_DOCUMENT'),
    ('VIEW_ADVANCED_DASHBOARDS'),
    ('MANAGE_SUBSCRIPTION'),
    ('REVIEW_SUBSCRIPTION_PAYMENT'),
    ('ACCESS_API_READ_ONLY'),
    ('ACCESS_API_FULL'),
    ('UPDATE_BOOKING_ITEM_STATUS'),
    ('ASSIGN_SUPPLIER'),
    ('ENTER_SELLING_PRICE'),
    ('ENTER_COST'),
    ('CREATE_INVOICE'),
    ('CREATE_RECEIPT'),
    ('RECORD_PAYMENT'),
    ('RECORD_REFUND'),
    ('CREATE_JOURNAL_ENTRY'),
    ('VIEW_TRAVEL_DOCUMENTS'),
    ('CREATE_DOCUMENT_VERSION'),
    ('VIEW_SUBSCRIPTION_STATUS'),
    ('CREATE_TASK'),
    ('ASSIGN_TASK'),
    ('COMPLETE_TASK'),
    ('VIEW_ASSIGNED_TASKS'),
    ('VIEW_DEPARTMENT_TASK_QUEUE'),
    ('CREATE_COMPLAINT'),
    ('RESOLVE_COMPLAINT'),
    ('VIEW_COMPLAINT'),
    ('CREATE_SERVICE_REQUEST'),
    ('RESOLVE_SERVICE_REQUEST'),
    ('VIEW_SERVICE_REQUEST'),
    ('CREATE_QUOTATION'),
    ('SEND_QUOTATION'),
    ('ACCEPT_QUOTATION'),
    ('VIEW_CONVERSATION'),
    ('SEND_MESSAGE'),
    ('ESCALATE_CONVERSATION'),
    ('CLOSE_CONVERSATION'),
    ('MANAGE_MARKETING_CAMPAIGN'),
    ('VIEW_MARKETING_DASHBOARD'),
    ('REVIEW_APPROVAL_REQUEST')
) as p(key)
on conflict (key) do nothing;
