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
  SI.shop,
  COUNT(SI.shop) AS my_item_cnt,
  ((SELECT COUNT(I.item) FROM Items I) - COUNT(SI.shop)) AS diff_cnt
FROM ShopItems SI
WHERE SI.item IN (SELECT I.item FROM Items I)
GROUP BY SI.shop;

-- 演習問題7-①：移動平均

CREATE TABLE Accounts
(
  prc_date VARCHAR(16) NOT NULL,
  prc_amt INTEGER NOT NULL
);

INSERT INTO Accounts VALUES ('2018-10-16', 12000);
INSERT INTO Accounts VALUES ('2018-10-31', -15000);
INSERT INTO Accounts VALUES ('2018-11-03', 34000);
INSERT INTO Accounts VALUES ('2018-11-04', -5000);
INSERT INTO Accounts VALUES ('2018-11-06', 7200);
INSERT INTO Accounts VALUES ('2018-11-11', 11000);

SELECT
  prc_date,
  prc_amt,
  ROUND(AVG(prc_amt) OVER (ORDER BY prc_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)) AS mvg_sum
FROM Accounts;

/*
  prc_date  | prc_amt | round
------------+---------+-------
 2018-10-16 |   12000 | 12000
 2018-10-31 |  -15000 | -1500
 2018-11-03 |   34000 | 10333
 2018-11-04 |   -5000 |  4667
 2018-11-06 |    7200 | 12067
 2018-11-11 |   11000 |  4400
*/

SELECT
  A1.prc_date,
  A1.prc_amt,
  (
    SELECT ROUND(AVG(A2.prc_amt)) FROM Accounts A2
    WHERE A2.prc_date <= A1.prc_date AND (
      SELECT COUNT(A3.prc_date) FROM Accounts A3
      WHERE A3.prc_date <= A1.prc_date AND A3.prc_date >= A2.prc_date
    ) <= 3
  ) AS mvg_sum
FROM Accounts A1;

-- 演習問題7-②：移動平均　その2

SELECT
  prc_date,
  prc_amt,
  ROUND(AVG(prc_amt) OVER (ORDER BY prc_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)) AS mvg_sum
FROM Accounts;

-- 演習問題8-①：結合が先か、集約が先か？

CREATE TABLE TblSex
(
  sex_cd CHAR(1),
  sex VARCHAR(5),
  PRIMARY KEY (sex_cd)
);

CREATE TABLE TblAge
(
  age_class CHAR(1),
  age_range VARCHAR(30),
  PRIMARY KEY (age_class)
);

CREATE TABLE TblPop
(
  pref_name VARCHAR(30),
  age_class CHAR(1),
  sex_cd CHAR(1),
  population INTEGER,
  PRIMARY KEY (pref_name, age_class, sex_cd)
);

INSERT INTO TblSex (sex_cd, sex) VALUES ('m', '男');
INSERT INTO TblSex (sex_cd, sex) VALUES ('f', '女');

INSERT INTO TblAge (age_class, age_range) VALUES ('1', '21～30歳');
INSERT INTO TblAge (age_class, age_range) VALUES ('2', '31～40歳');
INSERT INTO TblAge (age_class, age_range) VALUES ('3', '41～50歳');

INSERT INTO TblPop VALUES ('秋田', '1', 'm', 400);
INSERT INTO TblPop VALUES ('秋田', '3', 'm', 1000);
INSERT INTO TblPop VALUES ('秋田', '1', 'f', 800);
INSERT INTO TblPop VALUES ('秋田', '3', 'f', 1000);
INSERT INTO TblPop VALUES ('青森', '1', 'm', 700);
INSERT INTO TblPop VALUES ('青森', '1', 'f', 500);
INSERT INTO TblPop VALUES ('青森', '3', 'f', 800);
INSERT INTO TblPop VALUES ('東京', '1', 'm', 900);
INSERT INTO TblPop VALUES ('東京', '1', 'f', 1500);
INSERT INTO TblPop VALUES ('東京', '3', 'f', 1200);
INSERT INTO TblPop VALUES ('千葉', '1', 'm', 900);
INSERT INTO TblPop VALUES ('千葉', '1', 'f', 1000);
INSERT INTO TblPop VALUES ('千葉', '3', 'f', 900);

SELECT
  MASTER.age_class,
  MASTER.sex_cd,
  DATA.pop_tohoku,
  DATA.pop_kanto
FROM (
  SELECT
    TA.age_class,
    TS.sex_cd
  FROM TblAge TA CROSS JOIN TblSex TS
) MASTER
LEFT OUTER JOIN (
  SELECT
    age_class,
    sex_cd,
    SUM(CASE WHEN pref_name IN ('青森', '秋田') THEN population END) AS pop_tohoku,
    SUM(CASE WHEN pref_name IN ('東京', '千葉') THEN population END) AS pop_kanto
  FROM TblPop
  GROUP BY age_class, sex_cd
) DATA
  ON
    MASTER.age_class = DATA.age_class
    AND MASTER.sex_cd = DATA.sex_cd
ORDER BY MASTER.age_class ASC, MASTER.sex_cd DESC;

SELECT
  MASTER.age_class,
  MASTER.sex_cd,
  SUM(CASE WHEN DATA.pref_name IN ('青森', '秋田') THEN DATA.population END) AS pop_tohoku,
  SUM(CASE WHEN DATA.pref_name IN ('東京', '千葉') THEN DATA.population END) AS pop_kanto
FROM (
  SELECT
    TA.age_class,
    TS.sex_cd
  FROM TblAge TA CROSS JOIN TblSex TS
) MASTER
LEFT OUTER JOIN TblPop DATA
  ON
    MASTER.age_class = DATA.age_class
    AND MASTER.sex_cd = DATA.sex_cd
GROUP BY MASTER.age_class, MASTER.sex_cd
ORDER BY MASTER.age_class ASC, MASTER.sex_cd DESC;

-- 演習問題8-②：子どもの数にご用心

CREATE TABLE Personnel
(
  employee VARCHAR(32),
  child_1 VARCHAR(32),
  child_2 VARCHAR(32),
  child_3 VARCHAR(32),
  PRIMARY KEY (employee)
);

INSERT INTO Personnel VALUES ('赤井', '一郎', '二郎', '三郎');
INSERT INTO Personnel VALUES ('工藤', '春子', '夏子', NULL);
INSERT INTO Personnel VALUES ('鈴木', '夏子', NULL, NULL);
INSERT INTO Personnel VALUES ('吉田', NULL, NULL, NULL);

SELECT
  P.employee,
  COUNT(P.child) AS child_count
FROM (SELECT
  employee,
  child_1 AS child
FROM Personnel
UNION ALL
SELECT
  employee,
  child_2 AS child
FROM Personnel
UNION ALL
SELECT
  employee,
  child_3 AS child
FROM Personnel) P
GROUP BY P.employee;
