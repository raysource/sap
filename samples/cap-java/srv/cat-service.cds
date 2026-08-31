// srv/cat-service.cds —— 服务定义（服务层），Java 版
// 与《CAP for Java》手顺2（J4.2）一致：
// Books 可写（J6 练习 OData 增删改）；自定义 Action submitOrder（J5 写处理器）。
using { sap.capire.bookshop as my } from '../db/schema';

service CatalogService {
  entity Books   as projection on my.Books;
  entity Authors as projection on my.Authors;
  entity Genres  as projection on my.Genres;

  action submitOrder(book : Integer, quantity : Integer);   // 提交订单，扣减库存
}
