-- ============================================================
-- 03 种子数据：5 分类 / 4 作者 / 10 本书
-- 值与站点 CAP（Node / Java）路线的 CSV 种子数据完全一致
-- ============================================================

-- 分类 GENRES（ID 201–205）
INSERT INTO BOOKSHOP.GENRES (ID, NAME, DESCR) VALUES
  (201, 'Fiction',         '虚构类文学作品'),
  (202, 'Non-Fiction',     '非虚构类作品'),
  (203, 'Science Fiction', '科幻类'),
  (204, 'Romance',         '爱情与浪漫类'),
  (205, 'Essay',           '随笔散文');

-- 作者 AUTHORS（ID 101–104）
INSERT INTO BOOKSHOP.AUTHORS (ID, NAME, DATE_OF_BIRTH, PLACE_OF_BIRTH) VALUES
  (101, 'Emily Brontë',    '1818-07-30', 'Thornton England'),
  (102, 'George Orwell',   '1903-06-25', 'Motihari India'),
  (103, 'Jane Austen',     '1775-12-16', 'Steventon England'),
  (104, 'Haruki Murakami', '1949-01-12', 'Kyoto Japan');

-- 图书 BOOKS（ID 1–10，含库存 0 / 100 / 333 边界值）
INSERT INTO BOOKSHOP.BOOKS (ID, TITLE, DESCR, AUTHOR_ID, GENRE_ID, STOCK, PRICE, CURRENCY) VALUES
  (1,  'Wuthering Heights',   '哥特小说代表作',   101, 201, 12,  11.11, 'EUR'),
  (2,  'Jane Eyre',           '夏洛蒂·勃朗特经典', 101, 201, 11,  22.00, 'EUR'),
  (3,  'The Raven',           '爱伦坡诗作',       102, 203, 333, 8.00,  'EUR'),
  (4,  'Eleonora',            '爱伦坡短篇',       102, 203, 0,   7.99,  'EUR'),
  (5,  'Catweazle',           '幻想小说',         103, 204, 5,   19.99, 'EUR'),
  (6,  'Pride and Prejudice', '简·奥斯汀代表作',   103, 204, 10,  24.99, 'EUR'),
  (7,  '1Q84',                '村上春树长篇',      104, 201, 100, 33.00, 'EUR'),
  (8,  'Kafka on the Shore',  '村上春树长篇',      104, 201, 42,  32.99, 'EUR'),
  (9,  'Dandelion Wine',      '怀旧随笔',         102, 202, 8,   27.50, 'EUR'),
  (10, 'Norwegian Wood',      '村上春树爱情小说',  104, 204, 150, 35.50, 'EUR');
