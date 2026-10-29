#!/bin/bash
CONFIG_FILE="04_MULTIMEDIA/3d/config.json"

if [ ! -f "$CONFIG_FILE" ]; then
    echo '{"public_access": false, "sovereign_password": "alpha0az1omega"}' > "$CONFIG_FILE"
    echo "[+] Fichier de configuration cree avec le mot de passe par defaut."
fi

# Lire le mot de passe actuel depuis le JSON
CURRENT_PASS=$(python3 -c "import json; print(json.load(open('$CONFIG_FILE'))['sovereign_password'])")

read -sp "Entrez le mot de passe actuel (Souverain) : " INPUT_PASS
echo ""

if [ "$INPUT_PASS" != "$CURRENT_PASS" ]; then
    echo "[-] Mot de passe incorrect. Acces refuse."
    exit 1
fi

read -sp "Entrez le NOUVEAU mot de passe : " NEW_PASS
echo ""
read -sp "Confirmez le NOUVEAU mot de passe : " CONFIRM_PASS
echo ""

if [ "$NEW_PASS" != "$CONFIRM_PASS" ]; then
    echo "[-] Les mots de passe ne correspondent pas."
    exit 1
fi

# Mise à jour du fichier JSON
python3 -c "import json; f=open('$CONFIG_FILE','r+'); data=json.load(f); data['sovereign_password']='$NEW_PASS'; f.seek(0); json.dump(data,f,indent=2); f.truncate(); f.close()"

echo "[+] Mot de passe mis a jour avec succes."
echo "[+] N'oubliez pas de le noter en lieu sur."
