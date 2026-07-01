CLASS lhc_ticket DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS:
      get_instance_features      FOR INSTANCE FEATURES
        IMPORTING keys REQUEST requested_features FOR Ticket RESULT result,
      get_global_authorizations  FOR GLOBAL AUTHORIZATION
        IMPORTING REQUEST requested_authorizations FOR Ticket RESULT result,
      setCreationData            FOR DETERMINE ON MODIFY
        IMPORTING keys FOR Ticket~setCreationData,
      setUpdateTimestamp         FOR DETERMINE ON MODIFY
        IMPORTING keys FOR Ticket~setUpdateTimestamp,
      checkClosingComment        FOR VALIDATE ON SAVE
        IMPORTING keys FOR Ticket~checkClosingComment,
      closeTicket                FOR MODIFY
        IMPORTING keys FOR ACTION Ticket~closeTicket
        RESULT result,
      reopenTicket               FOR MODIFY
        IMPORTING keys FOR ACTION Ticket~reopenTicket
        RESULT result.
ENDCLASS.

CLASS lhc_ticket IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD setCreationData.
    MODIFY ENTITIES OF zticket_i IN LOCAL MODE
      ENTITY Ticket UPDATE FIELDS ( CreatedAt CreatedBy Status )
      WITH VALUE #( FOR key IN keys
        ( %tky      = key-%tky
          CreatedAt = cl_abap_context_info=>get_system_date( )
          CreatedBy = cl_abap_context_info=>get_user_alias( )
          Status    = 'OP' ) ).
  ENDMETHOD.

  METHOD setUpdateTimestamp.
    MODIFY ENTITIES OF zticket_i IN LOCAL MODE
      ENTITY Ticket UPDATE FIELDS ( UpdatedAt )
      WITH VALUE #( FOR key IN keys
        ( %tky      = key-%tky
          UpdatedAt = cl_abap_context_info=>get_system_date( ) ) ).
  ENDMETHOD.

  METHOD checkClosingComment.
    DATA lv_msg TYPE REF TO if_abap_behv_message.

    READ ENTITIES OF zticket_i IN LOCAL MODE
      ENTITY Ticket FIELDS ( Status ClosingComment )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_data).

    LOOP AT lt_data INTO DATA(ls).
      IF ls-Status = 'CL' AND ls-ClosingComment IS INITIAL.

        lv_msg = new_message_with_text(
                   severity = if_abap_behv_message=>severity-error
                   text     = 'Commentaire obligatoire pour cloturer le ticket' ).

        APPEND VALUE #( %tky = ls-%tky ) TO failed-ticket.
        APPEND VALUE #( %tky = ls-%tky %msg = lv_msg ) TO reported-ticket.

      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD closeTicket.
    MODIFY ENTITIES OF zticket_i IN LOCAL MODE
      ENTITY Ticket UPDATE FIELDS ( Status )
      WITH VALUE #( FOR key IN keys
        ( %tky   = key-%tky
          Status = 'CL' ) ).

    READ ENTITIES OF zticket_i IN LOCAL MODE
      ENTITY Ticket ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_data).

    result = VALUE #( FOR ls IN lt_data
      ( %tky   = ls-%tky
        %param = ls ) ).
  ENDMETHOD.

  METHOD reopenTicket.
    MODIFY ENTITIES OF zticket_i IN LOCAL MODE
      ENTITY Ticket UPDATE FIELDS ( Status )
      WITH VALUE #( FOR key IN keys
        ( %tky   = key-%tky
          Status = 'OP' ) ).

    READ ENTITIES OF zticket_i IN LOCAL MODE
      ENTITY Ticket ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_data).

    result = VALUE #( FOR ls IN lt_data
      ( %tky   = ls-%tky
        %param = ls ) ).
  ENDMETHOD.

ENDCLASS.
