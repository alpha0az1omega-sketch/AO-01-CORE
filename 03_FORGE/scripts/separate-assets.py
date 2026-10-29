import os
import shutil
from pathlib import Path

PROJECT = Path.home() / "AO-01-CORE"
SRC_DIR = PROJECT / "04_MULTIMEDIA" / "assets" / "imported"
PUBLIC_DIR = PROJECT / "04_MULTIMEDIA" / "assets" / "public"
PRIVATE_DIR = PROJECT / "04_MULTIMEDIA" / "assets" / "private"
REVIEW_DIR = PROJECT / "04_MULTIMEDIA" / "assets" / "review"

# Création des dossiers de destination
for d in [PUBLIC_DIR, PRIVATE_DIR, REVIEW_DIR]:
    d.mkdir(parents=True, exist_ok=True)

print("[+] Tri de vos assets (Public / Privé / Revue)...")

count_pub, count_priv, count_rev = 0, 0, 0

if SRC_DIR.exists():
    for file in SRC_DIR.iterdir():
        if file.is_file():
            name = file.name.lower()
            
            # RÈGLE 1 : Les SVG sont publics (vos créations vectorielles)
            if name.endswith('.svg'):
                shutil.copy2(file, PUBLIC_DIR / file.name)
                count_pub += 1
            
            # RÈGLE 2 : Les captures d'écran et photos sont PRIVÉES
            elif name.startswith('screenshot_') or name.endswith(('.jpg', '.jpeg')):
                shutil.move(file, PRIVATE_DIR / file.name)
                count_priv += 1
                
            # RÈGLE 3 : Les PNG (souvent des logos ou des avatars) et GIF -> REVUE
            elif name.endswith(('.png', '.gif')):
                shutil.move(file, REVIEW_DIR / file.name)
                count_rev += 1
                
            # RÈGLE 4 : Le reste (fichiers bizarres) -> PRIVÉ par sécurité
            else:
                shutil.move(file, PRIVATE_DIR / file.name)
                count_priv += 1

print(f"[+] {count_pub} fichiers SVG (Publics) copiés.")
print(f"[+] {count_priv} captures d'écran/photos (Privés) déplacés.")
print(f"[+] {count_rev} images/GIFs (À réviser) déplacés.")
