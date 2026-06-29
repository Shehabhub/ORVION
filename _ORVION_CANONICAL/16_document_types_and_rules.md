# Document Types And Rules

Version: 0.1
Status: Draft
Canonical: Yes

---

# MVP Document Types

Initial MVP document types:

- passport
- national_id
- visa
- ticket
- hotel_voucher
- invoice
- receipt
- quotation
- contract
- medical_certificate
- photo
- other

Document types must be controlled catalog values.

---

# Passenger-Level Passport Rule

Passport files are stored at passenger level.

They are not stored directly at customer level.

Reason:

A customer may book for multiple travelers.

---

# Booking Item Document Rule

Tickets, visas, hotel vouchers, and similar service documents are stored at booking item level.

---

# Expiry Date Rule

Every official document type must support expiry date.

Examples:

- Passport
- National ID where applicable
- Visa
- Medical certificate where applicable

Expiry alerts are controlled by notification rules.

---

# Allowed File Types

Allowed MVP upload formats:

- PDF
- JPG
- JPEG
- PNG
- WEBP

Executable files are not allowed.

Excel files were previously considered for business documents, but they are not approved for MVP upload until a clear use case and security policy are defined.

---

# Security Rule

File upload must validate:

- Extension
- MIME type
- File size
- Tenant ownership
- Entity linkage
- User permission

