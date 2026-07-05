# Authentication & Identity Principles

Version: 1.0
Status: Canonical
Purpose: Foundational principles

---

# Why this document exists

This document defines the small set of principles that every authentication-, identity-, and security-related decision in ORVION must follow. It is **not** a specification and **not** an implementation plan. It does not restate `20_authentication_security_model.md` (login flows, role requirements, device-trust fields) or `31_schema_draft.md` (table columns); those remain the detailed sources.

Its role is to answer a single recurring question before any schema or code is written:

> **"Which principle owns this responsibility?"**

When the owning principle is clear, the schema and the enforcement layer become a natural consequence rather than the starting point.

---

# Core Principles

## 1. Human Identity

A human being has exactly one identity across the entire platform. That identity is `auth.users` (Supabase Auth). It is global, tenant-independent, and owns everything that proves *who the person is*: credentials, verified email/phone, trusted devices, and MFA enrolment.

## 2. Tenant Membership

A membership is one human's participation in one tenant. It is the `users` row, unique per `(tenant_id, auth_user_id)`. It owns everything that describes *what the person may do inside that tenant*: role, permissions, department/branch, and operational ownership. One human may hold several memberships; each is a distinct `users` row over the same Human Identity.

## 3. Authentication

Authentication proves the human (Principle 1). It happens **before any tenant is chosen** and therefore belongs to the Human Identity, never to a membership. A person authenticates once as themselves, not once per company.

## 4. Authorization

Authorization decides what a membership may do inside a tenant. It belongs to Tenant Membership (Principle 2) and the RBAC tables. Authentication answers "who are you"; authorization answers "what may this membership do here." They are never conflated.

## 5. Session Ownership

A session belongs to the Human Identity. The **active tenant** is a selection *within* that session, not a property of it. Switching tenants does not re-authenticate the human; it re-resolves the active membership.

## 6. Trusted Devices

Device trust is established during authentication and is therefore a property of the Human Identity (Principle 1), not of any membership. A person who trusts a device trusts it as themselves — it must not require re-trusting once per tenant.

## 7. MFA / OTP / TOTP

The **secret and the enrolment** (authenticator app, email-OTP capability) belong to the Human Identity. The **requirement** to present a factor may be tenant- and role-driven (e.g. a Finance Manager role mandates TOTP). The artifact is global to the human; the policy that triggers it is scoped to the membership. These two must never be collapsed into one table.

## 8. Tenant Selection

After authentication, the human selects an active tenant from the memberships their Human Identity holds. With a single membership the selection is implicit; with several it is explicit and drives Membership Resolution.

## 9. Membership Resolution

Every authorization check resolves `auth.uid()` (Human Identity) plus the active tenant to exactly one `users` membership. When the human holds one membership this degrades to that membership automatically. RLS and application authorization both depend on this resolution and never on the raw `auth.users` id alone.

## 10. Platform Security

Some security concerns exist above any tenant: platform administration, cross-tenant operations, and platform-level events. These are represented with a **null tenant context** (e.g. `tenant_id` nullable on `events`/`security_events`) and are owned by the platform, not by a tenant.

## 11. Global vs Tenant-scoped Security

Authentication artifacts (trusted devices, OTP challenges, TOTP enrolments) are **global to the human**. Security *audit* records may be **either** platform-level or tenant-scoped, which is why their tenant reference is nullable. The rule of thumb: if a record proves *who the human is*, it is global; if it records *what happened inside a tenant*, it is tenant-scoped.

## 12. Security Audit Philosophy

Security events form an append-only history of authentication and authorization activity. They are never physically deleted (consistent with `30_database_conventions.md` and `20_authentication_security_model.md`). Their tenant reference is nullable so platform-level and tenant-level security history share one immutable log.

---

# How to apply these principles

For any new authentication/identity/security element, decide ownership **before** schema:

1. Does it prove *who the human is*? → Human Identity (`auth.users`); key by `auth_user_id`; no `tenant_id`.
2. Does it describe *what a person may do inside a tenant*? → Tenant Membership (`users`); tenant-scoped.
3. Is it a *policy or requirement* that varies by role? → belongs to RBAC/membership, separate from the artifact it governs.
4. Is it a *security audit record*? → append-only log with nullable tenant context (Principle 12).

# Direct consequence for the schema (informative)

Applying Principles 1, 6, and 7, the authentication support tables (`trusted_devices`, `otp_challenges`, `totp_enrollments`) belong to the Human Identity. They are keyed by `auth_user_id` referencing `auth.users(id)` and carry **no** `tenant_id` and no membership `user_id`. The requirement to use a factor remains role-driven through RBAC (Principle 7), independent of where the artifact is stored. This is the model `31_schema_draft.md` section 9 and `33_sql_migration_plan.md` migration 16 implement; RLS for these tables (migration 19) is simply row-ownership by `auth.uid()`, with no tenant scoping.

End of Document.
