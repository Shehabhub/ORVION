# Authentication Security Model

Version: 0.1
Status: Draft
Canonical: Yes

---

# Authentication Principle

Authentication strength depends on user risk level.

Financial, ownership, and system administration roles require stronger authentication than ordinary operational users.

---

# Normal User Login

Normal operational users authenticate using:

- Phone number
- Password
- Email OTP for first login from a new device

Email OTP is not required on every login unless risk rules require it.

---

# High-Risk Role Login

The following roles require Authenticator App TOTP:

- Owner
- CEO
- Finance Manager
- System Administrator

Email OTP is not sufficient for these roles because they can perform high-risk financial or administrative operations.

---

# Device Trust

The system must track trusted devices.

First login from a new device requires additional verification.

Device trust must record:

- User
- Device fingerprint or identifier
- First seen timestamp
- Last seen timestamp
- Verification method
- Revocation status

---

# Password Control

Password changes are controlled according to permissions.

High-authority users may reset lower-authority user passwords when policy allows.

All password reset and credential changes must be security events.

---

# Security Events

The system must record:

- Login attempt
- Login success
- Login failure
- OTP request
- OTP verification success
- OTP verification failure
- TOTP enrollment
- TOTP challenge success
- TOTP challenge failure
- New device verification
- Password change
- Password reset
- Account lock
- Permission change

Security events must not be physically deleted.

