# 06 — Journal des Décisions d'Architecture (ADR)

## Rôle du document

Ce document consigne les décisions d'architecture prises tout au long du projet.

Chaque ADR explique :
- le **contexte** ;
- la **décision retenue** ;
- la **justification** ;
- les **conséquences** ;
- les **alternatives rejetées** *(pour les ADR V1 STABLE et V2)*.

Il permet de comprendre *pourquoi* certaines orientations techniques ou fonctionnelles ont été choisies.

---

## Convention de rédaction

- Les ADR sont **immuables** : une fois écrits, ils ne sont jamais réécrits. Une décision qui remplace une décision antérieure fait l'objet d'un **nouvel ADR** qui référence l'ancien.
- Les ADR sont numérotés chronologiquement, sans trou.
- Chaque ADR est atomique : une seule décision par ADR.

---

# Partie 1 — Décisions fondatrices

## ADR-0001 — Le contenu est l'objet métier central

### Contexte
Le système manipule plusieurs objets :
- campagne ;
- contenu ;
- analyse IA ;
- script ;
- publication / tableau de bord.

### Décision
Le contenu est défini comme l'objet métier central.

### Justification
Toutes les opérations du système sont réalisées autour d'un contenu :
- collecte ;
- normalisation ;
- sauvegarde ;
- analyse IA ;
- génération de script.

### Conséquences
Tous les composants propagent le `contenu_id`.

---

## ADR-0002 — Une campagne regroupe les contenus

### Contexte
Un utilisateur peut lancer plusieurs recherches successives.

### Décision
Chaque exécution crée une nouvelle campagne.

### Justification
Cela garantit :
- la traçabilité ;
- l'historique ;
- la comparaison entre campagnes.

### Conséquences
Tous les contenus possèdent un `campagne_id`.

---

## ADR-0003 — Les données brutes sont conservées

### Contexte
Les plateformes peuvent modifier leur format de réponse.

### Décision
La collecte conserve les données sans transformation métier.
La normalisation est réalisée dans un composant dédié.

### Justification
Séparer la collecte de la transformation facilite la maintenance et permet de changer de source de données sans impacter le reste du système.

### Conséquences
Le composant de collecte reste indépendant du modèle de données interne.

---

## ADR-0004 — La normalisation précède toute persistance

### Contexte
Les plateformes retournent des formats hétérogènes.

### Décision
Toutes les données sont converties vers un modèle commun avant d'être enregistrées.

### Justification
La base PostgreSQL ne dépend plus du format des plateformes.

### Conséquences
Le remplacement d'une API ne nécessite pas de modifier le schéma de la base.

---

## ADR-0005 — Unicité des contenus

### Contexte
Une même vidéo peut être retrouvée lors de plusieurs campagnes.

### Décision
L'identifiant d'origine (`contenu_source_id`) devient la clé métier de référence.

### Justification
Éviter les doublons et permettre les mises à jour.

### Conséquences
Les insertions utilisent un mécanisme d'Upsert.

---

## ADR-0006 — L'IA enrichit les données sans les modifier

### Contexte
Le contenu d'origine doit rester fidèle à la source.

### Décision
L'IA produit des données complémentaires (`resume`, `theme`, `sentiment`, `score_qualite`, `mots_cles`, `langue`) sans altérer les données collectées.

### Justification
Séparer les faits observés des interprétations générées par l'IA.

### Conséquences
Les analyses sont stockées dans une table dédiée (`analyses`) reliée par `contenu_id`, et propagent un `analyse_id`.

---

## ADR-0007 — Les scripts sont des objets indépendants

### Contexte
Un même contenu ou une même analyse peut donner lieu à plusieurs variantes de scripts réutilisables.

### Décision
Les scripts sont stockés séparément des analyses IA.

### Justification
Permettre la génération et l'évolution de scripts sans modifier l'analyse initiale.

### Conséquences
Les scripts disposent de leur propre table (`scripts`) liée à l'analyse via `analyse_id`, propageant un `script_id`.

---

## ADR-0008 — Les composants sont indépendants

### Contexte
Le système doit évoluer facilement.

### Décision
Chaque composant possède une responsabilité unique.

### Justification
Un composant peut être remplacé ou réécrit sans impacter les autres.

### Conséquences
L'architecture reste modulaire et évolutive.

---

## ADR-0009 — La base PostgreSQL est la source de vérité

### Contexte
Les résultats peuvent être affichés dans plusieurs interfaces (tableaux de bord, application web, exports).

### Décision
Toutes les données officielles sont enregistrées dans PostgreSQL.
Les interfaces ne sont que des vues ou des exports consolidés (composants prévus en V2).

### Justification
Éviter les incohérences entre plusieurs supports de consultation.

### Conséquences
Toute évolution de l'interface n'affecte pas la persistance des données.

---

## ADR-0010 — L'ajout de nouvelles plateformes ne modifie pas l'architecture

### Contexte
Le système doit pouvoir intégrer de nouvelles sources (TikTok, YouTube, Instagram, LinkedIn, etc.).

### Décision
La plateforme de collecte est considérée comme un détail d'implémentation.

### Justification
L'architecture repose sur un modèle de données normalisé et non sur une plateforme spécifique.

### Conséquences
L'ajout d'une nouvelle source nécessite uniquement un nouveau composant de collecte et d'adaptation, sans remettre en cause les autres composants du système.

---

# Partie 2 — Décisions V1 STABLE

## ADR-0011 — Le workflow d'erreur est un workflow indépendant

### Contexte
La V1 doit garantir qu'aucune campagne ne reste indéfiniment en `EN_COURS` en cas d'incident. Deux approches étaient envisageables :
- (A) Intégrer la gestion d'erreur comme composant final du workflow principal ;
- (B) Externaliser la gestion d'erreur dans un workflow dédié.

### Décision
Créer un **workflow d'erreur indépendant** (E01→E04), rattaché au workflow principal via le mécanisme *Error Workflow* de n8n.

### Justification
- **Séparation des responsabilités** : la logique métier (workflow principal) reste lisible.
- **Couverture universelle** : le workflow d'erreur intercepte les exceptions de **tout nœud**, sans code de tentative de rattrapage dans chacun.
- **Réutilisabilité** : le même workflow d'erreur pourra couvrir plusieurs workflows futurs (V2).

### Alternatives rejetées
- **Try/catch dans chaque nœud** : verbeux, difficile à maintenir, fait fuir la logique d'erreur partout.
- **Composant final "Gestion d'erreurs"** : n'aurait pas capté les exceptions au milieu du flux.

### Conséquences
- Deux workflows n8n distincts à maintenir.
- Nécessite un mécanisme de corrélation → voir ADR-0012.

---

## ADR-0012 — Corrélation entre workflows via `execution_id`

### Contexte
Le workflow d'erreur (indépendant, cf. ADR-0011) doit pouvoir retrouver la campagne concernée par l'incident, sans partager de mémoire avec le workflow principal.

### Décision
Stocker `execution_id` (identifiant technique de l'exécution n8n) sur la table `campagnes` au moment de la création (C03). Le workflow d'erreur (E03, E04) retrouve la campagne par jointure SQL sur `execution_id`.

### Justification
- **Découplage total** entre les deux workflows.
- **Pas de dépendance** au mécanisme mémoire de n8n (Error Trigger fournit `execution.id`).
- **Auditable** : la corrélation reste visible en base même après la fin d'exécution.

### Alternatives rejetées
- **Passer `campagne_id` via variables globales** : couplage fort, casse en cas de changement d'orchestrateur.
- **Chercher la dernière campagne en `EN_COURS`** : race condition en cas de campagnes parallèles.

### Conséquences
- Ajout de la colonne `execution_id` (indexée) sur `campagnes`.
- Le workflow d'erreur reste opérationnel même si le workflow principal a été supprimé ou modifié.

---

## ADR-0013 — Les compteurs et statuts sont portés par la campagne

### Contexte
Il faut pouvoir répondre à tout moment :
- Combien de contenus une campagne a-t-elle collectés ?
- Combien ont été effectivement traités ?
- Est-elle en cours, terminée, en erreur ?

### Décision
Ajouter sur la table `campagnes` :
- `nb_contenus_total` (écrit une fois par C05c) ;
- `nb_contenus_traites` (incrémenté par C15) ;
- `statut` ∈ {`EN_COURS`, `TERMINEE`, `ERREUR`} ;
- `date_fin`.

### Justification
- **Observabilité en temps réel** : une simple requête SELECT permet de connaître l'avancement.
- **Auto-détection de fin de campagne** sans planificateur externe.
- **Pas de nouveaux outils** (monitoring externe, cache Redis, …) requis.

### Alternatives rejetées
- **Compter à la volée via COUNT(scripts)** : coûteux, ne permet pas de comparer à un total attendu.
- **Compteur en mémoire n8n** : perdu à chaque redémarrage.

### Conséquences
- Chaque étape critique doit garantir l'intégrité des compteurs.
- Contrainte CHECK : `nb_contenus_traites ≤ nb_contenus_total`.

---

## ADR-0014 — Idempotence par UPSERT systématique

### Contexte
Une campagne peut être relancée (bug, retry, exploration manuelle). Il faut garantir qu'aucun doublon n'est créé.

### Décision
Utiliser des **UPSERT** systématiques sur les 3 clés métier :
- `contenus.contenu_source_id` (C06) ;
- `analyses.contenu_id` (C09) ;
- `scripts.analyse_id` (C13).

### Justification
- **Idempotence garantie** au niveau base.
- **Simplicité** : pas besoin de vérifier l'existence avant chaque insert.
- **Cohérence** : une relance met à jour les données, ne les duplique pas.

### Alternatives rejetées
- **INSERT + gestion d'exception unique** : verbeux, mélange logique métier et erreurs.
- **Vérification préalable par SELECT** : race condition possible.

### Conséquences
- Contraintes UNIQUE obligatoires sur les 3 clés.
- Les analyses et scripts peuvent être régénérés (utile pour la V2).

---

## ADR-0015 — Le total est calculé avant la boucle de traitement

### Contexte
Le composant C15 doit détecter la fin de campagne en comparant `nb_contenus_traites` à `nb_contenus_total`. Il faut donc que le total soit connu **avant** que le premier contenu ne soit traité.

### Décision
Introduire les composants **C05a → C05d** :
- C05a : agrégation de tous les contenus en un item unique ;
- C05b : calcul du total ;
- C05c : écriture de `nb_contenus_total` sur `campagnes` ;
- C05d : redistribution en items individuels pour la suite du flux.

### Justification
- **Détection de fin fiable** : la comparaison compteur/total est déterministe.
- **Pas de dépendance temporelle** : peu importe la vitesse de traitement de chaque contenu.
- **Robustesse aux erreurs partielles** : si N-1 contenus sont traités et 1 échoue, la campagne bascule en `ERREUR` sans avoir été marquée `TERMINEE` par erreur.

### Alternatives rejetées
- **Marquer `TERMINEE` à la fin du workflow** : ne fonctionne pas car les items sont traités en parallèle ; aucun nœud "final" au sens séquentiel.
- **Timeout** : arbitraire, non fiable.

### Conséquences
- 4 nœuds supplémentaires dans le workflow.
- Le total est écrit avant même que les contenus soient persistés en base (ne pose pas de problème car il représente un engagement, pas un constat).

---

## ADR-0016 — Rechargement SQL entre l'analyse et la génération de script

### Contexte
Le composant de génération de script (C11) a besoin du contenu + de son analyse. Deux approches étaient possibles :
- (A) Transporter toutes les données en mémoire depuis C05 jusqu'à C11 ;
- (B) Recharger les données via un SELECT JOIN entre `contenus` et `analyses` (C10).

### Décision
Introduire **C10 — Lecture Analyse et Contenu** : un `SELECT JOIN` qui recharge fraîchement les données depuis la base juste avant la génération de script.

### Justification
- **Découplage** : C11 ne dépend plus de la structure mémoire propagée par les nœuds amont.
- **Fiabilité** : garantit que le script est généré sur des données **effectivement persistées**.
- **Facilite les évolutions** : on peut changer C07/C08/C09 sans casser C11.

### Alternatives rejetées
- **Tout garder en mémoire** : fragile, dépendant du bon comportement de chaque nœud amont.

### Conséquences
- Un SELECT supplémentaire par contenu.
- Compromis performance/robustesse jugé acceptable (volumes faibles en V1).

---

## ADR-0017 — Modèles Claude différenciés selon la tâche

### Contexte
Le système fait deux appels IA : analyse (C07) et génération de script (C11). Ces deux tâches ont des besoins très différents :
- Analyse : raisonnement structuré, extraction, jugement (score qualité, sentiment).
- Génération : créativité, format court, ton viral.

### Décision
- **C07 (Analyse)** : `claude-opus-5` (raisonnement puissant, coûteux).
- **C11 (Script)** : `claude-sonnet-5` (rapide, créatif, moins coûteux).

### Justification
- **Adéquation modèle/tâche** : l'analyse structurée bénéficie de la profondeur d'Opus ; la génération créative n'en a pas besoin.
- **Optimisation coût** : Sonnet est significativement moins cher pour du volume.

### Alternatives rejetées
- **Un seul modèle partout (Sonnet)** : qualité insuffisante sur l'analyse.
- **Un seul modèle partout (Opus)** : coût prohibitif à l'échelle.

### Conséquences
- Deux credentials à gérer (ou un seul avec deux modèles).
- Nécessité de re-tester en cas de changement de version de modèle.

---

## ADR-0018 — Un statut terminal n'est jamais écrasé

### Contexte
Il peut arriver que le workflow d'erreur (E04, statut `ERREUR`) et le composant C15 (statut `TERMINEE`) tentent tous deux d'écrire sur la même campagne.

### Décision
- **C15** utilise un `CASE WHEN` qui **ne bascule** vers `TERMINEE` **que si** `nb_contenus_traites + 1 >= nb_contenus_total`. Il ne touche jamais un statut `ERREUR`.
- **E04** écrase toujours `EN_COURS` par `ERREUR`, mais ne s'exécute qu'une fois par run (via Error Trigger).

### Justification
- **Cohérence métier** : une campagne en erreur ne doit jamais apparaître comme "terminée avec succès".
- **Simplicité** : pas besoin de verrou applicatif.

### Alternatives rejetées
- **Toujours écrire sans condition** : risque de faire disparaître un `ERREUR` sous un `TERMINEE`.
- **Verrou pessimiste SQL** : complexité disproportionnée pour le besoin.

### Conséquences
- Le statut `ERREUR` est absorbant : une fois posé, il ne change plus.
- Le statut `TERMINEE` n'est atteint que si le compteur est complet.

---

## ADR-0019 — Journalisation dans une table dédiée `journal_execution`

### Contexte
Les incidents doivent être conservés pour audit, indépendamment du moteur d'orchestration (n8n ne garantit pas la rétention infinie de ses executions).

### Décision
Créer une table `journal_execution` (colonnes : `id`, `campagne_id`, `niveau`, `etape`, `message`, `created_at`) alimentée par E03 lors de chaque incident.

### Justification
- **Audit long terme** : les erreurs restent consultables même si n8n purge ses runs.
- **Rattachement métier** : chaque incident est lié à sa campagne via jointure sur `execution_id`.
- **Extensibilité** : le champ `niveau` prépare une évolution future (`WARN`, `INFO`).

### Alternatives rejetées
- **Se contenter des logs n8n** : perdus à la purge, non requêtables en SQL.
- **Écrire dans un fichier / stream externe** : dépendance supplémentaire pour un besoin V1 modeste.

### Conséquences
- Une nouvelle table à maintenir (mais schéma très simple).
- Ouvre la porte à un tableau de bord de supervision en V2.

---

# Index thématique

| Thème | ADR |
|-------|-----|
| Modèle métier | ADR-0001, ADR-0002, ADR-0006, ADR-0007 |
| Découplage plateforme | ADR-0003, ADR-0004, ADR-0010 |
| Intégrité et unicité | ADR-0005, ADR-0014 |
| Modularité | ADR-0008 |
| Persistance | ADR-0009, ADR-0019 |
| Gestion des erreurs | ADR-0011, ADR-0012, ADR-0018 |
| Observabilité et compteurs | ADR-0013, ADR-0015 |
| Choix IA | ADR-0017 |
| Robustesse d'exécution | ADR-0016, ADR-0018 |

---

# Dépendances documentaires

**S'appuie sur** :
- `03 — Architecture des Workflows`
- `04 — Spécification des Composants`
- `05 — Implémentation Technique`

**Sert de référence pour** :
- Toute décision future documentée par un nouvel ADR (V2+).