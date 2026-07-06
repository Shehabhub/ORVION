-- Migration: seed_role_permissions
-- Phase 3 (Identity & Access). Seeds role_permissions from 28_permissions_matrix.md per ADR-0015
-- (binary role_permissions; scope/conditional/plan enforced at point-of-use).
-- Rule: one row only where the role's matrix cell is a strict "Yes". Every conditional/narrowed cell
-- (Optional, Assigned only, Limited, Own/Branch/Department only, Finance related, Assigned related only)
-- and every plan-only column (API) and "No" cell produces NO row; those are added by the capability
-- CR that builds their enforcement. Idempotent on (role_id, permission_id).
--
-- Provenance: role sets below are transcribed directly from 28_permissions_matrix.md. Roles omitted
-- from a table (e.g. finance_manager in CRM, system_administrator outside Organization/Subscription)
-- have no cell there and thus no grant. system_administrator's cells are all "Optional" -> zero rows.

insert into role_permissions (role_id, permission_id)
select r.id, p.id
from (values
    -- CRM
    ('CREATE_LEAD',                array['owner','ceo','branch_manager','department_manager','senior_employee','employee']),
    ('ASSIGN_LEAD',                array['owner','ceo','branch_manager','department_manager']),
    ('REASSIGN_LEAD',              array['owner','ceo','branch_manager','department_manager']),
    ('CLOSE_LEAD',                 array['owner','ceo','branch_manager','department_manager','senior_employee']),
    ('VIEW_ASSIGNED_LEADS',        array['owner','ceo','branch_manager','department_manager','senior_employee','employee']),
    ('VIEW_DEPARTMENT_QUEUE',      array['owner','ceo','branch_manager','department_manager']),
    ('CREATE_CUSTOMER',            array['owner','ceo','branch_manager','department_manager','senior_employee','employee']),
    ('MERGE_CUSTOMER_IDENTITY',    array['owner','ceo']),
    -- CRM extension
    ('CREATE_TASK',                array['owner','ceo','branch_manager','department_manager','senior_employee','employee']),
    ('ASSIGN_TASK',                array['owner','ceo','branch_manager','department_manager']),
    ('COMPLETE_TASK',              array['owner','ceo','branch_manager','department_manager','senior_employee']),
    ('VIEW_ASSIGNED_TASKS',        array['owner','ceo','branch_manager','department_manager','senior_employee','employee']),
    ('VIEW_DEPARTMENT_TASK_QUEUE', array['owner','ceo','branch_manager','department_manager']),
    ('CREATE_COMPLAINT',           array['owner','ceo','branch_manager','department_manager','senior_employee','employee']),
    ('RESOLVE_COMPLAINT',          array['owner','ceo','branch_manager','department_manager','senior_employee']),
    ('VIEW_COMPLAINT',             array['owner','ceo','branch_manager','department_manager','senior_employee']),
    ('CREATE_SERVICE_REQUEST',     array['owner','ceo','branch_manager','department_manager','senior_employee','employee']),
    ('RESOLVE_SERVICE_REQUEST',    array['owner','ceo','branch_manager','department_manager','senior_employee']),
    ('VIEW_SERVICE_REQUEST',       array['owner','ceo','branch_manager','department_manager','senior_employee']),
    ('CREATE_QUOTATION',           array['owner','ceo','branch_manager','department_manager','senior_employee']),
    ('SEND_QUOTATION',             array['owner','ceo','branch_manager','department_manager','senior_employee']),
    ('ACCEPT_QUOTATION',           array['owner','ceo','branch_manager','department_manager','senior_employee']),
    ('VIEW_CONVERSATION',          array['owner','ceo','branch_manager','department_manager','senior_employee']),
    ('SEND_MESSAGE',               array['owner','ceo','branch_manager','department_manager','senior_employee']),
    ('ESCALATE_CONVERSATION',      array['owner','ceo','branch_manager','department_manager']),
    ('CLOSE_CONVERSATION',         array['owner','ceo','branch_manager','department_manager','senior_employee']),
    -- Booking
    ('CREATE_BOOKING',             array['owner','ceo','branch_manager','department_manager','senior_employee']),
    ('CREATE_BOOKING_ITEM',        array['owner','ceo','branch_manager','department_manager','senior_employee']),
    ('UPDATE_BOOKING_ITEM_STATUS', array['owner','ceo','branch_manager','department_manager','senior_employee']),
    ('ASSIGN_SUPPLIER',            array['owner','ceo','branch_manager','department_manager','senior_employee']),
    ('ENTER_SELLING_PRICE',        array['owner','ceo','branch_manager','department_manager','senior_employee']),
    ('ENTER_COST',                 array['owner','ceo','branch_manager','department_manager','senior_employee']),
    ('ALLOW_ISSUE_WITH_NEGATIVE_BALANCE', array['owner','ceo','branch_manager','finance_manager']),
    -- Finance (owner/ceo/finance_manager strict-Yes; branch_manager Optional -> no row)
    ('APPROVE_FINANCE',                 array['owner','ceo','finance_manager']),
    ('EDIT_LOCKED_COST',                array['owner','ceo','finance_manager']),
    ('SET_EXCHANGE_RATE',               array['owner','ceo','finance_manager']),
    ('CREATE_EXCHANGE_RATE_ADJUSTMENT', array['owner','ceo','finance_manager']),
    ('VIEW_FINANCIAL_DOCUMENTS',        array['owner','ceo','finance_manager']),
    ('CREATE_INVOICE',                  array['owner','ceo','finance_manager']),
    ('CREATE_RECEIPT',                  array['owner','ceo','finance_manager']),
    ('RECORD_PAYMENT',                  array['owner','ceo','finance_manager']),
    ('RECORD_REFUND',                   array['owner','ceo','finance_manager']),
    ('CREATE_JOURNAL_ENTRY',            array['owner','ceo','finance_manager']),
    ('REVIEW_APPROVAL_REQUEST',         array['owner','ceo','finance_manager']),
    -- Document
    ('UPLOAD_DOCUMENT',          array['owner','ceo','branch_manager','department_manager','finance_manager','senior_employee']),
    ('VIEW_TRAVEL_DOCUMENTS',    array['owner','ceo','branch_manager','department_manager','senior_employee']),
    ('ARCHIVE_DOCUMENT',         array['owner','ceo','branch_manager','department_manager','finance_manager']),
    ('CREATE_DOCUMENT_VERSION',  array['owner','ceo','branch_manager','department_manager','finance_manager','senior_employee']),
    -- Marketing
    ('MANAGE_MARKETING_CAMPAIGN', array['owner','ceo']),
    ('VIEW_MARKETING_DASHBOARD',  array['owner','ceo']),
    -- Organization
    ('MANAGE_TENANT_SETTINGS', array['owner','ceo']),
    ('MANAGE_BRANCHES',        array['owner','ceo']),
    ('MANAGE_DEPARTMENTS',     array['owner','ceo']),
    ('MANAGE_USERS',           array['owner','ceo']),
    ('MANAGE_ROLES',           array['owner','ceo']),
    ('MANAGE_PERMISSIONS',     array['owner','ceo']),
    ('VIEW_ALL_BRANCHES',      array['owner','ceo']),
    ('VIEW_BRANCH_DATA',       array['owner','ceo']),
    -- Subscription (MANAGE_SUBSCRIPTION Limited, REVIEW_SUBSCRIPTION_PAYMENT platform-only -> no rows)
    ('VIEW_SUBSCRIPTION_STATUS', array['owner','ceo'])
    -- API permissions (ACCESS_API_READ_ONLY/ACCESS_API_FULL) are plan-gated with no role "Yes" -> no rows.
) as m(perm_key, role_codes)
cross join lateral unnest(m.role_codes) as rc(code)
join public.permissions p on p.key = m.perm_key
join public.roles r on r.code = rc.code
on conflict (role_id, permission_id) do nothing;
