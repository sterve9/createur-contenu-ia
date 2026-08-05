# 08 — Project Tracker

## Rôle du document

Le Project Tracker est le **point d'entrée officiel du projet**.

- Chaque séance commence par sa lecture.
- Chaque séance se termine par sa mise à jour.

Il répond à quatre questions :
- Où en est le projet ?
- Quelle est la prochaine tâche ?
- Quel document dois-je ouvrir ?
- Quand puis-je considérer ma séance comme terminée ?

Il ne contient aucune information d'architecture ou de conception.
Il pilote uniquement l'avancement du projet.

---

## 📌 État du projet

- **Projet** : Assistant IA pour Créateurs de Contenu
- **Version courante** : **V2 — Implémentation technique terminée. Passage au Plan de Tests**
- **Statut global** : 🟢 V1 STABLE verrouillée. Toute la conception V2 formalisée jusqu'à l'implémentation technique. Schéma V2 corrigé et enrichi. Passage à la phase de tests.
- **Phase actuelle** : Préparation du Plan de Tests de la V2
- **Dernière mise à jour** : 12 novembre 2025

---

## 🎯 Tâche active

- **ID** : `V2-011`
- **Titre** : Plan de Tests V2 — formaliser la stratégie et les scénarios de tests couvrant la V2 complète
- **Priorité** : P0
- **Statut** : ⬜ À démarrer

**Livrables attendus** :
1. Définir la stratégie de tests V2 (types, niveaux, périmètre).
2. Formaliser les scénarios de tests unitaires par nœud critique.
3. Formaliser les scénarios de tests d'intégration par workflow.
4. Formaliser les scénarios de tests bout-en-bout (E2E) sur une campagne complète.
5. Décrire les jeux de données de test et les prérequis en base.
6. Décrire les critères de validation, les résultats attendus et les cas d'erreur.
7. Formaliser la stratégie de non-régression V1/V2.
8. Rédiger le document `07.V2_Plan_de_tests.md`.

---

## 📂 Documents à ouvrir (dans cet ordre uniquement)

1. `08_Project_Tracker.md` (ce document)
2. `05.V2_Implementation_Technique.md` — référence directe pour identifier les nœuds à tester et les requêtes à valider
3. `03.V2_Architecture_des_Workflows.md` — référence pour les workflows à tester en intégration
4. `02.5.V2_Contrat_des_Donnees.md` — contrats à valider par les tests
5. `04.V2_Specification_des_Composants.md` — comportements attendus par composant
6. `07_Plan_de_tests.md` — référence de style V1

---

## ✅ Critères de fin de séance

La séance est terminée uniquement si :
- la stratégie de tests V2 est formalisée ;
- les scénarios unitaires, d'intégration et bout-en-bout sont documentés ;
- les jeux de données de test sont décrits ;
- les cas d'erreur et la résilience isolée par plan sont testés explicitement ;
- la non-régression V1/V2 est documentée ;
- le document `07.V2_Plan_de_tests.md` est créé et intégré à `00_Documentations/` ;
- le Project Tracker est mis à jour (statut V2-011, prochaine tâche définie).

---

## 🔒 Avancement V1 STABLE (verrouillé)

La V1 STABLE est **livrée, testée et documentée**. Aucune modification de la V1 n'est prévue.

### Documentation V1

| Document | Statut |
|----------|--------|
| `00_Contexte_Du_Client` | ✅ |
| `01_Besoin_Client` | ✅ |
| `02_Architecture_metier` | ✅ |
| `02.1_Modele_de_Donnees` | ✅ (aligné DOC-002) |
| `02.2_Dictionnaire_des_Donnees` | ✅ (aligné DOC-002) |
| `02.3_Schema_Physique_des_Donnees` | ✅ (aligné DOC-002) |
| `02.4_Mapping_des_Donnees` | ✅ |
| `02.5_Contrat_des_Donnees` | ✅ |
| `03_Architecture_des_Workflows` | ✅ |
| `04_Specification_des_Composants` | ✅ |
| `05_Implementation_Technique` | ✅ |
| `06_Journal_des_Decisions_d_Architecture` | 🟡 À enrichir avec les ADR V1 |
| `07_Plan_de_tests` | ✅ |
| `08_Project_Tracker` | ✅ |

### Produit V1

| Domaine | Statut |
|---------|--------|
| Base PostgreSQL (`campagnes`, `contenus`, `analyses`, `scripts`, `journal_execution`) | ✅ |
| Workflow principal n8n (C01 → C15, incluant C05a-d) | ✅ |
| Workflow d'erreur n8n (E01 → E04) | ✅ |
| Corrélation `execution_id` entre les 2 workflows | ✅ |
| Compteurs et statuts de campagne (`EN_COURS` / `TERMINEE` / `ERREUR`) | ✅ |
| Idempotence (UPSERT sur `contenu_source_id`, `contenu_id`, `analyse_id`) | ✅ |
| Sauvegarde des workflows n8n | ✅ |

### Capacités livrées par la V1

- Lancer une campagne via webhook HTTP ;
- Collecter N contenus depuis YouTube Data API v3 ;
- Analyser sémantiquement chaque contenu (Claude Opus) ;
- Générer un script vidéo <60s (Claude Sonnet) pour chaque contenu ;
- Historiser l'ensemble (contenus, analyses, scripts) sans doublon ;
- Détecter automatiquement la fin normale d'une campagne (`TERMINEE`) ;
- Basculer automatiquement en `ERREUR` et journaliser tout incident ;
- Tracer la chaîne complète `campagne_id → contenu_id → analyse_id → script_id`.

---

## 🚀 Roadmap V2

### Objectif de la V2

**Résoudre un vrai problème de créateur de contenu.**
La V2 apporte le contexte d'exécution qui manque à la V1 : transformer un script en dossier de production complet, prêt à exécuter dans les outils IA du créateur.

### Persona ciblé

**Le side-hustler ambitieux (Persona B)** :
- crée du contenu le soir/week-end en parallèle d'un emploi principal ;
- publie entre 3 et 8 vidéos par mois ;
- contrainte principale : le temps ;
- utilise déjà des outils IA (gratuits et/ou payants).

### Axe retenu

**Axe Production Assistée — "Le Kit Créateur"**

Fournir à chaque campagne un **dossier de production complet** :
- 1 script vidéo complet ;
- 1 découpage en scènes ;
- N plans par scène (selon durée et contenu) ;
- N prompts images optimisés pour l'**outil choisi par le créateur** (1 par plan) ;
- N prompts animations optimisés pour l'**outil choisi par le créateur** (1 par plan) ;
- 1 description par plateforme de publication ;
- 1 liste de hashtags par plateforme ;
- 1 checklist de production auto-générée.

Accessible depuis un **tableau de bord personnel**.

### Décisions structurantes validées

- ✅ Persona : Side-hustler ambitieux (Persona B)
- ✅ Axe : Production assistée (pas de génération auto d'images/vidéos)
- ✅ 1 seul script ultra-complet par campagne (choisi par le créateur parmi les scripts V1)
- ✅ Choix des outils par le créateur au lancement de la campagne
- ✅ Un seul outil d'image + un seul outil d'animation par campagne (cohérence visuelle)
- ✅ Catalogue d'outils intégré (gratuits, freemium, payants)
- ✅ Interface : tableau de bord personnel (pas de SaaS, pas de multi-utilisateurs)
- ✅ Usage : solo, open source, démonstration de résolution de problème métier
- ✅ Architecture : **V2 lit les données V1 (base partagée), réutilise les workflows V1, écrit dans ses propres tables V2** (E3 + E3-a)
- ✅ Structure visuelle : **Scène → N Plans → 1 Prompt Image + 1 Prompt Animation par plan**
- ✅ 1 Script V1 peut donner lieu à N Dossiers de Production
- ✅ Traçabilité : les prompts conservent l'`outil_id`
- ✅ Conventions physiques V2 : préfixe `v2_`, PK en BIGINT, timestamps en `timestamptz`
- ✅ Unicité d'écriture : chaque colonne V2 possède un seul composant écrivain
- ✅ Contrats V2 : la V2 ne modifie **jamais** les données V1
- ✅ Résilience : défaillance d'un générateur → n'impacte pas les autres plans
- ✅ Architecture des workflows V2 : 6 workflows modulaires (`V2-ORCH`, `V2-SCENE`, `V2-PLAN`, `V2-IMG`, `V2-ANIM`, `V2-PUB`) + 1 workflow d'erreur (`V2-ERR`)
- ✅ Frontière V1/V2 : nœud unique `C-V2-03` de lecture JOIN sur `scripts + analyses + contenus`
- ✅ Séquentialité Image → Animation par plan (robustesse avant performance)
- ✅ Spécification des composants V2 rédigée : composants, prompts IA, JSON attendus
- ✅ Catalogue V2 recentré sur des outils finaux web ; stack open source / locale réservée à la V3
- ✅ Schéma V2 corrigé : `execution_id`, `nb_plans_total`, `nb_plans_traites` sur `v2_dossiers_production` ; `statut` sur `v2_plans` ; création `v2_journal_execution`
- ✅ Implémentation V2 : 23 nœuds spécifiés avec SQL exact et syntaxe n8n réelle
- ✅ Barrière de phase C-V2-11b garantissant que `nb_plans_total` est verrouillé avant lancement des prompts
- ✅ Checklist de production auto-générée à la création du dossier (9 étapes standards)

### Ce que la V2 n'est PAS

- une génération automatique des images / vidéos ;
- une automatisation du montage ;
- une publication automatique sur les plateformes ;
- un SaaS multi-utilisateurs ;
- une refonte de l'architecture V1.

### Axes futurs (V3+, à étudier)

- ⬜ Axe Intelligence Stratégique (recommandations, angles viraux, analyse concurrentielle)
- ⬜ Axe Publication & Suivi de performance
- ⬜ Axe Pipeline complet (génération auto des visuels + montage automatisé)
- ⬜ Intégration d'une stack locale / open source (Flux, SDXL, ComfyUI, Wan, LivePortrait, etc.)
- ⬜ Passage éventuel en SaaS multi-utilisateurs

### Documentation V2

| Document | Statut |
|----------|--------|
| `01.V2_Besoin_Client` | ✅ |
| `02.V2_Architecture_metier` | ✅ |
| `02.1.V2_Modele_de_Donnees` | ✅ |
| `02.2.V2_Dictionnaire_des_Donnees` | ✅ |
| `02.3.V2_Schema_Physique_des_Donnees` | ✅ (enrichi V2-010) |
| `02.4.V2_Mapping_des_Donnees` | ✅ |
| `02.5.V2_Contrat_des_Donnees` | ✅ |
| `03.V2_Architecture_des_Workflows` | ✅ |
| `04.V2_Specification_des_Composants` | ✅ |
| `04.1.V2_Catalogue_Outils` | ✅ |
| `05.V2_Implementation_Technique` | ✅ |
| `07.V2_Plan_de_tests` | 🟡 En cours (V2-011) |

---

## ➜ Prochaine tâche

**V2-011 — Plan de Tests V2**

Formaliser la stratégie et les scénarios de tests couvrant la V2 complète :
- tests unitaires par nœud critique ;
- tests d'intégration par workflow ;
- tests bout-en-bout sur une campagne complète ;
- tests de résilience (défaillance d'un plan → autres plans continuent) ;
- tests de non-régression V1/V2 (lecture seule sur V1) ;
- tests d'idempotence (relance sans doublon).

Rédiger le document `07.V2_Plan_de_tests.md`.

---

## 📌 TODO transverses

| ID | Titre | Priorité | Statut |
|----|-------|----------|--------|
| DOC-002 | Aligner 02.1, 02.2, 02.3 avec le schéma Supabase réel | Moyenne | ✅ Terminé |
| DOC-003 | Enrichir `06_Journal_des_Decisions_d_Architecture` avec les ADR V1 | Basse | ⬜ À faire |
| DOC-004 | Créer une entrée ADR pour la décision d'architecture V2 (E3 + E3-a) | Moyenne | ⬜ À faire |
| DOC-005 | Créer une entrée ADR pour la décision "Scène → Plans" (rythme visuel du montage) | Basse | ⬜ À faire |
| DOC-006 | Créer une entrée ADR pour la décision "outil_id conservé dans les prompts" | Basse | ⬜ À faire |
| DOC-007 | Créer une entrée ADR pour les conventions physiques V2 (préfixe `v2_`, BIGINT, timestamptz) | Basse | ⬜ À faire |
| DOC-008 | Créer une entrée ADR pour la règle "V2 en lecture seule sur V1" | Moyenne | ⬜ À faire |
| DOC-009 | Créer une entrée ADR pour la décision "workflows modulaires V2 + résilience isolée par plan" | Moyenne | ⬜ À faire |
| DOC-010 | Créer une entrée ADR pour la décision "frontière V1/V2 via un nœud unique C-V2-03" | Moyenne | ⬜ À faire |
| DOC-011 | Créer une entrée ADR pour la décision "catalogue V2 = outils finaux web, stack locale/open source reportée en V3" | Basse | ⬜ À faire |
| DOC-012 | Créer une entrée ADR pour la décision "barrière de phase C-V2-11b" | Moyenne | ⬜ À faire |
| DOC-013 | Créer une entrée ADR pour la décision "clôture automatique du dossier par le workflow (et non par le Dashboard)" | Moyenne | ⬜ À faire |
| DOC-014 | Mettre à jour `02.4.V2_Mapping_des_Donnees` : ajouter `execution_id`, `nb_plans_total`, `nb_plans_traites` sur `v2_dossiers_production` ; ajouter `statut` sur `v2_plans` ; ajouter la table `v2_journal_execution` | Moyenne | ⬜ À faire |
| DOC-015 | Mettre à jour `02.5.V2_Contrat_des_Donnees` : intégrer les nouveaux invariants liés à `execution_id`, aux compteurs et au journal V2 | Moyenne | ⬜ À faire |

---

## 📈 Vision globale du projet

| Phase | Statut |
|-------|--------|
| Compréhension du besoin V1 | ✅ |
| Conception métier V1 | ✅ |
| Modélisation des données V1 | ✅ |
| Conception des workflows V1 | ✅ |
| Spécification technique V1 | ✅ |
| Développement & intégration V1 | ✅ |
| Tests & validation V1 | ✅ |
| **V1 STABLE — Livraison** | ✅ |
| Alignement documentaire V1 STABLE | ✅ |
| Cadrage métier V2 | ✅ |
| Architecture métier V2 | ✅ |
| Modèle conceptuel V2 | ✅ |
| Dictionnaire des données V2 | ✅ |
| Schéma physique V2 | ✅ |
| Mapping V2 | ✅ |
| Contrat des données V2 | ✅ |
| Architecture workflows V2 | ✅ |
| Spécification composants V2 | ✅ |
| Catalogue outils V2 | ✅ |
| Implémentation technique V2 | ✅ |
| **Plan de tests V2** | 🟡 En cours |
| Développement V2 | ⬜ |
| Tests & validation V2 | ⬜ |
| Déploiement V2 | ⬜ |

---

## 📜 Historique des jalons

| Date | Jalon | Détail |
|------|-------|--------|
| 2025-08-03 | 🎉 **V1 STABLE livrée** | Workflow principal C01→C15 + workflow d'erreur E01→E04 opérationnels, testés, sauvegardés |
| 2025-11 | 📚 Publication GitHub V1 | Repo public, tag `v1.0.0-stable`, release publiée, licence MIT |
| 2025-11-12 | 📚 Alignement documentaire (DOC-002) | 02.1, 02.2 et 02.3 alignés sur le schéma Supabase réel |
| 2025-11-12 | 🎯 **Cadrage V2 terminé** | `01.V2_Besoin_Client.md` rédigé et validé |
| 2025-11-12 | 🏛️ **Architecture métier V2 formalisée** | `02.V2_Architecture_metier.md` rédigé et validé |
| 2025-11-12 | 🧩 **Modèle conceptuel V2 formalisé** | `02.1.V2_Modele_de_Donnees.md` rédigé et validé |
| 2025-11-12 | 📖 **Dictionnaire des données V2 formalisé** | `02.2.V2_Dictionnaire_des_Donnees.md` rédigé et validé |
| 2025-11-12 | 🛠️ **Schéma physique V2 formalisé** | `02.3.V2_Schema_Physique_des_Donnees.md` rédigé et validé |
| 2025-11-12 | 🔗 **Mapping des données V2 formalisé** | `02.4.V2_Mapping_des_Donnees.md` rédigé et validé |
| 2025-11-12 | 📜 **Contrat des données V2 formalisé** | `02.5.V2_Contrat_des_Donnees.md` rédigé et validé |
| 2025-11-12 | 🔀 **Architecture des workflows V2 formalisée** | `03.V2_Architecture_des_Workflows.md` — 6 workflows modulaires + `V2-ERR`, résilience isolée par plan |
| 2025-11-12 | 🧱 **Spécification des composants V2 formalisée** | `04.V2_Specification_des_Composants.md` — composants détaillés, prompts IA structurés |
| 2025-11-12 | 🧰 **Catalogue des outils V2 formalisé** | `04.1.V2_Catalogue_Outils.md` — 4 outils image + 4 outils animation |
| 2025-11-12 | ⚙️ **Implémentation technique V2 formalisée** | `05.V2_Implementation_Technique.md` + correctifs `02.3.V2` — 23 nœuds SQL/n8n prêts à implémenter, DDL correctif, workflow V2-PUB ajouté, barrière de phase C-V2-11b, checklist auto-générée |

---

## 🧭 Règles de gouvernance du tracker

- Le tracker est **le seul document qui bouge à chaque séance**.
- Toute décision d'architecture prise en séance → à consigner dans `06_Journal_des_Decisions_d_Architecture.md`.
- Toute modification de la V1 STABLE → refusée par défaut, sauf bug critique documenté.
- La V2 se construit dans **de nouveaux fichiers** dédiés (`01.V2_`, `02.V2_`, etc.), pour préserver la référence V1.
- Les critères de fin de séance doivent être remplis avant de clôturer une session.