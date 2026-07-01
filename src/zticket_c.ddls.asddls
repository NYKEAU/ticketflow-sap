@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Ticket Consumption View'
@Metadata.allowExtensions: true
define root view entity ZTICKET_C
  provider contract transactional_query
  as projection on ZTICKET_I
{
  key TicketId,
      Title,
      Description,
      Priority,
      Status,
      Category,
      AssignedTo,
      CreatedAt,
      UpdatedAt,
      ClosingComment,
      CreatedBy
}
