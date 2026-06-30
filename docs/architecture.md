# TicketFlow SAP — Architecture

## Stack Overview

```
┌──────────────────────────────────────────┐
│         SAP Fiori Elements UI            │
│   List Report + Object Page + Actions    │
└──────────────────┬───────────────────────┘
                   │ OData V4
┌──────────────────▼───────────────────────┐
│         RAP Business Service             │
│   ZTICKET_SRV_DEF + ZTICKET_SRV_BIND     │
└──────────────────┬───────────────────────┘
                   │
┌──────────────────▼───────────────────────┐
│     Behavior Definition Projection       │
│            ZTICKET_C.bdef                │
└──────────────────┬───────────────────────┘
                   │
┌──────────────────▼───────────────────────┐
│     Behavior Definition Interface        │
│            ZTICKET_I.bdef                │
│  managed · strict(2) · etag UpdatedAt    │
└──────────────────┬───────────────────────┘
                   │
┌──────────────────▼───────────────────────┐
│     Handler Class ZBP_TICKET_I           │
│  Determinations · Validations · Actions  │
└──────────────────┬───────────────────────┘
                   │
┌──────────────────▼───────────────────────┐
│   CDS Projection View ZTICKET_C          │
│   UI annotations · Fiori Elements        │
└──────────────────┬───────────────────────┘
                   │
┌──────────────────▼───────────────────────┐
│   CDS Interface View ZTICKET_I           │
│   Root entity · Semantic annotations     │
└──────────────────┬───────────────────────┘
                   │
┌──────────────────▼───────────────────────┐
│         Table ZTICKETSAP                 │
│   DDIC · Domains · Data Elements         │
└──────────────────────────────────────────┘
```

---

## RAP Pattern — Managed

This project uses the **RAP managed scenario**, meaning the framework handles all CRUD persistence automatically.
Only custom logic (validations, determinations, actions) is implemented manually in the handler class.

---

## Object Dependency Order

| # | Object | Type | Depends on |
|---|---|---|---|
| 1 | `ZDTF_STATUS` | Domain | — |
| 2 | `ZDTF_PRIORITY` | Domain | — |
| 3 | `ZDTF_STATUS_DE` | Data Element | ZDTF_STATUS |
| 4 | `ZDTF_PRIORITY_DE` | Data Element | ZDTF_PRIORITY |
| 5 | `ZTICKETSAP` | Table | Data Elements |
| 6 | `ZTICKET_I` | CDS Interface View | ZTICKETSAP |
| 7 | `ZTICKET_I` | Behavior Definition | CDS Interface |
| 8 | `ZBP_TICKET_I` | Handler Class | BDEF Interface |
| 9 | `ZTICKET_C` | CDS Projection View | CDS Interface |
| 10 | `ZTICKET_C` | Behavior Definition Projection | BDEF Interface + CDS Projection |
| 11 | `ZTICKET_SRV_DEF` | Service Definition | CDS Projection |
| 12 | `ZTICKET_SRV_BIND` | Service Binding | Service Definition |

---

## Business Logic Summary

### Determinations
| Name | Trigger | Effect |
|---|---|---|
| `setTimestamps` | create | Sets `CreatedAt` + `UpdatedAt` |
| `setUpdateTimestamp` | modify (7 fields) | Refreshes `UpdatedAt` |

### Validations
| Name | Trigger | Rule |
|---|---|---|
| `validateStatus` | save | Status must be in domain (NW/IP/OH/RS/CL) |
| `checkClosingComment` | save | `ClosingComment` required when `Status = CL` |

### Actions
| Name | Parameter | Effect |
|---|---|---|
| `assignTicket` | `AssignedTo: UNAME` | Sets assignee, auto-sets status to IP if NW |
| `closeTicket` | `ClosingComment: CHAR255` | Sets status to CL, stores comment |
| `reopenTicket` | — | Resets status to NW, clears closing comment |

---

## Status Workflow

```
  [NW] ──assignTicket──▶ [IP] ──▶ [OH]
   ▲                               │
   │                               ▼
   └──reopenTicket────── [CL] ◀── [RS]
                          ▲
                    closeTicket
                  (comment required)
```

---

## Criticality Mapping (Fiori color-coding)

| Status | Value | Fiori Color |
|---|---|---|
| NW — New | 2 | Orange (Warning) |
| IP — In Progress | 5 | Blue (Info) |
| OH — On Hold | 0 | Grey (None) |
| RS — Resolved | 3 | Green (Success) |
| CL — Closed | 4 | Dark Grey |

| Priority | Value | Fiori Color |
|---|---|---|
| L — Low | 0 | Grey |
| N — Normal | 5 | Blue |
| H — High | 2 | Orange |
| C — Critical | 1 | Red (Error) |
