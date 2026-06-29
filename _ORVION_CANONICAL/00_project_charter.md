# ORVION Project Charter

Version: 0.1
Status: Draft
Owner: Product Owner
Domain: Travel and Tourism Operations
Canonical: Yes

---

# Product Identity

ORVION is a SaaS operating system for travel and tourism companies.

The product is built specifically for companies that receive, process, sell, book, document, and financially settle travel services such as:

- Flight tickets
- Hotels
- Visas
- Full travel programs containing ticket, hotel, visa, and related services

ORVION is not a generic CRM. CRM is one module inside a complete travel business operating system.

---

# Core Objective

The system must manage the full operational journey from first customer request to final booking, payment, accounting follow-up, documents, notifications, and management reporting.

The system must prevent:

- Random implementation decisions
- Duplicate customer records
- Employee-created dropdown values
- Hidden business rules
- Untracked edits
- Unclear ownership
- Uncontrolled plan changes during implementation

---

# Primary Business Flow

1. A lead is received from one of the approved acquisition channels.
2. The lead is assigned to a sales employee or queue.
3. If the lead is not handled within 15 minutes, an alert is sent to the employee and their manager.
4. If another 15 minutes pass without handling, the lead is reassigned to another employee.
5. The sales team qualifies the request and collects customer data.
6. The request becomes a quotation, booking, or full travel package depending on customer need.
7. Operations complete supplier coordination, booking, ticketing, visa, hotel, or package execution.
8. Documents are attached and linked to the correct customer, booking, passenger, invoice, or supplier.
9. Finance tracks receivables, payables, profit, supplier balances, customer balances, and company assets.
10. Every meaningful action creates an immutable event.

---

# Lead Sources

Approved lead sources include:

- Google Ads click-to-call
- Direct phone call
- WhatsApp message
- Website form
- Manual entry by authorized staff

The phone and WhatsApp intake number may be the same number.

---

# Company Departments

ORVION must support the work of:

- Sales
- CRM
- Booking and operations
- Finance and accounting
- Management
- Customer service
- Administration
- Asset management

---

# SaaS Model

ORVION will be hosted online as a multi-tenant SaaS product.

Each subscribed company is isolated from other companies.

Each company may have multiple branches.

Each branch is operationally separated from other branches according to permissions and company policy.

Subscription plans define which modules, features, tables, limits, and capabilities are available.

Subscription renewal payment is submitted by uploading a PDF or image proof of bank transfer.

If a subscription is suspended, users may continue to access the system in read-only mode, but cannot edit existing business data until subscription access is restored.

---

# Integration Targets

Planned integrations include:

- Supabase
- n8n
- Meta WhatsApp API
- Google Tag Manager
- Google Ads
- Meta Ads
- AI dashboard

---

# Non-Negotiable Principles

- Every important action is recorded as an event.
- Events are immutable and must not be deleted.
- Customer duplication must be prevented through identity matching rules.
- Dropdown values must be predefined and governed.
- Employees must not invent uncontrolled values inside operational forms.
- Documents must be linked to business entities and retrievable later.
- Permissions must be explicit and layered.
- Accounting must cover practical company needs without becoming an over-expanded ERP.
- The first implementation must be practical, phased, and usable.

