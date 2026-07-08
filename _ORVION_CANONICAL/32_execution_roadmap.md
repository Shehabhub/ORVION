# ORVION Execution Roadmap

Version: 0.2
Status: Draft
Canonical: Yes

---

# Purpose

This roadmap defines how ORVION should move from canonical documentation to implementation.

The project owner reviews decisions.

Codex drives structure, sequencing, and implementation work.

---

# Working Principle

The project should move in small controlled packages.

Each package must produce a concrete output.

No package should attempt to solve the entire product.

---

# Phase 0: Canonical Foundation

Status: Complete

Outputs:

- Product charter
- MVP scope
- Company structure
- Lead lifecycle
- Customer identity
- Booking model
- Finance model
- Document model
- SaaS plan model
- Notification model
- Authentication model
- Offline conversion engine
- Codex constitution
- Manifest
- Daily working prompt

---

# Phase 1: Database-Ready Specification

Status: Complete

Objective:

Prepare the database specification without writing SQL.

Outputs:

- Entity registry
- Catalog registry
- State machines
- Event catalog
- Permissions matrix
- Relationship map
- Database conventions
- Schema draft

Owner review required:

- Entity registry
- Catalog registry
- State machines
- Schema draft

---

# Phase 2: Database Foundation

Status: Complete

Objective:

Create the first Supabase/PostgreSQL database foundation.

Outputs:

- SQL migrations
- Core tables
- Catalog seed data
- RLS baseline
- Audit/event tables
- Basic indexes
- Database verification checklist

Delivered: migrations 1-20 (SPEC-022 through SPEC-053); 71 tables, 65 catalog types / 395 catalog values, 76 RLS policies, append-only audit, and an executable verification smoke-test (`scripts/verify_database.sql`).

---

# Backend Architecture (applies to Phases 3-10)

Supabase-native-first, per ADR-0014: PostgREST + RLS + PostgreSQL functions (RPC) as the backbone; Edge Functions + pg_cron/pg_net + n8n for out-of-database compute; a server-rendered web app (`@supabase/ssr`) and future mobile/API clients on the same Supabase surface; no standalone backend service unless a concrete capability provably requires one. Phases 3-10 are executed capability-by-capability under the CR lifecycle ("small controlled packages"); no separate per-phase implementation-plan document is authored unless a phase's complexity earns it.

---

# Phase 3: Identity And Access

Status: Complete

Objective:

Implement tenant, user, role, permission, branch, department, and authentication foundation.

Outputs:

- Tenant management
- User accounts
- Branch/department assignment
- Role/permission assignment
- TOTP requirements for high-risk roles
- Device trust baseline

---

# Phase 4: CRM Core

Status: Complete

Objective:

Implement lead and customer flow.

Outputs:

- Lead intake
- Round-robin assignment
- Lead SLA escalation
- Customer identity matching
- Lead closure
- Lead-to-customer link
- Lead-to-booking preparation

---

# Phase 5: Booking Core

Status: Complete

Objective:

Implement booking and booking item workflows.

Outputs:

- Booking creation
- Booking item creation
- Passenger linkage
- Supplier linkage
- Item lifecycle
- Finance approval gate
- Risk flag for negative balance issuance

---

# Phase 6: Finance Core

Status: Complete

Delivered: `app.customer_balance` + `app.supplier_balance` + `app.booking_item_profit` (derived read primitives); invoice create/issue, `record_payment` (allocation + status), `issue_receipt`, `record_supplier_payment`, customer refund workflow (`record_refund`/`advance_refund`), and basic journal entries + default chart of accounts (SPEC-089, SPEC-100–108). The finance-approval execution gate landed in Phase 5 (ADR-0020).

Objective:

Implement practical finance workflows.

Outputs:

- Customer receivables
- Supplier payables
- Payments
- Receipts
- Invoices
- Refunds
- Basic journal entries
- Profit per booking item
- Outstanding balance

---

# Phase 7: Documents

Status: Active

Objective:

Implement document upload, linkage, lifecycle, permissions, archive, and versioning.

Outputs:

- Document types
- Passenger documents
- Booking item documents
- Financial documents
- Expiry dates
- Archive
- Versioning

---

# Phase 8: Offline Conversion

Status: Pending

Objective:

Implement advertising outcome feedback.

Outputs:

- Click data capture
- Lead attribution
- CRM outcome mapping
- Internal conversion event
- Google Ads offline conversion delivery
- Delivery status and retry

---

# Phase 9: Reports And Dashboards

Status: Pending

Objective:

Implement useful operational visibility.

Outputs:

- Lead performance
- Sales activity
- Booking pipeline
- Finance outstanding balances
- Profit by booking item
- Subscription state

---

# Phase 10: Automation And Integrations

Status: Pending

Objective:

Implement controlled external automation.

Outputs:

- WhatsApp Cloud API
- n8n workflows
- GTM/GA4/Google Ads integrations
- Meta Conversions API
- Supabase Edge Functions

---

# Immediate Next Action

Phases 2–5 are complete (Database Foundation, Identity & Access, CRM Core, Booking Core including the finance-approval execution gate, ADR-0020). Execute Phase 6 (Finance Core) capability-by-capability on the Supabase-native architecture (ADR-0014), under the CR lifecycle. Natural first slice: a read-only, derived `app.customer_balance(...)` primitive (computed from invoices/payments/refunds, not stored) — the keystone that unblocks outstanding-balance reporting and the deferred negative-balance risk flag. Deferred items to fold in at their triggers: finance-gated booking-level transitions (Approve/Issue/Cancel/Refund/Reissue) with their capability permissions; the negative-balance risk flag; verifying attribution capture (`gclid`/`gbraid`/`wbraid` + consent) at lead intake before Phase 8. See `reports/future-backlog.md`.
