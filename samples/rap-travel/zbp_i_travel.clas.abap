" =====================================================================
" zbp_i_travel.clas.abap  — 行为实现类（Behavior Pool）
" 与《RAP 手顺2 4.3/4.4》配套。激活 BDEF 后双击「implementation in
" class zbp_i_travel」超链接生成类壳，再把本文件内容粘贴进去。
"
" 文件分两部分：
"   1) 全局类壳（PUBLIC ABSTRACT FINAL FOR BEHAVIOR OF）
"   2) 局部类 lhc_travel —— 4 个方法：get_features / accepttravel /
"      rejecttravel / validatecustomer
" =====================================================================

CLASS zbp_i_travel DEFINITION PUBLIC ABSTRACT FINAL FOR BEHAVIOR OF z_i_travel.
ENDCLASS.

CLASS zbp_i_travel IMPLEMENTATION.
ENDCLASS.

" ---------------------------------------------------------------------
" 局部类 lhc_travel：业务逻辑都在这里
" ---------------------------------------------------------------------
CLASS lhc_travel DEFINITION INHERITING FROM cl_abap_behv_handler.
  PRIVATE SECTION.

    METHODS get_features FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR travel
      RESULT result.

    METHODS accepttravel FOR MODIFY
      IMPORTING keys FOR ACTION travel~AcceptTravel.

    METHODS rejecttravel FOR MODIFY
      IMPORTING keys FOR ACTION travel~RejectTravel.

    METHODS validatecustomer FOR VALIDATION ON SAVE
      IMPORTING keys FOR travel~validateCustomer.
ENDCLASS.

CLASS lhc_travel IMPLEMENTATION.

  " --- 4.4.1 控制按钮可用性 --------------------------------------
  " 「已拒绝」的旅行不能再批准，「已批准」的不能再拒绝。
  METHOD get_features.
    READ ENTITIES OF z_i_travel IN LOCAL MODE
      ENTITY travel
        FIELDS ( Status )
        WITH CORRESPONDING #( keys )
      RESULT DATA(travels)
      FAILED    DATA(failed).

    result = VALUE #( FOR travel IN travels
      LET status = travel-Status IN
      ( %tky                 = travel-%tky
        %action-AcceptTravel = COND #( WHEN status = if_abap_behv_status=>status_rejected
                                       THEN if_abap_behv=>fc-o-disabled
                                       ELSE if_abap_behv=>fc-o-enabled )
        %action-RejectTravel = COND #( WHEN status = if_abap_behv_status=>status_approved
                                       THEN if_abap_behv=>fc-o-disabled
                                       ELSE if_abap_behv=>fc-o-enabled ) ) ).
  ENDMETHOD.

  " --- 4.4.2 批准：用 EML 把状态更新为 A -------------------------
  METHOD accepttravel.
    MODIFY ENTITIES OF z_i_travel IN LOCAL MODE
      ENTITY travel
        UPDATE FIELDS ( Status )
          WITH VALUE #( FOR key IN keys ( TravelID = key-TravelID
                                          Status   = if_abap_behv_status=>status_approved ) )
      REPORTED DATA(rs)
      FAILED DATA(rf).

    reported = corresponding #( deep rs ).
    failed   = corresponding #( deep rf ).

    IF rf IS INITIAL.
      reported-travel = VALUE #(
        FOR row IN rs-travel
          ( %tky = row-%tky
            %msg = new_message_with_text(
              severity = if_abap_behv_message=>severity-success
              text     = '已批准' ) ) ).
    ENDIF.
  ENDMETHOD.

  " --- 拒绝：与 accepttravel 对称，状态改为 X --------------------
  " 教程只声明了本方法；实现按 accepttravel 的模式补全。
  METHOD rejecttravel.
    MODIFY ENTITIES OF z_i_travel IN LOCAL MODE
      ENTITY travel
        UPDATE FIELDS ( Status )
          WITH VALUE #( FOR key IN keys ( TravelID = key-TravelID
                                          Status   = if_abap_behv_status=>status_rejected ) )
      REPORTED DATA(rs)
      FAILED DATA(rf).

    reported = corresponding #( deep rs ).
    failed   = corresponding #( deep rf ).

    IF rf IS INITIAL.
      reported-travel = VALUE #(
        FOR row IN rs-travel
          ( %tky = row-%tky
            %msg = new_message_with_text(
              severity = if_abap_behv_message=>severity-success
              text     = '已拒绝' ) ) ).
    ENDIF.
  ENDMETHOD.

  " --- 4.4.3 保存校验：CustomerID 必须在 zcustomer 中存在 -------
  METHOD validatecustomer.
    READ ENTITIES OF z_i_travel IN LOCAL MODE
      ENTITY travel
        FIELDS ( CustomerID )
        WITH CORRESPONDING #( keys )
      RESULT DATA(travels).

    IF travels IS NOT INITIAL.
      SELECT customerid FROM zcustomer
             FOR ALL ENTRIES IN @travels
             WHERE customerid = @travels-customerid
             INTO TABLE @DATA(valid_ids).

      LOOP AT travels INTO DATA(travel).
        IF NOT line_exists( valid_ids[ customerid = travel-customerid ] ).
          APPEND VALUE #( %tky = travel-%tky ) TO failed-travel.
          APPEND VALUE #( %tky = travel-%tky
                          %msg = new_message_with_text(
                            severity = if_abap_behv_message=>severity-error
                            text     = |客户 { travel-CustomerID } 不存在| ) )
            TO reported-travel.
        ENDIF.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
