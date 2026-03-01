-- ============================================================================
-- Oracle APEX CRM Application - Triggers and Business Logic
-- Version: 1.0
-- Description: Triggers, procedures, and packages for CRM automation
-- ============================================================================

-- ============================================================================
-- TRIGGERS FOR AUDIT TRAIL
-- ============================================================================

-- Customer Audit Trigger
CREATE OR REPLACE TRIGGER trg_cust_audit
AFTER INSERT OR UPDATE OR DELETE ON crm_customers
FOR EACH ROW
DECLARE
    v_action VARCHAR2(20);
BEGIN
    IF INSERTING THEN
        v_action := 'INSERT';
        INSERT INTO crm_audit_trail (table_name, record_id, action_type, action_by)
        VALUES ('CRM_CUSTOMERS', :NEW.customer_id, v_action, USER);
    ELSIF UPDATING THEN
        v_action := 'UPDATE';
        -- Track specific field changes
        IF :OLD.company_name != :NEW.company_name THEN
            INSERT INTO crm_audit_trail (table_name, record_id, action_type, field_name, old_value, new_value)
            VALUES ('CRM_CUSTOMERS', :NEW.customer_id, v_action, 'COMPANY_NAME', :OLD.company_name, :NEW.company_name);
        END IF;
        IF NVL(:OLD.annual_revenue,0) != NVL(:NEW.annual_revenue,0) THEN
            INSERT INTO crm_audit_trail (table_name, record_id, action_type, field_name, old_value, new_value)
            VALUES ('CRM_CUSTOMERS', :NEW.customer_id, v_action, 'ANNUAL_REVENUE', TO_CHAR(:OLD.annual_revenue), TO_CHAR(:NEW.annual_revenue));
        END IF;
    ELSIF DELETING THEN
        v_action := 'DELETE';
        INSERT INTO crm_audit_trail (table_name, record_id, action_type, action_by)
        VALUES ('CRM_CUSTOMERS', :OLD.customer_id, v_action, USER);
    END IF;
END;
/

-- Opportunity Audit Trigger
CREATE OR REPLACE TRIGGER trg_opp_audit
AFTER INSERT OR UPDATE OR DELETE ON crm_opportunities
FOR EACH ROW
DECLARE
    v_action VARCHAR2(20);
BEGIN
    IF INSERTING THEN
        INSERT INTO crm_audit_trail (table_name, record_id, action_type)
        VALUES ('CRM_OPPORTUNITIES', :NEW.opportunity_id, 'INSERT');
    ELSIF UPDATING THEN
        IF :OLD.stage_id != :NEW.stage_id THEN
            INSERT INTO crm_audit_trail (table_name, record_id, action_type, field_name, old_value, new_value)
            VALUES ('CRM_OPPORTUNITIES', :NEW.opportunity_id, 'UPDATE', 'STAGE_ID', TO_CHAR(:OLD.stage_id), TO_CHAR(:NEW.stage_id));
        END IF;
        IF NVL(:OLD.amount,0) != NVL(:NEW.amount,0) THEN
            INSERT INTO crm_audit_trail (table_name, record_id, action_type, field_name, old_value, new_value)
            VALUES ('CRM_OPPORTUNITIES', :NEW.opportunity_id, 'UPDATE', 'AMOUNT', TO_CHAR(:OLD.amount), TO_CHAR(:NEW.amount));
        END IF;
    ELSIF DELETING THEN
        INSERT INTO crm_audit_trail (table_name, record_id, action_type)
        VALUES ('CRM_OPPORTUNITIES', :OLD.opportunity_id, 'DELETE');
    END IF;
END;
/

-- ============================================================================
-- TRIGGERS FOR AUTO-NUMBERING
-- ============================================================================

-- Customer Account Number Trigger
CREATE OR REPLACE TRIGGER trg_cust_account_num
BEFORE INSERT ON crm_customers
FOR EACH ROW
WHEN (NEW.account_number IS NULL)
BEGIN
    :NEW.account_number := 'ACCT-' || LPAD(crm_account_num_seq.NEXTVAL, 6, '0');
END;
/

-- Opportunity Number Trigger
CREATE OR REPLACE TRIGGER trg_opp_number
BEFORE INSERT ON crm_opportunities
FOR EACH ROW
WHEN (NEW.opportunity_number IS NULL)
BEGIN
    :NEW.opportunity_number := 'OPP-' || LPAD(crm_opp_num_seq.NEXTVAL, 6, '0');
END;
/

-- Lead Number Trigger
CREATE OR REPLACE TRIGGER trg_lead_number
BEFORE INSERT ON crm_leads
FOR EACH ROW
WHEN (NEW.lead_number IS NULL)
BEGIN
    :NEW.lead_number := 'LEAD-' || LPAD(crm_lead_num_seq.NEXTVAL, 6, '0');
END;
/

-- ============================================================================
-- TRIGGERS FOR TIMESTAMP MANAGEMENT
-- ============================================================================

-- Customer Modified Date Trigger
CREATE OR REPLACE TRIGGER trg_cust_modified
BEFORE UPDATE ON crm_customers
FOR EACH ROW
BEGIN
    :NEW.modified_by := USER;
    :NEW.modified_date := CURRENT_TIMESTAMP;
END;
/

-- Contact Modified Date Trigger
CREATE OR REPLACE TRIGGER trg_contact_modified
BEFORE UPDATE ON crm_contacts
FOR EACH ROW
BEGIN
    :NEW.modified_by := USER;
    :NEW.modified_date := CURRENT_TIMESTAMP;
END;
/

-- Lead Modified Date Trigger
CREATE OR REPLACE TRIGGER trg_lead_modified
BEFORE UPDATE ON crm_leads
FOR EACH ROW
BEGIN
    :NEW.modified_by := USER;
    :NEW.modified_date := CURRENT_TIMESTAMP;
END;
/

-- Opportunity Modified Date Trigger
CREATE OR REPLACE TRIGGER trg_opp_modified
BEFORE UPDATE ON crm_opportunities
FOR EACH ROW
BEGIN
    :NEW.modified_by := USER;
    :NEW.modified_date := CURRENT_TIMESTAMP;
    
    -- Auto-update probability based on stage
    IF :OLD.stage_id != :NEW.stage_id THEN
        SELECT probability INTO :NEW.probability
        FROM crm_opportunity_stage
        WHERE stage_id = :NEW.stage_id;
    END IF;
    
    -- Auto-update closed date and flags when stage changes to closed
    SELECT is_closed, is_won INTO :NEW.is_closed, :NEW.is_won
    FROM crm_opportunity_stage
    WHERE stage_id = :NEW.stage_id;
    
    IF :NEW.is_closed = 'Y' AND :OLD.is_closed = 'N' THEN
        :NEW.closed_date := SYSDATE;
    END IF;
END;
/

-- Activity Modified Date Trigger
CREATE OR REPLACE TRIGGER trg_activity_modified
BEFORE UPDATE ON crm_activities
FOR EACH ROW
BEGIN
    :NEW.modified_by := USER;
    :NEW.modified_date := CURRENT_TIMESTAMP;
    
    -- Auto-set completed date when status changes to completed
    IF :NEW.status = 'COMPLETED' AND :OLD.status != 'COMPLETED' THEN
        :NEW.completed_date := CURRENT_TIMESTAMP;
    END IF;
END;
/

-- ============================================================================
-- BUSINESS LOGIC PACKAGE
-- ============================================================================

CREATE OR REPLACE PACKAGE crm_business_logic AS
    -- Lead conversion
    PROCEDURE convert_lead (
        p_lead_id           IN NUMBER,
        p_create_opportunity IN VARCHAR2 DEFAULT 'Y',
        p_opp_amount        IN NUMBER DEFAULT NULL,
        p_opp_close_date    IN DATE DEFAULT NULL,
        x_customer_id       OUT NUMBER,
        x_contact_id        OUT NUMBER,
        x_opportunity_id    OUT NUMBER
    );
    
    -- Customer validation
    FUNCTION validate_customer (
        p_customer_id IN NUMBER
    ) RETURN VARCHAR2;
    
    -- Opportunity probability calculation
    FUNCTION calculate_win_probability (
        p_opportunity_id IN NUMBER
    ) RETURN NUMBER;
    
    -- Activity reminder check
    PROCEDURE check_activity_reminders;
    
    -- Revenue forecasting
    FUNCTION get_revenue_forecast (
        p_start_date IN DATE,
        p_end_date   IN DATE
    ) RETURN NUMBER;
    
    -- Customer health score
    FUNCTION calculate_customer_health (
        p_customer_id IN NUMBER
    ) RETURN NUMBER;
    
END crm_business_logic;
/

CREATE OR REPLACE PACKAGE BODY crm_business_logic AS

    -- Convert Lead to Customer/Contact/Opportunity
    PROCEDURE convert_lead (
        p_lead_id           IN NUMBER,
        p_create_opportunity IN VARCHAR2 DEFAULT 'Y',
        p_opp_amount        IN NUMBER DEFAULT NULL,
        p_opp_close_date    IN DATE DEFAULT NULL,
        x_customer_id       OUT NUMBER,
        x_contact_id        OUT NUMBER,
        x_opportunity_id    OUT NUMBER
    ) IS
        v_lead crm_leads%ROWTYPE;
        v_status_id NUMBER;
    BEGIN
        -- Get lead details
        SELECT * INTO v_lead FROM crm_leads WHERE lead_id = p_lead_id;
        
        -- Check if already converted
        IF v_lead.status = 'CONVERTED' THEN
            RAISE_APPLICATION_ERROR(-20001, 'Lead has already been converted');
        END IF;
        
        -- Get default active customer status
        SELECT status_id INTO v_status_id 
        FROM crm_customer_status 
        WHERE status_code = 'ACTIVE' AND ROWNUM = 1;
        
        -- Create Customer
        INSERT INTO crm_customers (
            company_name, website, phone, email, industry_id, status_id,
            annual_revenue, employee_count, billing_street, billing_city,
            billing_state, billing_postal, billing_country, description,
            assigned_to
        ) VALUES (
            v_lead.company, v_lead.website, v_lead.phone, v_lead.email,
            v_lead.industry_id, v_status_id, v_lead.annual_revenue,
            v_lead.employee_count, v_lead.street, v_lead.city, v_lead.state,
            v_lead.postal_code, v_lead.country, v_lead.description,
            v_lead.assigned_to
        ) RETURNING customer_id INTO x_customer_id;
        
        -- Create Contact
        INSERT INTO crm_contacts (
            customer_id, first_name, last_name, job_title, email,
            phone_work, phone_mobile, mailing_street, mailing_city,
            mailing_state, mailing_postal, mailing_country, is_primary
        ) VALUES (
            x_customer_id, v_lead.first_name, v_lead.last_name, v_lead.title,
            v_lead.email, v_lead.phone, v_lead.mobile, v_lead.street,
            v_lead.city, v_lead.state, v_lead.postal_code, v_lead.country, 'Y'
        ) RETURNING contact_id INTO x_contact_id;
        
        -- Create Opportunity if requested
        IF p_create_opportunity = 'Y' THEN
            DECLARE
                v_stage_id NUMBER;
                v_amount NUMBER := NVL(p_opp_amount, v_lead.annual_revenue * 0.1);
                v_close_date DATE := NVL(p_opp_close_date, ADD_MONTHS(SYSDATE, 3));
            BEGIN
                SELECT stage_id INTO v_stage_id
                FROM crm_opportunity_stage
                WHERE stage_code = 'QUALIFICATION' AND ROWNUM = 1;
                
                INSERT INTO crm_opportunities (
                    opportunity_name, customer_id, contact_id, amount,
                    stage_id, close_date, lead_source_id, assigned_to
                ) VALUES (
                    v_lead.company || ' - Initial Opportunity',
                    x_customer_id, x_contact_id, v_amount, v_stage_id,
                    v_close_date, v_lead.lead_source_id, v_lead.assigned_to
                ) RETURNING opportunity_id INTO x_opportunity_id;
            END;
        END IF;
        
        -- Update Lead status
        UPDATE crm_leads
        SET status = 'CONVERTED',
            converted_date = SYSDATE,
            converted_customer_id = x_customer_id,
            converted_contact_id = x_contact_id
        WHERE lead_id = p_lead_id;
        
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE;
    END convert_lead;
    
    -- Validate Customer data
    FUNCTION validate_customer (p_customer_id IN NUMBER) RETURN VARCHAR2 IS
        v_errors VARCHAR2(4000) := '';
        v_count NUMBER;
    BEGIN
        -- Check for contacts
        SELECT COUNT(*) INTO v_count
        FROM crm_contacts
        WHERE customer_id = p_customer_id;
        
        IF v_count = 0 THEN
            v_errors := v_errors || 'No contacts found. ';
        END IF;
        
        -- Check for primary contact
        SELECT COUNT(*) INTO v_count
        FROM crm_contacts
        WHERE customer_id = p_customer_id AND is_primary = 'Y';
        
        IF v_count = 0 THEN
            v_errors := v_errors || 'No primary contact designated. ';
        END IF;
        
        IF LENGTH(v_errors) = 0 THEN
            RETURN 'VALID';
        ELSE
            RETURN v_errors;
        END IF;
    END validate_customer;
    
    -- Calculate opportunity win probability
    FUNCTION calculate_win_probability (p_opportunity_id IN NUMBER) RETURN NUMBER IS
        v_probability NUMBER;
        v_days_to_close NUMBER;
        v_activity_count NUMBER;
    BEGIN
        SELECT o.probability,
               o.close_date - SYSDATE,
               (SELECT COUNT(*) FROM crm_activities 
                WHERE opportunity_id = o.opportunity_id)
        INTO v_probability, v_days_to_close, v_activity_count
        FROM crm_opportunities o
        WHERE opportunity_id = p_opportunity_id;
        
        -- Adjust probability based on activity
        IF v_activity_count > 5 THEN
            v_probability := LEAST(v_probability + 10, 100);
        END IF;
        
        -- Adjust based on time to close
        IF v_days_to_close < 0 THEN
            v_probability := GREATEST(v_probability - 20, 0);
        END IF;
        
        RETURN v_probability;
    END calculate_win_probability;
    
    -- Check for overdue activities and send reminders
    PROCEDURE check_activity_reminders IS
        CURSOR c_reminders IS
            SELECT activity_id, subject, assigned_to, due_date
            FROM crm_activities
            WHERE status != 'COMPLETED'
              AND due_date < CURRENT_TIMESTAMP
              AND is_reminder_sent = 'N';
    BEGIN
        FOR rec IN c_reminders LOOP
            -- In a real implementation, this would send email/notification
            -- For now, just mark as sent
            UPDATE crm_activities
            SET is_reminder_sent = 'Y'
            WHERE activity_id = rec.activity_id;
        END LOOP;
        COMMIT;
    END check_activity_reminders;
    
    -- Calculate revenue forecast
    FUNCTION get_revenue_forecast (
        p_start_date IN DATE,
        p_end_date   IN DATE
    ) RETURN NUMBER IS
        v_forecast NUMBER := 0;
    BEGIN
        SELECT SUM(o.amount * (o.probability / 100))
        INTO v_forecast
        FROM crm_opportunities o
        WHERE o.close_date BETWEEN p_start_date AND p_end_date
          AND o.is_closed = 'N';
        
        RETURN NVL(v_forecast, 0);
    END get_revenue_forecast;
    
    -- Calculate customer health score (1-100)
    FUNCTION calculate_customer_health (p_customer_id IN NUMBER) RETURN NUMBER IS
        v_score NUMBER := 50; -- Base score
        v_opp_count NUMBER;
        v_activity_count NUMBER;
        v_open_opp_value NUMBER;
    BEGIN
        -- Count opportunities
        SELECT COUNT(*), SUM(CASE WHEN is_closed = 'N' THEN amount ELSE 0 END)
        INTO v_opp_count, v_open_opp_value
        FROM crm_opportunities
        WHERE customer_id = p_customer_id;
        
        -- Count recent activities (last 90 days)
        SELECT COUNT(*)
        INTO v_activity_count
        FROM crm_activities
        WHERE customer_id = p_customer_id
          AND created_date > SYSDATE - 90;
        
        -- Adjust score based on metrics
        v_score := v_score + LEAST(v_opp_count * 5, 20); -- Up to +20 for opportunities
        v_score := v_score + LEAST(v_activity_count * 2, 15); -- Up to +15 for activities
        v_score := v_score + LEAST(v_open_opp_value / 10000, 15); -- Up to +15 for pipeline value
        
        RETURN LEAST(v_score, 100);
    END calculate_customer_health;
    
END crm_business_logic;
/

COMMIT;
