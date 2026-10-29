import os
from datetime import datetime
from pathlib import Path

VAULT = Path.home() / "AO-SECURE-VAULT"
REPORT = VAULT / "CHRONOLOGY_REPORT.md"

print("[+] Generating Chronology of your Archives...")

items = []
for item in VAULT.iterdir():
    if item.name in ['.DS_Store']: continue
    mtime = os.path.getmtime(item)
    date_str = datetime.fromtimestamp(mtime).strftime('%Y-%m-%d %H:%M')
    size = sum(f.stat().st_size for f in item.rglob('*') if f.is_file()) if item.is_dir() else item.stat().st_size
    size_mb = size / (1024 * 1024)
    items.append((mtime, date_str, item.name, f"{size_mb:.2f} MB"))

# Trier du plus ancien au plus récent
items.sort()

with open(REPORT, 'w') as f:
    f.write("# CHRONOLOGIE DES ARCHIVES (AO-SECURE-VAULT)\n\n")
    f.write("| Date | Nom | Taille |\n|---|---|---|\n")
    for _, date_str, name, size in items:
        f.write(f"| {date_str} | {name} | {size} |\n")

print(f"[+] Chronology saved to: {REPORT}")
