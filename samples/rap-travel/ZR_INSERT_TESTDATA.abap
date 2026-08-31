" =====================================================================
" ZR_INSERT_TESTDATA.abap — 批量插入测试数据（与《RAP 手顺 7.4 方式二》配套）
" 在 ADT 新建 ABAP Program（名称 ZR_INSERT_TESTDATA）后粘贴本文件，F8 运行。
" 一次性写入：ZTRAVEL 7 条 + ZTRAVEL_BOOKING 6 条，并清空旧数据。
" =====================================================================

REPORT zr_insert_testdata.

DATA: lt_travel  TYPE TABLE OF ztravel,
      lt_booking TYPE TABLE OF ztravel_booking.

* 清空既有数据（可选，按需执行）
DELETE FROM: ztravel, ztravel_booking.

* --- 主表：7 条旅行 ---
lt_travel = VALUE #(
  ( travelid = 1  agencyid = 1  customerid = 1  begindate = '20260301'  enddate = '20260310'
    bookingfee = '100.00'  totalprice = '2500.00'  currencycode = 'EUR'  status = 'A'
    description = '巴黎商务考察'  createdby = 'DEMO'  createdat = '20260823120000'
    lastchangedby = 'DEMO'  lastchangedat = '20260823120000' )
  ( travelid = 2  agencyid = 2  customerid = 2  begindate = '20260405'  enddate = '20260412'
    bookingfee = '80.00'   totalprice = '1800.00'  currencycode = 'EUR'  status = 'O'
    description = '法兰克福展会'  createdby = 'DEMO'  createdat = '20260823120000'
    lastchangedby = 'DEMO'  lastchangedat = '20260823120000' )
  ( travelid = 3  agencyid = 1  customerid = 3  begindate = '20260510'  enddate = '20260520'
    bookingfee = '120.00'  totalprice = '3200.00'  currencycode = 'EUR'  status = 'N'
    description = '京都赏樱之旅'  createdby = 'DEMO'  createdat = '20260823120000'
    lastchangedby = 'DEMO'  lastchangedat = '20260823120000' )
  ( travelid = 4  agencyid = 3  customerid = 4  begindate = '20260601'  enddate = '20260608'
    bookingfee = '60.00'   totalprice = '950.00'   currencycode = 'EUR'  status = 'X'
    description = '里斯本周末'  createdby = 'DEMO'  createdat = '20260823120000'
    lastchangedby = 'DEMO'  lastchangedat = '20260823120000' )
  ( travelid = 5  agencyid = 2  customerid = 1  begindate = '20260715'  enddate = '20260725'
    bookingfee = '150.00'  totalprice = '4100.00'  currencycode = 'EUR'  status = 'A'
    description = '伦敦商务考察'  createdby = 'DEMO'  createdat = '20260823120000'
    lastchangedby = 'DEMO'  lastchangedat = '20260823120000' )
  ( travelid = 6  agencyid = 3  customerid = 2  begindate = '20260801'  enddate = '20260807'
    bookingfee = '90.00'   totalprice = '1280.00'  currencycode = 'EUR'  status = 'O'
    description = '苏黎世短途'  createdby = 'DEMO'  createdat = '20260823120000'
    lastchangedby = 'DEMO'  lastchangedat = '20260823120000' )
  ( travelid = 7  agencyid = 1  customerid = 3  begindate = '20260915'  enddate = '20260925'
    bookingfee = '200.00'  totalprice = '5600.00'  currencycode = 'EUR'  status = 'N'
    description = '十一黄金周东京之旅'  createdby = 'DEMO'  createdat = '20260823120000'
    lastchangedby = 'DEMO'  lastchangedat = '20260823120000' ) ).

INSERT ztravel FROM TABLE @lt_travel.

* --- 子表：6 条预订 ---
lt_booking = VALUE #(
  ( travelid = 1  bookingid = 1  bookingdate = '20260301'  customerid = 1
    carrierid = 'LH'  connectionid = '0400'  flightdate = '20260301'
    flightprice = '480.00'  currencycode = 'EUR'  bookingstatus = 'N' )
  ( travelid = 1  bookingid = 2  bookingdate = '20260301'  customerid = 1
    carrierid = 'LH'  connectionid = '0401'  flightdate = '20260310'
    flightprice = '520.00'  currencycode = 'EUR'  bookingstatus = 'N' )
  ( travelid = 2  bookingid = 1  bookingdate = '20260405'  customerid = 2
    carrierid = 'BA'  connectionid = '0300'  flightdate = '20260405'
    flightprice = '610.00'  currencycode = 'EUR'  bookingstatus = 'N' )
  ( travelid = 3  bookingid = 1  bookingdate = '20260510'  customerid = 3
    carrierid = 'AF'  connectionid = '0200'  flightdate = '20260510'
    flightprice = '730.00'  currencycode = 'EUR'  bookingstatus = 'N' )
  ( travelid = 5  bookingid = 1  bookingdate = '20260715'  customerid = 1
    carrierid = 'LH'  connectionid = '0400'  flightdate = '20260715'
    flightprice = '890.00'  currencycode = 'EUR'  bookingstatus = 'A' )
  ( travelid = 6  bookingid = 1  bookingdate = '20260801'  customerid = 2
    carrierid = 'EK'  connectionid = '0100'  flightdate = '20260801'
    flightprice = '410.00'  currencycode = 'EUR'  bookingstatus = 'O' ) ).

INSERT ztravel_booking FROM TABLE @lt_booking.

COMMIT WORK.
WRITE: / '插入完成：', lines( lt_travel ), '条旅行，', lines( lt_booking ), '条预订。'
