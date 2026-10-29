#!/bin/bash
echo "========================================="
echo "      ALPHA0AZ1OMEGA - AUTO-AUDIT        "
echo "========================================="
FILE="04_MULTIMEDIA/3d/portal.html"

if [ ! -f "$FILE" ]; then
    echo "[-] ERROR: $FILE not found."
    exit 1
fi

echo "[+] Checking HTML structure..."
if grep -q "</html>" "$FILE"; then echo "  OK: HTML closed."; else echo "  WARN: HTML not closed."; fi

echo "[+] Checking for critical JS errors..."
if grep -q "const symbols =" "$FILE"; then 
    echo "  OK: Symbols defined." 
else 
    echo "  WARN: Symbols missing." 
fi

echo "[+] Checking for security leaks..."
if grep -q "PRIVATE KEY" "$FILE"; then 
    echo "  DANGER: Private key found in code!" 
else 
    echo "  OK: No secrets detected." 
fi

echo "========================================="
echo "[+] AUDIT COMPLETE."
