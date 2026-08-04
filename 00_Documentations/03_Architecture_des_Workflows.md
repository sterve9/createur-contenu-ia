# 03 — Architecture des Workflows

## Rôle du document

Ce document décrit l'architecture d'orchestration du système technique.
Il répond à la question :

> **Comment les composants collaborent-ils pour transformer une demande utilisateur en contenu analysé, en analyse structurée, puis en script exploitable, tout en garantissant traçabilité et résilience ?**

Il décrit le cycle de vie complet du système, indépendamment de la technologie utilisée pour l'implémenter.

---

## 1. Mission

Automatiser :

- la **collecte** de contenus depuis une plateforme sociale ;
- leur **historisation** dans PostgreSQL ;
- la production d'une **analyse sémantique** par intelligence artificielle ;
- la **génération d'un script vidéo** inspiré du contenu analysé ;
- la **normalisation** des sorties des modèles IA ;
- la **persistance** de l'ensemble ;
- le **suivi d'avancement** de chaque campagne (compteurs et statuts) ;
- la **traçabilité complète des erreurs** via un workflow dédié.

Le tout afin de constituer une base de connaissances exploitable pour la création de contenus.

---

## 2. Principes d'architecture

### Responsabilité unique
Chaque composant possède une mission unique et clairement définie.

### Atomicité
Chaque contenu est enregistré indépendamment.
Une erreur sur un contenu ne bloque jamais le traitement des autres.

### Traçabilité
Tous les contenus sont rattachés à une même campagne grâce au `campagne_id`.
Chaque campagne est également liée à son exécution technique via `execution_id`,
ce qui permet au workflow d'erreur de retrouver la campagne concernée sans dépendance directe.

### Observabilité
L'état d'avancement de chaque campagne est mesurable en temps réel via deux compteurs (`nb_contenus_total`, `nb_contenus_traites`) et un statut (`EN_COURS`, `TERMINEE`, `ERREUR`).

### Indépendance technologique
L'architecture décrit des responsabilités fonctionnelles.
L'implémentation peut être réalisée avec **n8n**, **Python**, **Temporal**, **LangGraph**, **Airflow**… sans modifier cette architecture.

---

## 3. Vue d'ensemble du cycle de vie

### 3.1 Workflow principal
C01 — Recevoir Demande Campagne (Webhook)
│
▼
C02 — Valider Paramètres (IF)
│
▼
C03 — Créer Campagne (statut=EN_COURS, execution_id)
│
▼
C04 — Collecte des contenus (API externe)
│
▼
C05 — Normalisation
│
▼
C05a — Aggregate Contenus
│
▼
C05b — Préparer Total Campagne
│
▼
C05c — Update Total Campagne (écrit nb_contenus_total)
│
▼
C05d — Redistribuer Contenus (1 item = 1 contenu)
│
▼
C06 — Persistance des contenus (UPSERT)
│
▼
C07 — Analyse IA
│
▼
C08 — Normalisation Analyse IA
│
▼
C09 — Persistance Analyse (UPSERT)
│
▼
C10 — Lecture Analyse + Contenu
│
▼
C11 — Génération Script IA
│
▼
C12 — Normalisation Script IA
│
▼
C13 — Persistance Script (UPSERT)
│
▼
C14 — Préparer Increment
│
▼
C15 — Increment Traites (bascule statut à TERMINEE si fini)
│
▼
Fin du workflow

text


### 3.2 Workflow d'erreur (déclenché automatiquement)
E01 — Capture Erreur (Error Trigger)
│
▼
E02 — Structurer Erreur (extrait execution_id, étape, message)
│
▼
E03 — Log Erreur (INSERT journal_execution)
│
▼
E04 — Update Campagne Erreur (statut=ERREUR, date_fin=NOW)

text


Le lien entre les deux workflows est assuré par la colonne `execution_id` de la table `campagnes`, écrite par **C03** et exploitée par **E03** et **E04**.

---

## 4. Description des composants — Workflow principal

### C01 — Recevoir Demande Campagne
**Mission** : Recevoir les paramètres de recherche via un webhook HTTP POST.
**Entrées attendues** : `sujet`, `plateforme`, `langue`, `nb_resultats`.

### C02 — Valider Paramètres
**Mission** : Vérifier que tous les paramètres requis sont présents et valides.
**Règles** : `sujet`, `plateforme`, `langue` non vides ; `nb_resultats > 0`.

### C03 — Créer Campagne
**Mission** : Créer une ligne dans la table `campagnes`.
**Actions** :
- Génère `campagne_id` (fil conducteur de toute l'exécution) ;
- Écrit `statut = EN_COURS` ;
- Enregistre `execution_id` (identifiant technique du run), utilisé plus tard par le workflow d'erreur.

### C04 — Collecte des contenus
**Mission** : Interroger la plateforme cible (YouTube v3 en V1) et récupérer les contenus bruts.

### C05 — Normalisation
**Mission** : Transformer les contenus bruts en objets homogènes indépendants de la plateforme.
**Champs produits** : `campagne_id`, `contenu_source_id`, `titre`, `auteur`, `description`, `date_publication`, `plateforme`.

### C05a — Aggregate Contenus
**Mission** : Regrouper tous les contenus normalisés en un seul item (tableau `data`) afin de permettre le calcul du total.

### C05b — Préparer Total Campagne
**Mission** : Calculer `nb_total` (taille du tableau) et extraire `campagne_id`.

### C05c — Update Total Campagne
**Mission** : Écrire `nb_contenus_total` sur la ligne de la campagne dans la table `campagnes`.
**Importance** : Cette étape doit avoir lieu **avant** la boucle sur les contenus, car elle conditionne la détection de fin par C15.

### C05d — Redistribuer Contenus
**Mission** : Éclater à nouveau le tableau agrégé en items individuels (1 item = 1 contenu) pour que les nœuds suivants traitent chaque contenu indépendamment.

### C06 — Persistance des contenus
**Mission** : Enregistrer chaque contenu de manière idempotente.
**Opération** : `UPSERT` sur la clé unique `contenu_source_id` — un même contenu source ne peut être dupliqué.

### C07 — Analyse IA
**Mission** : Produire une analyse structurée du contenu via un LLM.
**Sortie attendue** : `resume`, `theme`, `sentiment`, `score_qualite`, `mots_cles`, `langue`.

### C08 — Normalisation Analyse IA
**Mission** : Extraire et parser proprement le JSON retourné par le LLM, en gérant les balises markdown (```json … ```), les blocs `thinking`, et tout formatage résiduel.

### C09 — Persistance Analyse
**Mission** : Enregistrer l'analyse dans la table `analyses`.
**Opération** : `UPSERT` sur `contenu_id` — une seule analyse par contenu.

### C10 — Lecture Analyse et Contenu
**Mission** : Recharger depuis la base l'ensemble des informations (contenu + analyse) nécessaires à la génération du script, via une jointure SQL.
**Objectif** : Éviter tout couplage entre C11 et l'état mémoire du workflow.

### C11 — Génération Script IA
**Mission** : Produire un script vidéo (<60s) optimisé pour TikTok / Shorts / Reels à partir du couple contenu + analyse.

### C12 — Normalisation Script IA
**Mission** : Extraire le champ `script` du JSON retourné par le LLM et réinjecter les identifiants relationnels (`campagne_id`, `contenu_id`, `analyse_id`) pour préparer la persistance.

### C13 — Persistance Script
**Mission** : Enregistrer le script dans la table `scripts`.
**Opération** : `UPSERT` sur `analyse_id` — un seul script par analyse.

### C14 — Préparer Increment
**Mission** : Assembler les identifiants nécessaires (`script_id`, `campagne_id`, `contenu_id`, `analyse_id`) pour l'incrément de compteur.

### C15 — Increment Traites
**Mission** : Mettre à jour la campagne à la fin du traitement de chaque contenu.
**Opération SQL** :
- `nb_contenus_traites = nb_contenus_traites + 1` ;
- si `nb_contenus_traites + 1 >= nb_contenus_total` → `statut = 'TERMINEE'` et `date_fin = NOW()` ;
- sinon → statut et `date_fin` inchangés.

---

## 5. Description des composants — Workflow d'erreur

Le workflow d'erreur est un workflow **indépendant** déclenché automatiquement lorsqu'une erreur survient dans le workflow principal. Il est rattaché via la fonctionnalité "Error Workflow" de la plateforme d'orchestration.

### E01 — Capture Erreur
**Mission** : Point d'entrée du workflow d'erreur.
**Déclenchement** : Automatique dès qu'un nœud du workflow principal lève une exception.

### E02 — Structurer Erreur
**Mission** : Extraire les données utiles du contexte d'erreur :
- `execution_id` : identifiant du run en échec ;
- `niveau` : `"ERREUR"` en V1 ;
- `etape` : nom du nœud ayant échoué (`error.node.name` ou `lastNodeExecuted`) ;
- `message` : description, message principal, ou concaténation des messages.

### E03 — Log Erreur
**Mission** : Enregistrer l'erreur dans la table `journal_execution`.
**Mécanisme** : `INSERT SELECT` qui retrouve le `campagne_id` en joignant sur `execution_id` dans `campagnes`. Ainsi l'erreur reste liée à la campagne concernée sans dépendance au workflow principal.

### E04 — Update Campagne Erreur
**Mission** : Basculer la campagne en état terminal d'erreur.
**Actions** : `statut = 'ERREUR'`, `date_fin = NOW()`.

---

## 6. Logique de comptage et de statuts

### 6.1 Compteurs sur `campagnes`

| Champ | Écrit par | Fréquence |
|-------|-----------|-----------|
| `nb_contenus_total` | **C05c** | Une seule fois, avant la boucle |
| `nb_contenus_traites` | **C15** | +1 à chaque script persisté |
| `date_fin` | **C15** (fin normale) ou **E04** (fin en erreur) | Une seule fois |

### 6.2 Transitions de statut

| Statut | Écrit par | Condition |
|--------|-----------|-----------|
| `EN_COURS` | **C03** | À la création de la campagne |
| `TERMINEE` | **C15** | Quand `nb_contenus_traites >= nb_contenus_total` |
| `ERREUR` | **E04** | Sur toute exception du workflow principal |

### 6.3 Diagramme d'états
text

    C03                       C15
[néant] ────► EN_COURS ─────────► TERMINEE
│
│ E04 (exception)
▼
ERREUR

text


Un statut terminal (`TERMINEE` ou `ERREUR`) n'est jamais réécrit.

---

## 7. Contraintes techniques

Le système garantit :

- **Unicité** :
  - un contenu ne peut être enregistré qu'une seule fois selon `contenu_source_id` ;
  - une analyse au plus par contenu (clé `contenu_id` sur `analyses`) ;
  - un script au plus par analyse (clé `analyse_id` sur `scripts`).

- **Immutabilité** : les analyses et scripts déjà persistés ne sont pas supprimés intempestivement (opérations en `UPSERT`).

- **Intégrité relationnelle** :
  - une analyse ne peut exister sans contenu associé valide ;
  - un script ne peut exister sans analyse et contenu associés valides ;
  - la chaîne `campagne_id → contenu_id → analyse_id → script_id` est toujours reconstituable.

- **Résilience** :
  - toute exception déclenche le workflow d'erreur E01→E04 ;
  - la campagne est explicitement marquée `ERREUR` avec date de fin ;
  - les contenus, analyses et scripts déjà persistés avant l'erreur sont conservés.

- **Corrélation workflow ↔ métier** : la colonne `execution_id` sur `campagnes` permet au workflow d'erreur de retrouver la campagne concernée sans partage d'état mémoire.

---

## 8. Validation

L'architecture est considérée comme valide lorsque :

1. Le flux principal suit l'ordre strict :
   **C01 → C02 → C03 → C04 → C05 → C05a → C05b → C05c → C05d → C06 → C07 → C08 → C09 → C10 → C11 → C12 → C13 → C14 → C15**.

2. Chaque contenu, analyse et script est traçable via les identifiants relationnels.

3. Le script généré est traçable jusqu'au contenu source via `campagne_id`, `contenu_id`, `analyse_id`.

4. Une panne externe (API plateforme, LLM, réseau) déclenche systématiquement le workflow d'erreur E01→E04 et met la campagne en statut `ERREUR`.

5. Les données déjà persistées avant une erreur ne sont pas perdues.

6. Une campagne complète sans incident termine avec `statut = TERMINEE`, `nb_contenus_traites = nb_contenus_total` et `date_fin` renseignée.

---

## 9. Chaîne de traçabilité
execution_id (technique)
│
▼
campagne_id (métier)
│
▼
contenu_id
│
▼
analyse_id
│
▼
script_id

text


**Deux niveaux de traçabilité coexistent** :

- **Technique** : `execution_id` permet de relier le run d'orchestration à la campagne, notamment lorsqu'une erreur survient.
- **Métier** : `campagne_id → contenu_id → analyse_id → script_id` permet de retracer chaque script jusqu'à son contenu source et sa campagne d'origine.

---

## 10. Dépendances documentaires

**S'appuie sur** :
- `02.1 — Modèle de Données`
- `02.2 — Dictionnaire des Données`
- `02.3 — Schéma Physique des Données`
- `02.4 — Mapping des Données`
- `02.5 — Contrat des Données`

**Sert de référence pour** :
- `04 — Spécification des Composants`
- `05 — Implémentation Technique`
- `07 — Plan de Tests`