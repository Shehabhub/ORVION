# Change Request — SPEC-067

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

Phase 4 (CRM Core) — lead SLA escalation, and the first application of the background-processing model (ADR-0018): `app.process_lead_sla()` (detection → `lead_sla_warning` + in-system notification at the warn threshold → reassignment + `lead_reassigned` at the reassign threshold), scheduled every minute via `pg_cron`.

---

## Business Reason

`04_lead_lifecycle.md` / `26_state_machines.md`: an `assigned` lead with no qualifying interaction within 15 minutes must raise `lead_sla_warning` and notify the assignee + manager; after another 15 minutes it must be reassigned (`lead_reassigned`), preserving assignment history. SLA is derived from assignment/interaction timing, so it requires a scheduled scan — the first scheduled workload.

---

## Risks

Low–moderate. One `SECURITY DEFINER` system RPC (`service_role`-only) that scans all tenants and reuses `record_event`, round-robin selection, `lead_assignments` history, and `notifications`. Thresholds are parameters (default 15/30 min) so it is deterministically testable by backdating assignment timestamps. `pg_cron` runs it every minute (available + preloaded in the Supabase image). No table/schema change. Idempotent: a lead is warned once per current assignment, reassigned once past the second threshold.

---

## Supersedes / Depends On

Depends On: `SPEC-065` (record_event, round-robin, lead_assignments), `SPEC-066` (interaction → contacted resets SLA). Establishes ADR-0018. First scheduled workload; pattern for future timers.

---

## Scope — Files Allowed to Modify

- reports/architecture-decision-records.md (append ADR-0018)
- supabase/migrations/202607044600_lead_sla_escalation.sql

---

## Out of Scope — Files Forbidden to Modify

- _ORVION_CANONICAL/** ; supabase/config.toml ; any existing migration ; table structure ; RBAC seed data ; external notification delivery (email/WhatsApp) ; manual reassignment RPC

---

## Minimum Reading List

- _ORVION_CANONICAL/26_state_machines.md (Lead SLA State Logic; qualifying interaction) ; 04_lead_lifecycle.md (SLA rule)
- reports/architecture-decision-records.md (ADR-0014, ADR-0018)
- supabase/migrations/202607044400_round_robin_lead_assignment.sql (record_event, round-robin, assignment history)

---

## Implementation Steps

1. Append ADR-0018 (scheduler-agnostic background-processing model).
2. Create `supabase/migrations/202607044600_lead_sla_escalation.sql`: `create extension if not exists pg_cron`; `app.process_lead_sla(p_warn_after interval default '15 minutes', p_reassign_after interval default '30 minutes')` — `SECURITY DEFINER`, `set search_path=''`, scans all `assigned` leads system-wide; for each, using its current `lead_assignments.assigned_at`: if elapsed ≥ warn and not yet warned → `record_event('lead_sla_warning', severity 'warning')` + notify assignee + branch/department managers; if elapsed ≥ reassign and already warned → pick a *different* eligible least-recently-assigned member, close the prior assignment, open a new current one, update the lead, `record_event('lead_reassigned', prev 'assigned', new 'assigned')`, notify the new assignee; return `(lead_id, action)` rows. `revoke` from public; `grant execute` to `service_role`. Schedule `select app.process_lead_sla()` every minute via `cron.schedule('lead-sla-processor', …)`, unscheduling any prior job of that name first (idempotent).

---

## Acceptance Criteria

- [x] The migration exists; `npx supabase db reset` applies cleanly; smoke-test still passes; the `lead-sla-processor` cron job is registered.
- [x] An `assigned` lead whose current assignment is older than the warn threshold gets exactly one `lead_sla_warning` event and a notification to the assignee (+ managers if any); a second immediate run does not double-warn.
- [x] Once past the reassign threshold (and warned), the lead is reassigned to a different eligible member: prior `lead_assignments` row closed (`is_current=false`), a new current row opened, `leads.assigned_user_id` updated, a `lead_reassigned` event recorded, and the new assignee notified. Assignment history is preserved.
- [x] A `contacted` (or non-`assigned`) lead is never acted on; a lead with no other eligible member is not reassigned.
- [x] `process_lead_sla` is `service_role`-only (not `authenticated`).

---

## Execution Log

### 2026-07-06 — Claude (Tier 1)

Outcome: Complete

Step results:
- Step 1: Applied — ADR-0018 appended.
- Step 2: Applied — `pg_cron` extension created; `app.process_lead_sla()` added and scheduled (`lead-sla-processor`, `* * * * *`). `npx supabase db reset` applied cleanly; `scripts/verify_database.sql` reports ALL CHECKS PASSED; `cron.job` contains `lead-sla-processor`.

Behavioral test (Sara & Ed both eligible in Sales; lead assigned to Sara; timestamps backdated to simulate elapsed time):
- Assignment backdated to 20 min: `process_lead_sla()` → `warned`; exactly one `lead_sla_warning` event; a `lead_sla_warning` notification to Sara. Immediate re-run → no action (no double-warn).
- Assignment backdated to 40 min (already warned): `process_lead_sla()` → `reassigned` to Ed; Sara's assignment `is_current=false` with `unassigned_at` set, new current assignment to Ed, `leads.assigned_user_id`=Ed, one `lead_reassigned` event (prev/new `assigned`), notification to Ed. Both assignment rows retained (history preserved).
- A `contacted` lead was ignored; when Ed was the only eligible member, a second-stage lead was not reassigned (no other member).
- `process_lead_sla()` executed as `authenticated` → permission denied (service_role-only).

Commits: recorded at Complete.

Blocker: none.

---

## Verification Notes

### 2026-07-06 — Claude (independent review)

Verdict: Confirmed Complete

Findings: The SLA logic lives entirely in a testable RPC (ADR-0018): detection from `lead_assignments.assigned_at`, one-warning-per-current-assignment idempotency (via the presence of a post-assignment `lead_sla_warning` event), and a reassignment that preserves history and reuses the deterministic round-robin (excluding the current assignee). Events (`lead_sla_warning`, `lead_reassigned`) and in-system notifications satisfy `26`/`04`; external delivery is correctly deferred. `pg_cron` is the thin, replaceable scheduler per ADR-0018; the RPC is verified independently of wall-clock via threshold parameters + backdating. `service_role`-only; no schema change; no file outside Scope modified.

Recommendation to human: Set Status to Complete

---

## Review Gate

- [x] Every change matches the Implementation Steps.
- [x] No file outside Scope was modified.
- [x] Every Acceptance Criteria item is confirmed true.
- [x] The repository is in a clean, releasable state.

---

## Notes

`process_lead_sla` is a system (cross-tenant) job, so it is `SECURITY DEFINER` and does **not** use `app.current_tenant_id()` (there is no caller tenant in a cron run); it acts per each lead's own `tenant_id`. Thresholds are parameters (default 15/30 min per canon) purely to make the RPC deterministically testable and future-configurable. **In-system** notifications are written now; **external** delivery (email/WhatsApp via `notification_deliveries`) is deferred to an Edge Function/n8n per ADR-0018. Manager resolution for warnings = active `branch_manager`/`department_manager` role assignments referencing the lead's branch or department (best-effort; refine-able). A **manual** reassignment RPC (`REASSIGN_LEAD`, for authorized users) is a small deferred follow-up — this CR delivers the automatic SLA-driven reassignment. Reassignment excludes the current assignee and, if no other eligible member exists, leaves the lead in place (re-warn/no-op) rather than reassigning to the same person. Per ADR-0018's escalation trigger, the scheduler is revisited only if a workload needs queues/retries/cross-service orchestration/high volume.
