#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="${SCRIPT_DIR}/.."

cd "$ROOT_DIR"

echo "🚀 Démarrage de l'application en mode LOCAL (Node.js direct)..."

# --- BACKEND ---
echo "➡ Lancement du backend..."
cd backend
npm install >/dev/null 2>&1
npm run dev >/dev/null 2>&1 & 
BACKEND_PID=$!
echo "$BACKEND_PID" > "$SCRIPT_DIR/.local_backend.pid"
echo "   ✅ Backend lancé (PID: $BACKEND_PID) sur http://localhost:3000"

# --- FRONTEND ---
echo "➡ Lancement du frontend..."
cd ../frontend
npm install >/dev/null 2>&1
npm run dev >/dev/null 2>&1 &
FRONTEND_PID=$!
echo "$FRONTEND_PID" > "$SCRIPT_DIR/.local_frontend.pid"
echo "   ✅ Frontend lancé (PID: $FRONTEND_PID) sur http://localhost:5173"

echo ""
echo "✅ Mode LOCAL démarré avec succès."
echo "ℹ️  Pour arrêter : ./scripts/local-stop.sh"