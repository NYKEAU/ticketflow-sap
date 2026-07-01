@EndUserText.label: 'Support Ticket'
@AccessControl.authorizationCheck: #NOT_REQUIRED

@UI.headerInfo: {
  typeName: 'Ticket',
  typeNamePlural: 'Tickets',
  title: { type: #STANDARD, value: 'Title' },
  description: { type: #STANDARD, value: 'Status' }
}

define root view entity ZTICKET_I
  as select from zticketsap
{
  @UI.facet: [
    { id: 'GeneralInfo', type: #IDENTIFICATION_REFERENCE,
      label: 'Informations générales', position: 10 },
    { id: 'Details', type: #FIELDGROUP_REFERENCE,
      targetQualifier: 'Details',
      label: 'Détails', position: 20 }
  ]

  @UI.hidden: true
  key ticket_id   as TicketId,

  @UI.lineItem:       [{ position: 10, label: 'Titre' }]
  @UI.identification: [{ position: 10 }]
  @UI.selectionField: [{ position: 10 }]
  title           as Title,

  @UI.lineItem:       [{ position: 20, label: 'Statut' }]
  @UI.identification: [{ position: 20 }]
  @UI.selectionField: [{ position: 20 }]
  status          as Status,

  @UI.lineItem:       [{ position: 30, label: 'Priorité' }]
  @UI.identification: [{ position: 30 }]
  @UI.selectionField: [{ position: 30 }]
  priority        as Priority,

  @UI.lineItem:       [{ position: 40, label: 'Catégorie' }]
  @UI.fieldGroup:     [{ qualifier: 'Details', position: 10, label: 'Catégorie' }]
  category        as Category,

  @UI.lineItem:       [{ position: 50, label: 'Assigné à' }]
  @UI.fieldGroup:     [{ qualifier: 'Details', position: 20, label: 'Assigné à' }]
  assigned_to     as AssignedTo,

  @UI.identification: [{ position: 40 }]
  @UI.multiLineText: true
  description     as Description,

  @UI.fieldGroup:     [{ qualifier: 'Details', position: 30, label: 'Commentaire clôture' }]
  closing_comment as ClosingComment,

  @UI.hidden: true
  created_at      as CreatedAt,

  @UI.hidden: true
  updated_at      as UpdatedAt,

  @UI.hidden: true
  created_by      as CreatedBy
}
