# Lead Statuses And Rules

Version: 0.1
Status: Draft
Canonical: Yes

---

# Official Lead Statuses

The official lead statuses are:

- new
- assigned
- contacted
- qualified
- quotation_sent
- negotiation
- won
- converted
- lost
- spam
- duplicate

Status values must be controlled catalog values.

Employees must not create lead statuses manually.

---

# Lead To Customer Rule

A lead becomes a customer when the person is approved as an actual customer inside the system, before executing services.

This means the person is no longer only an inquiry.

The system must preserve the original lead and link it to the customer record.

---

# Lead To Booking Rule

A booking may be created:

- Directly after the lead is created
- After a preliminary booking request for any service
- After qualification or negotiation when business rules require it

Creating a booking must not delete or overwrite the lead.

The lead remains part of the customer and booking history.

---

# Duplicate Lead Rule

Duplicate leads are linked to the existing customer, not physically deleted.

The system should prevent opening multiple active leads for the same customer when the current lead is still open.

Allowed exception:

The same customer may be handled by more than one department at the same time when the business need is different.

All leads must remain historically visible.

---

# New Lead After Closure

A new lead may be opened for the same customer after the current lead is closed because:

- Booking completed
- Customer postponed
- Customer declined
- Lead lost
- Other approved closure reason

Closure reason must be recorded.

---

# Official Lead Closure Reasons

Official lead closure reasons:

- booked
- postponed
- price_rejected
- no_response
- duplicate
- spam
- invalid_contact
- not_interested
- service_unavailable
- competitor
- customer_cancelled
- converted_customer
- other

Closure reasons must be controlled catalog values.
