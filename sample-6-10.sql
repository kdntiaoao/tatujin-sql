-- 演習問題6-①：歯抜けを探す——改良版

CREATE TABLE SeqTbl (
  seq INTEGER PRIMARY KEY,
  name VARCHAR(16) NOT NULL
);

INSERT INTO SeqTbl VALUES (1, 'ディック');
INSERT INTO SeqTbl VALUES (2, 'アン');
INSERT INTO SeqTbl VALUES (3, 'ライル');
INSERT INTO SeqTbl VALUES (5, 'カー');
INSERT INTO SeqTbl VALUES (6, 'マリー');
INSERT INTO SeqTbl VALUES (8, 'ベン');

SELECT
  CASE
    WHEN COUNT(*) != MAX(seq) THEN '歯抜けあり'
    ELSE '歯抜けなし'
  END AS gap
FROM SeqTbl;

CREATE TABLE SeqTblWithNoGaps (
  seq INTEGER PRIMARY KEY,
  name VARCHAR(16) NOT NULL
);

INSERT INTO SeqTbl VALUES (1, 'ディック');
INSERT INTO SeqTbl VALUES (2, 'アン');
INSERT INTO SeqTbl VALUES (3, 'ライル');
INSERT INTO SeqTbl VALUES (4, 'カー');
INSERT INTO SeqTbl VALUES (5, 'マリー');
INSERT INTO SeqTbl VALUES (6, 'ベン');

SELECT
  CASE
    WHEN COUNT(*) != MAX(seq) THEN '歯抜けあり'
    ELSE '歯抜けなし'
  END AS gap
FROM SeqTblWithNoGaps;

-- 演習問題6-②：特性関数の練習

CREATE TABLE Students
(
  student_id INTEGER PRIMARY KEY,
  dpt VARCHAR(16) NOT NULL,
  sbmt_date DATE
);

INSERT INTO Students VALUES (100, '理学部', '2018-10-10');
INSERT INTO Students VALUES (101, '理学部', '2018-09-22');
INSERT INTO Students VALUES (102, '文学部', NULL);
INSERT INTO Students VALUES (103, '文学部', '2018-09-10');
INSERT INTO Students VALUES (200, '文学部', '2018-09-22');
INSERT INTO Students VALUES (201, '工学部', NULL);
INSERT INTO Students VALUES (202, '経済学部', '2018-09-25');

SELECT dpt FROM Students
GROUP BY dpt
HAVING COUNT(*) = COUNT(sbmt_date) AND MIN(sbmt_date) >= '2018-09-01' AND MAX(sbmt_date) < '2018-10-01';

SELECT dpt FROM Students
WHERE sbmt_date IS NOT NULL AND sbmt_date >= '2018-09-01' AND sbmt_date < '2018-10-01';

-- 演習問題6-③：関係除算の改良

CREATE TABLE Items
(item VARCHAR(16) PRIMARY KEY);

CREATE TABLE ShopItems
(
  shop VARCHAR(16),
  item VARCHAR(16),
  PRIMARY KEY (shop, item)
);

INSERT INTO Items VALUES ('ビール');
INSERT INTO Items VALUES ('紙オムツ');
INSERT INTO Items VALUES ('自転車');

INSERT INTO ShopItems VALUES ('仙台', 'ビール');
INSERT INTO ShopItems VALUES ('仙台', '紙オムツ');
INSERT INTO ShopItems VALUES ('仙台', '自転車');
INSERT INTO ShopItems VALUES ('仙台', 'カーテン');
INSERT INTO ShopItems VALUES ('東京', 'ビール');
INSERT INTO ShopItems VALUES ('東京', '紙オムツ');
INSERT INTO ShopItems VALUES ('東京', '自転車');
INSERT INTO ShopItems VALUES ('大阪', 'テレビ');
INSERT INTO ShopItems VALUES ('大阪', '紙オムツ');
INSERT INTO ShopItems VALUES ('大阪', '自転車');

SELECT
  shop,
  COUNT(shop) AS my_item_cnt,
  ((SELECT COUNT(item) FROM Items) - COUNT(shop)) AS diff_cnt
FROM ShopItems
WHERE item IN (SELECT item FROM Items)
GROUP BY shop;
