#!/bin/bash
mkdir -p 04_MULTIMEDIA
cat << HTML > 04_MULTIMEDIA/index.html
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AO-01-CORE | Portail Souverain</title>
    <style>
        body { background-color: #0d1117; color: #c9d1d9; font-family: monospace; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
        .container { border: 1px solid #30363d; padding: 40px; border-radius: 10px; box-shadow: 0 0 20px rgba(88, 166, 255, 0.1); text-align: center; }
        h1 { color: #58a6ff; letter-spacing: 2px; }
        p { color: #8b949e; }
        .status { color: #3fb950; font-weight: bold; }
        .hash { font-size: 0.8em; color: #d2a8ff; word-break: break-all; }
    </style>
</head>
<body>
    <div class="container">
        <h1>ALPHA0AZ1OMEGA</h1>
        <p>Statut du Vaisseau : <span class="status">EN LIGNE</span></p>
        <p>Module : Terminal vers Visuel (WASM Ready)</p>
        <p class="hash">Sceau Actuel : S01 (5c992bbf...)</p>
    </div>
</body>
</html>
HTML
echo "[+] Interface visuelle générée dans 04_MULTIMEDIA/index.html"
