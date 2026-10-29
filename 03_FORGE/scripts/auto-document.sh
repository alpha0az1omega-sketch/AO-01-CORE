#!/bin/bash
echo "========================================="
echo "   ALPHA0AZ1OMEGA - AUTO-DOCUMENTATION   "
echo "========================================="

# Documenter le dossier des scripts
cat << DOC > 03_FORGE/scripts/README.md
# Scripts de la Forge (03_FORGE/scripts)

Ce dossier contient les outils exécutables du projet AO-01-CORE.

- \`start-alpha.sh\` : Démarre le serveur web et le cerveau IA.
- \`sync-context.sh\` : Lit le registre et le dernier sceau pour synchroniser l'IA.
- \`generate-sceau.sh\` : Crée un nouveau Sceau de Passation (S01, S02...).
- \`backup.sh\` : Crée une archive de sauvegarde du projet.
- \`hash-all.sh\` : Génère la preuve mathématique (Master Hash) du projet.
- \`auto-audit.sh\` : Vérifie qu'il n'y a pas d'erreurs ou de secrets dans le code.
- \`index-visuals.py\` : Catalogue vos images (SVG, PNG).
- \`extract-knowledge.py\` : Extrait vos textes pour nourrir l'IA.
- \`auto-document.sh\` : (Ce script) Génère la documentation automatique.
DOC

echo "[+] Documentation générée dans 03_FORGE/scripts/README.md"

# On peut ajouter d'autres dossiers ici plus tard
