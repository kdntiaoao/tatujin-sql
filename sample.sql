-- 演習問題1-①：複数列の最大値
CREATE TABLE Greatests
(key CHAR(1) PRIMARY KEY,
 x   INTEGER NOT NULL,
 y   INTEGER NOT NULL,
 z   INTEGER NOT NULL);

INSERT INTO Greatests VALUES('A', 1, 2, 3);
INSERT INTO Greatests VALUES('B', 5, 5, 2);
INSERT INTO Greatests VALUES('C', 4, 7, 1);
INSERT INTO Greatests VALUES('D', 3, 3, 8);

SELECT key, (CASE WHEN x >= y THEN x ELSE y END) AS greatest
FROM Greatests;

-- 演習問題1-②：合計と再掲を表頭に出力する行列変換

CREATE TABLE PopTbl2
(pref_name VARCHAR(32),
 sex CHAR(1) NOT NULL,
 population INTEGER NOT NULL,
    PRIMARY KEY(pref_name, sex));

INSERT INTO PopTbl2 VALUES('徳島', '1',	60 );
INSERT INTO PopTbl2 VALUES('徳島', '2',	40 );
INSERT INTO PopTbl2 VALUES('香川', '1',	100);
INSERT INTO PopTbl2 VALUES('香川', '2',	100);
INSERT INTO PopTbl2 VALUES('愛媛', '1',	100);
INSERT INTO PopTbl2 VALUES('愛媛', '2',	50 );
INSERT INTO PopTbl2 VALUES('高知', '1',	100);
INSERT INTO PopTbl2 VALUES('高知', '2',	100);
INSERT INTO PopTbl2 VALUES('福岡', '1',	100);
INSERT INTO PopTbl2 VALUES('福岡', '2',	200);
INSERT INTO PopTbl2 VALUES('佐賀', '1',	20 );
INSERT INTO PopTbl2 VALUES('佐賀', '2',	80 );
INSERT INTO PopTbl2 VALUES('長崎', '1',	125);
INSERT INTO PopTbl2 VALUES('長崎', '2',	125);
INSERT INTO PopTbl2 VALUES('東京', '1',	250);
INSERT INTO PopTbl2 VALUES('東京', '2',	150);

SELECT
  (CASE WHEN sex = '1' THEN '男' ELSE '女' END) AS "性別",
  SUM(population) AS "全国",
  SUM(CASE WHEN pref_name = '徳島' THEN population ELSE 0 END) AS "徳島",
  SUM(CASE WHEN pref_name = '香川' THEN population ELSE 0 END) AS "香川",
  SUM(CASE WHEN pref_name = '愛媛' THEN population ELSE 0 END) AS "愛媛",
  SUM(CASE WHEN pref_name = '高知' THEN population ELSE 0 END) AS "高知",
  SUM(CASE WHEN pref_name IN ('徳島', '香川', '愛媛', '高知') THEN population ELSE 0 END) AS "四国 (再掲)"
FROM PopTbl2
GROUP BY sex
ORDER BY sex;

-- 演習問題1-③：ORDER BYでソート列を作る

SELECT key FROM Greatests
ORDER BY (CASE WHEN key = 'B' THEN 1 WHEN key = 'A' THEN 2 WHEN key = 'D' THEN 3 ELSE 999 END);

-- 1-2 ウィンドウ関数 MEMO

CREATE TABLE LoadSample
(sample_date   DATE PRIMARY KEY,
 load_val      INTEGER NOT NULL);

INSERT INTO LoadSample VALUES('2018-02-01',   1024);
INSERT INTO LoadSample VALUES('2018-02-02',   2366);
INSERT INTO LoadSample VALUES('2018-02-05',   2366);
INSERT INTO LoadSample VALUES('2018-02-07',    985);
INSERT INTO LoadSample VALUES('2018-02-08',    780);
INSERT INTO LoadSample VALUES('2018-02-12',   1000);

SELECT sample_date,
       MIN(sample_date)
       OVER (ORDER BY sample_date ASC
             ROWS BETWEEN 1 PRECEDING AND 1 PRECEDING) AS latest_date
FROM LoadSample;

SELECT sample_date,
       MIN(sample_date)
       OVER (ORDER BY sample_date DESC
             ROWS BETWEEN 1 PRECEDING AND 1 PRECEDING) AS next_date
FROM LoadSample
ORDER BY sample_date ASC;
-- 上記と同じ結果を返す
SELECT sample_date,
       MIN(sample_date)
       OVER (ORDER BY sample_date ASC
             ROWS BETWEEN 1 FOLLOWING AND 1 FOLLOWING) AS next_date
FROM LoadSample;

SELECT
  sample_date,
  MIN(sample_date) OVER (ORDER BY sample_date ASC ROWS BETWEEN 1 PRECEDING AND 1 PRECEDING) AS latest_1,
  MIN(sample_date) OVER (ORDER BY sample_date ASC ROWS BETWEEN 2 PRECEDING AND 2 PRECEDING) AS latest_2,
  MIN(sample_date) OVER (ORDER BY sample_date ASC ROWS BETWEEN 3 PRECEDING AND 3 PRECEDING) AS latest_3
FROM LoadSample;

-- 参考: window関数を使いこなす (https://qiita.com/HiromuMasuda0228/items/0b20d461f1a80bd30cfc)

CREATE TABLE emp_info
(depname VARCHAR(32),
 empid   INTEGER PRIMARY KEY,
 salary  INTEGER NOT NULL);

INSERT INTO emp_info VALUES('develop' , 11 , 5200);
INSERT INTO emp_info VALUES('develop' ,  7 , 4200);
INSERT INTO emp_info VALUES('develop' ,  9 , 4500);
INSERT INTO emp_info VALUES('develop' ,  8 , 6000);
INSERT INTO emp_info VALUES('develop' , 10 , 5200);
INSERT INTO emp_info VALUES('personnel' ,  5 , 3500);
INSERT INTO emp_info VALUES('personnel' ,  2 , 3900);
INSERT INTO emp_info VALUES('sales'  ,  3 , 4800);
INSERT INTO emp_info VALUES('sales'  ,  1 , 5000);
INSERT INTO emp_info VALUES('sales'  ,  4 , 4800);

SELECT
  depname,
  empid,
  salary,
  AVG(salary) OVER (PARTITION BY depname) AS avg_salary
FROM emp_info;
-- 小数点四捨五入
SELECT
  depname,
  empid,
  salary,
  ROUND(AVG(salary) OVER (PARTITION BY depname)) AS avg_salary
FROM emp_info;
-- 実行計画 (推定値)
EXPLAIN SELECT
  depname,
  empid,
  salary,
  AVG(salary) OVER (PARTITION BY depname) AS avg_salary
FROM emp_info;
-- 実行と合わせて推定値を出す
EXPLAIN ANALYZE SELECT
  depname,
  empid,
  salary,
  AVG(salary) OVER (PARTITION BY depname) AS avg_salary
FROM emp_info;

CREATE TABLE fibonacci_numbers
(id     SERIAL PRIMARY KEY,
 number INTEGER NOT NULL);

INSERT INTO fibonacci_numbers (number) VALUES(1);
INSERT INTO fibonacci_numbers (number) VALUES(1);
INSERT INTO fibonacci_numbers (number) VALUES(2);
INSERT INTO fibonacci_numbers (number) VALUES(3);
INSERT INTO fibonacci_numbers (number) VALUES(5);
INSERT INTO fibonacci_numbers (number) VALUES(8);
INSERT INTO fibonacci_numbers (number) VALUES(13);
INSERT INTO fibonacci_numbers (number) VALUES(21);
INSERT INTO fibonacci_numbers (number) VALUES(34);
INSERT INTO fibonacci_numbers (number) VALUES(55);
INSERT INTO fibonacci_numbers (number) VALUES(89);
INSERT INTO fibonacci_numbers (number) VALUES(144);
INSERT INTO fibonacci_numbers (number) VALUES(233);

SELECT
  id,
  number,
  MIN(number) OVER (ORDER BY id ASC ROWS BETWEEN 1 PRECEDING AND 1 PRECEDING) AS latest_1,
  MIN(number) OVER (ORDER BY id ASC ROWS BETWEEN 2 PRECEDING AND 2 PRECEDING) AS latest_2,
  SUM(number) OVER (ORDER BY id ASC ROWS BETWEEN 2 PRECEDING AND 1 PRECEDING) AS "sum(latest_1 + latest_2)"
FROM fibonacci_numbers;

-- 演習問題2-①：ウィンドウ関数の結果予想　その1

CREATE TABLE ServerLoadSample
(server       CHAR(4) NOT NULL,
 sample_date  DATE    NOT NULL,
 load_val      INTEGER NOT NULL,
    PRIMARY KEY (server, sample_date));

INSERT INTO ServerLoadSample VALUES('A' , '2018-02-01',  1024);
INSERT INTO ServerLoadSample VALUES('A' , '2018-02-02',  2366);
INSERT INTO ServerLoadSample VALUES('A' , '2018-02-05',  2366);
INSERT INTO ServerLoadSample VALUES('A' , '2018-02-07',   985);
INSERT INTO ServerLoadSample VALUES('A' , '2018-02-08',   780);
INSERT INTO ServerLoadSample VALUES('A' , '2018-02-12',  1000);
INSERT INTO ServerLoadSample VALUES('B' , '2018-02-01',    54);
INSERT INTO ServerLoadSample VALUES('B' , '2018-02-02', 39008);
INSERT INTO ServerLoadSample VALUES('B' , '2018-02-03',  2900);
INSERT INTO ServerLoadSample VALUES('B' , '2018-02-04',   556);
INSERT INTO ServerLoadSample VALUES('B' , '2018-02-05', 12600);
INSERT INTO ServerLoadSample VALUES('B' , '2018-02-06',  7309);
INSERT INTO ServerLoadSample VALUES('C' , '2018-02-01',  1000);
INSERT INTO ServerLoadSample VALUES('C' , '2018-02-07',  2000);
INSERT INTO ServerLoadSample VALUES('C' , '2018-02-16',   500);

-- 1-3

CREATE TABLE Products
(name VARCHAR(16) NOT NULL,
 price INTEGER NOT NULL);

INSERT INTO Products VALUES('りんご',	50);
INSERT INTO Products VALUES('みかん',	100);
INSERT INTO Products VALUES('ぶどう',	50);
INSERT INTO Products VALUES('スイカ',	80);
INSERT INTO Products VALUES('レモン',	30);
INSERT INTO Products VALUES('いちご',	100);
INSERT INTO Products VALUES('バナナ',	100);

SELECT
  DISTINCT P1.name AS name_1,
  P2.name AS name_2,
  P1.price
FROM Products AS P1 INNER JOIN Products AS P2
  ON P1.name > P2.name
  AND P1.price = P2.price
ORDER BY P1.price;

-- 一回りセット
-- DROP TABLE Products;
-- CREATE TABLE Products
-- (id   SERIAL PRIMARY KEY,
--  name VARCHAR(16) NOT NULL,
--  price INTEGER NOT NULL);
-- INSERT INTO Products (name, price) VALUES('りんご',	50);
-- INSERT INTO Products (name, price) VALUES('みかん',	100);
-- INSERT INTO Products (name, price) VALUES('ぶどう',	50);
-- INSERT INTO Products (name, price) VALUES('スイカ',	80);
-- INSERT INTO Products (name, price) VALUES('レモン',	30);
-- INSERT INTO Products (name, price) VALUES('いちご',	100);
-- INSERT INTO Products (name, price) VALUES('バナナ',	100);

SELECT DISTINCT P1.name, P1.price
  FROM Products P1 INNER JOIN Products P2
    ON P1.price = P2.price
   AND P1.name <> P2.name
 ORDER BY P1.price;
-- 上記と同じ
-- SELECT
--   P1.name AS name_1,
--   P1.price,
--   P1.id
-- FROM Products AS P1 INNER JOIN Products AS P2
--   ON P1.name <> P2.name
--   AND P1.price = P2.price
-- WHERE P1.id < (SELECT MIN(P2.id) FROM Products P2 WHERE P1.name = P2.name AND P1.price = P2.price)
-- ORDER BY P1.price;

-- 演習問題3-①：重複組み合わせ
-- 一回りセット
DROP TABLE Products;
CREATE TABLE Products
(name VARCHAR(16) PRIMARY KEY,
 price INTEGER NOT NULL);
INSERT INTO Products VALUES('りんご',	100);
INSERT INTO Products VALUES('みかん',	50);
INSERT INTO Products VALUES('バナナ',	80);

SELECT
  P1.name AS name_1,
  P2.name AS name_2
FROM Products P1
LEFT OUTER JOIN Products P2
ON P1.name >= P2.name;

-- 演習問題3-②：ウィンドウ関数で重複削除
-- 一回リセット
DROP TABLE Products;
CREATE TABLE Products
(name VARCHAR(16) NOT NULL,
 price INTEGER NOT NULL);
INSERT INTO Products VALUES('りんご',	50);
INSERT INTO Products VALUES('みかん',	100);
INSERT INTO Products VALUES('みかん',	100);
INSERT INTO Products VALUES('みかん',	100);
INSERT INTO Products VALUES('バナナ',	80);

-- (name, price)のパーティションに一意な連番を振ったテーブルを作成
CREATE TABLE Products_NoRedundant
AS
SELECT ROW_NUMBER()
         OVER(PARTITION BY name, price
                  ORDER BY name) AS row_num,
       name, price
  FROM Products;


-- 連番が1以外のレコードを削除
DELETE FROM Products_NoRedundant
  WHERE row_num > 1;

SELECT * FROM Products_NoRedundant;
