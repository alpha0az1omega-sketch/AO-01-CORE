#!/bin/bash
# L'Archive Souveraine

# 1. Créer le dossier de sauvegarde s'il n'existe pas
BACKUP_DIR="$HOME/AO-CORE-BACKUPS"
mkdir -p "$BACKUP_DIR"

# 2. Trouver le dernier Sceau (ex: S06)
CURRENT_SEAL=$(ls 01_FOUNDATION/S*.json | sort -V | tail -n 1 | xargs basename | cut -d. -f1)
DATE=$(date +%Y%m%d_%H%M)

# 3. Nommer l'archive proprement
BACKUP_NAME="AO-01-CORE_${CURRENT_SEAL}_${DATE}.tar.gz"

echo "========================================="
echo "      CREATING SOVEREIGN BACKUP          "
echo "========================================="
echo "[+] Current Seal: $CURRENT_SEAL"
echo "[+] Creating archive: $BACKUP_NAME"

# 4. Compresser le projet (en excluant les trucs lourds inutiles)
tar --exclude='03_FORGE/mcp/.venv' --exclude='.git' --exclude='.DS_Store' -czf "$BACKUP_DIR/$BACKUP_NAME" .

echo "[+] Backup saved in: $BACKUP_DIR"
echo "[+] Last 5 backups:"
ls -lh "$BACKUP_DIR" | tail -n 5
