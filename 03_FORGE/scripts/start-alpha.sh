#!/bin/bash
cd ~/AO-01-CORE || { echo "Folder AO-01-CORE not found"; exit 1; }

echo "========================================="
echo "   STARTING ALPHA SOVEREIGN UNIVERSE     "
echo "========================================="

lsof -ti:8000 | xargs kill -9 2>/dev/null
lsof -ti:8001 | xargs kill -9 2>/dev/null
sleep 1

# Lancer le Serveur Web (Port 8000)
nohup python3 -m http.server 8000 > /tmp/alpha_web.log 2>&1 &
echo "[+] Web Server running on http://localhost:8000"

# Lancer le Cerveau Alpha (Port 8001) en utilisant le Python de la bulle (.venv)
nohup 03_FORGE/mcp/.venv/bin/python3 03_FORGE/agent/alpha_brain.py > /tmp/alpha_brain.log 2>&1 &
echo "[+] Alpha Brain running on http://localhost:8001"

# Empêcher le Mac de dormir
nohup caffeinate -d -i > /dev/null 2>&1 &
echo "[+] Mac sleep prevention (Caffeinate) activated."

echo ""
echo "[+] SYSTEM READY. Open your browser at:"
echo "    http://localhost:8000/04_MULTIMEDIA/3d/portal.html"
echo ""
