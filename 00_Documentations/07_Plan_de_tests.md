# 07 — Plan de Tests

## Rôle du document

Ce document définit l'ensemble des scénarios permettant de vérifier que chaque composant du système respecte son comportement attendu.

Il garantit que :
- chaque contrat de données est respecté ;
- chaque composant produit les résultats attendus ;
- le workflow complet fonctionne conformément aux besoins du client ;
- la gestion des erreurs marque explicitement les campagnes en échec ;
- l'idempotence est garantie sur les opérations critiques.

---

## Stratégie de test

Le système est validé selon quatre niveaux :

1. **Tests unitaires** — chaque composant isolément
2. **Tests d'intégration** — chaînes de composants
3. **Tests de bout en bout (End-to-End)** — parcours utilisateur complet
4. **Tests de robustesse** — comportement en cas d'incident

Chaque test possède un identifiant stable et fait référence explicite aux composants concernés (Cxx / Exx).

---

# 1. Tests unitaires

## Workflow principal

### TU-001 — Recevoir Demande Campagne (C01)
**Objectif** : Vérifier que le webhook accepte une demande valide.
**Entrée** :
```json
{
  "sujet": "Automatisation IA",
  "plateforme": "YouTube",
  "langue": "fr",
  "nb_resultats": 20
}
```
**Résultat attendu** : Le workflow démarre et transmet le body au composant suivant.

### TU-002 — Valider Paramètres (C02)
**Objectif** : Vérifier le filtrage des payloads invalides.
**Cas testés** :
- ✅ Payload complet → passe
- ❌ `sujet` vide → arrêt
- ❌ `nb_resultats = 0` → arrêt
- ❌ `plateforme` absente → arrêt

**Résultat attendu** : Seul le cas valide continue le workflow.

### TU-003 — Créer Campagne (C03)
**Objectif** : Vérifier la création correcte de la campagne.
**Résultat attendu** :
- Une ligne est créée dans `campagnes` ;
- `statut = 'EN_COURS'` ;
- `execution_id` est renseigné et égal à l'ID de l'exécution en cours ;
- `campagne_id` est retourné pour la suite du workflow.

### TU-004 — Collecte des contenus (C04)
**Objectif** : Vérifier l'appel à l'API YouTube.
**Résultat attendu** : Une liste d'items est renvoyée. Chaque item contient `id` (avec `videoId` ou `channelId` ou `playlistId`) et un objet `snippet` avec titre et description.

### TU-005 — Normalisation (C05)
**Objectif** : Vérifier la conformité des contenus normalisés.
**Résultat attendu** : Chaque contenu contient obligatoirement `campagne_id`, `contenu_source_id`, `titre`, `auteur`, `description`, `date_publication`, `plateforme`.

### TU-006 — Aggregate Contenus (C05a)
**Objectif** : Vérifier que le tableau agrégé contient tous les contenus.
**Résultat attendu** : Un seul item en sortie, contenant `data` = tableau de N contenus (N = `nb_resultats` demandé).

### TU-007 — Préparer Total Campagne (C05b)
**Objectif** : Vérifier le calcul du total et l'extraction du `campagne_id`.
**Résultat attendu** : L'item de sortie contient `campagne_id`, `nb_total = data.length`, `contenus`.

### TU-008 — Update Total Campagne (C05c)
**Objectif** : Vérifier l'écriture de `nb_contenus_total`.
**Résultat attendu** : `campagnes.nb_contenus_total` reflète exactement le nombre de contenus agrégés.

### TU-009 — Redistribuer Contenus (C05d)
**Objectif** : Vérifier l'éclatement du tableau en items individuels.
**Résultat attendu** : Un item de sortie par contenu, chaque item contenant tous les champs normalisés.

### TU-010 — Persistance des contenus (C06)
**Objectif** : Tester l'UPSERT sur `contenu_source_id`.
**Résultat attendu** :
- Premier passage → INSERT ;
- Second passage identique → UPDATE, aucun doublon ;
- `contenu_id` retourné dans les deux cas.

### TU-011 — Analyse IA (C07)
**Objectif** : Valider la sortie brute du LLM.
**Résultat attendu** : La réponse contient un bloc texte parsable en JSON avec les champs `contenu_id`, `resume`, `theme`, `sentiment`, `score_qualite`, `mots_cles`, `langue`.

### TU-012 — Normalisation Analyse IA (C08)
**Objectif** : Vérifier le nettoyage du JSON.
**Cas testés** :
- Réponse avec balises ```json … ``` → nettoyée ;
- Réponse avec blocs `thinking` → ignorés ;
- Réponse JSON pur → parsée directement ;
- Réponse invalide → item d'erreur produit (`error: "Failed to parse JSON"`).

### TU-013 — Persistance Analyse (C09)
**Objectif** : Vérifier l'UPSERT sur `contenu_id`.
**Résultat attendu** :
- INSERT au premier passage ;
- UPDATE au second passage, aucune duplication ;
- `analyse_id` propagé.

### TU-014 — Lecture Analyse et Contenu (C10)
**Objectif** : Vérifier la jointure SQL.
**Résultat attendu** : Un objet consolidé contenant `analyse_id`, `contenu_id`, `campagne_id`, `titre`, `auteur`, `description`, `date_publication`, `plateforme`, `resume`, `theme`, `sentiment`, `score_qualite`, `mots_cles`, `langue`.

### TU-015 — Génération Script IA (C11)
**Objectif** : Vérifier la génération d'un script viable.
**Résultat attendu** : Réponse contenant un JSON `{ "script": "..." }` avec un texte < 60 secondes de lecture, incluant hook, corps, appel à l'action.

### TU-016 — Normalisation Script IA (C12)
**Objectif** : Vérifier la réinjection des identifiants.
**Résultat attendu** : Objet de sortie contenant `campagne_id`, `contenu_id`, `analyse_id`, `script` (chaîne non vide).

### TU-017 — Persistance Script (C13)
**Objectif** : Vérifier l'UPSERT sur `analyse_id`.
**Résultat attendu** :
- INSERT au premier passage ;
- UPDATE au second passage, aucun doublon ;
- `script_id` propagé ;
- `contenu_id` correctement renseigné.

### TU-018 — Préparer Increment (C14)
**Objectif** : Vérifier l'assemblage des identifiants.
**Résultat attendu** : Item de sortie contenant `script_id`, `campagne_id`, `contenu_id`, `analyse_id` cohérents avec les nœuds amont.

### TU-019 — Increment Traites (C15)
**Objectif** : Vérifier l'incrément et la bascule de statut.
**Cas testés** :
- Contenu 1/N traité → `nb_contenus_traites = 1`, `statut` inchangé, `date_fin` NULL ;
- Dernier contenu N/N traité → `nb_contenus_traites = N`, `statut = 'TERMINEE'`, `date_fin` renseignée.

## Workflow d'erreur

### TU-020 — Capture Erreur (E01)
**Objectif** : Vérifier que l'Error Trigger se déclenche.
**Simulation** : Provoquer une erreur dans le workflow principal (ex : credential invalide sur C06).
**Résultat attendu** : E01 reçoit un objet contenant `execution.id`, `execution.error`, `lastNodeExecuted`.

### TU-021 — Structurer Erreur (E02)
**Objectif** : Vérifier l'extraction des champs d'erreur.
**Résultat attendu** : Item de sortie contenant `execution_id`, `niveau = 'ERREUR'`, `etape` (nom du nœud fautif), `message` non vide.

### TU-022 — Log Erreur (E03)
**Objectif** : Vérifier l'insertion dans `journal_execution`.
**Résultat attendu** :
- Une nouvelle ligne dans `journal_execution` ;
- `campagne_id` résolu par jointure sur `execution_id` ;
- `niveau`, `etape`, `message` correctement renseignés.

### TU-023 — Update Campagne Erreur (E04)
**Objectif** : Vérifier la bascule de statut.
**Résultat attendu** : La campagne concernée voit `statut = 'ERREUR'` et `date_fin` posée à `NOW()`.

---

# 2. Tests d'intégration

### TI-001 — C04 → C05
Le retour brut YouTube est correctement normalisé en objets internes.

### TI-002 — C05 → C05a → C05b
La chaîne d'agrégation produit un objet contenant `campagne_id` et `nb_total` cohérents.

### TI-003 — C05b → C05c
Le total calculé est correctement écrit dans `campagnes.nb_contenus_total`.

### TI-004 — C05c → C05d
La redistribution restitue exactement N items, avec toutes les données préservées.

### TI-005 — C05d → C06
Chaque contenu est correctement persisté sans doublon, `contenu_id` propagé.

### TI-006 — C06 → C07
L'analyse IA reçoit bien `contenu_id`, `titre`, `description`, `plateforme`.

### TI-007 — C07 → C08 → C09
La réponse brute du LLM est nettoyée et persistée sans perte de champs.

### TI-008 — C09 → C10
La lecture SQL restitue un objet consolidé complet.

### TI-009 — C10 → C11 → C12
Le script généré est correctement extrait et enrichi des identifiants.

### TI-010 — C12 → C13
Le script est correctement rattaché à son analyse et son contenu.

### TI-011 — C13 → C14 → C15
Le compteur `nb_contenus_traites` est incrémenté d'exactement +1 par contenu.

### TI-012 — E01 → E02 → E03
Une erreur simulée dans le workflow principal produit une entrée `journal_execution` valide.

### TI-013 — E03 → E04
Après journalisation, la campagne concernée bascule bien en `statut = 'ERREUR'`.

### TI-014 — Corrélation execution_id
La campagne créée par C03 est retrouvable par E03/E04 via jointure sur `execution_id`.

---

# 3. Tests de bout en bout (End-to-End)

### TE-001 — Campagne complète nominale
**Scénario** : `POST /lancer-campagne` avec sujet valide, `nb_resultats = 5`.
**Flux vérifié** : C01 → … → C15.
**Résultats attendus** :
- 5 lignes dans `contenus`, 5 dans `analyses`, 5 dans `scripts` ;
- `campagnes.nb_contenus_total = 5` ;
- `campagnes.nb_contenus_traites = 5` ;
- `campagnes.statut = 'TERMINEE'` ;
- `campagnes.date_fin` renseignée ;
- Aucune entrée dans `journal_execution` pour cette campagne.

### TE-002 — Aucun résultat retourné par la plateforme
**Scénario** : Sujet exotique ne retournant aucun contenu.
**Résultats attendus** :
- `nb_contenus_total = 0` ;
- `nb_contenus_traites = 0` ;
- `statut = 'TERMINEE'` (fin immédiate) ;
- Pas d'analyse ni script produits ;
- Pas d'erreur journalisée.

### TE-003 — Idempotence (double lancement identique)
**Scénario** : Lancer deux fois la même campagne (même sujet, même paramètres).
**Résultats attendus** :
- Deux lignes dans `campagnes` ;
- Aucun doublon dans `contenus` (UPSERT sur `contenu_source_id`) ;
- Analyses et scripts mis à jour, pas dupliqués ;
- Les deux campagnes se terminent en `TERMINEE`.

### TE-004 — Campagne volumineuse
**Scénario** : `nb_resultats = 50`.
**Résultats attendus** :
- Tous les contenus traités ;
- `nb_contenus_traites` = `nb_contenus_total` = 50 ;
- Aucun contenu perdu ;
- `statut = 'TERMINEE'`.

---

# 4. Tests de robustesse

### TR-001 — Plateforme indisponible
**Simulation** : Credential YouTube invalide ou API HTTP 503.
**Résultats attendus** :
- Exception levée sur C04 ;
- Workflow d'erreur déclenché : E01 → E02 → E03 → E04 ;
- Une entrée `journal_execution` avec `etape = 'Collecte des contenus'` ;
- `campagnes.statut = 'ERREUR'`, `date_fin` renseignée.

### TR-002 — LLM indisponible
**Simulation** : Credential Anthropic invalide au moment de C07.
**Résultats attendus** :
- Les contenus déjà persistés par C06 sont conservés en base ;
- Workflow d'erreur déclenché ;
- `campagnes.statut = 'ERREUR'` ;
- Entrée journal avec `etape = 'Analyse IA'`.

### TR-003 — JSON IA invalide
**Simulation** : Le LLM renvoie une chaîne non parsable en JSON.
**Résultats attendus** :
- C08 produit un item avec `{ error: "Failed to parse JSON", raw: "..." }` ;
- C09 échoue sur l'UPSERT (champs manquants) ;
- Workflow d'erreur déclenché normalement.

### TR-004 — Corrélation execution_id manquante
**Simulation** : E03/E04 sont déclenchés mais la campagne n'existe pas encore (erreur très précoce avant C03).
**Résultats attendus** :
- `journal_execution` reçoit une ligne avec `campagne_id = NULL` (ou aucune ligne si la jointure ne matche pas) ;
- Le workflow d'erreur ne plante pas ;
- L'incident reste diagnostiquable via `execution_id` dans les logs n8n.

### TR-005 — Cohérence des compteurs
**Simulation** : Interruption manuelle entre C13 et C15 sur 1 contenu.
**Résultats attendus** :
- `nb_contenus_traites < nb_contenus_total` ;
- `statut` reste `EN_COURS` (ne bascule pas prématurément en `TERMINEE`) ;
- Une relance de la campagne (même sujet) ré-UPSERT sans doublon.

### TR-006 — Statut terminal non écrasé
**Simulation** : Un événement C15 arrive après un E04.
**Résultats attendus** :
- Le statut reste `ERREUR` (CASE WHEN dans C15 ne bascule vers `TERMINEE` que si compteur atteint) ;
- `date_fin` posée par E04 n'est pas écrasée.

---

# 5. Matrice de couverture

| Composant | Tests unitaires | Tests d'intégration |
|-----------|-----------------|---------------------|
| C01 | TU-001 | — |
| C02 | TU-002 | — |
| C03 | TU-003 | TI-014 |
| C04 | TU-004 | TI-001 |
| C05 | TU-005 | TI-001, TI-002 |
| C05a | TU-006 | TI-002 |
| C05b | TU-007 | TI-002, TI-003 |
| C05c | TU-008 | TI-003 |
| C05d | TU-009 | TI-004 |
| C06 | TU-010 | TI-005, TI-006 |
| C07 | TU-011 | TI-006, TI-007 |
| C08 | TU-012 | TI-007 |
| C09 | TU-013 | TI-007, TI-008 |
| C10 | TU-014 | TI-008, TI-009 |
| C11 | TU-015 | TI-009 |
| C12 | TU-016 | TI-009, TI-010 |
| C13 | TU-017 | TI-010, TI-011 |
| C14 | TU-018 | TI-011 |
| C15 | TU-019 | TI-011 |
| E01 | TU-020 | TI-012 |
| E02 | TU-021 | TI-012 |
| E03 | TU-022 | TI-012, TI-013, TI-014 |
| E04 | TU-023 | TI-013, TI-014 |

---

# 6. Critères d'acceptation

Le système est validé lorsque :

- ✅ tous les tests unitaires TU-001 à TU-023 sont validés ;
- ✅ tous les tests d'intégration TI-001 à TI-014 sont validés ;
- ✅ tous les tests End-to-End TE-001 à TE-004 sont validés ;
- ✅ tous les tests de robustesse TR-001 à TR-006 sont validés ;
- ✅ aucune perte de données n'est constatée après un incident ;
- ✅ aucune violation des contrats de données (`02.5`) n'est détectée ;
- ✅ aucune campagne ne reste indéfiniment en `EN_COURS` en cas d'erreur ;
- ✅ aucun doublon n'apparaît lors des relances (idempotence).

---

# 7. Dépendances documentaires

**S'appuie sur** :
- `02.1 — Modèle de Données`
- `02.5 — Contrat des Données`
- `03 — Architecture des Workflows`
- `04 — Spécification des Composants`
- `05 — Implémentation Technique`
- `06 — Journal des Décisions d'Architecture`