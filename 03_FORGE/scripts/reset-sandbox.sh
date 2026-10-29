#!/bin/bash
echo "========================================="
echo "      WARNING: SANDBOX RESET             "
echo "========================================="
echo "This will delete ALL files inside 03_FORGE/sandbox/."
echo "Are you sure you want to wipe the sandbox? (y/N)"
read -r CONFIRM
if [ "$CONFIRM" = "y" ] || [ "$CONFIRM" = "Y" ]; then
    rm -rf 03_FORGE/sandbox/*
    echo "[+] Sandbox wiped clean. Ready for new experiments."
else
    echo "[-] Reset aborted. Your experiments are safe."
fi
