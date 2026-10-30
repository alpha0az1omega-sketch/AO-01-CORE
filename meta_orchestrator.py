import ollama
import subprocess
import os
import re

SCEAU_IDENTITE = """
Tu es Alpha, l'agent souverain du projet AO-01-CORE.
Tu es un développeur Python expert.
Tu réponds UNIQUEMENT avec du code Python. Jamais de texte, jamais de Markdown, jamais d'étoiles (**).
"""

def appeler_ia(role, tache):
    print(f"\n🧠 [Agent {role}] Réflexion en cours...")
    try:
        response = ollama.chat(
            model='llama3.2:3b',
            messages=[
                {'role': 'system', 'content': SCEAU_IDENTITE},
                {'role': 'user', 'content': f"Rôle : {role}\nTâche : {tache}"}
            ],
            options={'temperature': 0.0} # Zéro créativité, on veut du code pur
        )
        return response['message']['content']
    except Exception as e:
        print(f"❌ Erreur avec Ollama : {e}")
        return None

def nettoyer_code(code_brut):
    """Enlève tous les déchets Markdown que l'IA ajoute"""
    # 1. Enlever les blocs de code Markdown
    code = re.sub(r'```python', '', code_brut)
    code = re.sub(r'```', '', code)
    # 2. Enlever les étoiles de mise en forme (**)
    code = code.replace("**", "")
    # 3. Enlever les lignes qui commencent par des dièses (titres)
    lignes = code.split('\n')
    lignes_propres = [l for l in lignes if not l.strip().startswith('#') or l.strip().startswith('#!')]
    return '\n'.join(lignes_propres).strip()

def executer_code_securise(code_python, nom_fichier="test_sandbox.py"):
    os.makedirs("sandbox", exist_ok=True)
    filepath = os.path.join("sandbox", nom_fichier)
    
    code_propre = nettoyer_code(code_python)
    
    with open(filepath, "w") as f:
        f.write(code_propre)
        
    print(f"⚙️ Test du code généré dans {filepath}...")
    try:
        result = subprocess.run(["python3", filepath], capture_output=True, text=True, timeout=20)
        if result.returncode == 0:
            return True, result.stdout, code_propre
        else:
            return False, result.stderr, code_propre
    except Exception as e:
        return False, str(e), code_propre

def exporter_pour_github(code_final, nom_fichier_final):
    dossier_export = "A_PUBLIER_SUR_GITHUB"
    os.makedirs(dossier_export, exist_ok=True)
    chemin_export = os.path.join(dossier_export, nom_fichier_final)
    with open(chemin_export, "w") as f:
        f.write(code_final)
    print(f"\n📦 FICHIER PRÊT : '{chemin_export}'")
    print("👉 ALLEZ SUR GITHUB (Navigateur) -> Upload files")

def boucle_autonome(objectif, nom_fichier_final):
    print(f"🎯 OBJECTIF LANCÉ : {objectif}")
    
    plan = appeler_ia("Planificateur", f"Plan technique pour : {objectif}")
    if not plan: return
    
    prompt_codeur = f"""Écris le script Python pour : {plan}.
RÈGLES STRICTES :
1. Pas de texte avant ou après le code.
2. Pas de ** ou de #.
3. Utilise import hashlib pour le SHA-256.
4. Toutes les chaînes de caractères doivent être entre guillemets."""
    
    code = appeler_ia("Codeur", prompt_codeur)
    if not code: return
    
    succes, resultat, code_propre = executer_code_securise(code)
    
    if succes:
        print("✅ SUCCÈS : Le code fonctionne parfaitement !")
        print("--- RÉSULTAT ---")
        print(resultat)
        exporter_pour_github(code_propre, nom_fichier_final)
    else:
        print("❌ ÉCHEC : Le code a planté. L'IA tente de se corriger...")
        print(f"Erreur : {resultat}")
        
        prompt_correcteur = f"""Code Python qui a échoué :
{code_propre}

Erreur Python :
{resultat}

Donne UNIQUEMENT le code corrigé. Pas de texte. Pas de **. Pas de #."""
        
        correction = appeler_ia("Correcteur", prompt_correcteur)
        if correction:
            succes2, resultat2, code_propre2 = executer_code_securise(correction, "test_sandbox_corrige.py")
            if succes2:
                print("✅ SUCCÈS APRÈS CORRECTION !")
                print(resultat2)
                exporter_pour_github(code_propre2, nom_fichier_final)
            else:
                print("❌ L'IA n'a pas réussi. Le modèle 3b est trop petit pour coder.")
                print("💡 CONSEIL : Téléchargez un modèle de code comme 'qwen2.5-coder' avec la commande : ollama run qwen2.5-coder")

if __name__ == "__main__":
    print("=========================================")
    print("   META-ORCHESTRATEUR AO-01-CORE (ALPHA) ")
    print("=========================================")
    objectif_utilisateur = input("\n> Que doit faire l'IA aujourd'hui ? : ")
    nom_fichier = input("> Quel nom donner au fichier final (ex: mon_script.py) ? : ")
    if objectif_utilisateur.strip() and nom_fichier.strip():
        boucle_autonome(objectif_utilisateur, nom_fichier)
