import Database from "better-sqlite3";

const db = new Database("myapp.db");

// エリアごとの人口を取得する
const getDistricts = db.prepare(`
  SELECT
    CASE WHEN pref_name IN ('京都', '大阪') THEN '関西'
    WHEN pref_name IN ('福岡', '佐賀') THEN '九州'
    ELSE NULL
    END AS district,
    pref_name,
    population
  FROM populations;
`);

console.log(getDistricts.all());
