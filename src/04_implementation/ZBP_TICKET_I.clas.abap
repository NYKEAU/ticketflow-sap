CLASS zbp_ticket_i DEFINITION PUBLIC ABSTRACT FINAL FOR BEHAVIOR OF zticket_i.
ENDCLASS.

CLASS zbp_ticket_i IMPLEMENTATION.
ENDCLASS.


CLASS lhc_ticket DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS setTimestamps FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Ticket~setTimestamps.

    METHODS setUpdateTimestamp FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Ticket~setUpdateTimestamp.

    METHODS validateStatus FOR VALIDATE ON SAVE
      IMPORTING keys FOR Ticket~validateStatus.

    METHODS checkClosingComment FOR VALIDATE ON SAVE
      IMPORTING keys FOR Ticket~checkClosingComment.

    METHODS assignTicket FOR MODIFY
      IMPORTING keys FOR ACTION Ticket~assignTicket RESULT result.

    METHODS closeTicket FOR MODIFY
      IMPORTING keys FOR ACTION Ticket~closeTicket RESULT result.

    METHODS reopenTicket FOR MODIFY
      IMPORTING keys FOR ACTION Ticket~reopenTicket RESULT result.

ENDCLASS.


CLASS lhc_ticket IMPLEMENTATION.

  METHOD setTimestamps.
    " Fill creation and last-change timestamps on create
    MODIFY ENTITIES OF ZTICKET_I IN LOCAL MODE
      ENTITY Ticket
        UPDATE FIELDS ( CreatedAt UpdatedAt )
        WITH VALUE #( FOR ls_key IN keys
                      ( %tky      = ls_key-%tky
                        CreatedAt = utclong_current( )
                        UpdatedAt = utclong_current( ) ) ).
  ENDMETHOD.


  METHOD setUpdateTimestamp.
    " Refresh last-change timestamp when tracked fields are modified
    MODIFY ENTITIES OF ZTICKET_I IN LOCAL MODE
      ENTITY Ticket
        UPDATE FIELDS ( UpdatedAt )
        WITH VALUE #( FOR ls_key IN keys
                      ( %tky      = ls_key-%tky
                        UpdatedAt = utclong_current( ) ) ).
  ENDMETHOD.


  METHOD validateStatus.
    READ ENTITIES OF ZTICKET_I IN LOCAL MODE
      ENTITY Ticket
        FIELDS ( Status )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_tickets).

    LOOP AT lt_tickets INTO DATA(ls_ticket).
      IF NOT ( ls_ticket-Status = 'NW' OR ls_ticket-Status = 'IP'
            OR ls_ticket-Status = 'OH' OR ls_ticket-Status = 'RS'
            OR ls_ticket-Status = 'CL' ).
        APPEND VALUE #( %tky = ls_ticket-%tky ) TO failed-ticket.
        APPEND VALUE #( %tky     = ls_ticket-%tky
                        %msg     = new_message_with_text(
                                     severity = if_abap_behv_message=>severity-error
                                     text     = |Invalid status '{ ls_ticket-Status }'.|
                                             && ' Valid values are: NW, IP, OH, RS, CL.' )
                        %element-Status = if_abap_behv=>mk-on )
               TO reported-ticket.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.


  METHOD checkClosingComment.
    READ ENTITIES OF ZTICKET_I IN LOCAL MODE
      ENTITY Ticket
        FIELDS ( Status ClosingComment )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_tickets).

    LOOP AT lt_tickets INTO DATA(ls_ticket).
      IF ls_ticket-Status = 'CL' AND ls_ticket-ClosingComment IS INITIAL.
        APPEND VALUE #( %tky = ls_ticket-%tky ) TO failed-ticket.
        APPEND VALUE #( %tky     = ls_ticket-%tky
                        %msg     = new_message_with_text(
                                     severity = if_abap_behv_message=>severity-error
                                     text     = 'A closing comment is required to close a ticket.' )
                        %element-ClosingComment = if_abap_behv=>mk-on )
               TO reported-ticket.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.


  METHOD assignTicket.
    " Read current state to know the existing Status
    READ ENTITIES OF ZTICKET_I IN LOCAL MODE
      ENTITY Ticket
        FIELDS ( Status )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_tickets).

    LOOP AT keys INTO DATA(ls_key).
      DATA(lv_assigned_to) = ls_key-%param-AssignedTo.
      DATA(lv_current_status) = lt_tickets[ %tky = ls_key-%tky ]-Status.

      DATA(lv_new_status) = COND #( WHEN lv_current_status = 'NW'
                                    THEN 'IP'
                                    ELSE lv_current_status ).

      MODIFY ENTITIES OF ZTICKET_I IN LOCAL MODE
        ENTITY Ticket
          UPDATE FIELDS ( AssignedTo Status )
          WITH VALUE #( ( %tky       = ls_key-%tky
                          AssignedTo = lv_assigned_to
                          Status     = lv_new_status ) ).
    ENDLOOP.

    " Return updated instances as result ($self)
    READ ENTITIES OF ZTICKET_I IN LOCAL MODE
      ENTITY Ticket
        ALL FIELDS
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_result).

    result = VALUE #( FOR ls_result IN lt_result
                      ( %tky   = ls_result-%tky
                        %param = CORRESPONDING #( ls_result ) ) ).
  ENDMETHOD.


  METHOD closeTicket.
    LOOP AT keys INTO DATA(ls_key).
      DATA(lv_comment) = ls_key-%param-ClosingComment.

      " Defense-in-depth: reject empty comment (validation also covers this)
      IF lv_comment IS INITIAL.
        APPEND VALUE #( %tky = ls_key-%tky ) TO failed-ticket.
        APPEND VALUE #( %tky     = ls_key-%tky
                        %msg     = new_message_with_text(
                                     severity = if_abap_behv_message=>severity-error
                                     text     = 'A closing comment is required to close a ticket.' )
                        %element-ClosingComment = if_abap_behv=>mk-on )
               TO reported-ticket.
        CONTINUE.
      ENDIF.

      MODIFY ENTITIES OF ZTICKET_I IN LOCAL MODE
        ENTITY Ticket
          UPDATE FIELDS ( Status ClosingComment )
          WITH VALUE #( ( %tky           = ls_key-%tky
                          Status         = 'CL'
                          ClosingComment = lv_comment ) ).
    ENDLOOP.

    " Return updated instances ($self), skipping any that failed
    READ ENTITIES OF ZTICKET_I IN LOCAL MODE
      ENTITY Ticket
        ALL FIELDS
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_result).

    result = VALUE #( FOR ls_result IN lt_result
                      ( %tky   = ls_result-%tky
                        %param = CORRESPONDING #( ls_result ) ) ).
  ENDMETHOD.


  METHOD reopenTicket.
    " Read current state to filter only closed tickets
    READ ENTITIES OF ZTICKET_I IN LOCAL MODE
      ENTITY Ticket
        FIELDS ( Status )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_tickets).

    LOOP AT lt_tickets INTO DATA(ls_ticket) WHERE Status = 'CL'.
      MODIFY ENTITIES OF ZTICKET_I IN LOCAL MODE
        ENTITY Ticket
          UPDATE FIELDS ( Status ClosingComment )
          WITH VALUE #( ( %tky           = ls_ticket-%tky
                          Status         = 'NW'
                          ClosingComment = '' ) ).
    ENDLOOP.

    " Return updated instances ($self)
    READ ENTITIES OF ZTICKET_I IN LOCAL MODE
      ENTITY Ticket
        ALL FIELDS
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_result).

    result = VALUE #( FOR ls_result IN lt_result
                      ( %tky   = ls_result-%tky
                        %param = CORRESPONDING #( ls_result ) ) ).
  ENDMETHOD.

ENDCLASS.
