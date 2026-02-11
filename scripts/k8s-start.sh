#!/bin/bash
set -e

# Définition des variables de chemin
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="${SCRIPT_DIR}/.."

cd "$ROOT_DIR"

echo "🚀 Démarrage du mode Kubernetes (backend + DB en K8s, frontend en local)..."

# 1. Vérifier ou démarrer Minikube
echo "➡ Vérification de l'état de Minikube..."
MINIKUBE_STATUS=$(minikube status --format='{{.Host}}' 2>/dev/null || echo "Stopped")

if [ "$MINIKUBE_STATUS" != "Running" ]; then
    echo "⚠ Minikube n'est pas démarré — lancement..."
    minikube start
else
    echo "✔ Minikube est déjà démarré."
fi

# 2. Utiliser le moteur Docker interne de Minikube
echo "➡ Bascule sur le daemon Docker interne de Minikube..."
eval "$(minikube docker-env)"

# 3. Rebuild des images backend & frontend dans Minikube
echo "➡ Reconstruction de l'image backend (tasks-backend:latest)..."
docker build -t tasks-backend:latest "$ROOT_DIR/backend"

echo "➡ Reconstruction de l'image frontend (tasks-frontend:latest)..."
docker build -t tasks-frontend:latest "$ROOT_DIR/frontend"

# 4. Retour au Docker hôte
echo "➡ Retour au Docker hôte..."
eval "$(minikube docker-env -u)"

# 5. Appliquer les manifests Kubernetes
# CORRECTION ICI : On pointe vers infra/k8s
echo "➡ Application des manifests Kubernetes..."
kubectl apply -f "$ROOT_DIR/infra/k8s"

# 6. Attendre que le backend soit prêt
echo "⏳ Attente du déploiement backend..."
kubectl rollout status deployment/backend-deployment

# 7. Port-forward backend -> localhost:3000
echo "➡ Exposition du backend K8s sur http://localhost:3000 ..."
lsof -ti:3000 | xargs kill -9 2>/dev/null || true
kubectl port-forward deployment/backend-deployment 3000:3000 >/dev/null 2>&1 &
echo $! > "$SCRIPT_DIR/.k8s_portforward.pid"

# 8. Lancer le frontend en local
echo "➡ Lancement du frontend local (http://localhost:5173)..."
cd "$ROOT_DIR/frontend"
npm install
npm run dev >/dev/null 2>&1 &
echo $! > "$SCRIPT_DIR/.k8s_frontend.pid"

echo ""
echo "✅ Mode KUBERNETES démarré."
echo "------------------------------------------------"
echo "ℹ️  Backend (K8s)    : http://localhost:3000"
echo "ℹ️  Frontend (local) : http://localhost:5173"
echo "ℹ️  Pour arrêter     : ./scripts/k8s-stop.sh"
echo "------------------------------------------------"