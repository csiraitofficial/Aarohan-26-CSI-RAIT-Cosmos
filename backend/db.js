const sqlite3 = require("sqlite3");
const { open } = require("sqlite");

async function initDB() {
  const db = await open({
    filename: "./medical_system.db",
    driver: sqlite3.Database,
  });

  // Create Tables
  await db.exec(`
        CREATE TABLE IF NOT EXISTS Doctor (
            doctor_id INTEGER PRIMARY KEY AUTOINCREMENT,
            pin TEXT,
            mobile TEXT,
            name TEXT,
            degree TEXT
        );

        CREATE TABLE IF NOT EXISTS Patient (
            patient_id INTEGER PRIMARY KEY AUTOINCREMENT,
            doctor_id INTEGER,
            priority INTEGER,
            name TEXT,
            username TEXT,
            password TEXT,
            FOREIGN KEY(doctor_id) REFERENCES Doctor(doctor_id)
        );

        CREATE TABLE IF NOT EXISTS Vitals (
            patient_id INTEGER PRIMARY KEY,
            heart_rate INTEGER,
            bp TEXT,
            steps INTEGER,
            calories INTEGER,
            active_min INTEGER,
            glucose INTEGER,
            FOREIGN KEY(patient_id) REFERENCES Patient(patient_id)
        );

        CREATE TABLE IF NOT EXISTS Appointments (
            appointment_id INTEGER PRIMARY KEY AUTOINCREMENT,
            time TEXT,
            doctor_id INTEGER,
            confirmed BOOLEAN,
            patient_id INTEGER,
            FOREIGN KEY(patient_id) REFERENCES Patient(patient_id),
            FOREIGN KEY(doctor_id) REFERENCES Doctor(doctor_id)
        );
    `);

  // Add columns to existing patient table defensively
  try {
    await db.exec(`ALTER TABLE Patient ADD COLUMN username TEXT;`);
  } catch (e) {
    // Column might already exist
  }

  try {
    await db.exec(`ALTER TABLE Patient ADD COLUMN password TEXT;`);
  } catch (e) {
    // Column might already exist
  }

  // Emergency contact fields for special needs / autistic children
  try { await db.exec(`ALTER TABLE Patient ADD COLUMN emergency_contact TEXT;`); } catch (e) { }
  try { await db.exec(`ALTER TABLE Patient ADD COLUMN emergency_name TEXT;`); } catch (e) { }
  try { await db.exec(`ALTER TABLE Patient ADD COLUMN is_special_needs INTEGER DEFAULT 0;`); } catch (e) { }
  try { await db.exec(`ALTER TABLE Patient ADD COLUMN doctor_mobile TEXT;`); } catch (e) { }

  return db;
}
class MedicalDB {
  constructor(db) {
    this.db = db;
  }

  // ADD: Generic insert function
  async add(table, data) {
    const keys = Object.keys(data);
    const values = Object.values(data);
    const placeholders = keys.map(() => "?").join(",");
    const sql = `INSERT INTO ${table} (${keys.join(",")}) VALUES (${placeholders})`;

    return await this.db.run(sql, values);
  }

  // GET: Generic fetch function
  async get(table, criteria = {}) {
    const keys = Object.keys(criteria);
    let sql = `SELECT * FROM ${table}`;
    const values = Object.values(criteria);

    if (keys.length > 0) {
      const whereClause = keys.map((k) => `${k} = ?`).join(" AND ");
      sql += ` WHERE ${whereClause}`;
    }

    return await this.db.all(sql, values);
  }

  // SET: Upsert (update if exists, insert if not)
  async set(table, idColumn, idValue, updates) {
    const keys = Object.keys(updates);
    const values = Object.values(updates);
    const setClause = keys.map((k) => `${k} = ?`).join(", ");
    const updateSql = `UPDATE ${table} SET ${setClause} WHERE ${idColumn} = ?`;
    const updateResult = await this.db.run(updateSql, [...values, idValue]);

    // If no rows updated, insert
    if (updateResult.changes === 0) {
      const insertKeys = [idColumn, ...keys];
      const insertValues = [idValue, ...values];
      const placeholders = insertKeys.map(() => "?").join(",");
      const insertSql = `INSERT INTO ${table} (${insertKeys.join(",")}) VALUES (${placeholders})`;
      return await this.db.run(insertSql, insertValues);
    }
    return updateResult;
  }
}

module.exports = { initDB, MedicalDB };
