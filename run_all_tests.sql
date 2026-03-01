-- ============================================================================
-- CRM Application - Automated Test Execution Script
-- Version: 1.0
-- Description: Run all database tests and generate report
-- ============================================================================

SET SERVEROUTPUT ON SIZE UNLIMITED
SET FEEDBACK OFF
SET VERIFY OFF
SET HEADING OFF

SPOOL test_results.log

PROMPT ========================================================================
PROMPT CRM Application - Automated Test Suite
PROMPT ========================================================================
PROMPT Test Start Time: 
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') FROM DUAL;
PROMPT ========================================================================
PROMPT

-- ============================================================================
-- SECTION 1: SCHEMA VALIDATION TESTS
-- ============================================================================

PROMPT ========================================================================
PROMPT SECTION 1: SCHEMA VALIDATION TESTS
PROMPT ========================================================================
PROMPT

-- Test 1.1: Table Count
PROMPT Test 1.1: Verify Table Count
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count FROM user_tables WHERE table_name LIKE 'CRM_%';
    IF v_count >= 18 THEN
        DBMS_OUTPUT.PUT_LINE('[PASS] Table count: ' || v_count || ' tables found');
    ELSE
        DBMS_OUTPUT.PUT_LINE('[FAIL] Table count: Expected 18+, found ' || v_count);
    END IF;
END;
/

-- Test 1.2: Sequence Check
PROMPT Test 1.2: Verify Sequences
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count FROM user_sequences WHERE sequence_name LIKE 'CRM_%';
    IF v_count >= 3 THEN
        DBMS_OUTPUT.PUT_LINE('[PASS] Sequence count: ' || v_count || ' sequences found');
    ELSE
        DBMS_OUTPUT.PUT_LINE('[FAIL] Sequence count: Expected 3+, found ' || v_count);
    END IF;
END;
/

-- Test 1.3: Trigger Check
PROMPT Test 1.3: Verify Triggers
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count FROM user_triggers WHERE trigger_name LIKE 'TRG_%';
    IF v_count >= 5 THEN
        DBMS_OUTPUT.PUT_LINE('[PASS] Trigger count: ' || v_count || ' triggers found');
    ELSE
        DBMS_OUTPUT.PUT_LINE('[FAIL] Trigger count: Expected 5+, found ' || v_count);
    END IF;
END;
/

-- Test 1.4: Package Check
PROMPT Test 1.4: Verify Business Logic Package
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count 
    FROM user_objects 
    WHERE object_name = 'CRM_BUSINESS_LOGIC' 
      AND object_type = 'PACKAGE';
    IF v_count = 1 THEN
        DBMS_OUTPUT.PUT_LINE('[PASS] Package CRM_BUSINESS_LOGIC exists');
    ELSE
        DBMS_OUTPUT.PUT_LINE('[FAIL] Package CRM_BUSINESS_LOGIC not found');
    END IF;
END;
/

-- Test 1.5: Constraint Check
PROMPT Test 1.5: Verify Constraints
DECLARE
    v_pk_count NUMBER;
    v_fk_count NUMBER;
    v_ck_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_pk_count 
    FROM user_constraints WHERE constraint_type = 'P' AND table_name LIKE 'CRM_%';
    
    SELECT COUNT(*) INTO v_fk_count 
    FROM user_constraints WHERE constraint_type = 'R' AND table_name LIKE 'CRM_%';
    
    SELECT COUNT(*) INTO v_ck_count 
    FROM user_constraints WHERE constraint_type = 'C' 
    AND constraint_name NOT LIKE 'SYS_%' AND table_name LIKE 'CRM_%';
    
    DBMS_OUTPUT.PUT_LINE('[INFO] Primary Keys: ' || v_pk_count);
    DBMS_OUTPUT.PUT_LINE('[INFO] Foreign Keys: ' || v_fk_count);
    DBMS_OUTPUT.PUT_LINE('[INFO] Check Constraints: ' || v_ck_count);
    
    IF v_pk_count >= 18 AND v_fk_count >= 10 THEN
        DBMS_OUTPUT.PUT_LINE('[PASS] Constraints validated');
    ELSE
        DBMS_OUTPUT.PUT_LINE('[FAIL] Insufficient constraints');
    END IF;
END;
/

PROMPT

-- ============================================================================
-- SECTION 2: DATA INTEGRITY TESTS
-- ============================================================================

PROMPT ========================================================================
PROMPT SECTION 2: DATA INTEGRITY TESTS
PROMPT ========================================================================
PROMPT

-- Test 2.1: Lookup Data Population
PROMPT Test 2.1: Verify Lookup Data
DECLARE
    v_status_count NUMBER;
    v_source_count NUMBER;
    v_industry_count NUMBER;
    v_stage_count NUMBER;
    v_activity_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_status_count FROM crm_customer_status;
    SELECT COUNT(*) INTO v_source_count FROM crm_lead_source;
    SELECT COUNT(*) INTO v_industry_count FROM crm_industry_type;
    SELECT COUNT(*) INTO v_stage_count FROM crm_opportunity_stage;
    SELECT COUNT(*) INTO v_activity_count FROM crm_activity_type;
    
    DBMS_OUTPUT.PUT_LINE('[INFO] Customer Statuses: ' || v_status_count);
    DBMS_OUTPUT.PUT_LINE('[INFO] Lead Sources: ' || v_source_count);
    DBMS_OUTPUT.PUT_LINE('[INFO] Industries: ' || v_industry_count);
    DBMS_OUTPUT.PUT_LINE('[INFO] Opportunity Stages: ' || v_stage_count);
    DBMS_OUTPUT.PUT_LINE('[INFO] Activity Types: ' || v_activity_count);
    
    IF v_status_count > 0 AND v_source_count > 0 AND v_industry_count > 0 
       AND v_stage_count > 0 AND v_activity_count > 0 THEN
        DBMS_OUTPUT.PUT_LINE('[PASS] All lookup tables populated');
    ELSE
        DBMS_OUTPUT.PUT_LINE('[FAIL] Some lookup tables empty');
    END IF;
END;
/

-- Test 2.2: Referential Integrity
PROMPT Test 2.2: Verify Referential Integrity
DECLARE
    v_orphan_contacts NUMBER;
    v_orphan_opps NUMBER;
BEGIN
    -- Check for orphaned contacts
    SELECT COUNT(*) INTO v_orphan_contacts
    FROM crm_contacts c
    WHERE NOT EXISTS (SELECT 1 FROM crm_customers WHERE customer_id = c.customer_id);
    
    -- Check for orphaned opportunities
    SELECT COUNT(*) INTO v_orphan_opps
    FROM crm_opportunities o
    WHERE NOT EXISTS (SELECT 1 FROM crm_customers WHERE customer_id = o.customer_id);
    
    IF v_orphan_contacts = 0 AND v_orphan_opps = 0 THEN
        DBMS_OUTPUT.PUT_LINE('[PASS] No orphaned records found');
    ELSE
        DBMS_OUTPUT.PUT_LINE('[FAIL] Orphaned records detected');
        DBMS_OUTPUT.PUT_LINE('  Orphaned contacts: ' || v_orphan_contacts);
        DBMS_OUTPUT.PUT_LINE('  Orphaned opportunities: ' || v_orphan_opps);
    END IF;
END;
/

PROMPT

-- ============================================================================
-- SECTION 3: TRIGGER FUNCTIONALITY TESTS
-- ============================================================================

PROMPT ========================================================================
PROMPT SECTION 3: TRIGGER FUNCTIONALITY TESTS
PROMPT ========================================================================
PROMPT

-- Test 3.1: Auto-numbering Trigger
PROMPT Test 3.1: Auto-numbering Trigger Test
DECLARE
    v_cust_id NUMBER;
    v_account_num VARCHAR2(20);
BEGIN
    INSERT INTO crm_customers (
        company_name, status_id, email
    ) VALUES (
        'Test Auto Number',
        (SELECT status_id FROM crm_customer_status WHERE ROWNUM = 1),
        'test@autonumber.com'
    ) RETURNING customer_id, account_number INTO v_cust_id, v_account_num;
    
    IF v_account_num LIKE 'ACCT-%' THEN
        DBMS_OUTPUT.PUT_LINE('[PASS] Auto-numbering working: ' || v_account_num);
    ELSE
        DBMS_OUTPUT.PUT_LINE('[FAIL] Auto-numbering failed: ' || NVL(v_account_num, 'NULL'));
    END IF;
    
    ROLLBACK;
END;
/

-- Test 3.2: Audit Trail Trigger
PROMPT Test 3.2: Audit Trail Trigger Test
DECLARE
    v_cust_id NUMBER;
    v_audit_count NUMBER;
BEGIN
    INSERT INTO crm_customers (
        company_name, status_id, email
    ) VALUES (
        'Test Audit Trail',
        (SELECT status_id FROM crm_customer_status WHERE ROWNUM = 1),
        'test@audit.com'
    ) RETURNING customer_id INTO v_cust_id;
    
    UPDATE crm_customers
    SET company_name = 'Test Audit Trail Updated'
    WHERE customer_id = v_cust_id;
    
    SELECT COUNT(*) INTO v_audit_count
    FROM crm_audit_trail
    WHERE table_name = 'CRM_CUSTOMERS'
      AND record_id = v_cust_id;
    
    IF v_audit_count >= 2 THEN
        DBMS_OUTPUT.PUT_LINE('[PASS] Audit trail trigger working (' || v_audit_count || ' records)');
    ELSE
        DBMS_OUTPUT.PUT_LINE('[FAIL] Audit trail trigger failed');
    END IF;
    
    ROLLBACK;
END;
/

-- Test 3.3: Opportunity Stage Update Trigger
PROMPT Test 3.3: Opportunity Stage Update Trigger Test
DECLARE
    v_opp_id NUMBER;
    v_probability NUMBER;
    v_is_closed CHAR(1);
BEGIN
    -- Create opportunity in qualification stage
    INSERT INTO crm_opportunities (
        opportunity_name, customer_id, amount, stage_id, close_date
    ) VALUES (
        'Test Stage Update',
        (SELECT MIN(customer_id) FROM crm_customers),
        50000,
        (SELECT stage_id FROM crm_opportunity_stage WHERE stage_code = 'QUALIFICATION'),
        SYSDATE + 30
    ) RETURNING opportunity_id INTO v_opp_id;
    
    -- Update to closed won
    UPDATE crm_opportunities
    SET stage_id = (SELECT stage_id FROM crm_opportunity_stage WHERE stage_code = 'CLOSED_WON')
    WHERE opportunity_id = v_opp_id;
    
    SELECT probability, is_closed INTO v_probability, v_is_closed
    FROM crm_opportunities
    WHERE opportunity_id = v_opp_id;
    
    IF v_probability = 100 AND v_is_closed = 'Y' THEN
        DBMS_OUTPUT.PUT_LINE('[PASS] Stage update trigger working correctly');
    ELSE
        DBMS_OUTPUT.PUT_LINE('[FAIL] Stage update trigger failed');
        DBMS_OUTPUT.PUT_LINE('  Probability: ' || v_probability || ' (expected 100)');
        DBMS_OUTPUT.PUT_LINE('  Is Closed: ' || v_is_closed || ' (expected Y)');
    END IF;
    
    ROLLBACK;
END;
/

PROMPT

-- ============================================================================
-- SECTION 4: BUSINESS LOGIC TESTS
-- ============================================================================

PROMPT ========================================================================
PROMPT SECTION 4: BUSINESS LOGIC TESTS
PROMPT ========================================================================
PROMPT

-- Test 4.1: Lead Conversion
PROMPT Test 4.1: Lead Conversion Test
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
        status, lead_source_id, industry_id
    ) VALUES (
        'Test Conversion Co', 'John', 'Tester', 'john@testconv.com', '555-0999',
        'QUALIFIED',
        (SELECT source_id FROM crm_lead_source WHERE ROWNUM = 1),
        (SELECT industry_id FROM crm_industry_type WHERE ROWNUM = 1)
    ) RETURNING lead_id INTO v_lead_id;
    
    -- Convert lead
    crm_business_logic.convert_lead(
        p_lead_id => v_lead_id,
        p_create_opportunity => 'Y',
        p_opp_amount => 75000,
        p_opp_close_date => ADD_MONTHS(SYSDATE, 2),
        x_customer_id => v_customer_id,
        x_contact_id => v_contact_id,
        x_opportunity_id => v_opp_id
    );
    
    SELECT status INTO v_lead_status FROM crm_leads WHERE lead_id = v_lead_id;
    
    IF v_customer_id IS NOT NULL AND v_contact_id IS NOT NULL 
       AND v_opp_id IS NOT NULL AND v_lead_status = 'CONVERTED' THEN
        DBMS_OUTPUT.PUT_LINE('[PASS] Lead conversion successful');
        DBMS_OUTPUT.PUT_LINE('  Customer ID: ' || v_customer_id);
        DBMS_OUTPUT.PUT_LINE('  Contact ID: ' || v_contact_id);
        DBMS_OUTPUT.PUT_LINE('  Opportunity ID: ' || v_opp_id);
    ELSE
        DBMS_OUTPUT.PUT_LINE('[FAIL] Lead conversion failed');
    END IF;
    
    ROLLBACK;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('[FAIL] Lead conversion error: ' || SQLERRM);
        ROLLBACK;
END;
/

-- Test 4.2: Revenue Forecast Calculation
PROMPT Test 4.2: Revenue Forecast Calculation Test
DECLARE
    v_forecast NUMBER;
BEGIN
    v_forecast := crm_business_logic.get_revenue_forecast(
        p_start_date => SYSDATE,
        p_end_date => ADD_MONTHS(SYSDATE, 12)
    );
    
    IF v_forecast >= 0 THEN
        DBMS_OUTPUT.PUT_LINE('[PASS] Revenue forecast calculated: $' || 
                            TO_CHAR(v_forecast, '999,999,999.00'));
    ELSE
        DBMS_OUTPUT.PUT_LINE('[FAIL] Invalid forecast value');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('[FAIL] Forecast calculation error: ' || SQLERRM);
END;
/

-- Test 4.3: Customer Health Score
PROMPT Test 4.3: Customer Health Score Test
DECLARE
    v_health_score NUMBER;
    v_customer_id NUMBER;
BEGIN
    SELECT MIN(customer_id) INTO v_customer_id FROM crm_customers;
    
    IF v_customer_id IS NOT NULL THEN
        v_health_score := crm_business_logic.calculate_customer_health(v_customer_id);
        
        IF v_health_score BETWEEN 0 AND 100 THEN
            DBMS_OUTPUT.PUT_LINE('[PASS] Health score calculated: ' || v_health_score);
        ELSE
            DBMS_OUTPUT.PUT_LINE('[FAIL] Invalid health score: ' || v_health_score);
        END IF;
    ELSE
        DBMS_OUTPUT.PUT_LINE('[SKIP] No customers available for testing');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('[FAIL] Health score error: ' || SQLERRM);
END;
/

PROMPT

-- ============================================================================
-- SECTION 5: PERFORMANCE TESTS
-- ============================================================================

PROMPT ========================================================================
PROMPT SECTION 5: PERFORMANCE TESTS
PROMPT ========================================================================
PROMPT

-- Test 5.1: Customer Query Performance
PROMPT Test 5.1: Customer Query Performance Test
DECLARE
    v_start_time TIMESTAMP;
    v_end_time TIMESTAMP;
    v_elapsed_ms NUMBER;
    v_count NUMBER;
BEGIN
    v_start_time := SYSTIMESTAMP;
    
    SELECT COUNT(*) INTO v_count
    FROM crm_customers c
    JOIN crm_customer_status cs ON c.status_id = cs.status_id
    LEFT JOIN crm_industry_type i ON c.industry_id = i.industry_id;
    
    v_end_time := SYSTIMESTAMP;
    v_elapsed_ms := EXTRACT(SECOND FROM (v_end_time - v_start_time)) * 1000;
    
    DBMS_OUTPUT.PUT_LINE('[INFO] Query returned ' || v_count || ' rows');
    DBMS_OUTPUT.PUT_LINE('[INFO] Execution time: ' || ROUND(v_elapsed_ms, 2) || ' ms');
    
    IF v_elapsed_ms < 1000 THEN
        DBMS_OUTPUT.PUT_LINE('[PASS] Query performance acceptable');
    ELSE
        DBMS_OUTPUT.PUT_LINE('[WARN] Query performance may need optimization');
    END IF;
END;
/

PROMPT

-- ============================================================================
-- TEST SUMMARY
-- ============================================================================

PROMPT ========================================================================
PROMPT TEST EXECUTION SUMMARY
PROMPT ========================================================================
PROMPT
PROMPT Test End Time: 
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') FROM DUAL;
PROMPT
PROMPT Review test_results.log for detailed results
PROMPT ========================================================================

SPOOL OFF

SET FEEDBACK ON
SET VERIFY ON
SET HEADING ON

PROMPT
PROMPT Test execution complete. Check test_results.log for full report.
PROMPT
