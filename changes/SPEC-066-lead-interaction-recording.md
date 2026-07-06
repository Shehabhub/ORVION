# Change Request — SPEC-066

## Status

[ ] Draft
[ ] Approved
[ ] In Progress
[x] Complete
[ ] Cancelled

Allowed values are exactly these five. Do not use any other status word anywhere in a Change Request.

---

## Assigned Model Tier

[x] Tier 1 — Strong reasoning model
[ ] Tier 2 — Local execution agent (Qwen3.8B)

---

## Objective

Phase 4 (CRM Core) — lead interaction recording: `app.record_lead_interaction(...)` logs an interaction and, when it is a qualifying contact on an `assigned` lead, performs the `assigned → contacted` transition with a `lead_contacted` event. This establishes the "responded" boundary the SLA rule depends on.

---

## Business Reason

`26_state_machines.md`: `assigned → contacted` fires when a phone/WhatsApp/chat/customer-reply interaction is recorded; a lead is "not responded" until then (`04_lead_lifecycle.md`). Recording interactions is how the assigned employee works a lead, and it is the signal the (upcoming) SLA escalation reads.

---

## Risks

Low. One `SECURITY INVOKER` RPC reusing `record_event`. Guarded so only the assigned handler or a lead manager (`ASSIGN_LEAD`) can record, and MFA is enforced for high-risk callers. Validates the `lead_interaction_type` catalog. No table/schema change.

---

## Supersedes / Depends On

Depends On: `SPEC-065` (record_event, assignment), `SPEC-064` (leads). Precedes SLA escalation (which reads interaction/assignment timing).

---

## Scope — Files Allowed to Modify

- supabase/migrations/202607044500_record_lead_interaction.sql

---

## Out of Scope — Files Forbidden to Modify

- _ORVION_CANONICAL/** ; reports/** ; supabase/config.toml ; any existing migration ; table structure ; RBAC seed data ; SLA timers/scheduler ; qualification/closure transitions

---

## Minimum Reading List

- _ORVION_CANONICAL/26_state_machines.md (assigned → contacted; qualifying interaction; lead_contacted)
- supabase/migrations/202607042100_create_crm_core_tables.sql (lead_interactions, leads)
- supabase/migrations/202607044400_round_robin_lead_assignment.sql (record_event, transition pattern)

---

## Implementation Steps

1. Create `supabase/migrations/202607044500_record_lead_interaction.sql`: `app.record_lead_interaction(p_lead_id, p_interaction_type_code, p_summary default null, p_metadata default null)` — plpgsql SECURITY INVOKER, `set search_path=''`. Resolve tenant + caller user; load the lead (in tenant); require the caller is the lead's `assigned_user_id` **or** holds `ASSIGN_LEAD`, and `mfa_satisfied()`; validate `interaction_type_code` against the `lead_interaction_type` catalog; insert a `lead_interactions` row (`user_id`=caller). If the interaction is a **qualifying** contact (`phone_call`/`whatsapp_message`/`chat_opened`/`customer_reply`): set `leads.last_contact_at=now()`, and if the lead is `assigned`, transition it to `contacted` and `record_event('lead_contacted', prev 'assigned', new 'contacted')`. Return the interaction id. Grant execute to `authenticated`.

---

## Acceptance Criteria

- [x] The migration exists; `npx supabase db reset` applies cleanly; smoke-test still passes.
- [x] The assigned employee recording a `phone_call` on their `assigned` lead → lead becomes `contacted`, `last_contact_at` set, a `lead_contacted` event (prev `assigned`, new `contacted`) is written, and the interaction is logged.
- [x] A non-qualifying interaction (`note`) logs the interaction but does **not** change status or emit `lead_contacted`.
- [x] Recording a qualifying interaction on an already-`contacted` (or later) lead logs + updates `last_contact_at` but does not re-transition.
- [x] Rejections: caller who is neither the assignee nor an `ASSIGN_LEAD` holder → 42501; unknown `interaction_type_code`; lead outside tenant. High-risk caller at `aal1` is MFA-blocked.

---

## Execution Log

### 2026-07-06 — Claude (Tier 1)

Outcome: Complete

Step results:
- Step 1: Applied — `app.record_lead_interaction`; `npx supabase db reset` applied cleanly; `scripts/verify_database.sql` reports ALL CHECKS PASSED.

Behavioral test (owner@aal2 sets up; Sara = assigned employee; Ed = other employee):
- Lead assigned to Sara. Sara records `phone_call` → lead `contacted`, `last_contact_at` set, `lead_contacted` event (prev `assigned`/new `contacted`), interaction row present.
- Sara records `note` on the (now contacted) lead → interaction logged, status stays `contacted`, no new `lead_contacted` event.
- Sara records a second `whatsapp_message` (already contacted) → `last_contact_at` advanced, no re-transition.
- Ed (not assignee, employee without `ASSIGN_LEAD`) recording on Sara's lead → 42501; unknown `interaction_type_code='xyz'` → rejected; owner@aal1 → 42501 (MFA). Manager (owner@aal2, holds ASSIGN_LEAD) could record on any lead.

Commits: recorded at Complete.

Blocker: none.

---

## Verification Notes

### 2026-07-06 — Claude (independent review)

Verdict: Confirmed Complete

Findings: The `assigned → contacted` transition fires only on the canonical qualifying interaction set and is audited via `record_event('lead_contacted', …)`, satisfying `26`; non-qualifying interactions and already-contacted leads are handled idempotently (log + `last_contact_at`, no spurious transition). The assignee-or-manager guard plus `mfa_satisfied()` composes authorization + authentication policy without a dedicated permission key (documented). Catalog validation prevents free-typed interaction codes. No schema change; no file outside Scope modified.

Recommendation to human: Set Status to Complete

---

## Review Gate

- [x] Every change matches the Implementation Steps.
- [x] No file outside Scope was modified.
- [x] Every Acceptance Criteria item is confirmed true.
- [x] The repository is in a clean, releasable state.

---

## Notes

**Authorization (recorded decision):** there is no dedicated "record interaction" permission in `28`, so the guard is *ownership-or-management*: the caller must be the lead's `assigned_user_id` or hold `ASSIGN_LEAD`, plus `mfa_satisfied()` (so high-risk roles still require `aal2`). This mirrors how leads are actually worked (the assignee logs contact; managers may act across the queue) and is refine-able if `28` later adds a lead-handling permission. **Qualifying set** is transcribed verbatim from `26` (`phone_call`, `whatsapp_message`, `chat_opened`, `customer_reply`); "lead status changed by authorized user" is handled by the explicit status-transition RPCs, not here. The `assigned → contacted` transition is idempotent (only fires from `assigned`). This interaction/`last_contact_at` signal plus the assignment timestamp are exactly what the next capability — **SLA escalation** — will read; SLA requires a scheduler (pg_cron / Edge Function per ADR-0014), which is a background-processing architectural decision to be presented before implementing it.
