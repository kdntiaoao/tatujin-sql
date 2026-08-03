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
