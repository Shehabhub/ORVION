# Company Structure Model

Version: 0.1
Status: Draft
Canonical: Yes

---

# Tenant Model

Each subscribed travel company is a separate tenant.

Tenant data must be isolated from all other tenants.

Each tenant may have more than one owner.

Owners have top-level authority inside their company, subject to SaaS platform limits and subscription status.

---

# Branch Model

Branches are operationally separated, not financially separated by default.

Finance is company-level, while daily work, employees, queues, leads, permissions, and operational ownership are branch-aware.

The system must record which branch first registered a customer and which branches later interacted with the same customer.

---

# Employee Branch Assignment

The normal rule is:

- Each employee belongs to one primary branch.
- Each branch normally works with its own employees.

Exceptions are allowed:

- Temporary transfer to another branch
- Permanent transfer to another branch

Every transfer must be recorded as an event.

The system must preserve historical ownership. Past leads, bookings, approvals, and actions must continue to show the employee and branch that handled them at the time.

---

# Department Manager Authority

A department manager can manage permissions only for employees who are:

- In the same department
- Inside the branch the manager belongs to

A department manager must not manage permissions for:

- Employees in other branches
- Employees in other departments
- Users above the manager's authority level

---

# Finance Visibility

Although branches are operationally separated, finance can view company-level financial activity across departments and branches according to permission.

Branch operational separation must not prevent authorized finance users from reviewing:

- Customer balances
- Supplier balances
- Booking profit
- Bank/cash accounts
- Financial documents
- Company assets

