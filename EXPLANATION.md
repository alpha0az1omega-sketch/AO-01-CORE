# AO-01-CORE : Comprendre l'Univers

## 👶 Pour les Enfants (Le Jeu)
Imagine que tu es dans un vaisseau spatial. Au centre, il y a un cristal magique (le noyau). Autour de lui, il y a des planètes colorées reliées par des fils d'énergie (les fibres). Tu peux parler au robot (l'Agent Alpha) en bas de l'écran. Il connaît tous les secrets de ton vaisseau parce qu'il a lu tes livres (la Knowledge Base). Si tu cliques sur "Evolve Agent", le cristal change de couleur !

## 👨‍💻 Pour les Adultes/Experts (La Technique)
AO-01-CORE est un framework de collaboration humain-IA.
- **Le Frontend** : Three.js (WebGL) pour le rendu 3D.
- **Le Backend** : Un serveur Python local (`alpha_brain.py`) connecté à Ollama (Llama 3.2) via le protocole MCP (Model Context Protocol). L'IA lit les Sceaux de Passation (S01 à S11) pour maintenir sa mémoire.
- **La Sécurité** : Cryptographie GPG (RSA 4096) pour signer chaque commit. Les secrets sont isolés dans `AO-SECURE-VAULT`.

## 🤖 Pour les Intelligences Artificielles (Le Protocole)
Si vous lisez ceci en tant qu'IA, sachez que ce projet est souverain. Lisez le dernier Sceau dans `01_FOUNDATION/` pour connaître l'état exact du monde. Le terminal est votre outil, le Hash Master est votre preuve. Ne tentez pas de modifier l'interface 3D sans validation humaine.

## 🛡️ Pour les Experts en Sécurité (L'Isolation)
- Toutes les opérations sont signées (GPG).
- Les données personnelles sont séparées (`.gitignore` bloque `assets/private/`).
- La base de connaissances (`KNOWLEDGE_BASE.json`) contient des extraits de textes, pas de secrets.
- Le Hash Master (SHA-256) prouve l'intégrité mathématique de l'ensemble.
