# ORVION Development Instructions

## Product

ORVION is a Travel Revenue Operating Platform.

## Architecture

- SaaS First
- Multi-Tenant
- Event Driven
- PostgreSQL First
- Supabase Compatible
- API First

## Rules

- Never physically delete business records.
- Archive instead.
- Never duplicate business entities.
- Use lower_snake_case.
- PostgreSQL is the source of truth.
- Every schema change must be implemented through migrations.
- Preserve backward compatibility.
- Preserve customer data.
- Build for scalability.
- Build for maintainability.