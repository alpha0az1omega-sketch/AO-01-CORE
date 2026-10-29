#!/bin/bash
echo "========================================="
echo "       ALPHA0AZ1OMEGA - VOICE AGENT      "
echo "========================================="
echo "[+] Reading the latest seal (S01.md)..."
sleep 1
say "Initialisation du systeme Alpha 0 az 1 omega. Lecture du dernier sceau de passation."
cat 01_FOUNDATION/S01.md | say -v Thomas
echo "[+] Voice report completed."
