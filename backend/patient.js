const { MedicalDB } = require("./db");

const patient_router = require("express").Router();

patient_router.get("/register", (req, res) => {
  const db = new MedicalDB(req.app.locals.db);
  db.add("Patient", {
    doctor_id: req.query.doctor_id,
    priority: req.query.priority,
    name: req.query.name,
  })
    .then(() => res.json({ success: true }))
    .catch((err) => res.status(500).json({ error: err.message }));
});

// Authentication routes
patient_router.post("/signup", async (req, res) => {
  try {
    const { username, password, name, doctor_id, priority } = req.body;

    if (!username || !password) {
      return res.status(400).json({ error: "Username and password are required" });
    }

    const db = new MedicalDB(req.app.locals.db);

    // Check if username already exists
    const existing = await db.get("Patient", { username });
    if (existing.length > 0) {
      return res.status(409).json({ error: "Username already exists" });
    }

    const result = await db.add("Patient", {
      username,
      password,
      name: name || username,
      doctor_id: doctor_id || null,
      priority: priority || 0
    });

    res.json({ success: true, patient_id: result.lastID });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

patient_router.post("/login", async (req, res) => {
  try {
    const { username, password } = req.body;

    if (!username || !password) {
      return res.status(400).json({ error: "Username and password are required" });
    }

    const db = new MedicalDB(req.app.locals.db);
    const patients = await db.get("Patient", { username, password });

    if (patients.length === 0) {
      return res.status(401).json({ error: "Invalid credentials" });
    }

    res.json({ success: true, patient: patients[0] });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

patient_router.get("/set_vitals", (req, res) => {
  const db = new MedicalDB(req.app.locals.db);
  db.set("Vitals", "patient_id", req.query.patient_id, {
    heart_rate: req.query.heart_rate,
    bp: req.query.bp,
    steps: req.query.steps,
    calories: req.query.calories,
    active_min: req.query.active_min,
    glucose: req.query.glucose,
  })
    .then(() => res.json({ success: true }))
    .catch((err) => res.status(500).json({ error: err.message }));
});

patient_router.get("/get_vitals", (req, res) => {
  const db = new MedicalDB(req.app.locals.db);
  db.get("Vitals", { patient_id: req.query.patient_id })
    .then((vitals) => res.json(vitals))
    .catch((err) => res.status(500).json({ error: err.message }));
});

patient_router.get("/book_appointment", (req, res) => {
  const db = new MedicalDB(req.app.locals.db);
  db.add("Appointments", {
    time: req.query.time,
    doctor_id: req.query.doctor_id,
    patient_id: req.query.patient_id,
    confirmed: false,
  })
    .then(() => res.json({ success: true }))
    .catch((err) => res.status(500).json({ error: err.message }));
});

// Update patient profile with emergency contact info
patient_router.post("/update_profile", async (req, res) => {
  try {
    const { patient_id, emergency_contact, emergency_name, is_special_needs, doctor_mobile } = req.body;
    const db = new MedicalDB(req.app.locals.db);
    await db.set("Patient", "patient_id", patient_id, {
      emergency_contact,
      emergency_name,
      is_special_needs: is_special_needs ? 1 : 0,
      doctor_mobile,
    });
    res.json({ success: true });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Heart rate spike alert — logs emergency + GPS, ready for Twilio integration
patient_router.post("/alert_spike", async (req, res) => {
  try {
    const { patient_id, heart_rate, lat, lng } = req.body;
    const db = new MedicalDB(req.app.locals.db);
    const patients = await db.get("Patient", { patient_id });
    if (!patients.length) return res.status(404).json({ error: "Patient not found" });
    const patient = patients[0];
    const mapsUrl = `https://maps.google.com/?q=${lat},${lng}`;
    // Log alert — plug in Twilio here for real SMS in production
    console.log(`🚨 SPIKE ALERT: patient=${patient.name}, HR=${heart_rate} BPM`);
    console.log(`   Emergency: ${patient.emergency_name} (${patient.emergency_contact})`);
    console.log(`   Doctor mobile: ${patient.doctor_mobile}`);
    console.log(`   GPS: (${lat}, ${lng}) → ${mapsUrl}`);
    res.json({
      success: true,
      alerted: {
        emergency_contact: patient.emergency_contact,
        emergency_name: patient.emergency_name,
        doctor_mobile: patient.doctor_mobile,
        patient_name: patient.name,
        heart_rate,
        gps: { lat, lng },
        maps_url: mapsUrl,
      },
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = patient_router;
