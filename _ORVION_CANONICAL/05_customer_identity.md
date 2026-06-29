# Customer Identity Model

Version: 0.1
Status: Draft
Canonical: Yes

---

# Customer Scope

Customer uniqueness is enforced inside the tenant company.

The same customer may interact with multiple branches of the same company, but must not be duplicated as separate customer records.

---

# Primary Customer Number

Each customer must have one primary phone number.

The primary phone number is a major identity signal and must be unique inside the company unless an approved exception exists.

---

# Customer Cross-Branch Awareness

When a customer interacts with more than one branch, the system must show limited cross-branch awareness.

Visible cross-branch summary:

- Last interaction date
- Branch of last interaction
- Employee of last interaction

Detailed event content from another branch is not shown by default.

Coordination between branches may happen manually outside the system after the summary is seen.

---

# Person And Company Customer Types

A person and a company are separate customer identities.

If the same real-world party must exist as both:

- Register once as an individual customer.
- Register once as a company customer.
- Clearly label the customer type beside the name.

The system must prevent confusion between individual and company records.

---

# Duplicate Detection Signals

Duplicate detection must use:

- Primary phone
- Additional phones
- WhatsApp number
- Email
- Social media identity
- Passport number
- Other official travel document identifiers

Customer name alone is not enough for duplicate detection because names may repeat.

---

# Customer Name Fields

Customer name must be stored in separate fields:

- Family name
- First name
- Full name

The full name may be generated, entered, or corrected according to validation rules that will be defined later.

---

# Passport And Travel Identity

Passport documents and details — number, issue date, expiry date, nationality, issuing country, and document attachment — are stored at the Passenger level (see 16_document_types_and_rules.md and the `passengers` table in 31_schema_draft.md).

Customer profile may reference a passport number only as a duplicate-detection identity signal (see `customer_identity_signals` in 31_schema_draft.md), not as a stored profile field in its own right.

Customer profile additionally supports:

- Miles card information
- Related family members or travelers

Passport expiry alerts are generated from passenger passport records.

