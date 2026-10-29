import os
from pathlib import Path

DOCS = Path.home() / "Documents"
print("[+] Finding the heaviest directories (this may take a minute)...")

dirs = []
for root, dirs_list, files in os.walk(DOCS):
    # On ignore les dossiers système
    if '.Trash' in root: continue
    size = sum(f.stat().st_size for f in Path(root).glob('**/*') if f.is_file())
    if size > 100 * 1024 * 1024: # Plus de 100 Mo
        dirs.append((size, root))

dirs.sort(reverse=True)
print("\n--- TOP 10 DOSSIERS LES PLUS LOURDS ---")
for size, path in dirs[:10]:
    print(f"{size / (1024*1024):.2f} MB : {path}")
