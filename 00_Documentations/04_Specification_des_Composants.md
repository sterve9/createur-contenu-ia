# 04 — Spécification des Composants

## Rôle du document

Ce document décrit précisément le comportement attendu de chaque composant du système.
Il constitue le **contrat officiel** entre l'architecture des workflows (`03`) et l'implémentation technique (`05`).
Chaque composant peut être développé, testé, remplacé ou réécrit sans modifier son comportement attendu pour le reste du système.

---

## 📌 Règle de Gouvernance — Validation architecturale d'un composant

Avant de développer ou d'intégrer un nouveau composant, il doit répondre aux cinq questions fondamentales :

1. **Quel est son nom métier ?**
   Le composant doit être identifiable par sa fonction métier et non par son implémentation technique.

2. **Quelle est sa mission exacte ?**
   Une seule responsabilité, formulée en une phrase.

3. **Quelle est son entrée garantie ?**
   Décrire précisément les données acceptées.

4. **Quelle est sa sortie garantie ?**
   Les composants suivants doivent pouvoir fonctionner uniquement à partir de cette sortie.

5. **Pourquoi ce composant existe-t-il dans l'architecture ?**
   Justifier son existence : quel problème apparaîtrait s'il n'existait pas ?

Chaque composant doit respecter strictement le contrat défini dans `02.5 — Contrat des Données`. **En cas de divergence, le contrat prévaut.**

---

# Partie 1 — Composants du workflow principal

## C01 — Recevoir Demande Campagne

**Mission**
Recevoir les paramètres de recherche d'une campagne via un webhook HTTP POST.

**Responsabilités**
- exposer un endpoint HTTP `/lancer-campagne` ;
- accepter un payload JSON ;
- transmettre les données brutes au composant de validation.

**Entrées**
Payload JSON contenant : `sujet`, `plateforme`, `langue`, `nb_resultats`.

**Sorties**
Le body brut de la requête.

**Identifiant propagé** : aucun (point d'entrée).

**Justification** : Point d'entrée unique du système, garantissant un couplage faible avec les clients appelants.

---

## C02 — Valider Paramètres

**Mission**
Vérifier que tous les paramètres requis sont présents et valides avant de créer la campagne.

**Responsabilités**
- contrôler que `sujet`, `plateforme` et `langue` sont non vides ;
- contrôler que `nb_resultats > 0` ;
- interrompre le workflow si un paramètre est invalide.

**Entrées**
Body brut de la requête HTTP.

**Sorties**
Les paramètres validés, transmis au composant suivant.

**Identifiant propagé** : aucun.

**Justification** : Empêche la création de campagnes incomplètes ou invalides en base, garantissant la qualité des données dès l'entrée du système.

---

## C03 — Créer Campagne

**Mission**
Enregistrer la campagne en base de données et générer son identifiant unique.

**Responsabilités**
- insérer une ligne dans la table `campagnes` ;
- définir `statut = 'EN_COURS'` ;
- enregistrer `execution_id` (identifiant technique du run d'orchestration) permettant au workflow d'erreur de retrouver la campagne concernée ;
- retourner le `campagne_id` généré.

**Entrées**
Paramètres validés (`sujet`, `plateforme`, `langue`, `nb_resultats`).

**Sorties**
Objet campagne enrichi de son `id` et de son `execution_id`.

**Identifiant propagé** : `campagne_id`, `execution_id`.

**Justification** : Sans cette étape, les contenus collectés seraient orphelins et le workflow d'erreur n'aurait aucun moyen de rattacher un incident à une campagne.

---

## C04 — Collecte des contenus

**Mission**
Interroger la plateforme cible et récupérer les contenus correspondant aux critères.

**Responsabilités**
- construire la requête vers l'API externe (YouTube v3 en V1) ;
- exécuter l'appel HTTP ;
- retourner la liste brute des résultats.

**Entrées**
`sujet`, `nb_resultats`, `campagne_id`.

**Sorties**
Liste brute des items retournés par la plateforme.

**Identifiant propagé** : `campagne_id`.

**Justification** : Encapsule la dépendance externe pour permettre le changement de plateforme sans impact sur le reste du workflow.

---

## C05 — Normalisation

**Mission**
Transformer les contenus bruts hétérogènes en un format unifié indépendant de la plateforme.

**Responsabilités**
- extraire l'identifiant unique du contenu (`contenu_source_id`) selon le type retourné par la plateforme (`videoId`, `channelId`, `playlistId`, …) ;
- mapper les champs bruts vers le schéma interne : `titre`, `auteur`, `description`, `date_publication`, `plateforme` ;
- associer `campagne_id` à chaque contenu.

**Entrées**
Liste brute retournée par C04.

**Sorties**
Liste d'objets normalisés, un item = un contenu.

**Identifiant propagé** : `campagne_id`, `contenu_source_id`.

**Justification** : Isole le reste du système des spécificités de chaque plateforme.

---

## C05a — Aggregate Contenus

**Mission**
Regrouper tous les contenus normalisés en un seul item afin de permettre le calcul du total.

**Responsabilités**
- agréger l'ensemble des items produits par C05 dans un tableau `data`.

**Entrées**
Liste d'items normalisés issue de C05.

**Sorties**
Un unique item contenant `{ data: [...contenus] }`.

**Identifiant propagé** : `campagne_id` (préservé dans chaque contenu).

**Justification** : Le composant suivant (C05b) doit connaître le **total** de contenus, ce qui nécessite de les rassembler.

---

## C05b — Préparer Total Campagne

**Mission**
Calculer le nombre total de contenus collectés et extraire le `campagne_id`.

**Responsabilités**
- compter les éléments du tableau agrégé ;
- extraire `campagne_id` depuis le premier contenu ;
- produire un objet `{ campagne_id, nb_total, contenus }`.

**Entrées**
Item agrégé issu de C05a.

**Sorties**
Objet contenant `campagne_id`, `nb_total`, `contenus`.

**Identifiant propagé** : `campagne_id`.

**Justification** : Sépare la logique de calcul du total de l'appel base de données (C05c) pour respecter la responsabilité unique.

---

## C05c — Update Total Campagne

**Mission**
Écrire le nombre total de contenus prévus sur la ligne de la campagne.

**Responsabilités**
- exécuter un `UPDATE` sur `campagnes` pour renseigner `nb_contenus_total`.

**Entrées**
`campagne_id`, `nb_total`.

**Sorties**
Confirmation de la mise à jour.

**Identifiant propagé** : `campagne_id`.

**Justification** : Sans cette valeur, le composant C15 ne peut pas détecter la fin de campagne. **Cette étape doit obligatoirement précéder la boucle sur les contenus.**

---

## C05d — Redistribuer Contenus

**Mission**
Éclater à nouveau le tableau agrégé en items individuels pour que la suite du workflow traite chaque contenu indépendamment.

**Responsabilités**
- récupérer le tableau `contenus` depuis l'item agrégé ;
- émettre un item par contenu.

**Entrées**
Objet consolidé issu de C05b (via C05c).

**Sorties**
Un flux d'items : un contenu par item.

**Identifiant propagé** : `campagne_id`, `contenu_source_id`.

**Justification** : Rétablit le mode "un item = un contenu" indispensable au traitement atomique par la suite.

---

## C06 — Persistance des contenus

**Mission**
Enregistrer chaque contenu en base de manière idempotente.

**Responsabilités**
- exécuter un `UPSERT` sur la table `contenus` avec `contenu_source_id` comme clé de matching ;
- retourner l'`id` (contenu_id) généré ou récupéré.

**Entrées**
Objet contenu normalisé.

**Sorties**
Objet contenu enrichi de son `contenu_id` persistant.

**Identifiant propagé** : `contenu_id`, `campagne_id`.

**Justification** : Garantit qu'un même contenu source n'est jamais dupliqué, quel que soit le nombre d'exécutions.

---

## C07 — Analyse IA

**Mission**
Produire une analyse sémantique structurée du contenu grâce à un LLM.

**Responsabilités**
- construire le prompt d'analyse ;
- appeler le modèle (Claude Opus en V1) ;
- retourner la réponse brute.

**Entrées**
Contenu persisté (`contenu_id`, `titre`, `description`, `plateforme`).

**Sorties**
Réponse textuelle brute du LLM contenant les axes d'analyse.

**Identifiant propagé** : `contenu_id`.

**Justification** : Encapsule l'appel au LLM pour permettre le changement de modèle sans impact sur le workflow.

---

## C08 — Normalisation Analyse IA

**Mission**
Transformer la réponse brute du LLM en un objet JSON conforme au contrat.

**Responsabilités**
- retirer les balises markdown éventuelles (```json … ```) ;
- ignorer les blocs `thinking` ;
- parser le JSON ;
- gérer les erreurs de parsing en conservant une trace pour le debug.

**Entrées**
Réponse brute de C07.

**Sorties**
Objet JSON validé contenant : `contenu_id`, `resume`, `theme`, `sentiment`, `score_qualite`, `mots_cles`, `langue`.

**Identifiant propagé** : `contenu_id`.

**Justification** : Isole le reste du système des variations de formatage des réponses LLM.

---

## C09 — Persistance Analyse

**Mission**
Enregistrer l'analyse en base et propager `analyse_id`.

**Responsabilités**
- exécuter un `UPSERT` sur la table `analyses` avec `contenu_id` comme clé de matching ;
- retourner l'`analyse_id` généré ou récupéré.

**Entrées**
Objet analyse normalisé.

**Sorties**
Objet analyse enrichi de son `analyse_id`.

**Identifiant propagé** : `analyse_id`, `contenu_id`.

**Justification** : Garantit une seule analyse par contenu et un lien relationnel solide.

---

## C10 — Lecture Analyse et Contenu

**Mission**
Recharger depuis la base les données consolidées nécessaires à la génération du script.

**Responsabilités**
- exécuter un `SELECT` avec `JOIN` entre `analyses` et `contenus` sur `analyse_id` ;
- retourner un objet contenant toutes les informations utiles (contenu + analyse).

**Entrées**
`analyse_id`.

**Sorties**
Objet consolidé : `analyse_id`, `contenu_id`, `campagne_id`, `titre`, `auteur`, `description`, `date_publication`, `plateforme`, `resume`, `theme`, `sentiment`, `score_qualite`, `mots_cles`, `langue`.

**Identifiant propagé** : `analyse_id`, `contenu_id`, `campagne_id`.

**Justification** : Évite tout couplage entre C11 et l'état mémoire des nœuds précédents. Le générateur de script travaille sur des données fraîches et cohérentes.

---

## C11 — Génération Script IA

**Mission**
Produire un script vidéo (<60s) optimisé pour TikTok / Shorts / Reels à partir du couple contenu + analyse.

**Responsabilités**
- construire le prompt d'écriture créative ;
- appeler le modèle (Claude Sonnet en V1) ;
- retourner la réponse brute contenant le script.

**Entrées**
Objet consolidé issu de C10.

**Sorties**
Réponse textuelle brute contenant le script au format JSON.

**Identifiant propagé** : `analyse_id`, `contenu_id`, `campagne_id`.

**Justification** : Encapsule l'appel au modèle de génération créative.

---

## C12 — Normalisation Script IA

**Mission**
Extraire le script et réinjecter les identifiants relationnels nécessaires à la persistance.

**Responsabilités**
- parser le retour du LLM ;
- gérer les cas de format dégradé (markdown, texte brut, JSON valide) ;
- réinjecter `campagne_id`, `contenu_id`, `analyse_id` récupérés depuis C10.

**Entrées**
Réponse brute issue de C11.

**Sorties**
Objet normalisé : `campagne_id`, `contenu_id`, `analyse_id`, `script`.

**Identifiant propagé** : `analyse_id`, `contenu_id`, `campagne_id`.

**Justification** : Prépare un objet totalement autoportant pour la persistance et l'incrément.

---

## C13 — Persistance Script

**Mission**
Enregistrer le script en base et propager `script_id`.

**Responsabilités**
- exécuter un `UPSERT` sur la table `scripts` avec `analyse_id` comme clé de matching ;
- retourner l'`id` (script_id) généré ou récupéré.

**Entrées**
Objet script normalisé.

**Sorties**
Objet script enrichi de son `script_id`.

**Identifiant propagé** : `script_id`, `analyse_id`, `contenu_id`, `campagne_id`.

**Justification** : Garantit un seul script par analyse et clôture la chaîne de traçabilité.

---

## C14 — Préparer Increment

**Mission**
Assembler les identifiants nécessaires à la mise à jour du compteur de campagne.

**Responsabilités**
- extraire `script_id` depuis la persistance ;
- récupérer `campagne_id`, `contenu_id`, `analyse_id` depuis C12 ;
- produire un objet consolidé prêt pour l'incrément.

**Entrées**
Résultat de C13 et données de C12.

**Sorties**
Objet contenant `script_id`, `campagne_id`, `contenu_id`, `analyse_id`.

**Identifiant propagé** : `campagne_id`.

**Justification** : Sépare la logique de préparation de l'incrément SQL, respectant la responsabilité unique.

---

## C15 — Increment Traites

**Mission**
Mettre à jour la campagne à la fin du traitement de chaque contenu et détecter la fin de campagne.

**Responsabilités**
- incrémenter `nb_contenus_traites` de +1 ;
- si `nb_contenus_traites + 1 >= nb_contenus_total` → basculer `statut = 'TERMINEE'` et poser `date_fin = NOW()` ;
- sinon → laisser `statut` et `date_fin` inchangés.

**Entrées**
Objet préparé par C14.

**Sorties**
Confirmation de la mise à jour.

**Identifiant propagé** : `campagne_id`.

**Justification** : Assure l'observabilité temps réel de l'avancement et marque explicitement la fin normale d'une campagne.

---

# Partie 2 — Composants du workflow d'erreur

Le workflow d'erreur est un workflow **indépendant** déclenché automatiquement en cas d'exception dans le workflow principal. Il assure la journalisation de l'incident et la mise à jour de l'état de la campagne concernée.

## E01 — Capture Erreur

**Mission**
Point d'entrée du workflow d'erreur, déclenché automatiquement par toute exception non gérée dans le workflow principal.

**Responsabilités**
- capter le contexte d'exécution en erreur (Error Trigger natif de la plateforme).

**Entrées**
Contexte d'erreur fourni par le moteur d'orchestration (`execution.id`, `execution.error`, `lastNodeExecuted`).

**Sorties**
Objet contenant le contexte brut de l'erreur.

**Identifiant propagé** : `execution_id`.

**Justification** : Sans point d'entrée dédié, aucune trace ne serait conservée en cas d'incident.

---

## E02 — Structurer Erreur

**Mission**
Extraire et normaliser les informations utiles du contexte d'erreur.

**Responsabilités**
- extraire `execution_id`, `niveau`, `etape` (nom du nœud en échec), `message` ;
- gérer les cas où plusieurs messages sont présents ;
- produire un objet exploitable pour la journalisation.

**Entrées**
Contexte brut fourni par E01.

**Sorties**
Objet structuré : `{ execution_id, niveau, etape, message }`.

**Identifiant propagé** : `execution_id`.

**Justification** : Isole le formatage du contexte d'erreur des opérations en base.

---

## E03 — Log Erreur

**Mission**
Enregistrer l'erreur dans la table `journal_execution` en la rattachant à la campagne concernée.

**Responsabilités**
- exécuter un `INSERT SELECT` récupérant le `campagne_id` par jointure sur `execution_id` dans `campagnes` ;
- écrire `niveau`, `etape`, `message`.

**Entrées**
Objet structuré issu de E02.

**Sorties**
Confirmation de l'insertion.

**Identifiant propagé** : `execution_id`, `campagne_id` (résolu par jointure).

**Justification** : Permet un audit complet des incidents et leur rattachement métier sans dépendance mémoire au workflow principal.

---

## E04 — Update Campagne Erreur

**Mission**
Basculer la campagne concernée en état terminal d'erreur.

**Responsabilités**
- exécuter un `UPDATE` sur `campagnes` : `statut = 'ERREUR'`, `date_fin = NOW()` ;
- cibler la campagne via `execution_id`.

**Entrées**
`execution_id` issu de E02.

**Sorties**
Confirmation de la mise à jour.

**Identifiant propagé** : `execution_id`.

**Justification** : Garantit qu'une campagne en erreur est explicitement marquée comme telle et n'apparaît pas indéfiniment en `EN_COURS`.

---

# Partie 3 — Composants prévus pour les versions ultérieures

## Publication / Tableau de bord (V2)
Composant destiné à exposer les campagnes, contenus et scripts à travers une interface de consultation. **Non implémenté en V1.**

## Notification externe (V2)
Composant destiné à notifier l'utilisateur (email, webhook sortant, Slack, …) de la fin de campagne ou d'un incident. **Non implémenté en V1.**

---

## Dépendances documentaires

**S'appuie sur** :
- `03 — Architecture des Workflows`
- `02.5 — Contrat des Données`

**Sert de référence pour** :
- `05 — Implémentation Technique`
- `07 — Plan de Tests`