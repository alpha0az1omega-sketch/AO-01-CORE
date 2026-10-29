#!/bin/bash
echo "========================================="
echo "   LANCEMENT DE L'UNIVERS AO-01-CORE     "
echo "========================================="

# 1. Nettoyage des anciens processus
lsof -ti:8000 | xargs kill -9 2>/dev/null
lsof -ti:8001 | xargs kill -9 2>/dev/null
lsof -ti:8545 | xargs kill -9 2>/dev/null

# 2. Lancement de la Blockchain (Anvil)
nohup anvil > /tmp/anvil.log 2>&1 &
echo "[+] Blockchain Locale (Anvil) demarree."

# 3. Lancement du Serveur Web
nohup python3 -m http.server 8000 > /tmp/alpha_web.log 2>&1 &
echo "[+] Serveur Web demarre."

# 4. Lancement de l'Agent Alpha (en utilisant le venv)
nohup 03_FORGE/mcp/.venv/bin/python3 03_FORGE/agent/alpha_brain.py > /tmp/alpha_brain.log 2>&1 &
echo "[+] Agent Alpha demarre."

# 5. Prévention de la veille (Mac)
nohup caffeinate -d -i > /dev/null 2>&1 &
echo "[+] Prevention de la veille activee."

# 6. Ouverture du portail dans le navigateur
sleep 2
open http://localhost:8000/04_MULTIMEDIA/3d/portal.html

echo "========================================="
echo "   UNIVERS LANCE. A VOUS DE JOUER.       "
echo "========================================="
