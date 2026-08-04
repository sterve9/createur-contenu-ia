# 01 - Besoin Client

## Rôle du document
Ce document formalise le besoin exprimé par le client avant toute conception technique.
Il constitue le point de départ de la mission d'architecture.
Il répond aux questions suivantes :

* Quel problème le client souhaite-t-il résoudre ?
* Pourquoi ce problème est-il important ?
* Comment ce problème est-il traité aujourd'hui ?
* Quelles sont les limites de la méthode actuelle ?
* Quel est le résultat attendu ?
* Quelles sont les contraintes du client ?
* Quelles tâches doivent rester humaines ?
* Quels seront les critères d'acceptation de la solution ?

Ce document ne décrit jamais :
* l'architecture du système ;
* les composants ;
* les workflows ;
* les technologies utilisées ;
* la base de données ;
* les choix d'implémentation.

---

## 1. Expression du besoin
Le créateur de contenu IA souhaite industrialiser son processus de création de vidéos courtes destinées aux réseaux sociaux.
Aujourd'hui, chaque vidéo est produite manuellement à travers une succession d'outils indépendants. Bien que chaque outil soit performant individuellement, leur enchaînement demande de nombreuses manipulations répétitives.
Le client souhaite réduire ce temps de production tout en conservant la qualité créative de ses contenus.

## 2. Problème métier
Le principal problème n'est pas la création de contenu.
Le véritable problème est la multiplication des tâches techniques entre l'idée initiale et la publication finale.
Chaque vidéo nécessite :
* la recherche d'une idée ;
* la rédaction d'un scénario ;
* la génération des personnages ;
* la génération des images ;
* la génération des vidéos ;
* le montage ;
* l'ajout des sous-titres ;
* la préparation à la publication.

Ces opérations mobilisent une part importante du temps de travail sans créer directement de valeur pour l'audience.

## 3. Situation actuelle
Le processus actuel repose entièrement sur des interventions manuelles.
Le créateur copie des informations d'un outil à un autre, vérifie les résultats, télécharge les fichiers, les importe dans un logiciel de montage puis prépare la publication sur les réseaux sociaux.
Chaque étape dépend de la précédente et nécessite une intervention humaine.

## 4. Limites de la méthode actuelle
Les principales limites sont :
* temps de production élevé ;
* nombreuses manipulations répétitives ;
* risque d'erreurs lors des copies ou des transferts ;
* difficulté à produire plusieurs vidéos par jour ;
* faible capacité de passage à l'échelle.

## 5. Résultat attendu
Le client souhaite disposer d'un système capable de préparer automatiquement la majorité du travail technique afin qu'il puisse se concentrer sur la création des idées, la narration et la stratégie éditoriale.
Le système devra fournir un processus clair, reproductible et facilement extensible.

## 6. Contraintes métier
Le système devra respecter les contraintes suivantes :
* conserver la cohérence des personnages sur toute une histoire ;
* préserver la qualité narrative des scénarios ;
* permettre des corrections manuelles lorsque cela est nécessaire ;
* rester adaptable à l'évolution des outils IA utilisés.

## 7. Tâches qui doivent rester humaines
Les décisions suivantes restent sous la responsabilité du créateur :
* choisir les sujets des vidéos ;
* définir l'angle éditorial ;
* raconter l'histoire ;
* valider le rendu final ;
* décider de la publication.

Ces activités constituent le cœur de son expertise et ne doivent pas être automatisées.

## 8. Critères d'acceptation
La solution sera considérée comme satisfaisante si elle permet :
* de réduire significativement le temps nécessaire pour produire une vidéo ;
* de diminuer les manipulations répétitives ;
* de standardiser le processus de production ;
* de conserver la qualité des contenus publiés ;
* de permettre l'ajout de nouveaux outils sans remettre en cause le fonctionnement global.

---

## 9. Périmètre couvert par la V1 STABLE

Cette section fait le point sur ce que le système livré en V1 couvre réellement du besoin exprimé ci-dessus, et ce qui reste à traiter dans les versions ultérieures. Elle sera mise à jour à chaque livraison majeure.

### 9.1 Ce qui est livré en V1

La V1 STABLE couvre principalement **l'amont du processus créatif** :

- **Recherche d'inspiration automatisée** : à partir d'un sujet, le système collecte automatiquement N contenus existants sur une plateforme (YouTube en V1).
- **Analyse sémantique des contenus** : chaque contenu collecté est analysé par IA pour en extraire un résumé, un thème, un sentiment, un score de qualité, des mots-clés et la langue.
- **Génération de scripts vidéo courts** : pour chaque contenu analysé, le système produit un script vidéo de moins de 60 secondes prêt à être tourné (structure hook / corps / appel à l'action).
- **Historisation complète** : toutes les campagnes, contenus, analyses et scripts sont conservés en base et traçables de bout en bout.
- **Suivi d'avancement en temps réel** : chaque campagne dispose de compteurs et d'un statut (en cours / terminée / erreur) permettant de savoir instantanément où en est un traitement.
- **Résilience aux incidents** : toute erreur est journalisée et la campagne concernée est explicitement marquée en erreur.

En pratique, la V1 permet au créateur de **remplacer plusieurs heures de veille et de brainstorming manuel** par une seule requête, et de recevoir en retour une base de scripts exploitables.

### 9.2 Ce qui n'est PAS couvert par la V1

Les étapes suivantes du besoin restent **entièrement manuelles** aujourd'hui :

- génération des personnages ;
- génération des images ;
- génération des vidéos ;
- montage des séquences ;
- ajout des sous-titres ;
- préparation à la publication ;
- publication multi-plateforme ;
- suivi des performances après publication.

### 9.3 Ce qui fait l'objet du cadrage V2

La V2 doit répondre à un **vrai problème créateur** identifié parmi les étapes ci-dessus (ou parmi des besoins connexes non encore exprimés).

Le cadrage V2 s'attachera à :
1. **identifier le problème le plus douloureux** parmi ceux qui restent à traiter ;
2. **prioriser un axe unique** plutôt que de vouloir tout couvrir ;
3. **vérifier que la solution envisagée apporte une valeur métier claire**, mesurable, et pas seulement une amélioration technique.

Le détail du cadrage V2 est piloté par la tâche `V2-001` du Project Tracker.