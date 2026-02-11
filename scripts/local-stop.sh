#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "🛑 Arrêt du mode LOCAL..."
if [ -f "$SCRIPT_DIR/.local_backend.pid" ]; then
kill "$(cat "$SCRIPT_DIR/.local_backend.pid")" 2>/dev/null || true
rm "$SCRIPT_DIR/.local_backend.pid"
echo "✔ Backend local arrêté"
else
echo "Backend local déjà arrêté"
fi
if [ -f "$SCRIPT_DIR/.local_frontend.pid" ]; then
kill "$(cat "$SCRIPT_DIR/.local_frontend.pid")" 2>/dev/null || true
rm "$SCRIPT_DIR/.local_frontend.pid"
echo "✔ Frontend local arrêté"
else
echo "Frontend local déjà arrêté"
fi
echo "👌 Mode LOCAL arrêté."