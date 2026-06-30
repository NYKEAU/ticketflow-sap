# TicketFlow SAP — Mock Data

Use this data to populate the app after BTP deployment.  
Create these tickets manually via the Fiori Elements UI to get realistic screenshots.

---

## Tickets to Create

### Ticket 1
| Field | Value |
|---|---|
| **Title** | ERP login broken after password reset |
| **Description** | User JDUPONT cannot log in to SAP Fiori launchpad after IT reset his password yesterday. Error: "Authentication failed". Blocking access to all SAP applications. |
| **Priority** | C — Critical |
| **Status** | NW — New |
| **Category** | IT Support |
| **Assigned To** | *(leave empty — use Assign action after creation)* |

---

### Ticket 2
| Field | Value |
|---|---|
| **Title** | Invoice PDF export generates blank page |
| **Description** | When exporting invoices to PDF from the Billing module, the last page is always blank. Issue reported by 3 users in the Finance department. Reproducible on Chrome and Edge. |
| **Priority** | H — High |
| **Status** | IP — In Progress |
| **Category** | Finance |
| **Assigned To** | MLEBLANC |

---

### Ticket 3
| Field | Value |
|---|---|
| **Title** | New employee onboarding — access request |
| **Description** | New hire SMARTIN (start date 2026-07-14) needs access to HR module, Travel Management, and Fiori launchpad. Manager approval obtained. |
| **Priority** | N — Normal |
| **Status** | OH — On Hold |
| **Category** | HR |
| **Assigned To** | ATREMBLAY |

---

### Ticket 4
| Field | Value |
|---|---|
| **Title** | Printer mapping issue on floor 3 |
| **Description** | Windows print server is not mapping the HP LaserJet on floor 3 for remote users. Local users are unaffected. Issue started after last Windows Update on 2026-06-25. |
| **Priority** | L — Low |
| **Status** | RS — Resolved |
| **Category** | Infrastructure |
| **Assigned To** | PGAGNON |

---

### Ticket 5
| Field | Value |
|---|---|
| **Title** | SAP Fiori launchpad tiles not loading |
| **Description** | Several users reported that their Fiori launchpad shows empty tiles after the maintenance window on 2026-06-20. Cleared browser cache with no effect. Root cause identified: BSP application cache not refreshed after transport. |
| **Priority** | H — High |
| **Status** | CL — Closed |
| **Category** | IT Support |
| **Assigned To** | MLEBLANC |
| **Closing Comment** | Cache refreshed via transaction /UI5/APP_INDEX_CALCULATE. All tiles restored. Users confirmed resolution on 2026-06-22. |

---

### Ticket 6
| Field | Value |
|---|---|
| **Title** | Purchase order approval workflow stuck |
| **Description** | PO #4500123456 has been pending approval for 5 business days. Approver FMORIN is on leave and no substitute was configured in the workflow. Needs manual rerouting. |
| **Priority** | H — High |
| **Status** | IP — In Progress |
| **Category** | Finance |
| **Assigned To** | ATREMBLAY |

---

### Ticket 7
| Field | Value |
|---|---|
| **Title** | Report Z_MM_STOCK_REPORT slow performance |
| **Description** | Custom ABAP report Z_MM_STOCK_REPORT takes over 8 minutes to run for plant 1000. Used to run in under 1 minute. Table MARD may need index review. |
| **Priority** | N — Normal |
| **Status** | NW — New |
| **Category** | Development |
| **Assigned To** | *(leave empty)* |

---

## Recommended Creation Order

1. Create all 7 tickets with Status = **NW** first
2. Use the **Assign action** on tickets 2, 3, 4, 5, 6 to set the assignee → status auto-changes to IP
3. Manually update tickets 3 and 4 to OH and RS
4. Use the **Close action** on ticket 5 with the closing comment above
5. This gives you a realistic spread across all statuses for screenshots

---

## Screenshot Checklist

- [ ] List Report — all 7 tickets visible, criticality colors on Status + Priority columns
- [ ] List Report — filters panel open (Status + Priority active)
- [ ] List Report — action buttons visible (Assigner / Clôturer / Réouvrir)
- [ ] Object Page — Ticket 1 (Critical / New — orange badge)
- [ ] Object Page — Ticket 5 (Closed — with closing comment filled)
- [ ] Action dialog — "Clôturer" popup with ClosingComment input field
