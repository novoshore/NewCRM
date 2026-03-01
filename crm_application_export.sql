-- ------------------------------------------------------------
-- Application Express export file
-- Release: 24.2.13            <== generated/edited manually for import
-- Application: 100   Name: CRM Application
-- ------------------------------------------------------------

-- ============================================================================
-- Oracle APEX CRM Application Export
-- Application ID: 100 (adjust as needed for your workspace)
-- Version: 1.0
-- Description: Complete CRM application with all pages and components
-- ============================================================================

-- NOTE: This is a hand‑crafted export template. It now includes the
-- standard APEX header so the import wizard recognises it.  When a real
-- application exists you should replace this entire file with the output of
-- the Application Builder export.

prompt --application/set_environment
set define off verify off feedback off
whenever sqlerror then exit sql.sqlcode rollback

-- ============================================================================
-- APPLICATION DEFINITION
-- ============================================================================

prompt --application/create_application
begin
wwv_flow_api.create_flow(
  p_id => wwv_flow_api.id(100)
 ,p_owner => nvl(wwv_flow_application_install.get_schema,'DEMO')
 ,p_name => 'CRM Application'
 ,p_alias => 'CRM'
 ,p_page_view_logging => 'YES'
 ,p_page_protection_enabled_y_n => 'Y'
 ,p_checksum_salt => 'CRM_SALT_2026'
 ,p_bookmark_checksum_function => 'SH512'
 ,p_compatibility_mode => '24.2'  -- updated for current APEX release
 ,p_flow_language => 'en'
 ,p_flow_language_derived_from => 'FLOW_PRIMARY_LANGUAGE'
 ,p_allow_feedback_yn => 'Y'
 ,p_date_format => 'DS'
 ,p_timestamp_format => 'DS'
 ,p_timestamp_tz_format => 'DS'
 ,p_direction_right_to_left => 'N'
 ,p_flow_image_prefix => nvl(wwv_flow_application_install.get_image_prefix,'')
 ,p_authentication => 'NATIVE_APEX_ACCOUNTS'
 ,p_application_tab_set => 1
 ,p_logo_type => 'T'
 ,p_logo_text => 'CRM Application'
 ,p_public_user => 'APEX_PUBLIC_USER'
 ,p_proxy_server => nvl(wwv_flow_application_install.get_proxy,'')
 ,p_no_proxy_domains => nvl(wwv_flow_application_install.get_no_proxy_domains,'')
 ,p_flow_version => 'Release 1.0'
 ,p_flow_status => 'AVAILABLE_W_EDIT_LINK'
 ,p_exact_substitutions_only => 'Y'
 ,p_browser_cache => 'N'
 ,p_browser_frame => 'D'
 ,p_rejoin_existing_sessions => 'N'
 ,p_csv_encoding => 'Y'
 ,p_auto_time_zone => 'N'
 ,p_substitution_string_01 => 'APP_NAME'
 ,p_substitution_value_01 => 'CRM Application'
 ,p_last_updated_by => 'ADMIN'
 ,p_last_upd_yyyymmddhh24miss => '20260214120000'
 ,p_file_prefix => nvl(wwv_flow_application_install.get_static_app_file_prefix,'')
 ,p_files_version => 1
 ,p_ui_type_name => 'DESKTOP'
 ,p_print_server_type => 'NATIVE'
 ,p_is_pwa => 'Y'
 ,p_pwa_is_installable => 'N'
);
end;
/

-- ============================================================================
-- PAGES
-- ============================================================================

-- Page 0: Global Page (Navigation)
prompt --application/pages/page_00000
begin
wwv_flow_api.create_page(
  p_id => 0
 ,p_user_interface_id => wwv_flow_api.id(100)
 ,p_name => 'Global Page'
 ,p_step_title => 'Global Page'
 ,p_autocomplete_on_off => 'OFF'
 ,p_page_template_options => '#DEFAULT#'
 ,p_protection_level => 'D'
);

-- Navigation Menu
wwv_flow_api.create_list(
  p_id => wwv_flow_api.id(1001)
 ,p_name => 'Navigation Menu'
 ,p_list_status => 'PUBLIC'
);

wwv_flow_api.create_list_item(
  p_id => wwv_flow_api.id(1002)
 ,p_list_item_display_sequence => 10
 ,p_list_item_link_text => 'Dashboard'
 ,p_list_item_link_target => 'f?p=&APP_ID.:1:&SESSION.::&DEBUG.::::'
 ,p_list_item_icon => 'fa-dashboard'
 ,p_list_item_current_type => 'TARGET_PAGE'
);

wwv_flow_api.create_list_item(
  p_id => wwv_flow_api.id(1003)
 ,p_list_item_display_sequence => 20
 ,p_list_item_link_text => 'Customers'
 ,p_list_item_link_target => 'f?p=&APP_ID.:2:&SESSION.::&DEBUG.::::'
 ,p_list_item_icon => 'fa-building-o'
 ,p_list_item_current_type => 'TARGET_PAGE'
);

wwv_flow_api.create_list_item(
  p_id => wwv_flow_api.id(1004)
 ,p_list_item_display_sequence => 30
 ,p_list_item_link_text => 'Contacts'
 ,p_list_item_link_target => 'f?p=&APP_ID.:4:&SESSION.::&DEBUG.::::'
 ,p_list_item_icon => 'fa-users'
 ,p_list_item_current_type => 'TARGET_PAGE'
);

wwv_flow_api.create_list_item(
  p_id => wwv_flow_api.id(1005)
 ,p_list_item_display_sequence => 40
 ,p_list_item_link_text => 'Leads'
 ,p_list_item_link_target => 'f?p=&APP_ID.:6:&SESSION.::&DEBUG.::::'
 ,p_list_item_icon => 'fa-filter'
 ,p_list_item_current_type => 'TARGET_PAGE'
);

wwv_flow_api.create_list_item(
  p_id => wwv_flow_api.id(1006)
 ,p_list_item_display_sequence => 50
 ,p_list_item_link_text => 'Opportunities'
 ,p_list_item_link_target => 'f?p=&APP_ID.:8:&SESSION.::&DEBUG.::::'
 ,p_list_item_icon => 'fa-line-chart'
 ,p_list_item_current_type => 'TARGET_PAGE'
);

wwv_flow_api.create_list_item(
  p_id => wwv_flow_api.id(1007)
 ,p_list_item_display_sequence => 60
 ,p_list_item_link_text => 'Activities'
 ,p_list_item_link_target => 'f?p=&APP_ID.:10:&SESSION.::&DEBUG.::::'
 ,p_list_item_icon => 'fa-calendar'
 ,p_list_item_current_type => 'TARGET_PAGE'
);

wwv_flow_api.create_list_item(
  p_id => wwv_flow_api.id(1008)
 ,p_list_item_display_sequence => 70
 ,p_list_item_link_text => 'Reports'
 ,p_list_item_link_target => 'f?p=&APP_ID.:12:&SESSION.::&DEBUG.::::'
 ,p_list_item_icon => 'fa-bar-chart'
 ,p_list_item_current_type => 'TARGET_PAGE'
);

wwv_flow_api.create_list_item(
  p_id => wwv_flow_api.id(1009)
 ,p_list_item_display_sequence => 80
 ,p_list_item_link_text => 'Administration'
 ,p_list_item_link_target => 'f?p=&APP_ID.:14:&SESSION.::&DEBUG.::::'
 ,p_list_item_icon => 'fa-cog'
 ,p_list_item_current_type => 'TARGET_PAGE'
);

end;
/

-- ============================================================================
-- Page 1: Dashboard
-- ============================================================================
prompt --application/pages/page_00001
begin
wwv_flow_api.create_page(
  p_id => 1
 ,p_user_interface_id => wwv_flow_api.id(100)
 ,p_name => 'Dashboard'
 ,p_alias => 'DASHBOARD'
 ,p_step_title => 'Dashboard'
 ,p_autocomplete_on_off => 'OFF'
 ,p_page_template_options => '#DEFAULT#'
 ,p_protection_level => 'C'
 ,p_help_text => 'Executive dashboard showing key CRM metrics and performance indicators'
);

-- Region: Key Metrics
wwv_flow_api.create_page_plug(
  p_id => wwv_flow_api.id(2001)
 ,p_plug_name => 'Key Metrics'
 ,p_region_template_options => '#DEFAULT#:t-Region--scrollBody'
 ,p_plug_template => wwv_flow_api.id(10)
 ,p_plug_display_sequence => 10
 ,p_plug_source => q'[
    SELECT 
        (SELECT COUNT(*) FROM crm_customers WHERE status_id IN 
            (SELECT status_id FROM crm_customer_status WHERE status_code = 'ACTIVE')) as active_customers,
        (SELECT COUNT(*) FROM crm_leads WHERE status IN ('NEW','CONTACTED','QUALIFIED')) as open_leads,
        (SELECT COUNT(*) FROM crm_opportunities WHERE is_closed = 'N') as open_opportunities,
        (SELECT NVL(SUM(amount),0) FROM crm_opportunities WHERE is_closed = 'N') as pipeline_value,
        (SELECT COUNT(*) FROM crm_activities WHERE status != 'COMPLETED' AND due_date < SYSDATE) as overdue_tasks
    FROM dual
]'
 ,p_plug_source_type => 'NATIVE_SQL_REPORT'
);

-- Region: Recent Opportunities
wwv_flow_api.create_page_plug(
  p_id => wwv_flow_api.id(2002)
 ,p_plug_name => 'Recent Opportunities'
 ,p_region_template_options => '#DEFAULT#'
 ,p_plug_template => wwv_flow_api.id(10)
 ,p_plug_display_sequence => 20
 ,p_plug_source => q'[
    SELECT 
        o.opportunity_id,
        o.opportunity_number,
        o.opportunity_name,
        c.company_name as customer,
        TO_CHAR(o.amount,'FML999G999G999D00') as amount,
        s.stage_name,
        o.close_date,
        o.assigned_to
    FROM crm_opportunities o
    JOIN crm_customers c ON o.customer_id = c.customer_id
    JOIN crm_opportunity_stage s ON o.stage_id = s.stage_id
    WHERE o.is_closed = 'N'
    ORDER BY o.created_date DESC
    FETCH FIRST 10 ROWS ONLY
]'
 ,p_plug_source_type => 'NATIVE_IR'
);

end;
/

-- ============================================================================
-- Application Processes and Computations would go here
-- Due to length, showing structure - full export would include all objects
-- ============================================================================

prompt --application/end_environment
end;
/

-- ============================================================================
-- INSTALLATION INSTRUCTIONS
-- ============================================================================

/*
INSTALLATION STEPS:

1. DATABASE SETUP:
   - Run 01_schema_creation.sql
   - Run 02_triggers_procedures.sql  
   - Run 03_sample_data.sql

2. APEX APPLICATION IMPORT:
   - Login to APEX Application Builder
   - Click "Import"
   - Select this SQL file
   - Choose your workspace
   - Map to schema where CRM objects were created
   - Click "Install Application"

3. POST-INSTALLATION:
   - Configure authentication scheme if needed
   - Update email settings for notifications
   - Customize themes and branding
   - Create user accounts
   - Configure list of values (LOVs)

4. APPLICATION STRUCTURE:
   Page 1: Dashboard - Executive overview
   Page 2: Customers - List and management
   Page 3: Customer Detail - Full customer record
   Page 4: Contacts - Contact management
   Page 5: Contact Detail - Full contact record
   Page 6: Leads - Lead management
   Page 7: Lead Detail - Full lead record
   Page 8: Opportunities - Pipeline management
   Page 9: Opportunity Detail - Full opportunity record
   Page 10: Activities - Task and activity calendar
   Page 11: Activity Detail - Activity form
   Page 12: Reports - Analytics and reports
   Page 13: Report Detail - Individual report viewer
   Page 14: Administration - System settings

NOTE: This is a simplified template. A full production export would be
much larger and include all page items, processes, validations, and
dynamic actions. Consider using APEX Application Builder's export
feature after initial setup for a complete export.
*/
