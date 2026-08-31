// app/books/annotate.cds —— Fiori Elements List Report + Object Page 注解（最终版）
// 对应《Fiori 培训》F2（列表定制）+ F3（对象页 Facets）。
// 路径规则：本文件位于 app/books/ 下，服务定义在工程根 srv/，故相对路径为 ../../srv/cat-service。
using CatalogService as service from '../../srv/cat-service';

annotate service.Books with @(
  UI : {
    HeaderInfo : {
      TypeName : 'Book', TypeNamePlural : 'Books',
      Title : { Value : 'title' },
      Description : { Value : 'author.name' }
    },
    // —— F2 列表页：筛选栏字段 + 表格列 ——
    SelectionFields : ['title', 'author.name', 'price'],
    LineItem : [
      { Value : 'title', Label : '书名' },
      { Value : 'author.name', Label : '作者' },
      { Value : 'genre.name', Label : '分类' },
      { Value : 'price', Label : '价格' },
      { Value : 'stock', Label : '库存' }
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
    FieldGroup #more : {
      Data : [
        { Value : 'price', Label : '价格' },
        { Value : 'currency', Label : '币种' },
        { Value : 'stock', Label : '库存' }
      ]
    },
    LineItem #orders : [
      { Value : 'ID', Label : '订单号' },
      { Value : 'quantity', Label : '数量' },
      { Value : 'createdAt', Label : '下单时间' }
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

// ===== F4 可选：库存状态徽标 =====
// 下面这组注解把 stock 渲染成「售罄 / 紧张 / 充足」徽标，但需要服务端返回
// criticality 字段（0–3），cap-bookshop 素材包未内置。启用步骤见 README.md。
// annotate service.Books with @(
//   UI.DataPoint #stock : {
//     Value : 'stock',
//     Criticality : 'criticality',
//     CriticalityLabels : [
//       { Criticality : 3, Text : '售罄' },
//       { Criticality : 2, Text : '紧张' },
//       { Criticality : 1, Text : '充足' }
//     ]
//   }
// );
