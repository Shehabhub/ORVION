# CODING_STANDARDS.md

## 1. Naming Conventions
Use English names for all code, files, and identifiers. Use clear, descriptive terms and avoid abbreviations that are not standard. Use PascalCase for types and classes, camelCase for variables and functions, and snake_case for PostgreSQL database objects.

## 2. Project Structure
Organize code by domain or responsibility rather than by technical layer alone. Keep related logic together and separate concerns that differ in purpose. Maintain a consistent folder structure across modules and preserve existing repository boundaries.

## 3. General Coding Rules
Write code that is explicit, readable, and easy to review. Prefer small, focused units over large abstractions. Avoid duplicated logic. Avoid magic values and unexplained shortcuts. Keep behavior predictable and make intent clear in the code.

## 4. SQL Standards
Use PostgreSQL-compatible SQL and keep statements clear and deterministic. Prefer explicit constraints, sensible defaults, and consistent naming. Avoid implicit behavior and ensure schema changes preserve data integrity. Keep queries readable and maintainable.

## 5. API Standards
Design APIs to be consistent, predictable, and explicit. Use clear request and response shapes, stable naming, and consistent error behavior. Avoid unnecessary parameters and ensure the contract is understandable without hidden assumptions.

## 6. Error Handling
Handle errors explicitly and fail in a controlled way. Preserve useful context for diagnosis without exposing sensitive information. Avoid silent failures and ensure abnormal conditions are surfaced in a consistent manner.

## 7. Logging
Use logging to support diagnosis and operational awareness. Log meaningful events, include sufficient context, and avoid excessive or redundant output. Keep logging consistent across the codebase and avoid logging sensitive data.

## 8. Security
Protect secrets, credentials, and sensitive data at all times. Validate input, enforce authorization boundaries, and avoid unsafe assumptions. Follow least-privilege principles and preserve trust boundaries in every change.

## 9. Performance
Write code that is efficient enough for the intended workload without unnecessary complexity. Favor clear implementation over premature optimization. Use indexes and query structure decisions only when they are justified by measurable need.

## 10. Code Review Checklist
Review every change for correctness, clarity, maintainability, security, and consistency with these standards. Confirm that the change is necessary, scoped correctly, and does not introduce ambiguity or unnecessary risk. Verify that the change does not conflict with the canonical documentation.

## 11. Canonical Architecture

All implementation must remain consistent with the canonical architecture.

Never bypass or contradict canonical design decisions without explicit approval.

## 12. PostgreSQL Standards

UUID everywhere

TIMESTAMPTZ

NUMERIC for money

snake_case

No SELECT *

Explicit FK names

Explicit Index names

CHECK constraints

Comments on tables

Comments on columns