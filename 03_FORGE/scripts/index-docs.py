import os
from pathlib import Path

HOME = Path.home()
REPORT = HOME / "AO-SECURE-VAULT" / "MASTER_INDEX.md"
IGNORE_DIRS = {'Library', 'Applications', 'System', 'Volumes', '.Trash', '.venv', '.git', 'node_modules'}

print("[+] Building your Knowledge Index...")

with open(REPORT, 'w') as f:
    f.write("# ALPHA0AZ1OMEGA - MASTER DOCUMENT INDEX\n\n")
    for root, dirs, files in os.walk(HOME):
        dirs[:] = [d for d in dirs if d not in IGNORE_DIRS]
        for file in files:
            if file.endswith(('.md', '.txt')) and not file.startswith('.'):
                filepath = Path(root) / file
                try:
                    with open(filepath, 'r', encoding='utf-8', errors='ignore') as doc:
                        lines = [doc.readline().strip() for _ in range(3)]
                        title = next((line for line in lines if line and not line.startswith('#')), lines[0] if lines else "No Title")
                        f.write(f"- **[{file}]({filepath})** : {title[:100]}\n")
                except:
                    pass

print(f"[+] Index created at: {REPORT}")
