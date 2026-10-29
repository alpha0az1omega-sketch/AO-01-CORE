import os
from pathlib import Path
from collections import defaultdict

DOCS_DIR = Path.home() / "Documents"
REPORT = Path.home() / "AO-SECURE-VAULT" / "DOCUMENTS_SCAN_REPORT.md"

print("[+] Deep scanning your 'Documents' folder...")

file_types = defaultdict(int)
total_size = 0
dir_sizes = defaultdict(int)

for root, dirs, files in os.walk(DOCS_DIR):
    for file in files:
        if file.startswith('.'): continue
        filepath = Path(root) / file
        ext = filepath.suffix.lower()
        size = filepath.stat().st_size
        
        file_types[ext] += 1
        total_size += size
        
        # Garder la trace du dossier parent le plus haut
        parts = Path(root).relative_to(DOCS_DIR).parts
        top_dir = parts[0] if parts else "Racine_Documents"
        dir_sizes[top_dir] += size

with open(REPORT, 'w') as f:
    f.write("# SCAN DU DOSSIER DOCUMENTS\n\n")
    f.write(f"**Taille totale :** {total_size / (1024*1024):.2f} MB\n\n")
    
    f.write("## Taille par dossier (Top 10)\n")
    sorted_dirs = sorted(dir_sizes.items(), key=lambda x: x[1], reverse=True)[:10]
    for d, s in sorted_dirs:
        f.write(f"- **{d}** : {s / (1024*1024):.2f} MB\n")
        
    f.write("\n## Types de fichiers (Top 10)\n")
    sorted_types = sorted(file_types.items(), key=lambda x: x[1], reverse=True)[:10]
    for ext, count in sorted_types:
        f.write(f"- `{ext if ext else 'Sans extension'}` : {count} fichiers\n")

print(f"[+] Scan complete! Report saved to: {REPORT}")
