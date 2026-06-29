# Open Decisions Before Database Design

Version: 0.1
Status: Resolved
Canonical: Yes

---

# Purpose

These decisions were resolved by the Product Owner before creating the first database schema.

They affect tables, relationships, permissions, constraints, and workflow logic.

---

# Resolution Output Files

Resolved decisions were applied to:

- 12_lead_statuses_and_rules.md
- 13_booking_statuses_and_rules.md
- 14_finance_rules.md
- 17_saas_plan_matrix.md
- 20_authentication_security_model.md
- 21_offline_conversion_engine.md

---

# 1. Lead Closure Reasons

Resolved decision:

Define the official closure reasons for leads.

Approved values:

- booked
- postponed
- price_rejected
- no_response
- duplicate
- spam
- invalid_contact
- not_interested
- service_unavailable
- competitor
- customer_cancelled
- converted_customer
- other
Decision: approved with added values.

---

# 2. Booking Item Service-Specific Statuses

Resolved decision:

Define whether ticket, hotel, visa, package, and custom service items share one base status set or each has additional statuses.

Approved approach:

Use one shared base lifecycle for MVP, then add service-specific sub-status later.
Decision: approved.

MVP uses one shared base lifecycle:

- draft
- pending
- confirmed
- in_progress
- completed

Each service may have service-specific sub-status values.

---

# 3. Finance Lite Definition

Resolved decision:

Define exactly what Professional plan Finance Lite includes and excludes.

Approved include:

- Customer receivables
- Supplier payables
- Invoices
- Receipts
- Payments
- Basic journal entries
- Basic profit by booking item
- Refunds
- Outstanding balance

Approved exclude:

- Advanced financial statements
- Complex closing periods
- Advanced asset depreciation
- Advanced tax automation
- Advanced multi-currency revaluation
- Consolidation
Decision: approved with refunds included.

---

# 4. Cost Visibility

Resolved decision:

Sales can enter cost, but who can see and edit cost later?

Approved rule:

Sales can enter cost for their assigned booking item.

After finance approval, cost edits require finance or management permission.
Decision: approved with stricter edit lock.

Sales enters initial cost.

After finance approval, cost is locked.

After locking, only Owner, CEO, and Finance Manager can edit cost.

Operations cannot edit cost.

---

# 5. Risk Flag Approval

Resolved decision:

Who can allow issuing before full customer collection?

Original suggested roles:

- CEO
- Owner
- Branch Manager
- Finance Manager

Department Manager may be optional depending on company policy.
Decision: use permission-based control.

Default allowed roles:

- Owner
- CEO
- Finance Manager
- Branch Manager

Department Manager does not receive this authority by default.

Permission name:

- ALLOW_ISSUE_WITH_NEGATIVE_BALANCE

---

# 6. Plan Numeric Limits

Resolved decision:

Define first numeric limits for each plan.

Approved dimensions:

- Users
- Branches
- Monthly leads
- Monthly bookings
- Storage
- Active automations
- API access
Decision: initial plan limits approved.

| Feature | Starter | Professional | Enterprise |
| --- | --- | --- | --- |
| Users | 5 | 15 | Unlimited |
| Branches | 1 | 3 | Unlimited |
| Monthly Leads | 500 | 10,000 | Unlimited |
| Monthly Bookings | 100 | 3,000 | Unlimited |
| Storage | 2 GB | 5 GB | Custom |
| Automations | 5 | 100 | Unlimited |
| API | No | Read Only | Full |

---

# 7. Authentication Model

Resolved decision:

Confirm whether login uses:

- Phone + password + email OTP
- Email + password + email OTP
- Phone OTP only
- Authenticator app for platform owner actions

This affects identity tables and security flows.
Decision: hybrid authentication model.

Normal user:

- Phone
- Password
- Email OTP for first new device

High-risk roles:

- Owner
- CEO
- Finance Manager
- System Administrator

High-risk roles require Authenticator App TOTP, not email OTP.

---

# 8. Call Tracking Ownership

Resolved decision:

Decide whether ORVION will provide its own tracking numbers or only receive call tracking data from Google/third-party systems.

This affects integration complexity and cost.
Decision: ORVION should not depend on Google Forwarding Numbers as the primary model.

ORVION CRM becomes the source of truth for qualified call and sales outcomes.

Add Offline Conversion Engine to Analytics layer.
