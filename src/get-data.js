import Database from "better-sqlite3";

const db = new Database("myapp.db");

const getAllUsers = db.prepare("SELECT * FROM users");
const users = getAllUsers.all();
console.log(users);
