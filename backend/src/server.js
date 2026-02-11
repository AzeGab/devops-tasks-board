const express = require("express");
const cors = require("cors");
const dotenv = require("dotenv");
const { Pool } = require("pg"); // Ajout du client PostgreSQL

// Charger les variables d'environnement
dotenv.config();

const app = express();

// Configuration de la connexion PostgreSQL
const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: {
    rejectUnauthorized: false, // Requis pour Render
  },
});

// Middlewares
app.use(cors());
app.use(express.json());

const PORT = process.env.PORT || 3000;

// Route de santé
app.get("/health", (req, res) => {
  res.status(200).json({ status: "ok", message: "Backend DevOps Tasks Board opérationnel" });
});

// RÉCUPÉRER TOUS LES PROJETS (Depuis la DB)
app.get("/projects", async (req, res) => {
  try {
    const result = await pool.query("SELECT * FROM projects ORDER BY id ASC");
    res.json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Erreur lors de la récupération des projets" });
  }
});

// RÉCUPÉRER TOUTES LES TÂCHES (Depuis la DB)
app.get("/tasks", async (req, res) => {
  try {
    const result = await pool.query("SELECT * FROM tasks ORDER BY id ASC");
    res.json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Erreur lors de la récupération des tâches" });
  }
});

// CRÉER UNE NOUVELLE TÂCHE (Enregistre en DB)
app.post("/tasks", async (req, res) => {
  const { title, projectId } = req.body;

  if (!title || !projectId) {
    return res.status(400).json({ error: "title et projectId sont obligatoires" });
  }

  try {
    // Insertion dans la table selon tes colonnes actuelles : id, title, completed, project_id
    const query = `
      INSERT INTO tasks (title, project_id, completed) 
      VALUES ($1, $2, $3) 
      RETURNING *`;
    
    const values = [title, projectId, false];
    const result = await pool.query(query, values);

    res.status(201).json(result.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Erreur lors de la création de la tâche" });
  }
});

// Démarrage du serveur
app.listen(PORT, () => {
  console.log(`✅ Backend DevOps Tasks Board démarré sur le port ${PORT}`);
});