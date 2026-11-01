#!/bin/bash

echo "========================================="
echo "   LAUNCHING AO-01-CORE UNIVERSE         "
echo "========================================="

# 1. Clean up old processes
lsof -ti:8000 | xargs kill -9 2>/dev/null
lsof -ti:8001 | xargs kill -9 2>/dev/null
lsof -ti:8545 | xargs kill -9 2>/dev/null

# 2. Launch Local Blockchain (Anvil)
nohup anvil > /tmp/anvil.log 2>&1 &
echo "[+] Local Blockchain (Anvil) started."

# 3. Launch Web Server
nohup python3 -m http.server 8000 > /tmp/alpha_web.log 2>&1 &
echo "[+] Web Server started."

# 4. Launch Alpha Agent (using venv)
nohup 03_FORGE/mcp/.venv/bin/python3 03_FORGE/agent/alpha_brain.py > /tmp/alpha_brain.log 2>&1 &
echo "[+] Alpha Agent started."

# 5. Prevent Sleep Mode (Mac)
nohup caffeinate -d -i > /dev/null 2>&1 &
echo "[+] Sleep Prevention activated."

# 6. Open portal in browser
sleep 2
open http://localhost:8000/04_MULTIMEDIA/3d/portal.html

echo "========================================="
echo "   UNIVERSE LAUNCHED. AWAITING COMMAND.  "
echo "========================================="
