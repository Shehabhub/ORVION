# ORVION Project Manifest

Version: 2.0
Status: Canonical
Purpose: AI Entry Point
Loaded After: AGENTS.md

---

# Purpose

This document tells Codex where the project currently stands.

Its purpose is to minimize token usage.

Codex should never scan the entire repository.

Instead, read this document first, then load only the required files.

This file should always reflect the current state of the project.

---

# Project

Name: ORVION

Type: CRM & Operations System

Industry: Egyptian Travel Agencies

Target Users:

- Travel Agency Owners
- Sales Team
- Customer Service
- Ticketing Staff
- Operations
- Finance

---

# Project Goal

Build a practical business system that helps Egyptian travel agencies manage their daily operations.

The project is not intended to become an ERP.

The project is not intended to solve every business problem.

The goal is to automate the daily work that happens inside a travel agency.

---

# Current Development Status

Update this section continuously.

Current Phase: Database Foundation

Current Sprint: SQL migration authoring

Current Module: Database Foundation

Current Task: Repository Engineering — next dependency-ready packages: Package 5 (Compatibility Adapters, ready now that SPEC-018 is Complete) and Package 6 (Repository Index & Health, now meaningfully draftable); see reports/repository-engineering-program.md for the full program table

Last Completed Task: SPEC-015 (CR_LIFECYCLE.md Engineering Observations), SPEC-016 (Program Plan report), SPEC-017 (AGENTS.md refinements), SPEC-018 (Entry Point & Reading List)

Next Planned Task: Write SQL migrations per 33_sql_migration_plan.md's sequence

Active Change Request: None

---

# Development Roadmap

The order below represents the preferred implementation order.

1. Foundation
2. Identity
3. CRM
4. Conversations
5. Booking
6. Passengers
7. Payments
8. Revenue
9. Offline Conversion
10. Reports
11. Automation
12. Workflow Engine
13. Administration

Codex should not skip forward unless instructed.

---

# Module Status

| Module | Status |
| --- | --- |
| Foundation | Complete |
| Identity | Complete |
| CRM | In Progress |
| Conversations | Pending |
| Booking | Pending |
| Passengers | Pending |
| Payments | Pending |
| Revenue | Pending |
| Offline Conversion | In Progress |
| Reports | Pending |
| Workflow Engine | Pending |
| Administration | Pending |

Update this table after major milestones.

---

# Reference Documents

The following documents are considered canonical.

Always load them when needed.

Core:

- codex.md
- manifest.md
- SYSTEM_PROMPT.md

Architecture:

- 00_project_charter.md
- 01_mvp_scope.md
- 03_company_structure.md
- 06_booking_and_travel_products.md
- 22_database_ready_gap_analysis.md
- 23_database_ready_package_plan.md
- 24_entity_registry.md
- 25_catalog_registry.md
- 26_state_machines.md
- 27_event_catalog.md
- 28_permissions_matrix.md
- 29_relationship_map.md
- 30_database_conventions.md
- 31_schema_draft.md
- 32_execution_roadmap.md

Business Rules:

- 04_lead_lifecycle.md
- 05_customer_identity.md
- 12_lead_statuses_and_rules.md
- 13_booking_statuses_and_rules.md
- 14_finance_rules.md
- 15_permissions_roles.md
- 16_document_types_and_rules.md
- 17_saas_plan_matrix.md
- 18_integration_priority.md
- 19_open_decisions_before_database.md

Security:

- 20_authentication_security_model.md
- 24_entity_registry.md
- 25_catalog_registry.md
- 26_state_machines.md
- 27_event_catalog.md
- 28_permissions_matrix.md
- 29_relationship_map.md
- 30_database_conventions.md
- 31_schema_draft.md

Analytics:

- 21_offline_conversion_engine.md

---

# Which Documents Should Be Loaded?

## Database Work

Load:

- 03_company_structure.md
- 05_customer_identity.md
- 06_booking_and_travel_products.md
- 12_lead_statuses_and_rules.md
- 13_booking_statuses_and_rules.md
- 14_finance_rules.md
- 15_permissions_roles.md
- 16_document_types_and_rules.md
- 17_saas_plan_matrix.md
- 20_authentication_security_model.md

## CRM

Load:

- 04_lead_lifecycle.md
- 05_customer_identity.md
- 12_lead_statuses_and_rules.md
- 15_permissions_roles.md

## Booking

Load:

- 06_booking_and_travel_products.md
- 13_booking_statuses_and_rules.md
- 14_finance_rules.md
- 16_document_types_and_rules.md

## UI

Load:

- 01_mvp_scope.md
- Relevant module workflow files only

## API

Load:

- Relevant module rules
- 15_permissions_roles.md
- 20_authentication_security_model.md

## Security

Load:

- 15_permissions_roles.md
- 20_authentication_security_model.md

## Reports And Ads Attribution

Load:

- 18_integration_priority.md
- 21_offline_conversion_engine.md

Never load unrelated documents.

---

# Current Principles

While implementing ORVION always remember:

- Keep solutions simple.
- Reuse existing code.
- Respect previous decisions.
- Avoid unnecessary abstractions.
- Prefer practical business solutions.
- Avoid enterprise complexity.

---

# Things That Must Never Change Automatically

Never rename modules.

Never rename database tables.

Never reorganize folders.

Never rewrite documentation.

Never redesign architecture.

Unless explicitly instructed.

---

# Working Context

Every session determine:

1. Current Phase
2. Current Module
3. Current Task
4. Required Documents
5. Implementation

Never skip this sequence.

---

# Documentation Rule

If implementation changes:

- Business Rules
- Database
- Workflow
- API
- Permissions
- Events
- Architecture

Documentation must be updated before the task is considered complete.

---

# Token Optimization

Only read the documents required for the current task.

Avoid scanning the repository.

Avoid summarizing unrelated modules.

Avoid re-reading completed documentation.

Prefer canonical documents over duplicate information.

---

# Project Success

The project is progressing correctly if:

- Every session completes a small piece of work.
- Documentation stays synchronized.
- Architecture remains consistent.
- The system becomes easier to maintain.
- The owner understands every major decision.

---

# Final Reminder

ORVION is being built gradually.

Small, consistent progress is more valuable than large architectural redesigns.

Every completed task should make the next task easier.

End of Document.
