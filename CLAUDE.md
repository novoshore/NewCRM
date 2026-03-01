# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is an Oracle APEX CRM application (v1.0, February 2026) consisting entirely of SQL/PL/SQL scripts and documentation. There is no traditional build system — all development happens through `sqlplus` and the Oracle APEX Application Builder UI.

**Tech stack:** Oracle Database 19c+, Oracle APEX 24.2+, PL/SQL, ORDS

## Key Commands

All database operations require a `sqlplus` connection to the `CRM_APP` schema:

```bash
# Connect to database
sqlplus crm_app/password@database

# Install/reinstall database objects (run in order)
@01_schema_creation.sql
@02_triggers_procedures.sql
@03_sample_data.sql

# Run automated test suite
@run_all_tests.sql

# Gather statistics after bulk changes
EXEC DBMS_STATS.GATHER_SCHEMA_STATS('CRM_APP');

# Check package compilation errors
SELECT line, position, text FROM user_errors
WHERE name = 'CRM_BUSINESS_LOGIC' AND type = 'PACKAGE BODY'
ORDER BY sequence;

# Recompile package if needed
ALTER PACKAGE crm_business_logic COMPILE BODY;
```

## Architecture

### File Roles

| File | Purpose |
|------|---------|
| `01_schema_creation.sql` | All 18 tables, constraints, 15+ indexes, 3 sequences. Drops and recreates all `CRM_` objects at start. |
| `02_triggers_procedures.sql` | 8 triggers + `crm_business_logic` package (6 procedures/functions). |
| `03_sample_data.sql` | Lookup table data + 3 sample customers, 4 contacts, 2 leads, sample opportunities. |
| `crm_application_export.sql` | Reference template only — not a valid APEX import. The real application must be built via APEX Application Builder. |
| `run_all_tests.sql` | Automated SQL test script covering schema validation, trigger behavior, business logic, and performance benchmarks. |

### Database Layer

**Naming conventions:**
- Tables: `CRM_` prefix, plural (e.g., `CRM_CUSTOMERS`)
- Columns: snake_case (e.g., `company_name`)
- PKs: `<table_singular>_id` (e.g., `customer_id`)
- Indexes: `idx_<table>_<column>`
- Sequences: `crm_<purpose>_seq`
- Triggers: `trg_<table>_<action>`
- Flags: `CHAR(1)` with `CHECK` constraint `('Y'/'N')`

**Core tables:** `CRM_CUSTOMERS`, `CRM_CONTACTS`, `CRM_LEADS`, `CRM_OPPORTUNITIES`, `CRM_ACTIVITIES`, `CRM_NOTES`, `CRM_AUDIT_TRAIL`

**Lookup tables:** `CRM_CUSTOMER_STATUS`, `CRM_LEAD_SOURCE`, `CRM_INDUSTRY_TYPE`, `CRM_OPPORTUNITY_STAGE`, `CRM_ACTIVITY_TYPE`

### Business Logic Package (`crm_business_logic`)

Key procedures and functions defined in `02_triggers_procedures.sql`:
- `convert_lead(p_lead_id, p_create_opportunity, x_customer_id, x_contact_id, x_opportunity_id)` — Atomically creates customer + contact from a lead, optionally creates opportunity, marks lead CONVERTED.
- `calculate_customer_health(p_customer_id) RETURN NUMBER` — Returns 0–100 score based on opportunity count, recent activity (90-day window), and open pipeline value.
- Opportunity stage trigger: auto-updates probability and sets `actual_close_date` when `is_closed='Y'`.
- Audit triggers on `CRM_CUSTOMERS`, `CRM_OPPORTUNITIES`, `CRM_LEADS` log to `CRM_AUDIT_TRAIL`.

### APEX Application Structure

The application has 14 pages (built manually in APEX Application Builder against the `CRM_APP` schema):

```
Page 0  - Global Page (navigation, shared components)
Page 1  - Dashboard (KPIs, charts)
Pages 2-3  - Customers (Interactive Report + Form)
Pages 4-5  - Contacts
Pages 6-7  - Leads (includes conversion action)
Pages 8-9  - Opportunities
Pages 10-11 - Activities (Calendar + Form)
Pages 12-13 - Reports/Analytics
Page 14 - Administration
```

LOVs are sourced from the 5 lookup tables. Navigation menu has 8 items.

### Important Notes

- `01_schema_creation.sql` starts with a DROP loop for all `CRM_` objects — running it on a populated schema destroys all data.
- `crm_application_export.sql` is a structural reference, not an importable APEX file. Importing it will fail with "not a valid APEX import".
- Scripts must be run in order (01 → 02 → 03) due to foreign key dependencies on lookup data.
- Row-level security is enforced via the `assigned_to` column — queries should account for this in multi-user scenarios.
