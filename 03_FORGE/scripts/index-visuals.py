import os
import json
import shutil
from pathlib import Path

HOME = Path.home()
PROJECT = HOME / "AO-01-CORE"
DEST_DIR = PROJECT / "04_MULTIMEDIA" / "assets" / "imported"
INDEX_FILE = PROJECT / "01_FOUNDATION" / "VISUAL_INDEX.json"

DEST_DIR.mkdir(parents=True, exist_ok=True)
IGNORE_DIRS = {'Library', 'Applications', 'System', 'node_modules', '.git', '.venv', '.Trash'}

print("[+] Scanning for visual assets (SVG, PNG, JPG)...")
visuals = []

# On scanne le Bureau, les Documents et le Vault
for scan_dir in [HOME / "Desktop", HOME / "Documents", HOME / "AO-SECURE-VAULT"]:
    if not scan_dir.exists(): continue
    for root, dirs, files in os.walk(scan_dir):
        dirs[:] = [d for d in dirs if d not in IGNORE_DIRS]
        for file in files:
            if file.lower().endswith(('.svg', '.png', '.jpg', '.jpeg', '.gif')):
                filepath = Path(root) / file
                size = filepath.stat().st_size
                # On ne copie que si c'est un fichier de moins de 5 Mo pour éviter les vidéos déguisées
                if size < 5 * 1024 * 1024:
                    dest_path = DEST_DIR / file
                    # Si le fichier existe déjà, on ajoute un suffixe pour ne pas écraser
                    if dest_path.exists():
                        dest_path = DEST_DIR / f"{filepath.stem}_v2{filepath.suffix}"
                    
                    try:
                        shutil.copy2(filepath, dest_path)
                        visuals.append({
                            "original_path": str(filepath),
                            "project_path": str(dest_path.relative_to(PROJECT)),
                            "name": file,
                            "size_kb": round(size / 1024, 2)
                        })
                    except Exception as e:
                        pass

with open(INDEX_FILE, 'w', encoding='utf-8') as f:
    json.dump(visuals, f, indent=2, ensure_ascii=False)

print(f"[+] Found and imported {len(visuals)} unique visual assets!")
print(f"[+] Visual Index saved to: 01_FOUNDATION/VISUAL_INDEX.json")
