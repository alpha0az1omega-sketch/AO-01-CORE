#!/bin/bash
echo "========================================="
echo "   ALPHA0AZ1OMEGA - CONTEXT SYNCHRONIZER "
echo "========================================="
echo ""
echo "[1] READING REGISTRY..."
cat 01_FOUNDATION/REGISTRE.md
echo ""
echo "[2] READING LATEST SEAL (S05.md)..."
cat 01_FOUNDATION/S05.md
echo ""
echo "[3] READING LATEST HUMAN LOG..."
tail -n 5 JOURNAL.md
echo ""
echo "[4] SYSTEM STATUS..."
echo "Agent Brain: http://localhost:8001 (Offline)"
echo "Web Server: http://localhost:8000 (Offline)"
echo "========================================="
echo "[+] CONTEXT SYNCHRONIZED. YOU MAY PROCEED."
echo "========================================="
