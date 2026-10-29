import os
import json
from pathlib import Path

VAULT = Path.home() / "AO-SECURE-VAULT"
DOCS = Path.home() / "Documents"
MEMORY_FILE = Path.home() / "AO-01-CORE" / "01_FOUNDATION" / "KNOWLEDGE_BASE.json"

print("[+] Extracting key knowledge into a format the AI can read...")

knowledge = []
count = 0

for root, dirs, files in os.walk(DOCS):
    if not any(k in root for k in ['nexus_zero', 'Preuves', 'Langue_universelle', 'SLAVE']): continue
    
    for file in files:
        if file.endswith(('.md', '.txt')):
            filepath = Path(root) / file
            try:
                with open(filepath, 'r', encoding='utf-8', errors='ignore') as f:
                    content = f.read(1000)
                    if len(content.strip()) > 50:
                        knowledge.append({
                            "source": str(filepath),
                            "title": file,
                            "preview": content.strip()
                        })
                        count += 1
            except: pass
    if count > 500:
        break

with open(MEMORY_FILE, 'w', encoding='utf-8') as f:
    json.dump(knowledge, f, indent=2, ensure_ascii=False)

print(f"[+] Extracted {len(knowledge)} key documents into the Sovereign Knowledge Base.")
