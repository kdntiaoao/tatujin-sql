import Database from "better-sqlite3";

const db = new Database("myapp.db");

const insert = db.prepare(
  "INSERT INTO populations (pref_name, population) VALUES (?, ?)",
);

const prefs = [
  { name: "京都", population: 300 },
  { name: "大阪", population: 900 },
  { name: "福岡", population: 500 },
  { name: "佐賀", population: 100 },
];

for (const pref of prefs) {
  try {
    insert.run(pref.name, pref.population);
    console.log(`Inserted ${pref.name} with population ${pref.population}`);
  } catch (err) {
    console.error(`Error inserting ${pref.name}:`, err.message);
  }
}
