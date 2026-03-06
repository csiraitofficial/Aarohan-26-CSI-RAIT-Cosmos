const { MedicalDB } = require("./db");

const doctor_router = require("express").Router();

doctor_router.get("/register", (req, res) => {
  const db = new MedicalDB(req.app.locals.db);
  db.add("Doctor", {
    pin: req.query.pin,
    mobile: req.query.mobile,
    name: req.query.name,
    degree: req.query.degree,
  })
    .then(() => res.json({ success: true }))
    .catch((err) => res.status(500).json({ error: err.message }));
});

doctor_router.get("/get_info", (req, res) => {
  const db = new MedicalDB(req.app.locals.db);
  db.get("Doctor", { doctor_id: req.query.doctor_id })
    .then((doctors) => {
      if (doctors.length === 0) {
        return res.status(404).json({ error: "Doctor not found" });
      }
      res.json(doctors[0]);
    })
    .catch((err) => res.status(500).json({ error: err.message }));
});

doctor_router.get("/login", (req, res) => {
  const db = new MedicalDB(req.app.locals.db);
  db.get("Doctor", { mobile: req.query.mobile, pin: req.query.pin })
    .then((doctors) => {
      if (doctors.length === 0) {
        return res.status(401).json({ error: "Invalid credentials" });
      }
      res.json({ success: true, doctor_id: doctors[0].doctor_id });
    })
    .catch((err) => res.status(500).json({ error: err.message }));
});

doctor_router.get("/get_patients", (req, res) => {
  const db = new MedicalDB(req.app.locals.db);
  db.get("Patient", { doctor_id: req.query.doctor_id })
    .then((patients) => {
      const promises = patients.map((p) => {
        if (p.name) return Promise.resolve(p);
        // attempt to look up name in Users table (try user_id then patient_id)
        const userKey = p.user_id
          ? { user_id: p.user_id }
          : { patient_id: p.patient_id };
        return db.get("Users", userKey).then((users) => {
          const name = users && users[0] ? users[0].name : null;
          return { ...p, name };
        });
      });
      Promise.all(promises)
        .then((patientsWithNames) => res.json(patientsWithNames))
        .catch((err) => res.status(500).json({ error: err.message }));
    })
    .catch((err) => res.status(500).json({ error: err.message }));
});

doctor_router.get("/get_appointments", (req, res) => {
  const db = new MedicalDB(req.app.locals.db);
  db.get("Appointments", { doctor_id: req.query.doctor_id })
    .then((appointments) => {
      const promises = appointments.map((a) => {
        if (a.name) return Promise.resolve(a);
        const userKey = a.user_id
          ? { user_id: a.user_id }
          : { patient_id: a.patient_id };
        return db.get("Users", userKey).then((users) => {
          const name = users && users[0] ? users[0].name : null;
          return { ...a, name };
        });
      });
      Promise.all(promises)
        .then((appointmentsWithNames) => res.json(appointmentsWithNames))
        .catch((err) => res.status(500).json({ error: err.message }));
    })
    .catch((err) => res.status(500).json({ error: err.message }));
});

doctor_router.get("/confirm_appointment", (req, res) => {
  const db = new MedicalDB(req.app.locals.db);
  db.set("Appointments", "appointment_id", req.query.appointment_id, {
    confirmed: true,
  })
    .then(() => res.json({ success: true }))
    .catch((err) => res.status(500).json({ error: err.message }));
});

module.exports = doctor_router;
