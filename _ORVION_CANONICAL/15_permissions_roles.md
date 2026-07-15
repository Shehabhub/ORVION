# Permissions And Roles

Version: 0.1
Status: Draft
Canonical: Yes

---

# Role Model

The system uses role-based permissions with department, branch, and tenant scope.

Roles alone are not enough. Permission checks must also consider:

- Tenant
- Branch
- Department
- Ownership
- Assignment
- Subscription plan

---

# Core Company Roles

> **Synchronization annotation (2026-07-15 Repository Recovery, C6 — no business change):** this list is **not authoritative for the role set**. The authoritative role model is `28_permissions_matrix.md` and the seed (`202607043500`), which additionally include **Finance Manager** and **System Administrator** (9 roles total: owner, ceo, branch_manager, department_manager, finance_manager, senior_employee, employee, trainee, system_administrator). Read `28` for the complete set and per-role permissions.

Initial company roles:

- CEO
- Owner
- Branch Manager
- Department Manager
- Finance Manager
- Senior Employee
- Employee
- Trainee
- System Administrator

Operational roles may include:

- Sales
- Operations
- Finance
- Admin

The final permission matrix must combine hierarchy roles and functional roles.

---

# CEO Visibility

The company manager/CEO can see all branches inside the company.

---

# Branch Manager Visibility

The branch manager can see all departments inside their branch.

Branch manager access does not automatically grant cross-company or platform access.

---

# Department Manager Scope

The department manager manages employees and permissions only inside:

- Their department
- Their branch

---

# Sales Employee Lead Visibility

Sales employees see only their assigned leads by default.

They do not see the whole department queue unless granted explicit permission.

---

# Permission Design Note

The database design should separate:

- Roles
- Permissions
- Role permissions
- User role assignments
- Branch scope
- Department scope
- Feature/module access

This avoids hardcoding business authority into application code.

---

# Negative Balance Issuance Permission

Issuing a service before full customer collection is controlled by a separate permission, not only by role.

Permission:

- ALLOW_ISSUE_WITH_NEGATIVE_BALANCE

Default roles eligible for this permission:

- Owner
- CEO
- Finance Manager
- Branch Manager

Department Manager does not receive this permission by default.

Every use of this permission must create a risk flag and audit event.
