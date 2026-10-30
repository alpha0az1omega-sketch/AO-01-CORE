**Corrigé du Code**


import os
import hashlib

def afficher_ligne():
    os.system('clear')  # Nettoyer l'écran
    print("Alpha est en ligne")

def calculer_hash():
    message = "Alpha est en ligne"
    hash_sha256 = hashlib.sha256(message.encode()).hexdigest()
    return hash_sha256

def afficher_hash_sha256():
    os.system('clear')  # Nettoyer l'écran
    print("Alpha est en ligne")
    print("Hash SHA-256 : ", calculer_hash())

afficher_ligne()
afficher_hash_sha256()


**Raisonnement**

1.  L'erreur était due à une chaîne de caractères non fermée. J'ai ajouté un guillemet supplémentaire à la fin de la chaîne pour la fermer correctement.
2.  J'ai également réorganisé les fonctions pour que `calculer_hash()` soit appelée directement dans `afficher_hash_sha256()`. Cela simplifie le code et évite de répéter la même opération dans deux fonctions différentes.