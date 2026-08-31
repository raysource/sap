// db/schema.cds —— 领域模型（数据层）
// 与《CAP 培训》手顺2（第4章）+ 手顺3（第5章）内容一致：
// Genres / Authors / Books 三个实体 + Orders（cuid UUID 主键）
namespace sap.capire.bookshop;

using { cuid } from '@sap/cds/common';

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

entity Orders : cuid {
  book     : Association to Books;
  quantity : Integer;
  total    : Decimal(9,2);
  status   : String(16) default 'pending';
}
