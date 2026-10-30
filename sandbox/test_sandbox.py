import hashlib

def plan_technique():
    texte = "Alpha est en ligne"
    hash_sha256 = hashlib.sha256(texte.encode()).hexdigest()
    print(texte)
    print(f"Hash SHA-256 : {hash_sha256}")

plan_technique()