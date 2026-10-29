#!/bin/bash
echo "========================================="
echo "   PREPARING GITHUB PUBLICATION          "
echo "========================================="

# 1. Vérification des secrets
echo "[+] Checking for exposed secrets (GPG, keys, passwords)..."
if grep -r -n -E "PRIVATE KEY|password|passphrase" --exclude-dir=".git" --exclude-dir="06_ARCHIVES" .; then
    echo "  [!] WARNING: Potential secrets found. Please review the files above."
else
    echo "  [+] OK: No obvious secrets found."
fi

# 2. Vérification du .gitignore
if [ -f ".gitignore" ]; then
    echo "[+] .gitignore is present."
else
    echo "[!] WARNING: .gitignore is missing. Creating a basic one."
    cat << IGNORE > .gitignore
.DS_Store
*.log
.env
*.key
*.pem
IGNORE
fi

# 3. Taille du dépôt (sans les archives)
echo "[+] Calculating repository size (excluding archives)..."
du -sh --exclude="06_ARCHIVES" . 2>/dev/null || du -sh .

echo "[+] Repository is ready for GitHub preparation."
