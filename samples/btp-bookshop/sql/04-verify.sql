-- ============================================================
-- 04 验证：联表查询 + 计数核对
-- 期望：Books 10 行 / Authors 4 行 / Genres 5 行
-- ============================================================

-- 4.1 联表查询：书 + 作者名 + 分类名（Java 三种模式用的同一条 SQL）
SELECT
  b.ID, b.TITLE,
  a.NAME AS AUTHOR,
  g.NAME AS GENRE,
  b.STOCK, b.PRICE, b.CURRENCY
FROM BOOKSHOP.BOOKS b
  JOIN BOOKSHOP.AUTHORS a ON a.ID = b.AUTHOR_ID
  JOIN BOOKSHOP.GENRES  g ON g.ID = b.GENRE_ID
ORDER BY b.ID;

-- 4.2 计数核对（期望 10 / 4 / 5）
SELECT 'BOOKS'   AS TBL, COUNT(*) AS CNT FROM BOOKSHOP.BOOKS
UNION ALL
SELECT 'AUTHORS', COUNT(*) FROM BOOKSHOP.AUTHORS
UNION ALL
SELECT 'GENRES',  COUNT(*) FROM BOOKSHOP.GENRES;
