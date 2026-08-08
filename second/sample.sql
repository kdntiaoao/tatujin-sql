-- 1-1
SELECT
  key,
  x,
  y,
  z
FROM Greatests;

SELECT
  key,
  CASE WHEN x > y THEN x ELSE y END AS greatest
FROM Greatests;

SELECT
  key,
  CASE
    WHEN x > y AND x > z THEN x
    WHEN y > z THEN y
    ELSE z
  END AS greatest
FROM Greatests;


SELECT
  pref_name,
  sex,
  population
FROM PopTbl2;

SELECT
  CASE WHEN sex = '1' THEN '男' ELSE '女' END AS 性別,
  SUM(population) AS 全国,
  SUM(CASE WHEN pref_name = '徳島' THEN population ELSE 0 END) AS 徳島,
  SUM(CASE WHEN pref_name = '香川' THEN population ELSE 0 END) AS 香川,
  SUM(CASE WHEN pref_name = '愛媛' THEN population ELSE 0 END) AS 愛媛,
  SUM(CASE WHEN pref_name = '高知' THEN population ELSE 0 END) AS 高知,
  SUM(CASE WHEN pref_name IN ('徳島', '香川', '愛媛', '高知') THEN population ELSE 0 END) AS 四国
FROM PopTbl2
GROUP BY sex;


SELECT
  key,
  x,
  y,
  z
FROM Greatests
ORDER BY key;

SELECT
  key,
  x,
  y,
  z,
  CASE WHEN key = 'A' THEN 2 WHEN key = 'B' THEN 1 WHEN key = 'C' THEN 4 ELSE 3 END AS sort_num
FROM Greatests
ORDER BY CASE WHEN key = 'A' THEN 2 WHEN key = 'B' THEN 1 WHEN key = 'C' THEN 4 ELSE 3 END;

-- 1-3

CREATE TABLE Addresses (
  name VARCHAR(100) PRIMARY KEY,
  family_id INT NOT NULL,
  address VARCHAR(255) NOT NULL
);
INSERT INTO Addresses (name, family_id, address) VALUES
('前田義明', 100, '東京都港区虎ノ門 3-2-29'),
('前田由美', 100, '東京都港区虎ノ門 3-2-92'),
('加藤茶', 200, '東京都新宿区西新宿 2-8-1'),
('加藤勝', 200, '東京都新宿区西新宿 2-8-1'),
('ホームズ', 300, 'ベーカー街 221B'),
('ワトソン', 400, 'ベーカー街 221B');

SELECT DISTINCT
  A1.name,
  A1.family_id,
  A1.address
FROM Addresses A1
INNER JOIN Addresses A2
  ON A1.family_id = A2.family_id AND A1.address <> A2.address;


CREATE TABLE Fruits (
  name VARCHAR(100) PRIMARY KEY,
  price INT NOT NULL
);
INSERT INTO Fruits (name, price) VALUES
('りんご', 50),
('みかん', 100),
('ぶどう', 50),
('スイカ', 80),
('レモン', 30),
('いちご', 100),
('バナナ', 100);

SELECT
  name,
  price
FROM Fruits;

SELECT DISTINCT
  P1.name,
  P1.price
FROM Fruits P1
INNER JOIN Fruits P2 ON P1.price = P2.price AND P1.name <> P2.name
ORDER BY P1.price;


SELECT
  name,
  price
FROM Products;

SELECT
  P1.name AS name_1,
  P2.name AS name_2
FROM Products P1
LEFT OUTER JOIN Products P2 ON P1.name >= P2.name;


CREATE TABLE ProductsWithDuplicates
(
  name VARCHAR(16) NOT NULL,
  price INTEGER NOT NULL
);

DELETE FROM ProductsWithDuplicates;
INSERT INTO ProductsWithDuplicates VALUES ('りんご', 50);
INSERT INTO ProductsWithDuplicates VALUES ('みかん', 100);
INSERT INTO ProductsWithDuplicates VALUES ('みかん', 100);
INSERT INTO ProductsWithDuplicates VALUES ('みかん', 100);
INSERT INTO ProductsWithDuplicates VALUES ('バナナ', 80);

SELECT
  name,
  price
FROM ProductsWithDuplicates;

SELECT
  name,
  ROW_NUMBER() OVER (PARTITION BY name ORDER BY price) AS row_num
FROM ProductsWithDuplicates;

-- 1-5

SELECT DISTINCT key
FROM ArrayTbl2 A1
WHERE NOT EXISTS (
  SELECT * FROM ArrayTbl2 A2
  WHERE A1.key = A2.key AND (A2.val IS NULL OR A2.val <> 1)
);

SELECT key FROM ArrayTbl2
GROUP BY key
HAVING COUNT(*) = SUM(
  CASE WHEN val = 1 THEN 1 ELSE 0 END
);


SELECT
  P1.project_id,
  P1.step_nbr,
  P1.status
FROM Projects P1
WHERE P1.status = ALL(
  SELECT P2.status FROM Projects P2
  WHERE
    P1.project_id = P2.project_id
    AND P2.status = CASE WHEN P2.step_nbr <= 1 THEN '完了' ELSE '待機' END
);


SELECT N1.num FROM Numbers N1
WHERE
  N1.num <> 1
  AND NOT EXISTS (
    SELECT * FROM Numbers N2
    WHERE N2.num <> 1 AND N1.num > N2.num AND N1.num % N2.num = 0
  )
ORDER BY N1.num
LIMIT 5;

-- 1-6

CREATE TABLE SeqTblWithNoGaps (
  seq INTEGER PRIMARY KEY,
  name VARCHAR(16) NOT NULL
);

INSERT INTO SeqTblWithNoGaps VALUES (1, 'ディック');
INSERT INTO SeqTblWithNoGaps VALUES (2, 'アン');
INSERT INTO SeqTblWithNoGaps VALUES (3, 'ライル');
INSERT INTO SeqTblWithNoGaps VALUES (4, 'カー');
INSERT INTO SeqTblWithNoGaps VALUES (5, 'マリー');
INSERT INTO SeqTblWithNoGaps VALUES (6, 'ベン');

SELECT
  seq,
  name
FROM SeqTblWithNoGaps;

SELECT (
  CASE WHEN COUNT(*) = MAX(seq) THEN '歯抜けなし' ELSE '歯抜けあり' END
) FROM SeqTbl;

SELECT (
  CASE WHEN COUNT(*) = MAX(seq) THEN '歯抜けなし' ELSE '歯抜けあり' END
) FROM SeqTblWithNoGaps;


SELECT item FROM Items;
SELECT
  shop,
  item
FROM ShopItems;

SELECT
  SI.shop,
  COUNT(SI.item) AS my_item_cnt,
  ((SELECT COUNT(item) FROM Items) - COUNT(SI.item)) AS diff_cnt
FROM ShopItems SI INNER JOIN Items I ON SI.item = I.item
GROUP BY SI.shop;


-- 1-7

SELECT
  prc_date,
  prc_amt
FROM Accounts;

SELECT
  prc_date,
  prc_amt,
  AVG(prc_amt) OVER (ORDER BY prc_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)
FROM Accounts;

SELECT
  A2.prc_date,
  A2.prc_amt,
  (
    SELECT AVG(
      TMP.prc_amt) FROM (
      SELECT
        A1.prc_date,
        A1.prc_amt
      FROM Accounts A1
      WHERE A2.prc_date >= A1.prc_date
      ORDER BY A1.prc_date DESC
      LIMIT 3
    ) TMP
  )
FROM Accounts A2
ORDER BY A2.prc_date;


SELECT
  prc_date,
  prc_amt,
  CASE WHEN cnt >= 3 THEN avg END
FROM (SELECT
  prc_date,
  prc_amt,
  COUNT(prc_amt) OVER (ORDER BY prc_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS cnt,
  AVG(prc_amt) OVER (ORDER BY prc_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS avg
FROM Accounts);

SELECT
  A2.prc_date,
  A2.prc_amt,
  (
    SELECT CASE WHEN COUNT(TMP.prc_amt) >= 3 THEN AVG(
      TMP.prc_amt
    ) END FROM (
      SELECT
        A1.prc_date,
        A1.prc_amt
      FROM Accounts A1
      WHERE A2.prc_date >= A1.prc_date
      ORDER BY A1.prc_date DESC
      LIMIT 3
    ) TMP

  )
FROM Accounts A2
ORDER BY A2.prc_date;


-- 1-8

SELECT
  TA.age_class,
  TS.sex_cd,
  DATA.pop_tohoku,
  DATA.pop_kanto
FROM TblAge TA
CROSS JOIN TblSex TS
LEFT OUTER JOIN
  (SELECT
    age_class,
    sex_cd,
    SUM(CASE
      WHEN pref_name IN ('青森', '秋田')
        THEN population
    END) AS pop_tohoku,
    SUM(CASE
      WHEN pref_name IN ('東京', '千葉')
        THEN population
    END) AS pop_kanto
  FROM TblPop
  GROUP BY age_class, sex_cd) DATA
  ON
    TA.age_class = DATA.age_class
    AND TS.sex_cd = DATA.sex_cd;


CREATE VIEW Children (child)
AS SELECT child_1 FROM Personnel
UNION
SELECT child_2 FROM Personnel
UNION
SELECT child_3 FROM Personnel;

SELECT
  EMP.employee,
  COUNT(Children.child) AS child_cnt
FROM Personnel EMP
LEFT OUTER JOIN Children
  ON Children.child IN (EMP.child_1, EMP.child_2, EMP.child_3)
GROUP BY EMP.employee
ORDER BY child_cnt DESC;


drop table Class_A;
drop table Class_B;

CREATE TABLE Class_A
(id char(1),
 name varchar(30),
 PRIMARY KEY(id));

CREATE TABLE Class_B
(id   char(1),
 name varchar(30),
 PRIMARY KEY(id));

INSERT INTO Class_A (id, name) VALUES('1', '田中');
INSERT INTO Class_A (id, name) VALUES('2', '鈴木');
INSERT INTO Class_A (id, name) VALUES('3', '伊集院');

INSERT INTO Class_B (id, name) VALUES('1', '田中');
INSERT INTO Class_B (id, name) VALUES('2', '内海');
INSERT INTO Class_B (id, name) VALUES('4', '西園寺');

MERGE INTO Class_A tgt
USING Class_B src
  ON tgt.id = src.id
-- ① キーが一致 → 既存行を更新
WHEN MATCHED THEN
  UPDATE SET
    name = src.name
-- ② キーが不一致（ソースにだけ存在） → 新規行を挿入
WHEN NOT MATCHED THEN
  INSERT (id, name)
  VALUES (src.id, src.name);

SELECT
  id,
  name
FROM Class_A
ORDER BY id;
