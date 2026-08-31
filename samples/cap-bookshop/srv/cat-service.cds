// srv/cat-service.cds —— 服务定义（服务层）
// Books 放开写能力（供第7章测试场景练习 OData 增删改）；
// Authors / Genres / Orders 保持只读。
// submitOrder 参数声明为 Integer，与第7章 curl 载荷 {"book":1,"quantity":5} 一致。
// stockOf 为自定义 Function（GET 只读），按 ID 查库存。
using { sap.capire.bookshop as my } from '../db/schema';

service CatalogService {
  entity Books   as projection on my.Books;
  @readonly entity Authors as projection on my.Authors;
  @readonly entity Genres  as projection on my.Genres;
  @readonly entity Orders  as projection on my.Orders;

  action   submitOrder(book: Integer, quantity: Integer) returns Integer;
  function stockOf(book: Integer) returns Integer;
}
