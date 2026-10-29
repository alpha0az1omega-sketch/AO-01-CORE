from pathlib import Path
from collections import Counter
import re

INDEX_FILE = Path.home() / "AO-SECURE-VAULT" / "MASTER_INDEX.md"
REPORT = Path.home() / "AO-SECURE-VAULT" / "MASTER_INDEX_SUMMARY.md"

print("[+] Analyzing your Master Knowledge Index...")

themes = Counter()
total_docs = 0

with open(INDEX_FILE, 'r', encoding='utf-8', errors='ignore') as f:
    for line in f:
        if line.startswith("- **["):
            total_docs += 1
            # Extraire le chemin du document
            match = re.search(r'\]\((.*?)\)', line)
            if match:
                path = match.group(1)
                # Extraire le nom du dossier parent
                parent = Path(path).parent.name
                themes[parent] += 1

with open(REPORT, 'w') as f:
    f.write(f"# SYNTHESE DE VOTRE BIBLIOTHÈQUE ({total_docs} documents indexés)\n\n")
    f.write("Voici les dossiers où vous avez le plus de connaissances :\n\n")
    for theme, count in themes.most_common(20):
        f.write(f"- **{theme}** : {count} documents\n")

print(f"[+] Summary created at: {REPORT}")
