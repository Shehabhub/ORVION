# Lead Lifecycle Model

Version: 0.1
Status: Draft
Canonical: Yes

---

# Lead Intake Channels

Approved lead intake channels:

- Google Ads click-to-call
- Direct phone call
- WhatsApp message
- Website form
- Manual entry by authorized staff

The same company phone number may receive both calls and WhatsApp messages.

---

# Lead Routing Principle

New leads must not be distributed randomly.

The default routing method is round-robin assignment among eligible employees.

The assignment sequence must be deterministic, auditable, and branch/department aware.

---

# WhatsApp Routing

WhatsApp leads may be routed by:

- Manual employee selection
- Customer selection inside an initial automated chat flow

If the customer selects a department or service through the automated flow, the lead is routed to the selected department's eligible queue.

---

# Lead Not Responded Definition

A lead is considered not responded to when all of the following remain true:

- The lead status has not changed.
- No phone contact has been recorded.
- No WhatsApp contact has been recorded.
- The chat is still unopened.

This definition must be implemented as an explicit rule, not inferred informally.

---

# SLA Escalation Rule

If a lead is not responded to within 15 minutes:

- Notify the assigned employee.
- Notify the employee's manager.
- Record an escalation event.

If another 15 minutes pass without response:

- Reassign the lead to another eligible employee.
- Record the reassignment event.
- Preserve the original assignee in lead history.

---

# Lead Assignment History

Every assignment must remain visible in the lead timeline.

If an employee received a lead and did not interact with it, the system must show:

- The employee who received it
- The time it was assigned
- The lack of interaction
- The escalation event
- The reassignment event
- The next employee who received it

No assignment history may be deleted.

