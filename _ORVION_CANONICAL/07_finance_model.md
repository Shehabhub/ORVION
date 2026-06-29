# Finance Model

Version: 0.1
Status: Draft
Canonical: Yes

---

# Finance Scope

ORVION requires full journal entries, not only a simple receivables/payables tracker.

The finance module must remain practical for travel companies and should avoid unnecessary enterprise accounting expansion in the first implementation.

---

# Core Finance Capabilities

The system must support:

- Journal entries
- Customer receivables
- Supplier payables
- Customer payments
- Supplier payments
- Refunds
- Invoices
- Receipts
- Multiple bank accounts
- Multiple cash accounts
- Multiple currencies
- Manual exchange rates
- Company assets
- Profit tracking

---

# Profit Calculation

Profit must be calculated at booking item level.

Each booking item has:

- Cost
- Selling price
- Currency
- Exchange rate where needed
- Item profit

Booking-level profit is calculated from the sum of item-level results.

---

# Installment Payments

Customers may pay in installments.

Each payment must be recorded separately and linked to:

- Customer
- Booking
- Booking item when applicable
- Invoice or receipt
- Payment proof document when applicable

---

# Supplier Balance

A supplier may be payable and receivable at the same time.

Example:

The company owes the supplier for active services, while the supplier also owes the company refund amounts not yet transferred.

Supplier statements must support both directions.

---

# Bank And Cash Accounts

The company may have multiple bank and cash accounts.

Each account may have its own currency.

Finance users must be able to track balances by account and currency.

---

# Transfer Proof Approval

For bookings requiring bank transfer confirmation:

1. The responsible employee uploads the transfer receipt as an image or PDF.
2. The system creates a finance approval request.
3. Finance verifies the bank account.
4. Finance approves or rejects the proof.
5. After approval, the booking or item can proceed to the next operational step.

Once finance approval is granted, the approval state must not be edited by any users.

Any correction after approval must be handled through a new event, adjustment, reversal, or authorized finance action.

