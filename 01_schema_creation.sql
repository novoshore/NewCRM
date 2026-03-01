-- ============================================================================
-- Oracle APEX CRM Application - Database Schema
-- Version: 1.0
-- Created: 2026-02-14
-- Description: Complete schema for Customer Relationship Management System
-- ============================================================================

-- Drop existing objects (for clean installation)
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
            NULL;
      END;
   END LOOP;
END;
/

-- ============================================================================
-- LOOKUP/REFERENCE TABLES
-- ============================================================================

-- Customer Status Lookup
CREATE TABLE crm_customer_status (
    status_id          NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    status_code        VARCHAR2(20) NOT NULL UNIQUE,
    status_name        VARCHAR2(50) NOT NULL,
    description        VARCHAR2(200),
    is_active          CHAR(1) DEFAULT 'Y' CHECK (is_active IN ('Y','N')),
    display_order      NUMBER(3),
    created_by         VARCHAR2(100) DEFAULT USER,
    created_date       TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    modified_by        VARCHAR2(100),
    modified_date      TIMESTAMP
);

-- Lead Source Lookup
CREATE TABLE crm_lead_source (
    source_id          NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    source_code        VARCHAR2(20) NOT NULL UNIQUE,
    source_name        VARCHAR2(50) NOT NULL,
    description        VARCHAR2(200),
    is_active          CHAR(1) DEFAULT 'Y' CHECK (is_active IN ('Y','N')),
    created_by         VARCHAR2(100) DEFAULT USER,
    created_date       TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Industry Type Lookup
CREATE TABLE crm_industry_type (
    industry_id        NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    industry_code      VARCHAR2(20) NOT NULL UNIQUE,
    industry_name      VARCHAR2(100) NOT NULL,
    description        VARCHAR2(200),
    is_active          CHAR(1) DEFAULT 'Y' CHECK (is_active IN ('Y','N')),
    created_by         VARCHAR2(100) DEFAULT USER,
    created_date       TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Opportunity Stage Lookup
CREATE TABLE crm_opportunity_stage (
    stage_id           NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    stage_code         VARCHAR2(20) NOT NULL UNIQUE,
    stage_name         VARCHAR2(50) NOT NULL,
    probability        NUMBER(5,2) CHECK (probability BETWEEN 0 AND 100),
    is_closed          CHAR(1) DEFAULT 'N' CHECK (is_closed IN ('Y','N')),
    is_won             CHAR(1) DEFAULT 'N' CHECK (is_won IN ('Y','N')),
    display_order      NUMBER(3),
    created_by         VARCHAR2(100) DEFAULT USER,
    created_date       TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Activity Type Lookup
CREATE TABLE crm_activity_type (
    activity_type_id   NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    type_code          VARCHAR2(20) NOT NULL UNIQUE,
    type_name          VARCHAR2(50) NOT NULL,
    icon_css           VARCHAR2(50),
    color_code         VARCHAR2(20),
    is_active          CHAR(1) DEFAULT 'Y' CHECK (is_active IN ('Y','N')),
    created_by         VARCHAR2(100) DEFAULT USER,
    created_date       TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================================
-- CORE BUSINESS TABLES
-- ============================================================================

-- Customers/Accounts Table
CREATE TABLE crm_customers (
    customer_id        NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    account_number     VARCHAR2(20) NOT NULL UNIQUE,
    company_name       VARCHAR2(200) NOT NULL,
    website            VARCHAR2(200),
    phone              VARCHAR2(50),
    fax                VARCHAR2(50),
    email              VARCHAR2(100),
    industry_id        NUMBER,
    status_id          NUMBER NOT NULL,
    annual_revenue     NUMBER(15,2),
    employee_count     NUMBER(10),
    rating             NUMBER(1) CHECK (rating BETWEEN 1 AND 5),
    billing_street     VARCHAR2(200),
    billing_city       VARCHAR2(100),
    billing_state      VARCHAR2(50),
    billing_postal     VARCHAR2(20),
    billing_country    VARCHAR2(100),
    shipping_street    VARCHAR2(200),
    shipping_city      VARCHAR2(100),
    shipping_state     VARCHAR2(50),
    shipping_postal    VARCHAR2(20),
    shipping_country   VARCHAR2(100),
    description        CLOB,
    assigned_to        VARCHAR2(100),
    created_by         VARCHAR2(100) DEFAULT USER,
    created_date       TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    modified_by        VARCHAR2(100),
    modified_date      TIMESTAMP,
    CONSTRAINT fk_cust_industry FOREIGN KEY (industry_id) 
        REFERENCES crm_industry_type(industry_id),
    CONSTRAINT fk_cust_status FOREIGN KEY (status_id) 
        REFERENCES crm_customer_status(status_id)
);

-- Contacts Table
CREATE TABLE crm_contacts (
    contact_id         NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    customer_id        NUMBER NOT NULL,
    salutation         VARCHAR2(10),
    first_name         VARCHAR2(50) NOT NULL,
    last_name          VARCHAR2(50) NOT NULL,
    job_title          VARCHAR2(100),
    department         VARCHAR2(100),
    email              VARCHAR2(100) NOT NULL,
    phone_work         VARCHAR2(50),
    phone_mobile       VARCHAR2(50),
    phone_home         VARCHAR2(50),
    linkedin_url       VARCHAR2(200),
    is_primary         CHAR(1) DEFAULT 'N' CHECK (is_primary IN ('Y','N')),
    is_decision_maker  CHAR(1) DEFAULT 'N' CHECK (is_decision_maker IN ('Y','N')),
    mailing_street     VARCHAR2(200),
    mailing_city       VARCHAR2(100),
    mailing_state      VARCHAR2(50),
    mailing_postal     VARCHAR2(20),
    mailing_country    VARCHAR2(100),
    birthdate          DATE,
    notes              CLOB,
    do_not_call        CHAR(1) DEFAULT 'N' CHECK (do_not_call IN ('Y','N')),
    do_not_email       CHAR(1) DEFAULT 'N' CHECK (do_not_email IN ('Y','N')),
    created_by         VARCHAR2(100) DEFAULT USER,
    created_date       TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    modified_by        VARCHAR2(100),
    modified_date      TIMESTAMP,
    CONSTRAINT fk_contact_customer FOREIGN KEY (customer_id) 
        REFERENCES crm_customers(customer_id) ON DELETE CASCADE
);

-- Leads Table
CREATE TABLE crm_leads (
    lead_id            NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    lead_number        VARCHAR2(20) NOT NULL UNIQUE,
    company            VARCHAR2(200) NOT NULL,
    first_name         VARCHAR2(50) NOT NULL,
    last_name          VARCHAR2(50) NOT NULL,
    title              VARCHAR2(100),
    email              VARCHAR2(100) NOT NULL,
    phone              VARCHAR2(50),
    mobile             VARCHAR2(50),
    website            VARCHAR2(200),
    lead_source_id     NUMBER,
    industry_id        NUMBER,
    status             VARCHAR2(20) DEFAULT 'NEW' 
        CHECK (status IN ('NEW','CONTACTED','QUALIFIED','CONVERTED','LOST')),
    rating             VARCHAR2(10) CHECK (rating IN ('HOT','WARM','COLD')),
    street             VARCHAR2(200),
    city               VARCHAR2(100),
    state              VARCHAR2(50),
    postal_code        VARCHAR2(20),
    country            VARCHAR2(100),
    description        CLOB,
    annual_revenue     NUMBER(15,2),
    employee_count     NUMBER(10),
    converted_date     DATE,
    converted_customer_id NUMBER,
    converted_contact_id  NUMBER,
    assigned_to        VARCHAR2(100),
    created_by         VARCHAR2(100) DEFAULT USER,
    created_date       TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    modified_by        VARCHAR2(100),
    modified_date      TIMESTAMP,
    CONSTRAINT fk_lead_source FOREIGN KEY (lead_source_id) 
        REFERENCES crm_lead_source(source_id),
    CONSTRAINT fk_lead_industry FOREIGN KEY (industry_id) 
        REFERENCES crm_industry_type(industry_id),
    CONSTRAINT fk_lead_customer FOREIGN KEY (converted_customer_id) 
        REFERENCES crm_customers(customer_id),
    CONSTRAINT fk_lead_contact FOREIGN KEY (converted_contact_id) 
        REFERENCES crm_contacts(contact_id)
);

-- Opportunities Table
CREATE TABLE crm_opportunities (
    opportunity_id     NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    opportunity_number VARCHAR2(20) NOT NULL UNIQUE,
    opportunity_name   VARCHAR2(200) NOT NULL,
    customer_id        NUMBER NOT NULL,
    contact_id         NUMBER,
    amount             NUMBER(15,2) NOT NULL,
    stage_id           NUMBER NOT NULL,
    probability        NUMBER(5,2) CHECK (probability BETWEEN 0 AND 100),
    close_date         DATE NOT NULL,
    next_step          VARCHAR2(200),
    lead_source_id     NUMBER,
    description        CLOB,
    is_closed          CHAR(1) DEFAULT 'N' CHECK (is_closed IN ('Y','N')),
    is_won             CHAR(1) DEFAULT 'N' CHECK (is_won IN ('Y','N')),
    closed_date        DATE,
    assigned_to        VARCHAR2(100),
    created_by         VARCHAR2(100) DEFAULT USER,
    created_date       TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    modified_by        VARCHAR2(100),
    modified_date      TIMESTAMP,
    CONSTRAINT fk_opp_customer FOREIGN KEY (customer_id) 
        REFERENCES crm_customers(customer_id) ON DELETE CASCADE,
    CONSTRAINT fk_opp_contact FOREIGN KEY (contact_id) 
        REFERENCES crm_contacts(contact_id),
    CONSTRAINT fk_opp_stage FOREIGN KEY (stage_id) 
        REFERENCES crm_opportunity_stage(stage_id),
    CONSTRAINT fk_opp_source FOREIGN KEY (lead_source_id) 
        REFERENCES crm_lead_source(source_id)
);

-- Activities Table (Tasks, Calls, Meetings, Emails)
CREATE TABLE crm_activities (
    activity_id        NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    activity_type_id   NUMBER NOT NULL,
    subject            VARCHAR2(200) NOT NULL,
    description        CLOB,
    status             VARCHAR2(20) DEFAULT 'NOT STARTED' 
        CHECK (status IN ('NOT STARTED','IN PROGRESS','COMPLETED','DEFERRED','WAITING')),
    priority           VARCHAR2(20) DEFAULT 'MEDIUM' 
        CHECK (priority IN ('LOW','MEDIUM','HIGH','URGENT')),
    due_date           TIMESTAMP,
    completed_date     TIMESTAMP,
    customer_id        NUMBER,
    contact_id         NUMBER,
    opportunity_id     NUMBER,
    lead_id            NUMBER,
    duration_minutes   NUMBER(10),
    location           VARCHAR2(200),
    assigned_to        VARCHAR2(100),
    reminder_minutes   NUMBER(10),
    is_reminder_sent   CHAR(1) DEFAULT 'N' CHECK (is_reminder_sent IN ('Y','N')),
    created_by         VARCHAR2(100) DEFAULT USER,
    created_date       TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    modified_by        VARCHAR2(100),
    modified_date      TIMESTAMP,
    CONSTRAINT fk_act_type FOREIGN KEY (activity_type_id) 
        REFERENCES crm_activity_type(activity_type_id),
    CONSTRAINT fk_act_customer FOREIGN KEY (customer_id) 
        REFERENCES crm_customers(customer_id) ON DELETE CASCADE,
    CONSTRAINT fk_act_contact FOREIGN KEY (contact_id) 
        REFERENCES crm_contacts(contact_id) ON DELETE CASCADE,
    CONSTRAINT fk_act_opportunity FOREIGN KEY (opportunity_id) 
        REFERENCES crm_opportunities(opportunity_id) ON DELETE CASCADE,
    CONSTRAINT fk_act_lead FOREIGN KEY (lead_id) 
        REFERENCES crm_leads(lead_id) ON DELETE CASCADE
);

-- Notes/Comments Table
CREATE TABLE crm_notes (
    note_id            NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    note_title         VARCHAR2(200) NOT NULL,
    note_content       CLOB NOT NULL,
    is_private         CHAR(1) DEFAULT 'N' CHECK (is_private IN ('Y','N')),
    customer_id        NUMBER,
    contact_id         NUMBER,
    opportunity_id     NUMBER,
    lead_id            NUMBER,
    created_by         VARCHAR2(100) DEFAULT USER,
    created_date       TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    modified_by        VARCHAR2(100),
    modified_date      TIMESTAMP,
    CONSTRAINT fk_note_customer FOREIGN KEY (customer_id) 
        REFERENCES crm_customers(customer_id) ON DELETE CASCADE,
    CONSTRAINT fk_note_contact FOREIGN KEY (contact_id) 
        REFERENCES crm_contacts(contact_id) ON DELETE CASCADE,
    CONSTRAINT fk_note_opportunity FOREIGN KEY (opportunity_id) 
        REFERENCES crm_opportunities(opportunity_id) ON DELETE CASCADE,
    CONSTRAINT fk_note_lead FOREIGN KEY (lead_id) 
        REFERENCES crm_leads(lead_id) ON DELETE CASCADE
);

-- Audit Trail Table
CREATE TABLE crm_audit_trail (
    audit_id           NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    table_name         VARCHAR2(50) NOT NULL,
    record_id          NUMBER NOT NULL,
    action_type        VARCHAR2(20) NOT NULL 
        CHECK (action_type IN ('INSERT','UPDATE','DELETE')),
    field_name         VARCHAR2(100),
    old_value          VARCHAR2(4000),
    new_value          VARCHAR2(4000),
    action_by          VARCHAR2(100) DEFAULT USER,
    action_date        TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    session_id         VARCHAR2(100)
);

-- ============================================================================
-- INDEXES FOR PERFORMANCE
-- ============================================================================

-- Customer indexes
CREATE INDEX idx_cust_status ON crm_customers(status_id);
CREATE INDEX idx_cust_industry ON crm_customers(industry_id);
CREATE INDEX idx_cust_assigned ON crm_customers(assigned_to);
CREATE INDEX idx_cust_company ON crm_customers(UPPER(company_name));

-- Contact indexes
CREATE INDEX idx_cont_customer ON crm_contacts(customer_id);
CREATE INDEX idx_cont_email ON crm_contacts(UPPER(email));
CREATE INDEX idx_cont_name ON crm_contacts(UPPER(last_name), UPPER(first_name));

-- Lead indexes
CREATE INDEX idx_lead_status ON crm_leads(status);
CREATE INDEX idx_lead_source ON crm_leads(lead_source_id);
CREATE INDEX idx_lead_assigned ON crm_leads(assigned_to);
CREATE INDEX idx_lead_email ON crm_leads(UPPER(email));

-- Opportunity indexes
CREATE INDEX idx_opp_customer ON crm_opportunities(customer_id);
CREATE INDEX idx_opp_stage ON crm_opportunities(stage_id);
CREATE INDEX idx_opp_close_date ON crm_opportunities(close_date);
CREATE INDEX idx_opp_assigned ON crm_opportunities(assigned_to);
CREATE INDEX idx_opp_closed ON crm_opportunities(is_closed, is_won);

-- Activity indexes
CREATE INDEX idx_act_customer ON crm_activities(customer_id);
CREATE INDEX idx_act_contact ON crm_activities(contact_id);
CREATE INDEX idx_act_opportunity ON crm_activities(opportunity_id);
CREATE INDEX idx_act_lead ON crm_activities(lead_id);
CREATE INDEX idx_act_assigned ON crm_activities(assigned_to);
CREATE INDEX idx_act_due_date ON crm_activities(due_date);
CREATE INDEX idx_act_status ON crm_activities(status);

-- Note indexes
CREATE INDEX idx_note_customer ON crm_notes(customer_id);
CREATE INDEX idx_note_contact ON crm_notes(contact_id);
CREATE INDEX idx_note_opportunity ON crm_notes(opportunity_id);
CREATE INDEX idx_note_lead ON crm_notes(lead_id);

-- Audit indexes
CREATE INDEX idx_audit_table_record ON crm_audit_trail(table_name, record_id);
CREATE INDEX idx_audit_date ON crm_audit_trail(action_date);

-- ============================================================================
-- SEQUENCES (for account/opportunity numbers)
-- ============================================================================

CREATE SEQUENCE crm_account_num_seq START WITH 10001 INCREMENT BY 1;
CREATE SEQUENCE crm_opp_num_seq START WITH 100001 INCREMENT BY 1;
CREATE SEQUENCE crm_lead_num_seq START WITH 200001 INCREMENT BY 1;

COMMIT;
