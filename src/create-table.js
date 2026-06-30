import Database from "better-sqlite3";

const db = new Database("myapp.db");

db.exec(`
  CREATE TABLE IF NOT EXISTS populations (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    pref_name TEXT NOT NULL UNIQUE,
    population INTEGER,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP
  )
`);
