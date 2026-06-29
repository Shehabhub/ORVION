# PROJECT_CONTEXT.md

## 1. Project Overview
ORVION is a long-term travel revenue operating system designed to support customer-driven operations, traceable revenue, and scalable SaaS growth. Its purpose is to coordinate business processes, data integrity, and decision support across the full travel lifecycle.

## 2. Vision
The system exists to help the organization manage customer relationships, booking operations, financial accountability, and service delivery through a consistent and dependable platform. It must remain adaptable as the business grows and evolves.

## 3. Core Domains
The core domains include customer identity, lead lifecycle, bookings and travel products, finance, documents, notifications, permissions, and platform administration. These domains are interrelated and must remain consistent with each other.

## 4. Architectural Principles
The platform must preserve immutability of events, consistency of identity, traceability of revenue, and clarity of ownership. Decisions should favor stability, extensibility, and long-term maintainability over short-term convenience.

## 5. Technology Stack
The system is implemented through a modern application stack centered on PostgreSQL, Supabase, and supporting application services. The exact implementation choices must remain aligned with the canonical project guidance and repository standards.

## 6. Source of Truth
The canonical project documentation is the authoritative reference for requirements, rules, and structural decisions. Any implementation must remain consistent with that source and must not contradict it.

## 7. Design Priorities
The highest priorities are correctness, auditability, customer continuity, operational clarity, and scalability. The system must support future growth without sacrificing trust, traceability, or governance.

## 8. Non-Goals
This project does not exist to create isolated experiments, temporary shortcuts, or architecture changes that bypass the canonical guidance. It also does not define business strategy beyond the operational and platform needs expressed by the project documentation.

## 9. Decision Making Rules
Decisions must be grounded in the canonical documentation, repository standards, and the long-term needs of the platform. When requirements are unclear, the safe course is to defer rather than invent unsupported decisions.

## 10. Project Vocabulary
Key terms include customer, lead, booking, revenue, identity, event, document, permission, and SaaS. These terms should be used consistently and with their intended business meaning.

## 11. Non Goals

ORVION is not:

- ERP
- Accounting Suite
- HR System
- Hotel PMS
- Airline Reservation System

It integrates with such systems when necessary.