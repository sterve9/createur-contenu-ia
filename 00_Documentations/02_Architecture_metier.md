

## Rôle du document
Ce document décrit le fonctionnement métier du système indépendamment de toute technologie.
Il transforme le besoin du client en une architecture fonctionnelle composée d'objets métier, de processus et de composants.
Il répond aos questions suivantes :

* Quel est le cœur du métier ?
* Quels sont les objets métier du système ?
* Quel est l'objet métier central ?
* Quel est le cycle de vie de cet objet ?
* Quels composants métier gravitent autour de lui ?
* Comment les informations circulent-elles dans le système ?
* Quels principes d'architecture guident la conception ?

Ce document ne décrit jamais :
* les workflows n8n ;
* les APIs ;
* la base de données ;
* les scripts ;
* les technologies utilisées.

---

## 1. Mission du système
Le système a pour mission d'assister le créateur de contenu IA dans la préparation de ses contenus en automatisant les tâches techniques répétitives tout en préservant les décisions créatives.
Le système ne crée pas les idées à la place du créateur.
Il prépare l'ensemble des éléments nécessaires à la production d'un contenu prêt à être publié.

## 2. Les objets métier
Le système repose sur les objets métier suivants :
* Sujet de contenu
* Scénario
* Personnage
* Média (image ou vidéo)
* Séquence vidéo
* Projet de contenu
* Publication

Chaque objet possède son propre cycle de vie et ses propres règles métier.

## 3. Objet métier central
L'objet central du système est :
**Le Projet de contenu.**
Il représente une vidéo complète en cours de préparation.
Tous les autres objets gravitent autour de lui :
* un projet contient un scénario ;
* un scénario contient plusieurs séquences ;
* chaque séquence utilise des personnages ;
* chaque personnage produit des images ;
* les images produisent des vidéos ;
* les vidéos composent le projet final.

Le Projet de contenu constitue donc le point de convergence de l'ensemble du système.

## 4. Cycle de vie de l'objet central
Le Projet de contenu suit le cycle de vie suivant :

* **Création**
  Le créateur choisit un sujet et décide de produire une nouvelle vidéo.
* **Conception**
  Le scénario est rédigé.
  Les personnages sont définis.
  Les dialogues sont préparés.
* **Génération**
  Les images sont produites.
  Les séquences vidéo sont générées.
  Les ressources sont organisées.
* **Assemblage**
  Les séquences sont réunies.
  Les sous-titres sont ajoutés.
  Le montage est préparé.
* **Validation**
  Le créateur vérifie :
  * la cohérence de l'histoire ;
  * la qualité visuelle ;
  * le rythme ;
  * la narration.
* **Publication**
  Le projet devient une publication destinée à une ou plusieurs plateformes.
* **Archivage**
  Le projet reste disponible afin d'être réutilisé ou décliné sous d'autres formats.

## 5. Les composants métier
Le système est organisé autour des composants suivants :

* **C01 — Gestion des sujets**  
  *Mission :* Recevoir ou générer les idées de contenu.
* **C02 — Génération du scénario**  
  *Mission :* Transformer une idée en scénario structuré.
* **C03 — Gestion des personnages**  
  *Mission :* Créer les personnages utilisés dans les scènes et garantir leur cohérence.
* **C04 — Génération des médias**  
  *Mission :* Produire les images et les vidéos nécessaires au scénario.
* **C05 — Assemblage du projet**  
  *Mission :* Assembler les différentes séquences pour constituer la vidéo complète.
* **C06 — Validation éditoriale**  
  *Mission :* Permettre au créateur de contrôler et valider le résultat.
* **C07 — Publication**  
  *Mission :* Préparer la diffusion du contenu vers les différentes plateformes.

## 6. Flux métier
Le système suit le flux fonctionnel suivant :
```
Idée
 ↓
Scénario
 ↓
Personnages
 ↓
Images
 ↓
Vidéos
 ↓
Projet
 ↓
Validation
 ↓
Publication
```
Chaque étape enrichit le projet sans modifier le rôle des étapes précédentes.

## 7. Principes d'architecture
L'architecture repose sur les principes suivants :
* **Responsabilité unique :** chaque composant réalise une mission métier précise.
* **Objet central unique :** toutes les informations sont rattachées au Projet de contenu.
* **Enrichissement progressif :** le projet s'enrichit au fil des étapes sans perdre son identité.
* **Séparation des responsabilités :** les décisions créatives restent humaines, les tâches répétitives sont automatisées.
* **Indépendance technologique :** le fonctionnement métier ne dépend d'aucun outil particulier.

## 8. Validation
L'architecture métier est considérée comme valide lorsque :
* tous les objets métier sont identifiés ;
* un objet central est clairement défini ;
* son cycle de vie est complet ;
* chaque composant possède une mission distincte ;
* le flux métier est cohérent de bout en bout ;
* aucune décision technique n'apparaît dans ce document.