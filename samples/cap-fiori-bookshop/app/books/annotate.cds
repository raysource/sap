// app/books/annotate.cds —— Fiori Elements List Report + Object Page 注解（F2–F4 完整版）
// 列表定制（F2）+ 对象页 Facets（F3）+ 库存状态徽标（F4，criticality 由服务端 cat-service.js 计算）。
using CatalogService as service from '../../srv/cat-service';

annotate service.Books with @(
  UI : {
    HeaderInfo : {
      TypeName : 'Book', TypeNamePlural : 'Books',
      Title : { Value : 'title' },
      Description : { Value : 'author.name' }
    },
    // —— F2 列表页：筛选栏字段 + 表格列（库存列带状态徽标）——
    SelectionFields : ['title', 'author.name', 'price'],
    LineItem : [
      { Value : 'title', Label : '书名' },
      { Value : 'author.name', Label : '作者' },
      { Value : 'genre.name', Label : '分类' },
      { Value : 'price', Label : '价格' },
      { Value : 'stock', Label : '库存', Criticality : 'criticality' }
    ],
    // —— F3 对象页：Facet 区块布局（基本信息 / 订单 / 补充信息）——
    Facets : [
      { $Type : 'UI.ReferenceFacet', Target : '@UI.FieldGroup#general', Label : '基本信息' },
      { $Type : 'UI.ReferenceFacet', Target : '@UI.LineItem#orders',    Label : '订单' },
      { $Type : 'UI.ReferenceFacet', Target : '@UI.FieldGroup#more',    Label : '补充信息' }
    ],
    FieldGroup #general : {
      Data : [
        { Value : 'title', Label : '书名' },
        { Value : 'author.name', Label : '作者' },
        { Value : 'genre.name', Label : '分类' },
        { Value : 'descr', Label : '描述' }
      ]
    },
    // —— F4 补充信息区块：库存用 DataPoint 渲染成状态徽标 ——
    FieldGroup #more : {
      Data : [
        { Value : 'price', Label : '价格' },
        { Value : 'currency', Label : '币种' },
        { DataPoint : '@UI.DataPoint#stock', Label : '库存状态' }
      ]
    },
    LineItem #orders : [
      { Value : 'ID', Label : '订单号' },
      { Value : 'quantity', Label : '数量' },
      { Value : 'createdAt', Label : '下单时间' }
    ]
  },
  UI.DataPoint #stock : {
    Value : 'stock',
    Criticality : 'criticality',
    CriticalityLabels : [
      { Criticality : 3, Text : '售罄' },
      { Criticality : 2, Text : '紧张' },
      { Criticality : 1, Text : '充足' }
    ]
  },
  Common.SemanticKey : ['ID']
);

// 对象页「订单」子表渲染的是 Orders 实体，需要它自己的列注解
annotate service.Orders with @(
  UI.LineItem : [
    { Value : 'ID', Label : '订单号' },
    { Value : 'quantity', Label : '数量' },
    { Value : 'createdAt', Label : '下单时间' }
  ]
);
