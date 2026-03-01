# CRM Application - Technical Documentation

## Version 1.0 | February 2026

---

## Table of Contents
1. [System Overview](#system-overview)
2. [Architecture](#architecture)
3. [Database Design](#database-design)
4. [Application Components](#application-components)
5. [Security Model](#security-model)
6. [API and Integration](#api-and-integration)
7. [Performance Optimization](#performance-optimization)
8. [Maintenance and Support](#maintenance-and-support)

---

## 1. System Overview

### 1.1 Purpose
The CRM Application is a comprehensive Customer Relationship Management system built on Oracle APEX. It provides complete functionality for managing customers, contacts, leads, opportunities, and sales activities.

### 1.2 Technology Stack
- **Database:** Oracle Database 19c or higher
- **Application Server:** Oracle APEX 21.2 or higher
- **Web Server:** Oracle HTTP Server / ORDS
- **Client:** Modern web browsers (Chrome, Firefox, Safari, Edge)

### 1.3 Key Features
- Customer and contact management
- Lead tracking and conversion
- Sales opportunity pipeline
- Activity and task management
- Comprehensive reporting and analytics
- Audit trail for all transactions
- Email and notification integration
- Mobile-responsive interface

---

## 2. Architecture

### 2.1 Application Architecture

```
┌─────────────────────────────────────────────────┐
│         Presentation Layer (APEX UI)            │
│  - Interactive Reports                          │
│  - Forms and Modal Dialogs                      │
│  - Charts and Dashboards                        │
│  - Mobile Responsive Pages                      │
└────────────────┬────────────────────────────────┘
                 │
┌────────────────▼────────────────────────────────┐
│         Application Logic Layer                  │
│  - APEX Processes                               │
│  - Dynamic Actions                              │
│  - Validations                                  │
│  - Computations                                 │
└────────────────┬────────────────────────────────┘
                 │
┌────────────────▼────────────────────────────────┐
│         Business Logic Layer                     │
│  - PL/SQL Packages (crm_business_logic)         │
│  - Triggers                                     │
│  - Stored Procedures                            │
│  - Functions                                    │
└────────────────┬────────────────────────────────┘
                 │
┌────────────────▼────────────────────────────────┐
│         Data Layer (Oracle Database)             │
│  - Core Tables (12 tables)                      │
│  - Lookup Tables (5 tables)                     │
│  - Indexes and Constraints                      │
│  - Sequences                                    │
└─────────────────────────────────────────────────┘
```

### 2.2 Data Flow
1. User interacts with APEX page
2. APEX processes user input
3. Business logic validates and processes data
4. Database triggers maintain data integrity
5. Changes logged to audit trail
6. Updated data returned to UI

---

## 3. Database Design

### 3.1 Entity Relationship Overview

**Core Entities:**
- **CRM_CUSTOMERS:** Master customer/account records
- **CRM_CONTACTS:** Individual contacts associated with customers
- **CRM_LEADS:** Potential customers not yet converted
- **CRM_OPPORTUNITIES:** Sales opportunities in the pipeline
- **CRM_ACTIVITIES:** Tasks, calls, meetings, emails
- **CRM_NOTES:** Comments and notes on any entity

**Lookup Tables:**
- **CRM_CUSTOMER_STATUS:** Customer status values
- **CRM_LEAD_SOURCE:** Lead source tracking
- **CRM_INDUSTRY_TYPE:** Industry classifications
- **CRM_OPPORTUNITY_STAGE:** Sales stage definitions
- **CRM_ACTIVITY_TYPE:** Activity type categories

**System Tables:**
- **CRM_AUDIT_TRAIL:** Complete audit log

### 3.2 Key Relationships

```
CRM_CUSTOMERS (1) ──< (*) CRM_CONTACTS
CRM_CUSTOMERS (1) ──< (*) CRM_OPPORTUNITIES
CRM_CUSTOMERS (1) ──< (*) CRM_ACTIVITIES
CRM_LEADS (1) ──< (*) CRM_ACTIVITIES
CRM_OPPORTUNITIES (1) ──< (*) CRM_ACTIVITIES
CRM_CONTACTS (*) ──> (1) CRM_CUSTOMERS
```

### 3.3 Naming Conventions
- **Tables:** `CRM_` prefix, plural nouns (e.g., CRM_CUSTOMERS)
- **Columns:** Snake_case (e.g., company_name)
- **Primary Keys:** `<table>_id` (e.g., customer_id)
- **Foreign Keys:** References parent table PK
- **Indexes:** `idx_<table>_<column>` (e.g., idx_cust_status)
- **Sequences:** `crm_<purpose>_seq` (e.g., crm_account_num_seq)
- **Triggers:** `trg_<table>_<action>` (e.g., trg_cust_audit)

### 3.4 Data Types and Standards
- **IDs:** NUMBER (identity columns)
- **Codes:** VARCHAR2(20)
- **Names:** VARCHAR2(50-200)
- **Amounts:** NUMBER(15,2)
- **Dates:** TIMESTAMP for transaction dates
- **Flags:** CHAR(1) with CHECK constraints ('Y'/'N')
- **Descriptions:** CLOB for long text

### 3.5 Constraints
- **Primary Keys:** All tables have identity-based PKs
- **Foreign Keys:** CASCADE DELETE where appropriate
- **Check Constraints:** Data validation (status values, ranges)
- **Unique Constraints:** Business key uniqueness (account numbers)
- **Not Null:** Required fields enforced

---

## 4. Application Components

### 4.1 Page Structure

| Page | Name | Type | Description |
|------|------|------|-------------|
| 0 | Global Page | Template | Navigation menu and global components |
| 1 | Dashboard | Report | Executive dashboard with KPIs |
| 2 | Customers | Interactive Report | Customer list with search/filter |
| 3 | Customer Detail | Form | Customer CRUD operations |
| 4 | Contacts | Interactive Report | Contact list with inline editing |
| 5 | Contact Detail | Form | Contact CRUD operations |
| 6 | Leads | Interactive Report | Lead management and conversion |
| 7 | Lead Detail | Form | Lead CRUD and conversion |
| 8 | Opportunities | Interactive Report | Sales pipeline view |
| 9 | Opportunity Detail | Form | Opportunity management |
| 10 | Activities | Calendar | Activity calendar and task list |
| 11 | Activity Detail | Form | Activity CRUD operations |
| 12 | Reports | Report | Analytics and custom reports |
| 14 | Administration | Form | System configuration |

### 4.2 Key Business Logic

**Lead Conversion Process:**
```sql
crm_business_logic.convert_lead(
    p_lead_id => :P7_LEAD_ID,
    p_create_opportunity => 'Y',
    x_customer_id => :P7_CUSTOMER_ID,
    x_contact_id => :P7_CONTACT_ID,
    x_opportunity_id => :P7_OPPORTUNITY_ID
);
```

**Opportunity Stage Management:**
- Automatic probability update based on stage
- Closed date set when opportunity closes
- Win/loss flags updated automatically

**Customer Health Score:**
```sql
v_health_score := crm_business_logic.calculate_customer_health(
    p_customer_id => :P3_CUSTOMER_ID
);
```

### 4.3 Validations

**Customer Validations:**
- Company name required and unique
- Email format validation
- Phone number format check
- At least one contact required

**Opportunity Validations:**
- Amount must be positive
- Close date cannot be in the past
- Customer must be active
- Stage progression rules enforced

**Lead Validations:**
- Email required and unique
- Cannot convert already converted lead
- Valid lead source required

---

## 5. Security Model

### 5.1 Authentication
- APEX Authentication Scheme
- Session timeout: 8 hours
- Password complexity requirements
- Failed login attempt tracking

### 5.2 Authorization
**Access Control:**
- Page-level security
- Item-level authorization
- Read/Write/Delete permissions by role

**User Roles:**
- **Administrator:** Full system access
- **Sales Manager:** View all, edit own + team
- **Sales Representative:** View all, edit own
- **Read-Only User:** View access only

### 5.3 Data Security
- Row-level security via assigned_to field
- Audit trail for all changes
- Sensitive data encryption (if configured)
- Session state protection enabled

### 5.4 SQL Injection Prevention
- Bind variables in all dynamic SQL
- APEX built-in protections
- Input validation on all fields
- Whitelist validation for codes

---

## 6. API and Integration

### 6.1 Database API Package

```sql
PACKAGE crm_api AS
    -- Customer operations
    FUNCTION create_customer(...) RETURN NUMBER;
    PROCEDURE update_customer(...);
    PROCEDURE delete_customer(p_customer_id IN NUMBER);
    
    -- Opportunity operations
    FUNCTION create_opportunity(...) RETURN NUMBER;
    PROCEDURE update_opportunity(...);
    
    -- Lead conversion
    PROCEDURE convert_lead(...);
END crm_api;
```

### 6.2 REST API (via ORDS)
- GET /customers - List customers
- POST /customers - Create customer
- GET /customers/{id} - Get customer detail
- PUT /customers/{id} - Update customer
- DELETE /customers/{id} - Delete customer

### 6.3 Integration Points
- **Email:** APEX_MAIL for notifications
- **Calendar:** ICS export for activities
- **Export:** CSV/Excel export on all reports
- **External Systems:** REST API endpoints

---

## 7. Performance Optimization

### 7.1 Indexing Strategy
- Indexed foreign keys for joins
- Composite indexes on frequently queried columns
- Function-based indexes for UPPER() searches
- Covering indexes for report queries

### 7.2 Query Optimization
- Materialized views for complex reports (optional)
- Pagination on all interactive reports
- FETCH FIRST for top-N queries
- Query result caching where appropriate

### 7.3 APEX Optimizations
- Region caching enabled
- Static file aggregation
- Lazy loading for large forms
- AJAX-based refreshes

### 7.4 Database Tuning
- Regular statistics gathering
- Partitioning for audit trail (if high volume)
- Archive old activities/notes
- Index maintenance schedule

---

## 8. Maintenance and Support

### 8.1 Backup Strategy
- Daily database backups
- APEX application exports weekly
- Export application before major changes
- Test restore procedures monthly

### 8.2 Monitoring
**Key Metrics:**
- Page load times
- Database CPU usage
- Session counts
- Error log review

**Health Checks:**
- Orphaned records check
- Data consistency validation
- Foreign key integrity
- Audit trail growth monitoring

### 8.3 Upgrade Path
1. Export current application
2. Backup database
3. Test upgrade in DEV environment
4. Apply database changes
5. Import new application version
6. Run data migration scripts
7. Test all functionality
8. Deploy to PROD

### 8.4 Troubleshooting

**Common Issues:**

| Issue | Cause | Solution |
|-------|-------|----------|
| Slow page load | Missing indexes | Review execution plans, add indexes |
| Session timeout | Idle too long | Increase timeout or use keep-alive |
| Constraint violation | Data integrity | Check foreign keys and constraints |
| Login failure | Wrong credentials | Reset password, check account status |

### 8.5 Log Management
- **APEX Debug:** Enable for troubleshooting
- **Database Alerts:** Monitor alert.log
- **Audit Trail:** Archive quarterly
- **Error Logging:** Custom error table

---

## Appendices

### A. Database Objects
- 12 core tables
- 5 lookup tables  
- 1 audit table
- 15+ indexes
- 3 sequences
- 8 triggers
- 1 package (crm_business_logic)

### B. System Requirements
- Oracle Database 19c+
- APEX 21.2+
- 2GB minimum database storage
- Modern web browser
- Network connectivity for ORDS

### C. Support Contacts
- **Technical Support:** support@yourcompany.com
- **Database Admin:** dba@yourcompany.com
- **APEX Admin:** apex-admin@yourcompany.com

---

*Document Version: 1.0*  
*Last Updated: February 14, 2026*  
*Classification: Internal Use*
