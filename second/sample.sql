-- 1
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
