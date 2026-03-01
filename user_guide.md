# CRM Application - User Guide

## Version 1.0 | February 2026

---

## Table of Contents
1. [Getting Started](#getting-started)
2. [Dashboard Overview](#dashboard-overview)
3. [Managing Customers](#managing-customers)
4. [Working with Contacts](#working-with-contacts)
5. [Lead Management](#lead-management)
6. [Opportunity Pipeline](#opportunity-pipeline)
7. [Activities and Tasks](#activities-and-tasks)
8. [Reports and Analytics](#reports-and-analytics)
9. [Best Practices](#best-practices)
10. [FAQs](#faqs)

---

## 1. Getting Started

### 1.1 Accessing the Application
1. Navigate to your APEX application URL
2. Enter your username and password
3. Click "Sign In"
4. You'll be directed to the Dashboard

### 1.2 Navigation
The main navigation menu is located on the left side of the screen:
- **Dashboard** - Overview of key metrics
- **Customers** - Manage customer accounts
- **Contacts** - Manage individual contacts
- **Leads** - Track and convert leads
- **Opportunities** - Manage sales pipeline
- **Activities** - Schedule and track tasks
- **Reports** - View analytics and reports
- **Administration** - System settings (admin only)

### 1.3 User Interface Elements
- **Search Bar:** Quick search across all entities
- **Filters:** Refine lists by status, date, owner
- **Action Buttons:** Create, Edit, Delete operations
- **Export:** Download data to Excel/CSV
- **Refresh:** Update current view

---

## 2. Dashboard Overview

### 2.1 Key Metrics Cards
The dashboard displays real-time metrics:
- **Active Customers:** Count of active customer accounts
- **Open Leads:** Leads not yet converted or closed
- **Open Opportunities:** Active sales opportunities
- **Pipeline Value:** Total value of open opportunities
- **Overdue Tasks:** Activities past their due date

### 2.2 Recent Activity
View your most recent:
- Opportunities updated
- Tasks completed
- Leads created
- Customers modified

### 2.3 Quick Actions
- Create New Lead
- Add Customer
- Schedule Activity
- Log Call
- Create Opportunity

---

## 3. Managing Customers

### 3.1 Viewing Customers
1. Click **Customers** in the navigation menu
2. Browse the interactive report
3. Use search and filters to find specific customers
4. Click on a customer name to view details

### 3.2 Creating a New Customer
1. Click the **Create** button
2. Fill in required fields:
   - **Company Name** (required)
   - **Industry**
   - **Status** (Active/Prospect/Inactive)
   - **Contact Information** (email, phone)
   - **Billing Address**
3. Optional fields:
   - Annual Revenue
   - Employee Count
   - Rating (1-5 stars)
   - Shipping Address
   - Description
4. Assign to a sales representative
5. Click **Create** to save

### 3.3 Editing Customer Information
1. Navigate to the customer detail page
2. Click **Edit**
3. Update information as needed
4. Click **Save Changes**
5. Changes are automatically logged in audit trail

### 3.4 Customer Details Page
The customer detail page shows:
- **Company Information:** All account details
- **Contacts Tab:** Associated contacts
- **Opportunities Tab:** Sales opportunities
- **Activities Tab:** Related tasks and events
- **Notes Tab:** Comments and notes
- **Audit Trail:** History of changes

### 3.5 Deleting a Customer
**Warning:** This will delete all associated contacts, opportunities, activities, and notes.
1. Navigate to customer detail page
2. Click **Delete**
3. Confirm deletion
4. Customer and related records are removed

---

## 4. Working with Contacts

### 4.1 Contact Management Overview
Contacts are individuals associated with customer accounts. Each customer can have multiple contacts.

### 4.2 Adding a Contact
1. From the customer detail page, click **Add Contact**
   OR
   Navigate to **Contacts** menu and click **Create**
2. Fill in contact information:
   - **First Name** (required)
   - **Last Name** (required)
   - **Email** (required)
   - **Job Title**
   - **Phone Numbers** (work, mobile, home)
   - **Mailing Address**
3. Set contact properties:
   - **Primary Contact:** Mark as main contact
   - **Decision Maker:** Indicate if this person makes purchasing decisions
4. Communication preferences:
   - Do Not Call
   - Do Not Email
5. Click **Create** to save

### 4.3 Marking a Primary Contact
Each customer should have one primary contact:
1. Edit the contact record
2. Check **Is Primary Contact**
3. Save changes
4. System automatically removes primary flag from other contacts

### 4.4 Contact Communication
- **Email:** Click email address to send email
- **Call:** Click phone number to initiate call (if integrated)
- **LinkedIn:** Click LinkedIn URL to view profile

### 4.5 Contact Privacy Settings
Respect contact preferences:
- **Do Not Call:** Cannot be called
- **Do Not Email:** Cannot receive marketing emails
- System shows warnings when these flags are set

---

## 5. Lead Management

### 5.1 Understanding Leads
Leads are potential customers who have shown interest but haven't been qualified or converted yet.

### 5.2 Lead Statuses
- **NEW:** Just entered the system
- **CONTACTED:** Initial contact made
- **QUALIFIED:** Meets criteria for conversion
- **CONVERTED:** Turned into customer and opportunity
- **LOST:** Not interested or disqualified

### 5.3 Lead Ratings
- **HOT:** High interest, ready to buy
- **WARM:** Interested, needs nurturing
- **COLD:** Low interest or not ready

### 5.4 Creating a Lead
1. Click **Leads** > **Create**
2. Enter lead information:
   - **Company Name** (required)
   - **First/Last Name** (required)
   - **Email** (required)
   - **Phone**
   - **Lead Source** (Website, Referral, Trade Show, etc.)
   - **Industry**
3. Set initial status and rating
4. Assign to a sales representative
5. Click **Create**

### 5.5 Qualifying a Lead
Review the lead and determine if they meet your criteria:
1. Open lead record
2. Review information
3. Add notes about qualification criteria
4. If qualified, change status to **QUALIFIED**
5. If not qualified, change to **LOST** with reason

### 5.6 Converting a Lead
When a lead becomes a customer:
1. Open the qualified lead
2. Click **Convert Lead** button
3. Review pre-filled customer information
4. Choose whether to create an opportunity
5. If creating opportunity:
   - Enter opportunity amount
   - Set expected close date
6. Click **Convert**
7. System creates:
   - Customer account
   - Primary contact
   - Opportunity (if selected)
8. Lead status changes to **CONVERTED**

**Note:** Converted leads remain in the system for historical tracking but are marked as converted and linked to the new customer record.

---

## 6. Opportunity Pipeline

### 6.1 Sales Stages
Opportunities move through defined stages:
1. **Qualification (10%)** - Initial interest identified
2. **Needs Analysis (20%)** - Understanding requirements
3. **Proposal/Quote (40%)** - Formal proposal submitted
4. **Negotiation (60%)** - Discussing terms
5. **Closed Won (100%)** - Deal won
6. **Closed Lost (0%)** - Deal lost

The percentage represents the probability of winning.

### 6.2 Creating an Opportunity
1. Click **Opportunities** > **Create**
   OR
   From customer page, click **Add Opportunity**
2. Fill in details:
   - **Opportunity Name** (required)
   - **Customer** (required)
   - **Contact** (optional but recommended)
   - **Amount** (required)
   - **Expected Close Date** (required)
   - **Stage** (required)
   - **Lead Source**
3. Add description and next steps
4. Assign owner
5. Click **Create**

### 6.3 Updating Opportunity Stage
As the deal progresses:
1. Open opportunity record
2. Click **Edit**
3. Change **Stage** to next appropriate stage
4. Update **Next Step**
5. Adjust **Close Date** if needed
6. Click **Save**

**Automatic Updates:**
- Probability updates based on stage
- Close date set when marked as Closed Won/Lost
- Win/Loss flags updated automatically

### 6.4 Forecasting
View your pipeline forecast:
1. Navigate to **Reports** > **Revenue Forecast**
2. Select date range
3. Report shows:
   - Total pipeline value
   - Weighted pipeline (amount × probability)
   - Expected close dates
   - Win rate percentage

### 6.5 Closing an Opportunity
**Closed Won:**
1. Change stage to **Closed Won**
2. System automatically:
   - Sets probability to 100%
   - Marks as closed
   - Records close date
3. Opportunity appears in won deals report

**Closed Lost:**
1. Change stage to **Closed Lost**
2. Add lost reason in notes
3. System automatically:
   - Sets probability to 0%
   - Marks as closed
   - Records close date

---

## 7. Activities and Tasks

### 7.1 Activity Types
- **Phone Call:** Scheduled or logged calls
- **Meeting:** In-person or virtual meetings
- **Email:** Important email communications
- **Task:** General to-do items
- **Product Demo:** Scheduled demonstrations

### 7.2 Creating an Activity
1. Click **Activities** > **Create**
2. Select **Activity Type**
3. Fill in details:
   - **Subject** (required)
   - **Due Date and Time**
   - **Status** (Not Started, In Progress, Completed, etc.)
   - **Priority** (Low, Medium, High, Urgent)
4. Link to related records:
   - Customer
   - Contact
   - Opportunity
   - Lead
5. Set duration (for calls and meetings)
6. Add location (for meetings)
7. Enable reminder if desired
8. Click **Create**

### 7.3 Calendar View
1. Navigate to **Activities**
2. Switch to **Calendar** view
3. See all activities by:
   - Day
   - Week
   - Month
4. Click on activity to view/edit
5. Drag and drop to reschedule

### 7.4 Completing Activities
1. Open activity
2. Add completion notes
3. Change status to **Completed**
4. System automatically:
   - Records completion date
   - Updates activity timeline
   - Triggers any follow-up workflows

### 7.5 Overdue Activities
Activities past due date show in red:
1. Check **Dashboard** for overdue count
2. Navigate to **Activities** > filter **Overdue**
3. Prioritize and complete or reschedule
4. Update status and due dates as needed

---

## 8. Reports and Analytics

### 8.1 Available Reports

**Sales Reports:**
- **Pipeline Report:** All open opportunities by stage
- **Revenue Forecast:** Weighted pipeline projection
- **Win/Loss Analysis:** Success rate by stage, source
- **Sales by Rep:** Performance by sales representative

**Customer Reports:**
- **Customer List:** All customers with filters
- **Customer Health Score:** Account health metrics
- **Customer Activity:** Interaction history
- **Industry Analysis:** Breakdown by industry

**Lead Reports:**
- **Lead Conversion Rate:** Conversion metrics
- **Lead Source Performance:** ROI by source
- **Lead Aging:** Time in each status
- **Sales Funnel:** Lead to customer conversion

**Activity Reports:**
- **Activity Summary:** Activities by type and status
- **Completion Rate:** Task completion metrics
- **Time Analysis:** Time spent on activities

### 8.2 Running a Report
1. Navigate to **Reports**
2. Select desired report
3. Set parameters:
   - Date range
   - Sales rep
   - Status filters
   - Other criteria
4. Click **Run Report**
5. View results in interactive table or chart

### 8.3 Exporting Reports
1. Run the report
2. Click **Export** button
3. Choose format:
   - Excel (XLSX)
   - CSV
   - PDF
4. File downloads to your computer

### 8.4 Dashboard Charts
The dashboard includes visualizations:
- **Pipeline by Stage:** Funnel chart
- **Revenue Trend:** Line chart over time
- **Top Customers:** Bar chart by revenue
- **Activity Distribution:** Pie chart by type

---

## 9. Best Practices

### 9.1 Data Entry
- **Be Consistent:** Use standard formats for phone, email
- **Complete Profiles:** Fill in all available information
- **Timely Updates:** Update records as information changes
- **Use Notes:** Document important details and conversations

### 9.2 Lead Management
- **Follow Up Quickly:** Contact new leads within 24 hours
- **Qualify Early:** Determine fit before investing time
- **Track Source:** Always record where leads came from
- **Regular Review:** Clean up old, stale leads

### 9.3 Opportunity Management
- **Keep Current:** Update stages as deals progress
- **Realistic Close Dates:** Set achievable timelines
- **Document Next Steps:** Always know the next action
- **Link Activities:** Create tasks for follow-ups

### 9.4 Activity Management
- **Schedule Everything:** Don't rely on memory
- **Set Reminders:** Use system reminders for important tasks
- **Complete Promptly:** Mark tasks complete when done
- **Add Details:** Include outcome in notes

### 9.5 Customer Relationships
- **Regular Touchpoints:** Schedule periodic check-ins
- **Respond Quickly:** Answer customer inquiries promptly
- **Track Interactions:** Log all significant communications
- **Celebrate Wins:** Record and acknowledge milestones

---

## 10. FAQs

**Q: How do I reset my password?**  
A: Contact your system administrator or use the "Forgot Password" link on the login page.

**Q: Can I delete a customer with opportunities?**  
A: Yes, but all related opportunities, activities, and notes will also be deleted. Use caution.

**Q: What happens to a lead after conversion?**  
A: The lead status changes to "Converted" and remains in the system for reference. It's linked to the new customer and contact records.

**Q: How do I assign a record to someone else?**  
A: Edit the record and change the "Assigned To" field to the new owner.

**Q: Can I undo a deleted record?**  
A: No, deletions are permanent. The audit trail retains a record that it existed, but the data cannot be restored.

**Q: Why can't I see all opportunities?**  
A: You may have filters applied, or your role may limit which records you can view. Check with your administrator.

**Q: How often is the dashboard updated?**  
A: Dashboard metrics are calculated in real-time when you load the page. Click refresh for latest data.

**Q: Can I export my entire customer list?**  
A: Yes, navigate to Customers, select all (or use filters), and click Export to download.

**Q: How do I schedule a recurring task?**  
A: Create the first instance, then after completion, create a new activity with the next due date. (Future enhancement: recurring tasks)

**Q: Who can see my private notes?**  
A: Private notes are visible only to you and system administrators.

---

## Support

For additional help:
- **Email:** support@yourcompany.com
- **Phone:** 1-800-CRM-HELP
- **Help Desk:** https://support.yourcompany.com
- **Training Videos:** https://training.yourcompany.com/crm

---

*User Guide Version: 1.0*  
*Last Updated: February 14, 2026*  
*For CRM Application v1.0*
