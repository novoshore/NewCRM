# Oracle APEX CRM Application

## Complete Customer Relationship Management System

Version 1.0 | February 2026

---

## 📋 Overview

This is a comprehensive, production-ready Customer Relationship Management (CRM) system built on Oracle APEX. It provides complete functionality for managing customers, contacts, leads, sales opportunities, and activities - all with enterprise-grade features including audit trails, business logic automation, and comprehensive reporting.

### Key Features

- ✅ **Customer Management** - Complete account lifecycle management
- ✅ **Contact Management** - Individual contact tracking with relationship mapping
- ✅ **Lead Tracking** - Lead capture, qualification, and conversion workflow
- ✅ **Sales Pipeline** - Visual opportunity management with stage progression
- ✅ **Activity Management** - Task, call, meeting, and email tracking
- ✅ **Business Logic Automation** - Automated workflows and validations
- ✅ **Comprehensive Reporting** - Analytics and forecasting capabilities
- ✅ **Audit Trail** - Complete change history and compliance tracking
- ✅ **Mobile Responsive** - Works on desktop, tablet, and mobile devices
- ✅ **RESTful API** - Integration-ready architecture

---

## 🏗️ Architecture

### Technology Stack

- **Database:** Oracle Database 19c+
- **Application Framework:** Oracle APEX 24.2+
- **Language:** PL/SQL, SQL, JavaScript
- **Web Server:** Oracle REST Data Services (ORDS)

### Database Components

- **18 Tables** - Core business entities and lookup tables
- **3 Sequences** - Auto-numbering for key entities
- **8 Triggers** - Automation and data integrity
- **1 PL/SQL Package** - Business logic layer with 6+ procedures/functions
- **15+ Indexes** - Optimized for performance

### Application Structure

```
CRM Application
├── Dashboard (Page 1)
├── Customers (Pages 2-3)
├── Contacts (Pages 4-5)
├── Leads (Pages 6-7)
├── Opportunities (Pages 8-9)
├── Activities (Pages 10-11)
├── Reports (Pages 12-13)
└── Administration (Page 14)
```

---

## 📦 What's Included

### Database Scripts
- `01_schema_creation.sql` - All tables, constraints, and indexes
- `02_triggers_procedures.sql` - Triggers and business logic package
- `03_sample_data.sql` - Lookup data and sample records

### APEX Application
- `crm_application_export.sql` - Complete APEX application export

### Documentation
- `technical_documentation.md` - Architecture and technical details
- `user_guide.md` - End-user documentation
- `process_flows.md` - Business process diagrams
- `INSTALLATION.md` - Complete installation guide

### Testing
- `test_plan.md` - Comprehensive test scenarios
- `run_all_tests.sql` - Automated test execution script

---

## 🚀 Quick Start

### Prerequisites

- Oracle Database 19c or higher
- Oracle APEX 24.2 or higher
- 2GB free database space
- Modern web browser

### Installation (5 Steps)

1. **Create database user:**
   ```sql
   CREATE USER crm_app IDENTIFIED BY "SecurePassword123!";
   GRANT CONNECT, RESOURCE TO crm_app;
   ```

2. **Install database objects:**
   ```bash
   sqlplus crm_app/password@database
   @database/01_schema_creation.sql
   @database/02_triggers_procedures.sql
   @database/03_sample_data.sql
   ```

3. **Build APEX application:**
   - Access APEX Application Builder → Create → New Application
   - Add Report+Form pages for each core table (Customers, Contacts, Leads, Opportunities, Activities)
   - Set parsing schema to `CRM_APP`
   - See [INSTALLATION.md](INSTALLATION.md) Step 4 for full details

4. **Create users:**
   - Set up APEX workspace users
   - Assign appropriate roles

5. **Verify installation:**
   ```bash
   sqlplus crm_app/password@database @tests/run_all_tests.sql
   ```

**For detailed instructions, see [INSTALLATION.md](INSTALLATION.md)**

---

## 💼 Business Processes

### Lead to Customer Conversion
1. Lead captured from website/trade show/referral
2. Assigned to sales representative
3. Initial contact and qualification
4. Convert to customer account with contact
5. Optional: Create initial opportunity

### Sales Opportunity Management
1. Opportunity created (manually or from lead)
2. Progress through stages:
   - Qualification (10%)
   - Needs Analysis (20%)
   - Proposal/Quote (40%)
   - Negotiation (60%)
   - Closed Won/Lost (100%/0%)
3. Automatic probability updates
4. Revenue forecasting

### Activity Tracking
1. Create task/call/meeting/email
2. Link to customer/contact/opportunity/lead
3. Set reminder and due date
4. Complete with notes
5. Create follow-up activities as needed

**For detailed process flows, see [process_flows.md](documentation/process_flows.md)**

---

## 📊 Database Schema

### Core Tables
- `CRM_CUSTOMERS` - Customer/account master data
- `CRM_CONTACTS` - Individual contacts
- `CRM_LEADS` - Potential customers
- `CRM_OPPORTUNITIES` - Sales pipeline
- `CRM_ACTIVITIES` - Tasks and interactions
- `CRM_NOTES` - Comments and notes

### Lookup Tables
- `CRM_CUSTOMER_STATUS` - Active, Inactive, Prospect, etc.
- `CRM_LEAD_SOURCE` - Website, Referral, Trade Show, etc.
- `CRM_INDUSTRY_TYPE` - Technology, Finance, Healthcare, etc.
- `CRM_OPPORTUNITY_STAGE` - Qualification → Closed Won/Lost
- `CRM_ACTIVITY_TYPE` - Call, Meeting, Email, Task, Demo

### System Tables
- `CRM_AUDIT_TRAIL` - Complete change history

**For complete schema details, see [technical_documentation.md](documentation/technical_documentation.md)**

---

## 🔧 Key Features Explained

### Automated Lead Conversion
The `crm_business_logic.convert_lead()` procedure automatically:
- Creates customer account from lead data
- Creates primary contact
- Optionally creates opportunity
- Updates lead status to CONVERTED
- Links all records together

### Intelligent Opportunity Management
- **Auto-numbering:** OPP-100001, OPP-100002, etc.
- **Stage-based probability:** Updates automatically when stage changes
- **Automatic close date:** Set when opportunity marked as won/lost
- **Revenue forecasting:** Weighted pipeline calculation

### Comprehensive Audit Trail
Every change to customers, opportunities, and leads is logged:
- What changed
- Old and new values
- Who made the change
- When it was changed

### Customer Health Scoring
Algorithm considers:
- Number of opportunities
- Recent activity (last 90 days)
- Open pipeline value
- Returns score 0-100

---

## 📱 User Interface

### Dashboard
- Active customer count
- Open leads and opportunities
- Total pipeline value
- Overdue tasks alert
- Recent activity feed

### Interactive Reports
- Search and filter
- Sort by any column
- Export to Excel/CSV
- Customizable views
- Saved filters

### Forms
- Responsive design
- Inline validation
- Auto-complete fields
- Related record tabs
- Attachment support

---

## 🔐 Security Features

### Authentication
- APEX Authentication (default)
- Supports LDAP, SSO, OAuth
- Session timeout (8 hours)
- Password complexity rules

### Authorization
- Role-based access control (RBAC)
- Page-level security
- Item-level authorization
- Custom authorization schemes

### Data Security
- Row-level security via `assigned_to`
- Audit trail for compliance
- SQL injection prevention
- Input validation and sanitization

---

## 📈 Reporting and Analytics

### Standard Reports
- **Sales Pipeline** - All opportunities by stage
- **Revenue Forecast** - Weighted pipeline projection
- **Win/Loss Analysis** - Success rates and trends
- **Lead Conversion** - Conversion metrics by source
- **Activity Summary** - Task completion rates
- **Customer Health** - Account scoring report

### Custom Reports
Create custom reports using:
- Interactive Reports
- Classic Reports
- Charts (bar, line, pie, funnel)
- Pivot tables
- Export to Excel/PDF

---

## 🔗 Integration Capabilities

### REST API (via ORDS)
```
GET    /customers          - List customers
POST   /customers          - Create customer
GET    /customers/{id}     - Get customer details
PUT    /customers/{id}     - Update customer
DELETE /customers/{id}     - Delete customer
```

### Email Integration
- Send emails via APEX_MAIL
- Email notifications for:
  - New leads assigned
  - Opportunity stage changes
  - Activity reminders
  - Task assignments

### Export Options
- Excel (XLSX)
- CSV
- PDF reports
- Calendar export (ICS)

---

## 🧪 Testing

### Automated Tests
Run comprehensive test suite:
```bash
sqlplus crm_app/password@database @tests/run_all_tests.sql
```

Tests include:
- Schema validation (tables, constraints, indexes)
- Trigger functionality
- Business logic procedures
- Data integrity
- Performance benchmarks

### Manual Testing
Complete test scenarios for:
- Lead management workflow
- Customer creation and management
- Opportunity progression
- Activity tracking
- Reporting functionality

**For complete test plan, see [test_plan.md](tests/test_plan.md)**

---

## 📚 Documentation

| Document | Description |
|----------|-------------|
| [Installation Guide](INSTALLATION.md) | Step-by-step setup instructions |
| [Technical Documentation](documentation/technical_documentation.md) | Architecture and technical details |
| [User Guide](documentation/user_guide.md) | End-user manual with screenshots |
| [Process Flows](documentation/process_flows.md) | Business process diagrams |
| [Test Plan](tests/test_plan.md) | Testing strategy and test cases |

---

## 🛠️ Maintenance

### Regular Tasks
- **Daily:** Monitor for errors
- **Weekly:** Review audit trail growth
- **Monthly:** Archive old audit records
- **Quarterly:** Gather database statistics
- **Annually:** Review and optimize indexes

### Backup Strategy
```bash
# Full export
expdp crm_app/password@database \
  directory=DATA_PUMP_DIR \
  dumpfile=crm_backup_%U.dmp \
  schemas=CRM_APP \
  parallel=4

# APEX application export
# Via Application Builder > Export
```

---

## 🐛 Troubleshooting

### Common Issues

**Issue:** Page loads slowly  
**Solution:** Run `DBMS_STATS.GATHER_SCHEMA_STATS`, check indexes

**Issue:** Email not sending  
**Solution:** Verify SMTP configuration in APEX instance settings

**Issue:** Constraint violation errors  
**Solution:** Check foreign key relationships, verify lookup data exists

**For detailed troubleshooting, see [INSTALLATION.md](INSTALLATION.md#troubleshooting)**

---

## 📊 Performance Benchmarks

| Operation | Expected Performance |
|-----------|---------------------|
| Customer list query (100 rows) | < 1 second |
| Opportunity pipeline query | < 0.5 seconds |
| Lead conversion | < 2 seconds |
| Report generation | < 3 seconds |
| Page load (dashboard) | < 2 seconds |

---

## 🔄 Version History

### Version 1.0 (February 2026)
- Initial release
- 14 APEX pages
- 18 database tables
- Complete CRUD operations
- Audit trail functionality
- Business logic automation
- Comprehensive documentation

---

## 📞 Support

### Getting Help
- 📧 Email: crm-support@yourcompany.com
- 📚 Documentation: See `/documentation` folder
- 🐛 Bug Reports: Contact database administrator
- 💡 Feature Requests: Submit to product team

### Community Resources
- Oracle APEX Community: https://community.oracle.com/apex
- Oracle Documentation: https://docs.oracle.com/apex
- Stack Overflow: Tag `oracle-apex`

---

## 📄 License

Copyright © 2026 Your Company Name  
All Rights Reserved

This application is proprietary software. Unauthorized copying, modification, distribution, or use of this software, via any medium, is strictly prohibited.

---

## 🙏 Acknowledgments

Built with:
- Oracle Database
- Oracle Application Express (APEX)
- Oracle REST Data Services (ORDS)

---

## 🚧 Roadmap

### Planned Enhancements (v2.0)
- [ ] Marketing campaign management
- [ ] Contract and quote management
- [ ] Customer portal
- [ ] Mobile app (native iOS/Android)
- [ ] Advanced analytics with ML predictions
- [ ] Integration with email clients (Outlook, Gmail)
- [ ] Document management
- [ ] Recurring tasks/activities
- [ ] Team collaboration features
- [ ] Advanced reporting with OBIEE integration

---

**Ready to get started? See [INSTALLATION.md](INSTALLATION.md) for setup instructions!**

*README Version: 1.0 | Last Updated: February 14, 2026*
