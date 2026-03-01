# CRM Application - Test Plan and Test Scripts

## Version 1.0 | February 2026

---

## Table of Contents
1. [Test Strategy](#test-strategy)
2. [Test Environment Setup](#test-environment-setup)
3. [Unit Tests](#unit-tests)
4. [Integration Tests](#integration-tests)
5. [Functional Tests](#functional-tests)
6. [Performance Tests](#performance-tests)
7. [Security Tests](#security-tests)
8. [User Acceptance Tests](#user-acceptance-tests)

---

## 1. Test Strategy

### 1.1 Testing Objectives
- Verify all database objects are created correctly
- Validate business logic and workflows
- Ensure data integrity and constraints
- Test APEX application functionality
- Verify security and access controls
- Validate performance requirements

### 1.2 Testing Levels
1. **Unit Testing:** Individual database objects and procedures
2. **Integration Testing:** Component interactions
3. **Functional Testing:** End-to-end business processes
4. **Performance Testing:** Load and response times
5. **Security Testing:** Authentication and authorization
6. **UAT:** User acceptance validation

### 1.3 Success Criteria
- All test cases pass (100%)
- No critical or high severity defects
- Performance within acceptable limits
- Security vulnerabilities addressed
- User acceptance achieved

---

## 2. Test Environment Setup

### 2.1 Database Setup
```sql
-- Connect as SYSDBA or privileged user
CREATE USER crm_test IDENTIFIED BY SecurePassword123!
  DEFAULT TABLESPACE USERS
  TEMPORARY TABLESPACE TEMP
  QUOTA UNLIMITED ON USERS;

GRANT CONNECT, RESOURCE TO crm_test;
GRANT CREATE VIEW TO crm_test;
GRANT CREATE SEQUENCE TO crm_test;
GRANT CREATE TRIGGER TO crm_test;

-- Connect as CRM_TEST user
CONN crm_test/SecurePassword123!

-- Run schema creation scripts
@01_schema_creation.sql
@02_triggers_procedures.sql
@03_sample_data.sql
```

### 2.2 APEX Workspace Setup
1. Create APEX workspace: CRM_TEST
2. Map to schema: CRM_TEST
3. Import application
4. Create test users

### 2.3 Test Data Reset Script
```sql
-- Save as test_data_reset.sql
BEGIN
    -- Delete all data (preserves structure)
    DELETE FROM crm_audit_trail;
    DELETE FROM crm_notes;
    DELETE FROM crm_activities;
    DELETE FROM crm_opportunities;
    DELETE FROM crm_contacts;
    DELETE FROM crm_leads;
    DELETE FROM crm_customers;
    
    -- Reset sequences
    EXECUTE IMMEDIATE 'ALTER SEQUENCE crm_account_num_seq RESTART START WITH 10001';
    EXECUTE IMMEDIATE 'ALTER SEQUENCE crm_opp_num_seq RESTART START WITH 100001';
    EXECUTE IMMEDIATE 'ALTER SEQUENCE crm_lead_num_seq RESTART START WITH 200001';
    
    COMMIT;
    
    -- Reload sample data
    @03_sample_data.sql
END;
/
```

---

## 3. Unit Tests

### 3.1 Table Structure Tests

```sql
-- Test Case UT-001: Verify all tables exist
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM user_tables
    WHERE table_name LIKE 'CRM_%';
    
    IF v_count >= 18 THEN
        DBMS_OUTPUT.PUT_LINE('PASS: All tables created (' || v_count || ' tables)');
    ELSE
        DBMS_OUTPUT.PUT_LINE('FAIL: Missing tables. Expected 18+, found ' || v_count);
    END IF;
END;
/

-- Test Case UT-002: Verify primary keys
SELECT 
    'UT-002: ' || table_name || ' - ' ||
    CASE WHEN constraint_name IS NOT NULL THEN 'PASS' ELSE 'FAIL' END as result
FROM user_tables t
LEFT JOIN user_constraints c ON t.table_name = c.table_name AND c.constraint_type = 'P'
WHERE t.table_name LIKE 'CRM_%'
ORDER BY t.table_name;

-- Test Case UT-003: Verify foreign keys
SELECT 
    table_name,
    constraint_name,
    'PASS' as result
FROM user_constraints
WHERE constraint_type = 'R'
  AND table_name LIKE 'CRM_%'
ORDER BY table_name;

-- Test Case UT-004: Verify indexes
SELECT 
    table_name,
    index_name,
    'PASS' as result
FROM user_indexes
WHERE table_name LIKE 'CRM_%'
  AND index_name NOT LIKE 'SYS_%'
ORDER BY table_name, index_name;
```

### 3.2 Trigger Tests

```sql
-- Test Case UT-101: Auto-numbering trigger for customers
INSERT INTO crm_customers (
    company_name, status_id, email
) VALUES (
    'Test Company UT-101', 
    (SELECT status_id FROM crm_customer_status WHERE status_code = 'ACTIVE'),
    'test@ut101.com'
);

SELECT 
    'UT-101: ' || 
    CASE 
        WHEN account_number LIKE 'ACCT-%' THEN 'PASS - Account number: ' || account_number
        ELSE 'FAIL - Invalid account number: ' || NVL(account_number, 'NULL')
    END as result
FROM crm_customers
WHERE company_name = 'Test Company UT-101';

ROLLBACK;

-- Test Case UT-102: Opportunity probability auto-update
DECLARE
    v_opp_id NUMBER;
    v_probability NUMBER;
    v_stage_id NUMBER;
BEGIN
    -- Get proposal stage
    SELECT stage_id INTO v_stage_id 
    FROM crm_opportunity_stage 
    WHERE stage_code = 'PROPOSAL';
    
    -- Create test opportunity
    INSERT INTO crm_opportunities (
        opportunity_name, customer_id, amount, stage_id, close_date
    ) VALUES (
        'Test Opp UT-102',
        (SELECT MIN(customer_id) FROM crm_customers),
        100000,
        (SELECT stage_id FROM crm_opportunity_stage WHERE stage_code = 'QUALIFICATION'),
        SYSDATE + 30
    ) RETURNING opportunity_id INTO v_opp_id;
    
    -- Update to proposal stage
    UPDATE crm_opportunities
    SET stage_id = v_stage_id
    WHERE opportunity_id = v_opp_id;
    
    -- Check probability
    SELECT probability INTO v_probability
    FROM crm_opportunities
    WHERE opportunity_id = v_opp_id;
    
    IF v_probability = 40 THEN
        DBMS_OUTPUT.PUT_LINE('UT-102: PASS - Probability auto-updated to 40%');
    ELSE
        DBMS_OUTPUT.PUT_LINE('UT-102: FAIL - Probability is ' || v_probability || '%, expected 40%');
    END IF;
    
    ROLLBACK;
END;
/

-- Test Case UT-103: Audit trail trigger
DECLARE
    v_cust_id NUMBER;
    v_audit_count NUMBER;
BEGIN
    -- Insert customer
    INSERT INTO crm_customers (
        company_name, status_id, email
    ) VALUES (
        'Test Company UT-103',
        (SELECT status_id FROM crm_customer_status WHERE status_code = 'ACTIVE'),
        'test@ut103.com'
    ) RETURNING customer_id INTO v_cust_id;
    
    -- Update customer
    UPDATE crm_customers
    SET company_name = 'Test Company UT-103 Updated'
    WHERE customer_id = v_cust_id;
    
    -- Check audit trail
    SELECT COUNT(*) INTO v_audit_count
    FROM crm_audit_trail
    WHERE table_name = 'CRM_CUSTOMERS'
      AND record_id = v_cust_id;
    
    IF v_audit_count >= 2 THEN -- INSERT + UPDATE
        DBMS_OUTPUT.PUT_LINE('UT-103: PASS - Audit trail records created (' || v_audit_count || ')');
    ELSE
        DBMS_OUTPUT.PUT_LINE('UT-103: FAIL - Expected 2+ audit records, found ' || v_audit_count);
    END IF;
    
    ROLLBACK;
END;
/
```

### 3.3 Business Logic Package Tests

```sql
-- Test Case UT-201: Lead conversion function
DECLARE
    v_lead_id NUMBER;
    v_customer_id NUMBER;
    v_contact_id NUMBER;
    v_opp_id NUMBER;
    v_lead_status VARCHAR2(20);
BEGIN
    -- Create test lead
    INSERT INTO crm_leads (
        company, first_name, last_name, email, phone,
        status, lead_source_id, industry_id, assigned_to
    ) VALUES (
        'UT-201 Test Company', 'John', 'Doe', 'john@ut201.com', '555-0201',
        'QUALIFIED',
        (SELECT source_id FROM crm_lead_source WHERE ROWNUM = 1),
        (SELECT industry_id FROM crm_industry_type WHERE ROWNUM = 1),
        'TEST_USER'
    ) RETURNING lead_id INTO v_lead_id;
    
    -- Convert lead
    crm_business_logic.convert_lead(
        p_lead_id => v_lead_id,
        p_create_opportunity => 'Y',
        p_opp_amount => 50000,
        p_opp_close_date => ADD_MONTHS(SYSDATE, 2),
        x_customer_id => v_customer_id,
        x_contact_id => v_contact_id,
        x_opportunity_id => v_opp_id
    );
    
    -- Verify results
    SELECT status INTO v_lead_status
    FROM crm_leads
    WHERE lead_id = v_lead_id;
    
    IF v_customer_id IS NOT NULL AND 
       v_contact_id IS NOT NULL AND 
       v_opp_id IS NOT NULL AND 
       v_lead_status = 'CONVERTED' THEN
        DBMS_OUTPUT.PUT_LINE('UT-201: PASS - Lead converted successfully');
        DBMS_OUTPUT.PUT_LINE('  Customer ID: ' || v_customer_id);
        DBMS_OUTPUT.PUT_LINE('  Contact ID: ' || v_contact_id);
        DBMS_OUTPUT.PUT_LINE('  Opportunity ID: ' || v_opp_id);
    ELSE
        DBMS_OUTPUT.PUT_LINE('UT-201: FAIL - Lead conversion incomplete');
    END IF;
    
    ROLLBACK;
END;
/

-- Test Case UT-202: Customer validation function
DECLARE
    v_cust_id NUMBER;
    v_result VARCHAR2(4000);
BEGIN
    -- Create customer without contacts
    INSERT INTO crm_customers (
        company_name, status_id, email
    ) VALUES (
        'UT-202 Test Company',
        (SELECT status_id FROM crm_customer_status WHERE status_code = 'ACTIVE'),
        'test@ut202.com'
    ) RETURNING customer_id INTO v_cust_id;
    
    -- Validate
    v_result := crm_business_logic.validate_customer(v_cust_id);
    
    IF v_result != 'VALID' THEN
        DBMS_OUTPUT.PUT_LINE('UT-202: PASS - Validation caught missing contacts');
        DBMS_OUTPUT.PUT_LINE('  Errors: ' || v_result);
    ELSE
        DBMS_OUTPUT.PUT_LINE('UT-202: FAIL - Should have detected missing contacts');
    END IF;
    
    ROLLBACK;
END;
/

-- Test Case UT-203: Revenue forecast calculation
DECLARE
    v_forecast NUMBER;
    v_expected NUMBER := 0;
BEGIN
    -- Calculate expected forecast from existing data
    SELECT SUM(amount * (probability / 100)) INTO v_expected
    FROM crm_opportunities
    WHERE is_closed = 'N'
      AND close_date BETWEEN SYSDATE AND ADD_MONTHS(SYSDATE, 6);
    
    -- Get forecast from function
    v_forecast := crm_business_logic.get_revenue_forecast(
        p_start_date => SYSDATE,
        p_end_date => ADD_MONTHS(SYSDATE, 6)
    );
    
    IF ABS(v_forecast - v_expected) < 0.01 THEN
        DBMS_OUTPUT.PUT_LINE('UT-203: PASS - Forecast calculation correct');
        DBMS_OUTPUT.PUT_LINE('  Forecast: $' || TO_CHAR(v_forecast, '999,999,999.00'));
    ELSE
        DBMS_OUTPUT.PUT_LINE('UT-203: FAIL - Forecast mismatch');
        DBMS_OUTPUT.PUT_LINE('  Expected: $' || TO_CHAR(v_expected, '999,999,999.00'));
        DBMS_OUTPUT.PUT_LINE('  Actual: $' || TO_CHAR(v_forecast, '999,999,999.00'));
    END IF;
END;
/
```

---

## 4. Integration Tests

### 4.1 Cross-Entity Tests

```sql
-- Test Case IT-001: Customer > Contact > Opportunity chain
DECLARE
    v_cust_id NUMBER;
    v_cont_id NUMBER;
    v_opp_id NUMBER;
    v_count NUMBER;
BEGIN
    -- Create customer
    INSERT INTO crm_customers (
        company_name, status_id, email
    ) VALUES (
        'IT-001 Integration Test',
        (SELECT status_id FROM crm_customer_status WHERE status_code = 'ACTIVE'),
        'test@it001.com'
    ) RETURNING customer_id INTO v_cust_id;
    
    -- Create contact
    INSERT INTO crm_contacts (
        customer_id, first_name, last_name, email, is_primary
    ) VALUES (
        v_cust_id, 'Jane', 'Smith', 'jane@it001.com', 'Y'
    ) RETURNING contact_id INTO v_cont_id;
    
    -- Create opportunity
    INSERT INTO crm_opportunities (
        opportunity_name, customer_id, contact_id, amount,
        stage_id, close_date
    ) VALUES (
        'IT-001 Test Opportunity', v_cust_id, v_cont_id, 75000,
        (SELECT stage_id FROM crm_opportunity_stage WHERE stage_code = 'PROPOSAL'),
        ADD_MONTHS(SYSDATE, 1)
    ) RETURNING opportunity_id INTO v_opp_id;
    
    -- Verify relationships
    SELECT COUNT(*) INTO v_count
    FROM crm_opportunities o
    JOIN crm_customers c ON o.customer_id = c.customer_id
    JOIN crm_contacts ct ON o.contact_id = ct.contact_id
    WHERE o.opportunity_id = v_opp_id
      AND c.customer_id = v_cust_id
      AND ct.contact_id = v_cont_id;
    
    IF v_count = 1 THEN
        DBMS_OUTPUT.PUT_LINE('IT-001: PASS - Entity relationships working');
    ELSE
        DBMS_OUTPUT.PUT_LINE('IT-001: FAIL - Relationship verification failed');
    END IF;
    
    ROLLBACK;
END;
/

-- Test Case IT-002: Cascade delete test
DECLARE
    v_cust_id NUMBER;
    v_initial_count NUMBER;
    v_final_count NUMBER;
BEGIN
    -- Create customer with related records
    INSERT INTO crm_customers (
        company_name, status_id, email
    ) VALUES (
        'IT-002 Delete Test',
        (SELECT status_id FROM crm_customer_status WHERE status_code = 'ACTIVE'),
        'test@it002.com'
    ) RETURNING customer_id INTO v_cust_id;
    
    INSERT INTO crm_contacts (customer_id, first_name, last_name, email)
    VALUES (v_cust_id, 'Test', 'Contact', 'contact@it002.com');
    
    INSERT INTO crm_opportunities (opportunity_name, customer_id, amount, stage_id, close_date)
    VALUES ('IT-002 Opp', v_cust_id, 10000, 
            (SELECT stage_id FROM crm_opportunity_stage WHERE ROWNUM = 1),
            SYSDATE + 30);
    
    -- Count related records
    SELECT COUNT(*) INTO v_initial_count
    FROM (
        SELECT contact_id FROM crm_contacts WHERE customer_id = v_cust_id
        UNION ALL
        SELECT opportunity_id FROM crm_opportunities WHERE customer_id = v_cust_id
    );
    
    -- Delete customer
    DELETE FROM crm_customers WHERE customer_id = v_cust_id;
    
    -- Verify cascade delete
    SELECT COUNT(*) INTO v_final_count
    FROM (
        SELECT contact_id FROM crm_contacts WHERE customer_id = v_cust_id
        UNION ALL
        SELECT opportunity_id FROM crm_opportunities WHERE customer_id = v_cust_id
    );
    
    IF v_initial_count > 0 AND v_final_count = 0 THEN
        DBMS_OUTPUT.PUT_LINE('IT-002: PASS - Cascade delete working (' || v_initial_count || ' records deleted)');
    ELSE
        DBMS_OUTPUT.PUT_LINE('IT-002: FAIL - Cascade delete failed');
    END IF;
    
    ROLLBACK;
END;
/
```

---

## 5. Functional Tests

### 5.1 Lead Management Test Cases

| Test ID | Test Case | Steps | Expected Result | Status |
|---------|-----------|-------|-----------------|--------|
| FT-001 | Create new lead | 1. Navigate to Leads<br>2. Click Create<br>3. Fill required fields<br>4. Save | Lead created with auto-generated lead number | |
| FT-002 | Qualify lead | 1. Open lead<br>2. Change status to QUALIFIED<br>3. Save | Status updated, can now convert | |
| FT-003 | Convert lead to customer | 1. Open qualified lead<br>2. Click Convert<br>3. Review info<br>4. Create opportunity: Yes<br>5. Enter amount<br>6. Complete | Customer, contact, opportunity created; lead marked CONVERTED | |
| FT-004 | Prevent duplicate lead conversion | 1. Open converted lead<br>2. Try to convert again | Error message: Lead already converted | |

### 5.2 Opportunity Management Test Cases

| Test ID | Test Case | Steps | Expected Result | Status |
|---------|-----------|-------|-----------------|--------|
| FT-101 | Create opportunity | 1. Navigate to Opportunities<br>2. Click Create<br>3. Select customer<br>4. Enter amount, close date<br>5. Save | Opportunity created with number OPP-XXXXXX | |
| FT-102 | Progress through stages | 1. Open opportunity<br>2. Change stage to Needs Analysis<br>3. Save<br>4. Change to Proposal<br>5. Save | Probability updates: 10% → 20% → 40% | |
| FT-103 | Close opportunity as won | 1. Open opportunity<br>2. Change stage to Closed Won<br>3. Save | Probability = 100%, is_closed = Y, closed_date set | |
| FT-104 | Close opportunity as lost | 1. Open opportunity<br>2. Change stage to Closed Lost<br>3. Add lost reason in notes<br>4. Save | Probability = 0%, is_closed = Y, closed_date set | |

### 5.3 Activity Management Test Cases

| Test ID | Test Case | Steps | Expected Result | Status |
|---------|-----------|-------|-----------------|--------|
| FT-201 | Create task | 1. Navigate to Activities<br>2. Click Create<br>3. Select type: Task<br>4. Fill subject, due date<br>5. Link to opportunity<br>6. Save | Task created and linked | |
| FT-202 | Set activity reminder | 1. Create activity<br>2. Enable reminder<br>3. Set 30 minutes before<br>4. Save | Reminder configured | |
| FT-203 | Complete activity | 1. Open activity<br>2. Add completion notes<br>3. Change status to Completed<br>4. Save | completed_date set, appears in completed list | |
| FT-204 | View calendar | 1. Navigate to Activities<br>2. Switch to Calendar view | All activities shown on calendar | |

---

## 6. Performance Tests

```sql
-- Test Case PT-001: Query performance - Customer list with joins
SET TIMING ON
SET AUTOTRACE ON

SELECT 
    c.customer_id,
    c.account_number,
    c.company_name,
    cs.status_name,
    i.industry_name,
    (SELECT COUNT(*) FROM crm_contacts WHERE customer_id = c.customer_id) as contact_count,
    (SELECT COUNT(*) FROM crm_opportunities WHERE customer_id = c.customer_id AND is_closed = 'N') as open_opps
FROM crm_customers c
JOIN crm_customer_status cs ON c.status_id = cs.status_id
LEFT JOIN crm_industry_type i ON c.industry_id = i.industry_id
ORDER BY c.created_date DESC
FETCH FIRST 100 ROWS ONLY;

SET AUTOTRACE OFF
SET TIMING OFF

-- Expected: < 1 second for 100 rows

-- Test Case PT-002: Opportunity pipeline query
SET TIMING ON

SELECT 
    o.opportunity_id,
    o.opportunity_number,
    o.opportunity_name,
    c.company_name,
    s.stage_name,
    o.amount,
    o.probability,
    o.close_date,
    o.amount * (o.probability / 100) as weighted_value
FROM crm_opportunities o
JOIN crm_customers c ON o.customer_id = c.customer_id
JOIN crm_opportunity_stage s ON o.stage_id = s.stage_id
WHERE o.is_closed = 'N'
ORDER BY o.close_date, o.amount DESC;

SET TIMING OFF

-- Expected: < 0.5 seconds
```

---

## 7. Security Tests

### 7.1 Access Control Tests

| Test ID | Test Case | Expected Result | Status |
|---------|-----------|-----------------|--------|
| ST-001 | Login with valid credentials | Successful login, redirect to dashboard | |
| ST-002 | Login with invalid credentials | Login failed, error message displayed | |
| ST-003 | Session timeout | Session expires after 8 hours inactivity | |
| ST-004 | SQL injection attempt | Input sanitized, query fails safely | |
| ST-005 | Access admin page as regular user | Access denied, redirect to home | |

### 7.2 Data Security Tests

```sql
-- Test Case ST-101: Audit trail completeness
SELECT 
    action_type,
    COUNT(*) as occurrence_count
FROM crm_audit_trail
GROUP BY action_type
ORDER BY action_type;

-- Expected: INSERT, UPDATE, DELETE all present

-- Test Case ST-102: Sensitive data protection
SELECT 
    CASE 
        WHEN email LIKE '%@%' THEN 'PASS'
        ELSE 'FAIL'
    END as email_format_check,
    COUNT(*) as count
FROM (
    SELECT email FROM crm_customers
    UNION ALL
    SELECT email FROM crm_contacts
    UNION ALL
    SELECT email FROM crm_leads
)
GROUP BY 
    CASE 
        WHEN email LIKE '%@%' THEN 'PASS'
        ELSE 'FAIL'
    END;

-- Expected: All PASS
```

---

## 8. User Acceptance Tests

### 8.1 UAT Scenarios

**UAT-001: Complete Lead to Close Workflow**
1. Create new lead from website inquiry
2. Assign to sales rep
3. Sales rep contacts lead
4. Qualify and convert lead
5. Create opportunity with $100,000 value
6. Progress through all stages
7. Close as won
8. Verify customer record, opportunity record, all activities logged

**UAT-002: Customer Management**
1. Create new customer account
2. Add 3 contacts (1 primary, 2 secondary)
3. Add company details and address
4. Create follow-up task
5. Add notes
6. Update customer status
7. View complete customer profile

**UAT-003: Sales Pipeline Review**
1. View all open opportunities
2. Filter by stage
3. Sort by close date
4. View pipeline value by stage
5. Generate forecast report
6. Export to Excel

**UAT-004: Activity Tracking**
1. Create call activity for tomorrow
2. Set reminder for 1 hour before
3. View in calendar
4. Receive reminder (simulated)
5. Complete activity with notes
6. Create follow-up meeting
7. View activity history

---

## Test Execution Summary Template

```
CRM Application Test Execution Summary
Date: __________
Tester: __________
Environment: __________

Test Results:
- Total Test Cases: ______
- Passed: ______
- Failed: ______
- Blocked: ______
- Not Executed: ______

Pass Rate: ______%

Critical Issues Found: ______
High Priority Issues: ______
Medium Priority Issues: ______
Low Priority Issues: ______

Overall Status: PASS / FAIL / CONDITIONAL PASS

Comments:
_________________________________
_________________________________
_________________________________

Tester Signature: __________
Date: __________
```

---

*Test Plan Version: 1.0*  
*Last Updated: February 14, 2026*
