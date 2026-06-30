@Metadata.layer: #CORE
@UI.headerInfo: {
  typeName: 'Ticket',
  typeNamePlural: 'Tickets',
  title.value: 'Title',
  description.value: 'Status'
}
@UI.facet: [
  { id: 'GeneralInfo', type: #COLLECTION, label: 'Informations générales', position: 10 },
  { id: 'TicketDetails', type: #IDENTIFICATION_REFERENCE, parentId: 'GeneralInfo', position: 10 }
]
define root view entity ZTICKET_C
  as projection on ZTICKET_I
{
  @UI.lineItem: [
    { position: 10, importance: #LOW, label: 'ID' },
    { type: #FOR_ACTION, dataAction: 'assignTicket', label: 'Assigner', position: 80 },
    { type: #FOR_ACTION, dataAction: 'closeTicket', label: 'Clôturer', position: 90 },
    { type: #FOR_ACTION, dataAction: 'reopenTicket', label: 'Réouvrir', position: 100 }
  ]
  @UI.identification: [{ position: 10 }]
  key TicketId,

  @UI.lineItem: [{ position: 20, importance: #HIGH }]
  @UI.identification: [{ position: 20 }]
  @UI.selectionField: [{ position: 10 }]
  Title,

  @UI.identification: [{ position: 70, label: 'Description' }]
  Description,

  @UI.lineItem: [{ position: 40, importance: #HIGH, criticality: 'PriorityCriticality', label: 'Priorité' }]
  @UI.identification: [{ position: 40 }]
  @UI.selectionField: [{ position: 30 }]
  Priority,

  @UI.lineItem: [{ position: 30, importance: #HIGH, criticality: 'StatusCriticality', label: 'Statut' }]
  @UI.identification: [{ position: 30 }]
  @UI.selectionField: [{ position: 20 }]
  Status,

  @UI.lineItem: [{ position: 50, importance: #MEDIUM }]
  @UI.identification: [{ position: 50 }]
  @UI.selectionField: [{ position: 40 }]
  Category,

  @UI.lineItem: [{ position: 60, importance: #MEDIUM, label: 'Assigné à' }]
  @UI.identification: [{ position: 60 }]
  @UI.selectionField: [{ position: 50 }]
  AssignedTo,

  @UI.lineItem: [{ position: 70, importance: #LOW, label: 'Créé le' }]
  @UI.identification: [{ position: 90 }]
  CreatedAt,

  @UI.identification: [{ position: 100, label: 'Mis à jour le' }]
  UpdatedAt,

  @UI.identification: [{ position: 80, label: 'Commentaire de clôture' }]
  ClosingComment,

  @UI.identification: [{ position: 110, label: 'Créé par' }]
  CreatedBy,

  @UI.hidden: true
  StatusCriticality,

  @UI.hidden: true
  PriorityCriticality
}
