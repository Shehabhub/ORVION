# Phase 3 — User Lifecycle Review

Date: 2026-07-06
Type: One-time end-to-end coherence review (not a phase, not new implementation)
Scope: The Phase-3 Identity & Access capability group (SPEC-058 … SPEC-063)
Method: A single scripted pass over the full lifecycle against a **fresh `npx supabase db reset`**, simulating Supabase-issued JWT claims (`sub`, `aal`).

---

## Purpose

Validate that the separately-shipped identity capabilities compose into one coherent flow:

**Provision → Invite → Activate → Assign Role → Assign Branch/Department → Login → Membership Resolution → Permission Resolution → RLS**

Per-CR tests each proved one capability; this review proves the **seams between them**.

---

## Scenario

Two tenants provisioned (Meridian, Other). At Meridian: the owner (high-risk role, logs in at `aal2`) builds org structure, invites an employee (Sara) by pre-creating an unlinked membership + assigning role and branch; Sara then authenticates (`aal1`), activates her membership, and operates under RLS. Cross-tenant isolation checked from the Other tenant's owner.

---

## Results — every seam confirmed

| # | Lifecycle seam | Check | Result |
|---|---|---|---|
| 1 | **Provision** | `provision_tenant` (service_role) creates tenant + owner for two tenants | PASS |
| 2 | **Login + Org** | owner membership resolves at `aal2`; `create_branch` + `create_department` | PASS |
| 3 | **Invite** | `create_tenant_user` pre-creates Sara **unlinked** (`auth_user_id` null) | PASS |
| 3 | **Assign Role** | `assign_user_role(sara,'employee')` | PASS |
| 3 | **Assign Branch/Dept** | `assign_user_branch(sara, branch, dept, primary)` | PASS |
| 4 | **Activate** | Sara's verified identity `activate_membership()` links exactly 1 membership | PASS |
| 5 | **Membership Resolution** | `my_memberships()` → Meridian; `current_tenant_id()` resolves | PASS |
| 6 | **Permission Resolution** | `has_permission('CREATE_LEAD')`=true, `('MANAGE_USERS')`=false; `requires_mfa()`=false (employee) | PASS |
| 7 | **RLS (read)** | Sara sees only her tenant's `users` | PASS |
| 7 | **RLS (write-check)** | Sara inserts a `customers` row in her tenant (RLS `WITH CHECK`) | PASS |
| 8 | **MFA policy** | high-risk owner at `aal1` is **blocked** from management (SQLSTATE 42501) | PASS |
| 9 | **Device trust** | Sara `record_trusted_device()` (Human-Identity artifact, pre-tenant) | PASS |
| 10 | **Cross-tenant isolation** | Other tenant's owner sees **zero** Meridian users/customers | PASS |

Foundation smoke-test (`scripts/verify_database.sql`) remained green throughout.

---

## Findings

No defects. The chain is internally consistent:
- Naming, argument shapes, and return types line up across the RPCs (activation returns the `my_memberships` shape; assignment RPCs share the `MANAGE_USERS` gate).
- The two enforcement layers cooperate correctly: **RLS** scopes rows by tenant; **`has_permission`/`authorize`** gate actions by role; **`mfa_satisfied`** gates high-risk roles by session assurance — each independent, none conflated (consistent with ADR-0015 / ADR-0017).
- Identity binding is safe: activation links only unlinked memberships matching the caller's Supabase-verified email; cross-tenant and cross-user access return empty, not error-leaking.

### Observations (recorded, not acted on now)
- **Active-tenant selection** for a human with multiple memberships remains deferred (`set_active_tenant()`; ADR-0011). The single-membership path is proven; the multi-membership UX is future work.
- **Security-event emission** (role assigned, permission change, etc. — `28` Event Requirements) is still deferred to the eventing capability; the lifecycle works without it but the audit trail is not yet populated by these RPCs.
- **Scoped management** (branch_manager "Branch only" / department_manager "Department only") is not yet enforceable (ADR-0015); only owner/CEO manage today. Earns its grants when scope enforcement is built.

---

## Verdict

**The Phase-3 identity lifecycle is coherent and correct end-to-end.** Build-first-review-once satisfied; no rework required. Proceed with the roadmap.
