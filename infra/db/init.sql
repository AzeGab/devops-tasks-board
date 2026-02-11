CREATE TABLE IF NOT EXISTS projects (
id SERIAL PRIMARY KEY,
name TEXT NOT NULL
);
CREATE TABLE IF NOT EXISTS tasks (
id SERIAL PRIMARY KEY,
title TEXT NOT NULL,
completed BOOLEAN DEFAULT FALSE,
project_id INTEGER REFERENCES projects(id)
);
-- Données exemple
INSERT INTO projects (name) VALUES ('Projet démo') ON CONFLICT DO NOTHING;
INSERT INTO tasks (title, completed, project_id)
VALUES ('Créer l’app', false, 1),
('Dockeriser', false, 1),
('Déployer', false, 1)
ON CONFLICT DO NOTHING;