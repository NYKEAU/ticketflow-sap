@EndUserText.label: 'Ticket interface view'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity ZTICKET_I
  as select from zticketsap as ticket
{
  key ticket.ticket_id                              as TicketId,
      ticket.title                                  as Title,
      ticket.description                            as Description,
      ticket.priority                               as Priority,
      ticket.status                                 as Status,
      ticket.category                               as Category,
      ticket.assigned_to                            as AssignedTo,
      @Semantics.systemDateTime.createdAt: true
      ticket.created_at                             as CreatedAt,
      @Semantics.systemDateTime.lastChangedAt: true
      ticket.updated_at                             as UpdatedAt,
      ticket.closing_comment                        as ClosingComment,
      @Semantics.user.createdBy: true
      ticket.created_by                             as CreatedBy,

      /* Virtual field: status criticality for UI coloring
         0 = none, 1 = red, 2 = orange, 3 = green, 4 = grey, 5 = blue */
      case ticket.status
        when 'NW' then 2
        when 'IP' then 5
        when 'OH' then 0
        when 'RS' then 3
        when 'CL' then 4
        else 0
      end                                           as StatusCriticality : abap.int1,

      /* Virtual field: priority criticality for UI coloring
         0 = none, 1 = red, 2 = orange, 5 = blue */
      case ticket.priority
        when 'L' then 0
        when 'N' then 5
        when 'H' then 2
        when 'C' then 1
        else 0
      end                                           as PriorityCriticality : abap.int1
}
