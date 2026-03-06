const express = require("express");
const { initDB } = require("./db");
const app = express();
app.use(express.json()); // Add JSON parsing middleware
const PORT = 3000;
initDB().then((db) => {
  app.locals.db = db;
  console.log("Database initialized");
});

// ── Ollama proxy — no DB needed, mount BEFORE the DB-guard middleware ──
app.use("/ollama", require("./ollama"));

// ── Speech-to-text (Whisper) — no DB needed, mount BEFORE the DB-guard middleware ──
app.use("/speech", require("./speech"));

// ── Simple health-check (no DB) ──
app.get("/", (req, res) => {
  res.send("Nodemon is watching for changes!");
});

// ── DB-guard middleware — only applies to routes below ──
app.use((req, res, next) => {
  if (!app.locals.db) {
    return res.status(503).json({ error: "Database not initialized" });
  }
  console.log(`Received ${req.method} request for ${req.url}`);
  next();
});
app.use("/patient", require("./patient"));
app.use("/doctor", require("./doctor"));
app.listen(PORT, "0.0.0.0", () => {
  console.log(`Server is running at http://0.0.0.0:${PORT}`);
});
