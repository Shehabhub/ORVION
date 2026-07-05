# Tenant Isolation & Data Access Principles

Version: 1.0
Status: Canonical
Purpose: Foundational principles

---

# Why this document exists

This document consolidates the tenant-isolation and data-access decisions that already exist — scattered across ADR-0011, `30_database_conventions.md` (Tenant Scope Standard and Identity Key Standard), and `31_schema_draft.md` `# 13. Review Required` item 3 — into execution-ready principles for Migration 19 (RLS). It is **not** a specification: the RLS policy bodies and the resolution function belong to Migration 19. It answers only the architectural questions Migration 19 genuinely depends on, using the same recurring question as the auth principles (`34`):

> **"Which principle owns this responsibility?"**

Nothing here re-opens a settled decision. Each principle either restates an existing authority (cited) or adds a derivable engineering recommendation (marked).

---

# Principles

## 1. Tenant Isolation Philosophy

Isolation is **default-deny and database-enforced**, never trusted to the application. Every tenant-owned table carries `tenant_id uuid not null references tenants(id)` (`30` Tenant Scope Standard); access to its rows is confined to the caller's resolved tenant.

- **Finding:** because the Tenant Scope Standard already guarantees that column on every tenant-owned table, RLS has a single uniform predicate (`tenant_id = <resolved tenant>`) — no per-table special-casing for the common case.

## 2. Membership Resolution

The caller is a **human** (`auth.uid()` = `auth.users`). Authorization resolves through **one `SECURITY DEFINER` lookup against ORVION RBAC** (`users`, `user_role_assignments`, `roles`, `permissions`, `role_permissions`) — **never through JWT claims** (`31 §13` item 3; `30` Identity Key Standard). The JWT is authentication-only. Resolution maps `auth.uid()` + the active tenant to the membership: the `users` row where `auth_user_id = auth.uid()` and `tenant_id` = the active tenant.

## 3. Active Tenant Context

A human may hold several memberships. **MVP degrades to the single active membership** (ADR-0011: active-tenant plumbing is wired only when multi-membership UX ships).

- **Recommendation:** the resolution function reads an *optional* session setting for the active tenant; if it is set **and** the caller is a member of that tenant, use it; else if the caller has exactly **one** active membership, use it; else resolve to none (deny). MVP never sets the value, so it always uses the single membership. When multi-membership UX ships, an application-set, membership-validated session value activates the multi-tenant path **without changing any table policy**.
- **Engineering preference:** a session setting (`set_config`) over a JWT claim — consistent with the no-JWT-claims-for-authorization ruling. (Alternative: strict single-membership now, deny if more than one, add everything later. Equally correct; the recommended form is marginally more forward-compatible at near-zero cost.)

## 4. RLS Interaction

**Every table policy references one resolution primitive** — a helper that returns the caller's authorized tenant (or a boolean membership check) — so the resolution mechanism can evolve in exactly one place.

- **Recommendation (the key rework-prevention decision):** table policies must not inline `auth.uid()` logic. They call the primitive. Adding active-tenant plumbing, an SSO provider, or a role check later then touches **one function, not ~70 policies**.
- **Engineering preference:** resolution/helper functions are `SECURITY DEFINER` and live in a **non-API schema** (not `public`, which Supabase exposes), so they cannot be called or bypassed by clients.
- Global system tables (no `tenant_id`, per Tenant Scope Standard) receive **read-all-for-authenticated** policies; writes are platform-controlled.

## 5. Cross-Tenant Behavior

Default: **no cross-tenant read or write.** The only shared-read data are the global tables — catalog *system* rows, `currencies`/`countries`/`languages`/`nationalities`, `roles`/`permissions`, `subscription_plans`/`feature_entitlements` — readable by all authenticated callers, writable only by the platform.

- **Finding:** `catalog_values` mixes global (`tenant_id null`, `is_system`) and tenant rows, so its read policy is the one deliberate exception: **readable when `tenant_id is null` OR `tenant_id` = resolved tenant**; tenant rows otherwise follow standard isolation. (This is the "careful constraints" `31 §13` item 2 anticipated.)

## 6. Platform Administration & Support Access

Backend and platform operations use the Supabase **`service_role`, which bypasses RLS by design**; end-user clients use the `authenticated` role and are always tenant-isolated. Platform-level support access is therefore a **backend concern (service role)**, not a per-table RLS policy and not a cross-tenant path for end users.

- **Future consideration:** a first-class in-app platform-admin identity and its audit trail are **not required for MVP RLS** and there is no schema evidence demanding them now. Revisit only if in-app cross-tenant support tooling is built.

## 7. Audit Behavior

Security and event logs are **append-only**: RLS permits `INSERT` and tenant-scoped `SELECT`, and **forbids `UPDATE`/`DELETE`** (by omitting those policies, backed by a restrictive trigger for defence in depth). `tenant_id` is nullable on `events`/`security_events` for platform-level entries, which are readable only by the platform.

- **Recommendation:** enforce event immutability in the database at Migration 19, closing the standing Future-Backlog item ("DB-enforced event immutability").

## 8. Future Compatibility

- **Subscription-state gating** (`read_only` / `suspended` / `grace_period`) is a **distinct concern from tenant isolation** and must not be conflated with it. **Finding:** two "is this tenant active?" sources exist — `tenants.status` and `subscriptions.subscription_status_code`. **Recommendation:** the authority for *access* gating is the subscription state; handle read-only/suspended enforcement at the service layer for MVP, or later as a separate RLS predicate routed through the same resolution layer — decided at implementation, not here.
- **Deferred F2 FKs** (`catalog_values.tenant_id`, `catalog_values.created_by`) should land **before or with** Migration 19 for referential integrity of the tenant column RLS depends on. **Recommendation:** a small ALTER migration precedes RLS.
- Adding multi-membership active-tenant plumbing later touches only the resolution function (Principles 3–4), by design.

---

# How to apply these principles (Migration 19)

For any table's RLS, ask which case it is:

1. **Global** (no `tenant_id`) → read-all-for-authenticated; platform-only write.
2. **Tenant-owned** → isolate through the single resolution primitive (`tenant_id` = resolved tenant).
3. **`catalog_values`** → readable when `tenant_id is null` OR = resolved tenant; tenant writes isolated.
4. **Append-only audit** (`events`, `security_events`) → `INSERT` + tenant-scoped `SELECT`; no `UPDATE`/`DELETE`.
5. Authorization is **never** encoded in JWT claims; it resolves through the RBAC lookup.

# Genuinely unresolved questions

**None that block Migration 19.** The tenant-isolation architecture is pre-settled (ADR-0011; `30` Tenant Scope + Identity Key Standards; `31 §13` item 3). The only open mechanism — active-tenant context — is resolved by the degrade-now / plumb-later recommendation (Principle 3), consistent with ADR-0011. Implementation may proceed.

End of Document.
