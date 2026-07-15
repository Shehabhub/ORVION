# Notifications Model

Version: 0.1
Status: Draft
Canonical: Yes

> **Supersession banner (2026-07-15 Repository Recovery, C3 — no business change):** any authentication/OTP prose here is **superseded by ADR-0017** and `34_authentication_and_identity_principles.md` (auth artifacts belong to Supabase Auth). The notification-domain content itself remains current design intent.

---

# Notification Channels

MVP notification channels:

- In-system notifications for operational alerts
- Email OTP notifications for login

Future channels may include:

- WhatsApp
- Email business alerts
- External automation through n8n

---

# Mandatory Notifications

Users cannot mute mandatory operational notifications.

Mandatory notifications include:

- Lead not responded alert
- Manager escalation
- Lead reassignment
- Finance approval result for relevant booking
- Passport expiry where configured
- Subscription expiry and read-only warnings

---

# Lead Notifications

Lead delay notifications are immediate.

After 15 minutes without response:

- Notify assigned employee.
- Notify manager.

After another 15 minutes without response:

- Notify reassigned employee.
- Notify manager.
- Record reassignment event.

---

# Finance Notifications

Financial notifications are normally visible to management and finance only.

Exceptions:

The employee responsible for a lead or booking may receive financial notifications directly related to that lead or booking.

Examples:

- Customer has not transferred payment yet.
- Customer refund is still pending.
- Finance approved bank transfer proof.
- Finance rejected bank transfer proof.

---

# Authentication Notifications

Email OTP is required after password validation according to the proposed authentication model.

Every login attempt and OTP verification must be recorded as security events.

