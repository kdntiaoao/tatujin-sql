import Database from "better-sqlite3";

const db = new Database("myapp.db");

const insert = db.prepare(
  "INSERT INTO users (name, email, age) VALUES (?, ?, ?)",
);
const info = insert.run("山田太郎", "taro@example.com", 30);
console.log(info.lastInsertRowid);
