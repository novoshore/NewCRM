# CRM Application - Process Flow Diagrams

## Table of Contents
1. [Lead to Customer Conversion Process](#1-lead-to-customer-conversion-process)
2. [Opportunity Management Process](#2-opportunity-management-process)
3. [Activity Management Workflow](#3-activity-management-workflow)
4. [Customer Onboarding Process](#4-customer-onboarding-process)
5. [Sales Pipeline Progression](#5-sales-pipeline-progression)

---

## 1. Lead to Customer Conversion Process

```mermaid
flowchart TD
    Start([New Lead Received]) --> Enter[Enter Lead Information]
    Enter --> Assign[Assign to Sales Rep]
    Assign --> Contact{Initial Contact Made?}
    
    Contact -->|No| Remind[Set Reminder Task]
    Remind --> Contact
    
    Contact -->|Yes| UpdateStatus[Update Status: CONTACTED]
    UpdateStatus --> Qualify{Meets Qualification Criteria?}
    
    Qualify -->|No| Lost[Mark as LOST<br/>Document Reason]
    Lost --> End1([End - Lead Lost])
    
    Qualify -->|Yes| QualStatus[Update Status: QUALIFIED]
    QualStatus --> Convert{Ready to Convert?}
    
    Convert -->|Not Yet| Nurture[Continue Nurturing<br/>Schedule Follow-ups]
    Nurture --> Convert
    
    Convert -->|Yes| ConvertLead[Click Convert Lead Button]
    ConvertLead --> FillInfo[Review Pre-filled Info<br/>Make Adjustments]
    FillInfo --> OppQuestion{Create Opportunity?}
    
    OppQuestion -->|Yes| OppDetails[Enter Opportunity<br/>Amount & Close Date]
    OppDetails --> Execute[Execute Conversion]
    
    OppQuestion -->|No| Execute
    
    Execute --> CreateCust[System Creates:<br/>1. Customer Account<br/>2. Primary Contact]
    CreateCust --> CreateOpp{Opportunity Selected?}
    
    CreateOpp -->|Yes| OppCreated[3. Opportunity Created]
    OppCreated --> UpdateLead[Update Lead Status:<br/>CONVERTED]
    
    CreateOpp -->|No| UpdateLead
    
    UpdateLead --> Link[Link Lead to Customer]
    Link --> Notify[Send Notification to<br/>Sales Rep]
    Notify --> End2([End - Conversion Complete])
    
    style Start fill:#90EE90
    style End1 fill:#FFB6C1
    style End2 fill:#90EE90
    style Execute fill:#FFD700
    style Lost fill:#FFB6C1
```

---

## 2. Opportunity Management Process

```mermaid
flowchart TD
    Start([Create Opportunity]) --> InitStage[Initial Stage:<br/>QUALIFICATION 10%]
    InitStage --> EnterDetails[Enter:<br/>- Customer<br/>- Amount<br/>- Close Date<br/>- Description]
    EnterDetails --> Assign[Assign to Sales Rep]
    Assign --> CreateAct[Create Initial Activity:<br/>Discovery Call]
    
    CreateAct --> Track[Track Opportunity]
    Track --> Review{Regular Review<br/>Every Week}
    
    Review --> Progress{Deal Progressing?}
    
    Progress -->|No| Assess{Still Viable?}
    Assess -->|No| CloseLost[Close as LOST<br/>Document Reason]
    CloseLost --> End1([End - Lost Deal])
    
    Assess -->|Yes| UpdateNext[Update Next Steps<br/>Schedule Follow-up]
    UpdateNext --> Track
    
    Progress -->|Yes| NextStage{Move to<br/>Next Stage?}
    
    NextStage -->|Needs Analysis| Stage2[Needs Analysis 20%<br/>- Understand requirements<br/>- Identify decision makers]
    NextStage -->|Proposal| Stage3[Proposal/Quote 40%<br/>- Prepare proposal<br/>- Present solution]
    NextStage -->|Negotiation| Stage4[Negotiation 60%<br/>- Discuss terms<br/>- Address concerns]
    
    Stage2 --> UpdateProb[System Auto-updates<br/>Probability]
    Stage3 --> UpdateProb
    Stage4 --> UpdateProb
    
    UpdateProb --> CheckDate{Close Date<br/>Realistic?}
    CheckDate -->|No| AdjustDate[Adjust Close Date]
    AdjustDate --> LogActivity[Log Activity Notes]
    CheckDate -->|Yes| LogActivity
    
    LogActivity --> Track
    
    NextStage -->|Ready to Close| FinalStage{Outcome?}
    
    FinalStage -->|Won| CloseWon[Close as WON<br/>Probability: 100%]
    CloseWon --> RecordDate[System Records<br/>Close Date]
    RecordDate --> Celebrate[Notify Team<br/>Update Metrics]
    Celebrate --> End2([End - Won Deal])
    
    FinalStage -->|Lost| CloseLost
    
    style Start fill:#90EE90
    style End1 fill:#FFB6C1
    style End2 fill:#90EE90
    style CloseWon fill:#FFD700
    style CloseLost fill:#FFB6C1
```

---

## 3. Activity Management Workflow

```mermaid
flowchart TD
    Start([Activity Needed]) --> Type{Activity Type?}
    
    Type -->|Phone Call| CreateCall[Create Call Activity]
    Type -->|Meeting| CreateMeet[Create Meeting Activity]
    Type -->|Email| CreateEmail[Create Email Activity]
    Type -->|Task| CreateTask[Create Task Activity]
    Type -->|Demo| CreateDemo[Create Demo Activity]
    
    CreateCall --> FillDetails
    CreateMeet --> FillDetails
    CreateEmail --> FillDetails
    CreateTask --> FillDetails
    CreateDemo --> FillDetails
    
    FillDetails[Fill in Details:<br/>- Subject<br/>- Description<br/>- Priority<br/>- Due Date/Time] --> LinkRecord{Link to Record?}
    
    LinkRecord -->|Customer| LinkCust[Associate with<br/>Customer]
    LinkRecord -->|Opportunity| LinkOpp[Associate with<br/>Opportunity]
    LinkRecord -->|Lead| LinkLead[Associate with Lead]
    LinkRecord -->|Contact| LinkCont[Associate with<br/>Contact]
    LinkRecord -->|No Link| SetReminder
    
    LinkCust --> SetReminder
    LinkOpp --> SetReminder
    LinkLead --> SetReminder
    LinkCont --> SetReminder
    
    SetReminder{Set Reminder?} -->|Yes| ConfigRemind[Configure Reminder<br/>Minutes Before Due]
    SetReminder -->|No| SaveActivity
    ConfigRemind --> SaveActivity[Save Activity]
    
    SaveActivity --> Calendar[Activity Appears<br/>in Calendar]
    Calendar --> DueApproach{Due Date<br/>Approaching?}
    
    DueApproach -->|Yes| SendReminder[System Sends<br/>Reminder]
    SendReminder --> Perform
    DueApproach -->|No| Wait[Wait]
    Wait --> DueApproach
    
    Perform[Perform Activity] --> Complete{Activity<br/>Completed?}
    
    Complete -->|Yes| AddNotes[Add Completion Notes<br/>Document Outcome]
    AddNotes --> MarkComplete[Mark Status:<br/>COMPLETED]
    MarkComplete --> TimeStamp[System Records<br/>Completion Time]
    TimeStamp --> FollowUp{Follow-up<br/>Needed?}
    
    FollowUp -->|Yes| NewActivity[Create New<br/>Follow-up Activity]
    NewActivity --> End1([End])
    
    FollowUp -->|No| End1
    
    Complete -->|No - Rescheduled| UpdateDate[Update Due Date<br/>Add Reschedule Note]
    UpdateDate --> DueApproach
    
    Complete -->|No - Cancelled| Cancel[Mark as Deferred<br/>Document Reason]
    Cancel --> End2([End - Cancelled])
    
    style Start fill:#90EE90
    style End1 fill:#90EE90
    style End2 fill:#FFB6C1
    style MarkComplete fill:#FFD700
```

---

## 4. Customer Onboarding Process

```mermaid
flowchart TD
    Start([New Customer Created]) --> Source{Source?}
    
    Source -->|Converted Lead| LeadData[Import Data from<br/>Lead Record]
    Source -->|Direct Entry| ManualEntry[Manual Data Entry]
    Source -->|Import| ImportData[Import from File/API]
    
    LeadData --> Validate
    ManualEntry --> Validate
    ImportData --> Validate
    
    Validate[Validate Data:<br/>- Required Fields<br/>- Email Format<br/>- Phone Format] --> Valid{Data Valid?}
    
    Valid -->|No| Correct[Correct Errors<br/>& Warnings]
    Correct --> Validate
    
    Valid -->|Yes| SaveCustomer[Save Customer Record<br/>Auto-generate Account#]
    SaveCustomer --> AddContact[Add Primary Contact]
    
    AddContact --> ContactDetails[Enter Contact:<br/>- Name<br/>- Email<br/>- Phone<br/>- Title<br/>- Mark as Primary]
    ContactDetails --> MoreContacts{Additional<br/>Contacts?}
    
    MoreContacts -->|Yes| AddMore[Add More Contacts]
    AddMore --> MoreContacts
    
    MoreContacts -->|No| Assign[Assign to<br/>Sales Representative]
    Assign --> SetStatus[Set Customer Status:<br/>ACTIVE or PROSPECT]
    
    SetStatus --> Welcome[Create Welcome Task:<br/>- Introduction call<br/>- Send welcome email<br/>- Due: Within 48hrs]
    
    Welcome --> Documents{Contracts/<br/>Documents?}
    
    Documents -->|Yes| Attach[Attach Documents<br/>to Customer Record]
    Attach --> Opportunity
    
    Documents -->|No| Opportunity
    
    Opportunity{Create Initial<br/>Opportunity?} -->|Yes| CreateOpp[Create Opportunity<br/>with Expected Value]
    CreateOpp --> Notify
    
    Opportunity -->|No| Notify
    
    Notify[Notify Sales Rep:<br/>- New customer assigned<br/>- Welcome task created] --> Calendar[Add to Customer<br/>Review Calendar]
    
    Calendar --> Monitor[Monitor:<br/>- Activity completion<br/>- First order<br/>- Health score]
    
    Monitor --> End([Onboarding Complete])
    
    style Start fill:#90EE90
    style End fill:#90EE90
    style SaveCustomer fill:#FFD700
    style Notify fill:#87CEEB
```

---

## 5. Sales Pipeline Progression

```mermaid
stateDiagram-v2
    [*] --> Qualification: New Opportunity<br/>Created
    
    Qualification --> NeedsAnalysis: Requirements<br/>Identified
    Qualification --> ClosedLost: Not Qualified
    
    NeedsAnalysis --> Proposal: Needs<br/>Understood
    NeedsAnalysis --> ClosedLost: No Fit
    
    Proposal --> Negotiation: Proposal<br/>Accepted
    Proposal --> NeedsAnalysis: More Info<br/>Needed
    Proposal --> ClosedLost: Rejected
    
    Negotiation --> ClosedWon: Terms<br/>Agreed
    Negotiation --> Proposal: Revise<br/>Proposal
    Negotiation --> ClosedLost: No Agreement
    
    ClosedWon --> [*]: Deal Won<br/>🎉
    ClosedLost --> [*]: Deal Lost<br/>❌
    
    note right of Qualification
        Probability: 10%
        - Identify decision makers
        - Understand budget
        - Confirm timeline
    end note
    
    note right of NeedsAnalysis
        Probability: 20%
        - Document requirements
        - Assess pain points
        - Determine solution fit
    end note
    
    note right of Proposal
        Probability: 40%
        - Present solution
        - Provide pricing
        - Address questions
    end note
    
    note right of Negotiation
        Probability: 60%
        - Discuss terms
        - Handle objections
        - Finalize details
    end note
    
    note right of ClosedWon
        Probability: 100%
        - Contract signed
        - Implementation begins
        - Customer onboarded
    end note
    
    note right of ClosedLost
        Probability: 0%
        - Document loss reason
        - Keep for future
        - Learn from outcome
    end note
```

---

## Additional Process Notes

### Automation Triggers
1. **Lead Assignment:** Auto-assign based on territory/round-robin
2. **Opportunity Updates:** Probability auto-updates with stage changes
3. **Activity Reminders:** System sends reminders before due date
4. **Audit Trail:** All changes automatically logged
5. **Email Notifications:** Stakeholders notified of key events

### Validation Rules
1. **Lead Conversion:** Cannot convert already converted lead
2. **Opportunity Amount:** Must be positive value
3. **Close Date:** Cannot be in the past for new opportunities
4. **Primary Contact:** Only one per customer
5. **Required Fields:** Enforced before save

### Integration Points
1. **Email System:** Activity creation triggers email
2. **Calendar:** Activities sync to calendar
3. **Reporting:** Real-time dashboard updates
4. **External CRM:** API for data exchange
5. **Marketing Automation:** Lead source tracking

---

*Process Documentation Version: 1.0*  
*Last Updated: February 14, 2026*
