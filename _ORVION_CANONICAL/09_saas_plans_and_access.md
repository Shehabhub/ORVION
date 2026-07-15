# SaaS Plans And Access Model

Version: 0.1
Status: Draft
Canonical: Yes

> **Synchronization annotations (2026-07-15 Repository Recovery — no business change; these align prose to authoritative sources):**
> - **Plan names (C1):** the plan-family names below (Basic / Integrated / Complete) are **superseded by the authoritative names Starter / Professional / Enterprise**, which are the ones seeded and used in `17_saas_plan_matrix.md`, `14_finance_rules.md`, and the catalog seed (`202607043100`). Read the sections below by position (entry / mid / top tier); the seeded names govern implementation.
> - **Authentication prose (C3):** any authentication/OTP/login detail in this document predates and is **superseded by ADR-0017 (Supabase-native authentication)** and the cross-cutting principles in `34_authentication_and_identity_principles.md`. Where they differ, ADR-0017 / doc 34 govern.
> - **Activation-code idea & subscription grace/read-only mode (C4/C5):** these remain **undecided pending owner disposition** (recorded in the 2026-07-15 recovery findings) — neither adopted nor rejected here.

---

# Initial Plans

ORVION will launch with three initial plan families.

## Basic Plan

CRM-focused plan.

Expected scope:

- Lead management
- Customer records
- Basic follow-up
- Basic notifications
- Limited reporting

## Integrated Plan

Operational plan.

Expected scope:

- CRM
- Bookings
- Travel service items
- Documents
- Suppliers
- Finance core
- Operational workflows

## Complete Plan

Management and analytics plan.

Expected scope:

- Integrated Plan features
- Dashboards
- Analysis
- Monitoring
- Advanced reporting
- AI dashboard capabilities where approved

---

# Recommended Plan Limits

Plan limits should combine module access and usage limits.

Recommended controlled dimensions:

- Number of users
- Number of branches
- Enabled modules
- Monthly lead limit
- Monthly booking limit
- Storage limit
- Advanced dashboard access
- Automation access
- Integration access

This is a recommendation and must be reviewed before pricing is finalized.

---

# Subscription Expiry

After subscription expiry, the tenant has a two-day grace period.

After the grace period, the tenant enters read-only mode.

In read-only mode:

- Users can log in.
- Users can view permitted existing data.
- Users cannot edit business data.
- Users cannot create new leads, bookings, payments, or documents.
- System owner renewal actions remain available where required.

---

# Renewal Payment

Subscription renewal payment is submitted by uploading proof of bank transfer as PDF or image.

The platform owner reviews the proof and activates renewal.

---

# Activation Code Idea

An activation code flow is under consideration.

Possible model:

- Platform owner receives renewal proof.
- System generates or requests a time-sensitive activation code.
- Platform owner provides the code to the tenant admin.
- Tenant admin enters the code to activate renewal.

This requires security review before implementation.

---

# User Authentication

User login identity may be linked to phone number.

Login flow under consideration:

- User enters phone/user ID and password.
- System sends OTP to email after password validation.
- User enters OTP to complete login.

Password changes are controlled by higher-authority users according to permission policy.

This requires detailed security design before implementation.

