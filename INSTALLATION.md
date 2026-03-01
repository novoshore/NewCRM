# CRM Application - Installation Guide

## Version 1.0 | February 2026

---

## Table of Contents
1. [Prerequisites](#prerequisites)
2. [Installation Steps](#installation-steps)
3. [Configuration](#configuration)
4. [Verification](#verification)
5. [Post-Installation](#post-installation)
6. [Troubleshooting](#troubleshooting)
7. [Uninstallation](#uninstallation)

---

## 1. Prerequisites

### 1.1 System Requirements

**Database:**
- Oracle Database 19c or higher (19.3+ recommended)
- Minimum 2GB free space
- Character set: AL32UTF8 or UTF8

**APEX:**
- Oracle APEX 24.2 or higher
- APEX workspace created
- ORDS configured (for REST APIs)

**Client:**
- Modern web browser (Chrome 90+, Firefox 88+, Safari 14+, Edge 90+)
- JavaScript enabled
- Cookies enabled

### 1.2 Access Requirements

You will need:
- Database user with CREATE privileges (or SYSDBA access)
- APEX workspace administrator access
- Network access to the database and APEX instance

### 1.3 Download Files

Ensure you have all required files:
```
crm_apex_app/
├── database/
│   ├── 01_schema_creation.sql
│   ├── 02_triggers_procedures.sql
│   └── 03_sample_data.sql
├── apex/
│   └── crm_application_export.sql
├── documentation/
│   ├── technical_documentation.md
│   ├── user_guide.md
│   └── process_flows.md
└── tests/
    ├── test_plan.md
    └── run_all_tests.sql
```

---

## 2. Installation Steps

### Step 1: Create Database Schema

#### Option A: Create New User (Recommended)

Connect as SYSDBA:
```sql
sqlplus sys/password@database as sysdba
```

Create the schema user:
```sql
-- Create user
CREATE USER crm_app IDENTIFIED BY "YourSecurePassword123!"
  DEFAULT TABLESPACE USERS
  TEMPORARY TABLESPACE TEMP
  QUOTA UNLIMITED ON USERS;

-- Grant privileges
GRANT CONNECT TO crm_app;
GRANT RESOURCE TO crm_app;
GRANT CREATE VIEW TO crm_app;
GRANT CREATE SEQUENCE TO crm_app;
GRANT CREATE TRIGGER TO crm_app;
GRANT CREATE PROCEDURE TO crm_app;

-- Additional grants for APEX
GRANT EXECUTE ON DBMS_STATS TO crm_app;
GRANT EXECUTE ON DBMS_LOB TO crm_app;

EXIT;
```

#### Option B: Use Existing Schema

If using an existing schema, ensure it has the necessary privileges listed above.

### Step 2: Install Database Objects

Connect as the CRM user:
```bash
sqlplus crm_app/YourSecurePassword123!@database
```

Run the installation scripts in order:
```sql
-- Step 2.1: Create tables and constraints
@database/01_schema_creation.sql

-- Step 2.2: Create triggers and business logic
@database/02_triggers_procedures.sql

-- Step 2.3: Load lookup data and sample data
@database/03_sample_data.sql

EXIT;
```

**Important:** Check for any errors after each script. The scripts should complete without errors.

### Step 3: Verify Database Installation

Run verification script:
```sql
sqlplus crm_app/YourSecurePassword123!@database

-- Check table count
SELECT COUNT(*) FROM user_tables WHERE table_name LIKE 'CRM_%';
-- Expected: 18 tables

-- Check sequence count
SELECT COUNT(*) FROM user_sequences WHERE sequence_name LIKE 'CRM_%';
-- Expected: 3 sequences

-- Check package
SELECT object_name, object_type, status 
FROM user_objects 
WHERE object_name = 'CRM_BUSINESS_LOGIC';
-- Expected: PACKAGE and PACKAGE BODY, both VALID

-- Check sample data
SELECT COUNT(*) FROM crm_customers;
-- Expected: 3 or more customers

EXIT;
```

### Step 4: Build the APEX Application

The `crm_application_export.sql` file included in this project is a reference template showing the intended application structure. A complete, importable APEX export must be generated using APEX Application Builder. Follow the steps below to create the application against the installed schema.

#### 4.1 Create New Application
1. Open your APEX instance in a web browser and sign in to your workspace
2. Click **App Builder** → **Create** → **New Application**
3. Set:
   - **Name:** CRM Application
   - **Appearance:** Universal Theme (Theme 42) — choose a suitable Style
   - **Parsing Schema:** `CRM_APP`
4. Click **Add Page** for each of the five core entities using **Report and Form**:
   - **Customers** — Table: `CRM_CUSTOMERS`
   - **Contacts** — Table: `CRM_CONTACTS`
   - **Leads** — Table: `CRM_LEADS`
   - **Opportunities** — Table: `CRM_OPPORTUNITIES`
   - **Activities** — Table: `CRM_ACTIVITIES`
5. Add a **Dashboard** page (Blank page) to display KPI metrics and charts
6. Click **Create Application** — APEX auto-generates all regions, forms, and processes

#### 4.2 Configure Navigation and Shared Components
1. In App Builder, open the new application
2. Navigate to **Shared Components** > **Lists** and configure the navigation menu with 8 items:
   Dashboard, Customers, Contacts, Leads, Opportunities, Activities, Reports, Administration
3. Navigate to **Shared Components** > **List of Values** and create LOVs from the lookup tables:
   - `CRM_CUSTOMER_STATUS`, `CRM_LEAD_SOURCE`, `CRM_INDUSTRY_TYPE`, `CRM_OPPORTUNITY_STAGE`, `CRM_ACTIVITY_TYPE`
4. Navigate to **Shared Components** > **Application Definition Attributes** and set:
   - **Application Name:** CRM Application
   - **Version:** 1.0

#### 4.3 Export the Application for Archiving (Optional)
Once the application is built and verified:
1. In App Builder, click **Export** > **Application**
2. Save the exported `.sql` file — this replaces `crm_application_export.sql` with a genuine export
3. Re-zip and update `crm_application_export.zip`

### Step 5: Create APEX Users

#### 5.1 Create Workspace Users
1. Navigate to **App Builder** > **Workspace Utilities** > **Manage Users and Groups**
2. Click **Create User**
3. Fill in user details:
   - **Username:** (user's email or username)
   - **Email:** (user's email)
   - **Password:** (temporary password)
   - **Require Change of Password:** Yes
4. Assign user to appropriate group (Admin, Developer, or End User)
5. Click **Create User**
6. Repeat for additional users

#### 5.2 Set Up User Roles (within the application)
1. Run the application
2. Navigate to **Administration** > **User Management**
3. For each user, assign appropriate role:
   - **Administrator:** Full access
   - **Sales Manager:** View all, edit own + team
   - **Sales Representative:** View all, edit own
   - **Read-Only:** View only

---

## 3. Configuration

### 3.1 Email Configuration (Optional)

To enable email notifications:

```sql
-- Connect as SYSDBA
sqlplus sys/password@database as sysdba

-- Configure APEX email
BEGIN
    APEX_INSTANCE_ADMIN.SET_PARAMETER(
        p_parameter => 'SMTP_HOST_ADDRESS',
        p_value     => 'smtp.yourcompany.com'
    );
    
    APEX_INSTANCE_ADMIN.SET_PARAMETER(
        p_parameter => 'SMTP_HOST_PORT',
        p_value     => '587'
    );
    
    APEX_INSTANCE_ADMIN.SET_PARAMETER(
        p_parameter => 'SMTP_TLS_MODE',
        p_value     => 'STARTTLS'
    );
    
    APEX_INSTANCE_ADMIN.SET_PARAMETER(
        p_parameter => 'SMTP_USERNAME',
        p_value     => 'noreply@yourcompany.com'
    );
    
    APEX_INSTANCE_ADMIN.SET_PARAMETER(
        p_parameter => 'SMTP_PASSWORD',
        p_value     => 'your_smtp_password'
    );
    
    COMMIT;
END;
/

EXIT;
```

### 3.2 Authentication Configuration

The application uses APEX Authentication by default. To configure SSO or LDAP:

1. Navigate to **Shared Components** > **Authentication Schemes**
2. Click **Create**
3. Select authentication type (LDAP, Oracle SSO, etc.)
4. Configure according to your organization's requirements
5. Set as current authentication scheme

### 3.3 Application Settings

Configure application-specific settings:

1. Run the application as Administrator
2. Navigate to **Administration** > **Settings**
3. Configure:
   - **Company Name:** Your company name
   - **Default Currency:** USD, EUR, etc.
   - **Date Format:** MM/DD/YYYY or DD/MM/YYYY
   - **Session Timeout:** 480 minutes (8 hours)
   - **Password Policy:** As per company requirements

### 3.4 Lookup Data Customization

Customize lookup values to match your business:

```sql
-- Connect as CRM_APP user
sqlplus crm_app/password@database

-- Add custom customer statuses
INSERT INTO crm_customer_status (status_code, status_name, description, display_order)
VALUES ('VIP', 'VIP Customer', 'High-value VIP customer', 5);

-- Add custom lead sources
INSERT INTO crm_lead_source (source_code, source_name, description)
VALUES ('WEBINAR', 'Webinar', 'Lead from webinar registration');

-- Add custom industries
INSERT INTO crm_industry_type (industry_code, industry_name, description)
VALUES ('PHARMA', 'Pharmaceutical', 'Pharmaceutical and biotech');

COMMIT;
EXIT;
```

---

## 4. Verification

### 4.1 Run Automated Tests

```bash
# Connect and run tests
sqlplus crm_app/password@database @tests/run_all_tests.sql

# Review results
cat test_results.log
```

Expected output: All tests should PASS

### 4.2 Manual Verification Checklist

- [ ] Can log in to the application
- [ ] Dashboard loads with metrics
- [ ] Can create a new customer
- [ ] Can create a new lead
- [ ] Can convert a lead to customer
- [ ] Can create an opportunity
- [ ] Can create an activity/task
- [ ] Can view reports
- [ ] Navigation menu works
- [ ] Search functionality works
- [ ] Export to Excel works
- [ ] No JavaScript errors in browser console

### 4.3 Performance Verification

```sql
-- Test query performance
SET TIMING ON

SELECT COUNT(*) FROM crm_customers c
JOIN crm_contacts ct ON c.customer_id = ct.customer_id;

-- Should complete in < 1 second

SELECT COUNT(*) FROM crm_opportunities o
JOIN crm_opportunity_stage s ON o.stage_id = s.stage_id
WHERE o.is_closed = 'N';

-- Should complete in < 0.5 seconds

SET TIMING OFF
```

---

## 5. Post-Installation

### 5.1 Initial Setup Tasks

1. **Remove or modify sample data:**
   ```sql
   -- Delete sample customers (optional)
   DELETE FROM crm_customers 
   WHERE created_by = 'ADMIN' 
     AND created_date < SYSDATE - 1;
   COMMIT;
   ```

2. **Import your actual data:**
   - Use SQL*Loader or external table for bulk import
   - Or use APEX Data Workshop

3. **Create database backup:**
   ```bash
   expdp crm_app/password@database \
     directory=DATA_PUMP_DIR \
     dumpfile=crm_initial_backup.dmp \
     schemas=CRM_APP
   ```

### 5.2 Set Up Monitoring

1. **Enable APEX Monitoring:**
   - Navigate to **Monitor Activity** in APEX Administration
   - Review page performance reports regularly

2. **Database Monitoring:**
   ```sql
   -- Create monitoring view
   CREATE OR REPLACE VIEW crm_monitor AS
   SELECT 
       (SELECT COUNT(*) FROM crm_customers) as total_customers,
       (SELECT COUNT(*) FROM crm_opportunities WHERE is_closed = 'N') as open_opps,
       (SELECT COUNT(*) FROM crm_leads WHERE status != 'CONVERTED') as active_leads,
       (SELECT COUNT(*) FROM crm_activities WHERE due_date < SYSDATE AND status != 'COMPLETED') as overdue_tasks
   FROM dual;
   ```

3. **Set up audit trail archiving:**
   ```sql
   -- Create procedure to archive old audit records
   CREATE OR REPLACE PROCEDURE archive_old_audit_trail AS
   BEGIN
       DELETE FROM crm_audit_trail
       WHERE action_date < ADD_MONTHS(SYSDATE, -12);
       
       COMMIT;
   END;
   /
   
   -- Schedule monthly (via DBMS_SCHEDULER)
   ```

### 5.3 User Training

1. Provide users with the User Guide (documentation/user_guide.md)
2. Schedule training sessions covering:
   - Basic navigation
   - Creating and managing customers
   - Lead conversion process
   - Opportunity management
   - Activity tracking
   - Running reports

### 5.4 Support Setup

1. Create support email alias (e.g., crm-support@yourcompany.com)
2. Document common issues and resolutions
3. Set up ticketing system integration if available

---

## 6. Troubleshooting

### 6.1 Common Installation Issues

**Issue: "Insufficient privileges" error**
```sql
-- Solution: Grant missing privileges
GRANT CREATE VIEW TO crm_app;
GRANT CREATE SEQUENCE TO crm_app;
GRANT CREATE TRIGGER TO crm_app;
```

**Issue: "Package body has errors"**
```sql
-- Solution: Check compilation errors
SELECT line, position, text
FROM user_errors
WHERE name = 'CRM_BUSINESS_LOGIC'
  AND type = 'PACKAGE BODY'
ORDER BY sequence;

-- Recompile
ALTER PACKAGE crm_business_logic COMPILE BODY;
```

**Issue: APEX import fails with "File is not a valid APEX import"**
- The included `crm_application_export.sql` is a reference template, not a complete APEX export
- You must build the application using APEX Application Builder as described in Step 4
- A genuine export from Application Builder will import correctly
- Ensure APEX version is 24.2 or higher

**Issue: Foreign key constraint violations**
- Ensure scripts are run in correct order
- Verify lookup data was loaded (script 03)
- Check for missing parent records

### 6.2 Runtime Issues

**Issue: Page won't load**
- Clear browser cache
- Check APEX session state
- Review APEX debug messages
- Verify user has appropriate permissions

**Issue: Slow performance**
- Run DBMS_STATS.GATHER_SCHEMA_STATS
- Check for missing indexes
- Review execution plans
- Increase APEX cache settings

**Issue: Email not sending**
- Verify SMTP configuration
- Check APEX_MAIL_QUEUE
- Test SMTP connection from database server
- Review firewall rules

### 6.3 Getting Help

1. Check documentation in `/documentation` folder
2. Review test results and logs
3. Contact database administrator
4. APEX Community Forums: https://community.oracle.com/apex
5. Oracle Support (if licensed)

---

## 7. Uninstallation

### 7.1 Remove APEX Application

1. Login to APEX Application Builder
2. Navigate to the CRM application
3. Click **Utilities** > **Delete Application**
4. Confirm deletion

### 7.2 Remove Database Objects

```sql
-- Connect as CRM_APP user
sqlplus crm_app/password@database

-- Drop all objects
BEGIN
   FOR cur_rec IN (SELECT object_name, object_type 
                   FROM user_objects 
                   WHERE object_type IN ('TABLE','VIEW','PACKAGE','PROCEDURE','FUNCTION','SEQUENCE','TRIGGER')
                   AND object_name LIKE 'CRM_%') 
   LOOP
      BEGIN
         IF cur_rec.object_type = 'TABLE' THEN
            EXECUTE IMMEDIATE 'DROP ' || cur_rec.object_type || ' "' || cur_rec.object_name || '" CASCADE CONSTRAINTS';
         ELSE
            EXECUTE IMMEDIATE 'DROP ' || cur_rec.object_type || ' "' || cur_rec.object_name || '"';
         END IF;
      EXCEPTION
         WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error dropping ' || cur_rec.object_name || ': ' || SQLERRM);
      END;
   END LOOP;
END;
/

EXIT;
```

### 7.3 Remove Database User (Optional)

```sql
-- Connect as SYSDBA
sqlplus sys/password@database as sysdba

-- Drop user and all objects
DROP USER crm_app CASCADE;

EXIT;
```

**Warning:** This will permanently delete all data. Ensure you have a backup before proceeding.

---

## Appendix A: File Checksums

Use these to verify file integrity:

```bash
# Generate checksums
md5sum database/*.sql
md5sum apex/*.sql
md5sum tests/*.sql
```

## Appendix B: Network Ports

Required network access:
- **Database:** 1521 (default Oracle listener)
- **APEX/ORDS:** 8080 (HTTP) or 443 (HTTPS)
- **SMTP:** 25, 587, or 465 (if email configured)

## Appendix C: Support Contacts

- **Installation Support:** install-support@yourcompany.com
- **Technical Issues:** tech-support@yourcompany.com
- **Training Requests:** training@yourcompany.com

---

*Installation Guide Version: 1.0*  
*Last Updated: February 14, 2026*  
*For CRM Application v1.0*
