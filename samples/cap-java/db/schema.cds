// db/schema.cds —— 领域模型（数据层），Java 版与 Node 版完全一致
// 与《CAP for Java》手顺2（J4.2）一致；Java 路线未使用 Orders / cuid。
namespace sap.capire.bookshop;

entity Genres {
  key ID    : Integer;
      name  : String(64) @title : 'Genre';
      descr : String(512);
}

entity Authors {
  key ID          : Integer;
      name        : String(128) @title : 'Author';
      dateOfBirth : Date;
      placeOfBirth : String(128);
      books       : Association to many Books on books.author = $self;
}

entity Books {
  key ID     : Integer;
      title  : String(256) @title : 'Title';
      descr  : String(1024);
      author : Association to Authors;
      genre  : Association to Genres;
      stock  : Integer @title : 'Stock';
      price  : Decimal(9,2) @title : 'Price';
      currency : String(3);
}
