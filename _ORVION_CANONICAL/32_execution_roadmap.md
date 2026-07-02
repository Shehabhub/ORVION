# ORVION Execution Roadmap

Version: 0.1
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

Status: Pending

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

Do not begin until Phase 1 is reviewed.

---

# Phase 3: Identity And Access

Status: Pending

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

Status: Pending

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

Status: Pending

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

Status: Pending

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

Status: Pending

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

Create SQL migration plan.

This is the first required document in the database foundation package.
