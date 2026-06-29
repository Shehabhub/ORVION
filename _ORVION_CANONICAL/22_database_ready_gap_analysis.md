# Database-Ready Gap Analysis

Version: 0.1
Status: Draft
Canonical: Yes

---

# Purpose

This document defines what is still missing before ORVION can move safely from business specification to database schema design.

The objective is not to expand the project.

The objective is to identify the minimum missing specifications required to design a practical first database.

---

# Current State

The project already has enough canonical decisions for:

- Product purpose
- MVP scope
- Company and branch structure
- Lead lifecycle
- Customer identity
- Booking and travel products
- Finance rules
- Document rules
- SaaS plans
- Notifications
- Authentication model
- Offline conversion engine
- Pre-database open decisions

These are sufficient to begin a database-ready specification layer.

---

# Main Gap

Most current documents describe business intent and rules.

Database design needs a stricter layer that defines:

- Entities
- Catalogs
- State machines
- Events
- Permissions
- Relationships
- Ownership rules
- Audit rules
- Soft-delete/archive rules
- First schema boundaries

Without this layer, database tables would be created from interpretation instead of specification.

---

# Required Missing Documents

The following documents must be created before writing `schema_draft.md`.

## 1. entity_registry.md

Defines the first official business entities.

Must include:

- Tenant/company
- Branch
- Department
- User
- Role
- Permission
- Lead
- Customer
- Passenger
- Booking
- Booking item
- Supplier
- Document
- Payment
- Invoice
- Receipt
- Journal entry
- Event
- Notification
- Subscription plan
- Subscription

## 2. catalog_registry.md

Defines controlled values.

Must include:

- Lead statuses
- Lead closure reasons
- Booking statuses
- Booking item base statuses
- Service types
- Document types
- Payment methods
- User roles
- Permission keys
- Notification types
- Subscription plan codes
- Offline conversion event types

## 3. state_machines.md

Defines allowed state transitions.

Must include:

- Lead state machine
- Booking state machine
- Booking item base state machine
- Finance approval state machine
- Document lifecycle
- Subscription lifecycle
- Offline conversion delivery lifecycle

## 4. event_catalog.md

Defines meaningful immutable business events.

Must include:

- Lead events
- Customer events
- Booking events
- Finance events
- Document events
- Permission/security events
- Subscription events
- Offline conversion events

## 5. permissions_matrix.md

Defines role and permission behavior.

Must include:

- Owner
- CEO
- Branch Manager
- Department Manager
- Finance Manager
- Senior Employee
- Employee
- Trainee
- System Administrator

Must define tenant, branch, department, assignment, and plan scope.

## 6. relationship_map.md

Defines entity relationships before tables.

Must include:

- Tenant to branch
- Branch to department
- User to branch/department
- Lead to customer
- Customer to passenger
- Lead to booking
- Booking to booking item
- Booking item to supplier
- Booking item to document
- Payment to booking/customer
- Finance approval to booking item
- Event to actor/entity

## 7. database_conventions.md

Defines database rules.

Must include:

- Naming convention
- UUID policy
- Timestamp fields
- Soft delete/archive fields
- Audit fields
- Foreign key rules
- Index rules
- RLS direction
- Multi-tenant rules

## 8. schema_draft.md

Defines the first logical database draft after all previous documents exist.

This is the last document before SQL/migrations.

---

# Not Required Before First Schema

The following should not block first database design:

- Full UI design
- Full API contracts
- Advanced reports
- Payment gateway implementation
- GDS integrations
- Full n8n workflow library
- Advanced accounting reports
- Data warehouse
- Mobile app

These are later layers.

---

# Risk Assessment

## Critical

No schema should be written before entity registry, catalog registry, state machines, event catalog, and relationship map exist.

## High

Permissions must be clarified before implementing database access control.

## Medium

Offline conversion can be modeled early but implemented later.

## Low

UI-specific documents can wait.

---

# Decision

Proceed with creating the Database-Ready Specification Package.

Do not restructure folders.

Do not modify old non-canonical files.

Use `_ORVION_CANONICAL` as the active source of truth.

