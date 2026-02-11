#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🛑 Arrêt du mode Kubernetes..."

# 1. Arrêt du port-forward backend
if [ -f "$SCRIPT_DIR/.k8s_portforward.pid" ]; then
    echo "➡ Arrêt du port-forward backend..."
    kill "$(cat "$SCRIPT_DIR/.k8s_portforward.pid")" 2>/dev/null || true
    rm -f "$SCRIPT_DIR/.k8s_portforward.pid"
    echo "✔ Port-forward backend arrêté"
else
    echo "ℹ Aucun port-forward backend détecté"
fi

# 2. Arrêt du frontend local
if [ -f "$SCRIPT_DIR/.k8s_frontend.pid" ]; then
    echo "➡ Arrêt du frontend local..."
    kill "$(cat "$SCRIPT_DIR/.k8s_frontend.pid")" 2>/dev/null || true
    rm -f "$SCRIPT_DIR/.k8s_frontend.pid"
    echo "✔ Frontend local arrêté"
else
    echo "ℹ Aucun frontend local détecté"
fi

echo "👌 Mode Kubernetes arrêté."
echo "ℹ Les pods K8s sont toujours actifs."
echo " Pour les supprimer complètement :"
echo " kubectl delete -f infra/k8s/"
echo ""

# 3. Proposer d'arrêter Minikube
printf "Voulez-vous aussi arrêter Minikube ? (y/n): "
read STOP_MINIKUBE

if [ "$STOP_MINIKUBE" = "y" ] || [ "$STOP_MINIKUBE" = "Y" ]; then
    echo "🛑 Arrêt de Minikube..."
    minikube stop
    echo "✔ Minikube arrêté."
else
    echo "ℹ Minikube laissé en fonctionnement."
fi