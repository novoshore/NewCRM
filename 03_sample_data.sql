-- ============================================================================
-- Oracle APEX CRM Application - Sample Data
-- Version: 1.0
-- Description: Initial lookup data and sample records for testing
-- ============================================================================

-- ============================================================================
-- LOOKUP DATA
-- ============================================================================

-- Customer Status
INSERT INTO crm_customer_status (status_code, status_name, description, display_order) VALUES
('ACTIVE', 'Active', 'Active customer with ongoing business', 1);
INSERT INTO crm_customer_status (status_code, status_name, description, display_order) VALUES
('INACTIVE', 'Inactive', 'Customer with no recent activity', 2);
INSERT INTO crm_customer_status (status_code, status_name, description, display_order) VALUES
('PROSPECT', 'Prospect', 'Potential customer', 3);
INSERT INTO crm_customer_status (status_code, status_name, description, display_order) VALUES
('CHURNED', 'Churned', 'Former customer', 4);

-- Lead Source
INSERT INTO crm_lead_source (source_code, source_name, description) VALUES
('WEB', 'Website', 'Lead from website contact form');
INSERT INTO crm_lead_source (source_code, source_name, description) VALUES
('REFERRAL', 'Referral', 'Customer referral');
INSERT INTO crm_lead_source (source_code, source_name, description) VALUES
('TRADE_SHOW', 'Trade Show', 'Met at trade show or event');
INSERT INTO crm_lead_source (source_code, source_name, description) VALUES
('COLD_CALL', 'Cold Call', 'Outbound cold calling');
INSERT INTO crm_lead_source (source_code, source_name, description) VALUES
('PARTNER', 'Partner', 'Partner referral');
INSERT INTO crm_lead_source (source_code, source_name, description) VALUES
('SOCIAL', 'Social Media', 'Social media campaign');
INSERT INTO crm_lead_source (source_code, source_name, description) VALUES
('EMAIL', 'Email Campaign', 'Email marketing campaign');

-- Industry Type
INSERT INTO crm_industry_type (industry_code, industry_name, description) VALUES
('TECH', 'Technology', 'Software and technology services');
INSERT INTO crm_industry_type (industry_code, industry_name, description) VALUES
('FINANCE', 'Financial Services', 'Banking, insurance, and finance');
INSERT INTO crm_industry_type (industry_code, industry_name, description) VALUES
('HEALTHCARE', 'Healthcare', 'Medical and healthcare services');
INSERT INTO crm_industry_type (industry_code, industry_name, description) VALUES
('RETAIL', 'Retail', 'Retail and e-commerce');
INSERT INTO crm_industry_type (industry_code, industry_name, description) VALUES
('MANUFACTURING', 'Manufacturing', 'Manufacturing and industrial');
INSERT INTO crm_industry_type (industry_code, industry_name, description) VALUES
('EDUCATION', 'Education', 'Educational institutions');
INSERT INTO crm_industry_type (industry_code, industry_name, description) VALUES
('REAL_ESTATE', 'Real Estate', 'Real estate and property');
INSERT INTO crm_industry_type (industry_code, industry_name, description) VALUES
('HOSPITALITY', 'Hospitality', 'Hotels, restaurants, and tourism');

-- Opportunity Stage
INSERT INTO crm_opportunity_stage (stage_code, stage_name, probability, is_closed, is_won, display_order) VALUES
('QUALIFICATION', 'Qualification', 10, 'N', 'N', 1);
INSERT INTO crm_opportunity_stage (stage_code, stage_name, probability, is_closed, is_won, display_order) VALUES
('NEEDS_ANALYSIS', 'Needs Analysis', 20, 'N', 'N', 2);
INSERT INTO crm_opportunity_stage (stage_code, stage_name, probability, is_closed, is_won, display_order) VALUES
('PROPOSAL', 'Proposal/Quote', 40, 'N', 'N', 3);
INSERT INTO crm_opportunity_stage (stage_code, stage_name, probability, is_closed, is_won, display_order) VALUES
('NEGOTIATION', 'Negotiation', 60, 'N', 'N', 4);
INSERT INTO crm_opportunity_stage (stage_code, stage_name, probability, is_closed, is_won, display_order) VALUES
('CLOSED_WON', 'Closed Won', 100, 'Y', 'Y', 5);
INSERT INTO crm_opportunity_stage (stage_code, stage_name, probability, is_closed, is_won, display_order) VALUES
('CLOSED_LOST', 'Closed Lost', 0, 'Y', 'N', 6);

-- Activity Type
INSERT INTO crm_activity_type (type_code, type_name, icon_css, color_code) VALUES
('CALL', 'Phone Call', 'fa-phone', '#3498db');
INSERT INTO crm_activity_type (type_code, type_name, icon_css, color_code) VALUES
('MEETING', 'Meeting', 'fa-users', '#2ecc71');
INSERT INTO crm_activity_type (type_code, type_name, icon_css, color_code) VALUES
('EMAIL', 'Email', 'fa-envelope', '#9b59b6');
INSERT INTO crm_activity_type (type_code, type_name, icon_css, color_code) VALUES
('TASK', 'Task', 'fa-check-square', '#e74c3c');
INSERT INTO crm_activity_type (type_code, type_name, icon_css, color_code) VALUES
('DEMO', 'Product Demo', 'fa-desktop', '#f39c12');

COMMIT;

-- ============================================================================
-- SAMPLE CUSTOMER DATA
-- ============================================================================

DECLARE
    v_status_id NUMBER;
    v_industry_id NUMBER;
    v_customer_id NUMBER;
    v_contact_id NUMBER;
    v_source_id NUMBER;
    v_stage_id NUMBER;
    v_activity_type_id NUMBER;
BEGIN
    -- Get lookup IDs
    SELECT status_id INTO v_status_id FROM crm_customer_status WHERE status_code = 'ACTIVE';
    SELECT industry_id INTO v_industry_id FROM crm_industry_type WHERE industry_code = 'TECH';
    SELECT source_id INTO v_source_id FROM crm_lead_source WHERE source_code = 'WEB';
    SELECT stage_id INTO v_stage_id FROM crm_opportunity_stage WHERE stage_code = 'PROPOSAL';
    SELECT activity_type_id INTO v_activity_type_id FROM crm_activity_type WHERE type_code = 'CALL';
    
    -- Sample Customer 1: Acme Corporation
    INSERT INTO crm_customers (
        company_name, website, phone, email, industry_id, status_id,
        annual_revenue, employee_count, rating,
        billing_street, billing_city, billing_state, billing_postal, billing_country,
        description, assigned_to
    ) VALUES (
        'Acme Corporation', 'www.acmecorp.com', '555-0101', 'info@acmecorp.com',
        v_industry_id, v_status_id, 5000000, 150, 5,
        '123 Tech Boulevard', 'San Francisco', 'CA', '94105', 'USA',
        'Leading software solutions provider focusing on enterprise applications',
        'SALES_REP_1'
    ) RETURNING customer_id INTO v_customer_id;
    
    -- Contacts for Acme Corporation
    INSERT INTO crm_contacts (
        customer_id, salutation, first_name, last_name, job_title, email,
        phone_work, phone_mobile, is_primary, is_decision_maker
    ) VALUES (
        v_customer_id, 'Mr.', 'John', 'Smith', 'CEO', 'john.smith@acmecorp.com',
        '555-0101', '555-0102', 'Y', 'Y'
    ) RETURNING contact_id INTO v_contact_id;
    
    INSERT INTO crm_contacts (
        customer_id, salutation, first_name, last_name, job_title, email,
        phone_work, is_primary, is_decision_maker
    ) VALUES (
        v_customer_id, 'Ms.', 'Sarah', 'Johnson', 'CTO', 'sarah.johnson@acmecorp.com',
        '555-0103', 'N', 'Y'
    );
    
    -- Opportunity for Acme Corporation
    INSERT INTO crm_opportunities (
        opportunity_name, customer_id, contact_id, amount, stage_id,
        close_date, lead_source_id, assigned_to, next_step
    ) VALUES (
        'Acme Corp - Enterprise License Renewal', v_customer_id, v_contact_id,
        250000, v_stage_id, ADD_MONTHS(SYSDATE, 2), v_source_id, 'SALES_REP_1',
        'Send updated proposal with 3-year pricing'
    );
    
    -- Activities for Acme Corporation
    INSERT INTO crm_activities (
        activity_type_id, subject, description, status, priority,
        due_date, customer_id, contact_id, assigned_to
    ) VALUES (
        v_activity_type_id, 'Follow-up call with John Smith',
        'Discuss renewal terms and answer technical questions',
        'NOT STARTED', 'HIGH', SYSDATE + 2, v_customer_id, v_contact_id, 'SALES_REP_1'
    );
    
    -- Sample Customer 2: Global Industries Inc
    SELECT industry_id INTO v_industry_id FROM crm_industry_type WHERE industry_code = 'MANUFACTURING';
    
    INSERT INTO crm_customers (
        company_name, website, phone, email, industry_id, status_id,
        annual_revenue, employee_count, rating,
        billing_street, billing_city, billing_state, billing_postal, billing_country,
        description, assigned_to
    ) VALUES (
        'Global Industries Inc', 'www.globalind.com', '555-0201', 'contact@globalind.com',
        v_industry_id, v_status_id, 12000000, 450, 4,
        '456 Industrial Park', 'Chicago', 'IL', '60601', 'USA',
        'Manufacturing company specializing in automotive parts',
        'SALES_REP_2'
    ) RETURNING customer_id INTO v_customer_id;
    
    INSERT INTO crm_contacts (
        customer_id, salutation, first_name, last_name, job_title, email,
        phone_work, is_primary, is_decision_maker
    ) VALUES (
        v_customer_id, 'Mr.', 'Michael', 'Chen', 'VP Operations', 'michael.chen@globalind.com',
        '555-0201', 'Y', 'Y'
    );
    
    -- Sample Customer 3: TechStart Solutions
    SELECT industry_id INTO v_industry_id FROM crm_industry_type WHERE industry_code = 'TECH';
    SELECT status_id INTO v_status_id FROM crm_customer_status WHERE status_code = 'PROSPECT';
    
    INSERT INTO crm_customers (
        company_name, website, phone, email, industry_id, status_id,
        annual_revenue, employee_count, rating,
        billing_street, billing_city, billing_state, billing_postal, billing_country,
        description, assigned_to
    ) VALUES (
        'TechStart Solutions', 'www.techstart.io', '555-0301', 'hello@techstart.io',
        v_industry_id, v_status_id, 800000, 25, 3,
        '789 Startup Avenue', 'Austin', 'TX', '78701', 'USA',
        'Fast-growing startup in the SaaS space',
        'SALES_REP_1'
    ) RETURNING customer_id INTO v_customer_id;
    
    INSERT INTO crm_contacts (
        customer_id, salutation, first_name, last_name, job_title, email,
        phone_work, is_primary
    ) VALUES (
        v_customer_id, 'Ms.', 'Emily', 'Rodriguez', 'Founder & CEO', 'emily@techstart.io',
        '555-0301', 'Y'
    );
    
    COMMIT;
END;
/

-- ============================================================================
-- SAMPLE LEADS
-- ============================================================================

DECLARE
    v_source_id NUMBER;
    v_industry_id NUMBER;
BEGIN
    SELECT source_id INTO v_source_id FROM crm_lead_source WHERE source_code = 'TRADE_SHOW';
    SELECT industry_id INTO v_industry_id FROM crm_industry_type WHERE industry_code = 'FINANCE';
    
    INSERT INTO crm_leads (
        company, first_name, last_name, title, email, phone,
        website, lead_source_id, industry_id, status, rating,
        street, city, state, postal_code, country,
        description, assigned_to
    ) VALUES (
        'Financial Partners LLC', 'David', 'Martinez', 'VP Technology',
        'dmartinez@finpartners.com', '555-0401', 'www.finpartners.com',
        v_source_id, v_industry_id, 'QUALIFIED', 'HOT',
        '321 Finance Street', 'New York', 'NY', '10001', 'USA',
        'Interested in our CRM solution for their sales team of 50',
        'SALES_REP_2'
    );
    
    SELECT source_id INTO v_source_id FROM crm_lead_source WHERE source_code = 'SOCIAL';
    SELECT industry_id INTO v_industry_id FROM crm_industry_type WHERE industry_code = 'RETAIL';
    
    INSERT INTO crm_leads (
        company, first_name, last_name, title, email, phone,
        lead_source_id, industry_id, status, rating,
        city, state, country, description, assigned_to
    ) VALUES (
        'Retail Excellence Co', 'Lisa', 'Thompson', 'Operations Manager',
        'lisa.t@retailex.com', '555-0501',
        v_source_id, v_industry_id, 'NEW', 'WARM',
        'Seattle', 'WA', 'USA',
        'Downloaded whitepaper on retail CRM best practices',
        'SALES_REP_1'
    );
    
    COMMIT;
END;
/

-- ============================================================================
-- STATISTICS UPDATE
-- ============================================================================

BEGIN
    DBMS_STATS.GATHER_SCHEMA_STATS(
        ownname => USER,
        estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE,
        method_opt => 'FOR ALL COLUMNS SIZE AUTO'
    );
END;
/

COMMIT;
