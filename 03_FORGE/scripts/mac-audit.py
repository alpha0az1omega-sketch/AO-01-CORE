import os
from pathlib import Path

# Dossiers système à ignorer (pour ne pas scanner tout le Mac et prendre 3 heures)
IGNORE_DIRS = {'Library', 'Applications', 'System', 'Volumes', 'private', '.Trash', 'node_modules', '.venv', '.git'}

# Extensions sensibles ou importantes
EXTENSIONS = ('.gpg', '.key', '.pem', '.asc', '.zip', '.tar.gz', '.pdf', '.docx', '.md', '.txt')
HOME = Path.home()
REPORT = HOME / "AO-CORE-BACKUPS" / "MAC_AUDIT_REPORT.txt"

print("[+] Scanning your Mac for sensitive files and archives...")
print("[+] This may take 1-2 minutes. Please wait...")

sensitive_files = []
archives = []
documents = []

for root, dirs, files in os.walk(HOME):
    dirs[:] = [d for d in dirs if d not in IGNORE_DIRS]
    for file in files:
        if file.startswith('.'):
            continue
        ext = file.lower()
        filepath = Path(root) / file
        
        if ext.endswith(('.gpg', '.key', '.pem', '.asc')):
            sensitive_files.append(filepath)
        elif ext.endswith(('.zip', '.tar.gz')):
            archives.append(filepath)
        elif ext.endswith(('.pdf', '.docx', '.md', '.txt')):
            documents.append(filepath)

with open(REPORT, 'w') as f:
    f.write("=== MAC SECURITY AUDIT ===\n\n")
    f.write(f"--- SENSITIVE KEYS ({len(sensitive_files)}) ---\n")
    for p in sensitive_files: f.write(f"{p}\n")
    f.write(f"\n--- ARCHIVES ({len(archives)}) ---\n")
    for p in archives: f.write(f"{p}\n")
    f.write(f"\n--- DOCUMENTS ({len(documents)}) ---\n")
    for p in documents: f.write(f"{p}\n")

print(f"[+] Audit complete! Found {len(sensitive_files)} sensitive keys, {len(archives)} archives, {len(documents)} documents.")
print(f"[+] Report saved to: {REPORT}")
