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
- **Version courante** : **V2 — Développement en cours (~35 %)**
- **Statut global** : 🟢 V1 STABLE verrouillée. Conception V2 100 % terminée. **Développement V2 en cours : fondations posées (DDL Supabase appliqué, catalogue outils peuplé, credentials configurés, workflow V2-ERR opérationnel dans n8n et publié sur GitHub). Clarification architecturale levée le 06/08/2026 (ADR-V2-01/02 : hiérarchie documentaire + pattern monolithique actés). Reste à créer le workflow monolithique `V2 — Créateur de Dossier de Production` (6 blocs métier), le rattacher à V2-ERR, puis smoke test TE2E-01.**
- **Phase actuelle** : Développement de la V2 (implémentation n8n + Supabase) — clarification architecturale terminée, prêt pour la construction du workflow monolithique
- **Dernière mise à jour** : 06 août 2026

---

## 🎯 Tâche active

- **ID** : `V2-DEV`
- **Titre** : Développement V2 — implémenter la V2 dans n8n et Supabase en suivant strictement les documents de conception
- **Priorité** : P0
- **Statut** : 🟡 En cours (~35 %)

**Livrables attendus** :
1. ✅ **Exécuter le DDL V2 dans Supabase** (`02.3.V2_Schema_Physique_des_Donnees.md`) — *Fait*
2. ✅ **Peupler la table `v2_outils`** avec les 8 outils du catalogue (`05.V2_Implementation_Technique.md`, section 2.4) — *Fait*
3. 🟡 **Créer le workflow monolithique `V2 — Créateur de Dossier de Production`** selon `05.V2_Implementation_Technique.md` et ADR-V2-02 (1 seul workflow n8n contenant les nœuds C-V2-01 à C-V2-22, regroupés par Sticky Notes) :
   - ⬜ Bloc V2-ORCH (C-V2-01 → C-V2-05b)
   - ⬜ Bloc V2-SCENE (C-V2-06 → C-V2-08)
   - ⬜ Bloc V2-PLAN (C-V2-09 → C-V2-11b)
   - ⬜ Bloc V2-IMG (C-V2-13 → C-V2-15)
   - ⬜ Bloc V2-ANIM (C-V2-16 → C-V2-19)
   - ⬜ Bloc V2-PUB (C-V2-20 → C-V2-22)
   - ✅ V2-ERR (Gestionnaire d'Erreurs V2) — *Créé, importé, activé (Published), exporté en JSON et pushé sur GitHub*
4. ✅ **Configurer les credentials** (Anthropic API, Supabase PostgreSQL) — *Fait*
5. ⏳ **Configurer le workflow V2-ERR comme workflow d'erreur** du workflow monolithique — *En attente (après création du workflow principal)*
6. ⬜ **Effectuer un smoke test** avec le scénario TE2E-01 du plan de tests

---

## 📂 Documents à ouvrir (dans cet ordre uniquement)

1. `08_Project_Tracker.md` (ce document)
2. `06.V2_Journal_des_Decisions_d_Architecture.md` — **ADR-V2-01 et ADR-V2-02 actés le 06/08/2026 (hiérarchie + pattern monolithique)**
3. `05.V2_Implementation_Technique.md` — **document principal de l'implémentation**, contient tout le SQL et la syntaxe n8n
4. `02.3.V2_Schema_Physique_des_Donnees.md` — DDL des tables V2
5. `03.V2_Architecture_des_Workflows.md` — vue d'ensemble des workflows (pour référence métier, voir ADR-V2-01)
6. `04.V2_Specification_des_Composants.md` — comportement attendu par composant
7. `04.1.V2_Catalogue_Outils.md` — conventions de prompt par outil
8. `07.V2_Plan_de_tests.md` — pour le smoke test et la validation

---

## ✅ Critères de fin de séance

La séance de développement V2 est terminée uniquement si :
- toutes les tables V2 sont créées dans Supabase et validées ;
- le catalogue `v2_outils` est peuplé et vérifié ;
- le workflow monolithique V2 est créé dans n8n avec la configuration exacte du document d'implémentation ;
- les credentials sont configurés et testés ;
- le workflow V2-ERR est correctement rattaché au workflow monolithique ;
- le smoke test TE2E-01 passe avec succès sur une campagne V1 réelle ;
- le Project Tracker est mis à jour (statut V2-DEV, prochaine tâche définie).

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
- ✅ 1 seul script ultra-complet par campagne (choisi par le créateur parmi les scripts V1 d'une campagne TERMINEE)
- ✅ Choix des outils par le créateur au lancement de la campagne
- ✅ Un seul outil d'image + un seul outil d'animation par campagne
- ✅ Catalogue d'outils intégré (gratuits, freemium, payants)
- ✅ Interface : tableau de bord personnel
- ✅ Usage : solo, open source, démonstration de résolution de problème métier
- ✅ Architecture : E3 + E3-a — V2 lit V1, réutilise les workflows V1, écrit dans ses propres tables V2
- ✅ Structure visuelle : Scène → N Plans → 1 Prompt Image + 1 Prompt Animation par plan
- ✅ 1 Script V1 peut donner lieu à N Dossiers de Production
- ✅ Traçabilité : les prompts conservent l'`outil_id`
- ✅ Conventions physiques V2 : préfixe `v2_`, PK en BIGINT, timestamps en `timestamptz`
- ✅ Unicité d'écriture : chaque colonne V2 possède un seul composant écrivain
- ✅ Contrats V2 : la V2 ne modifie **jamais** les données V1
- ✅ Résilience : défaillance d'un générateur → n'impacte pas les autres plans
- ✅ 7 workflows V2 (`V2-ORCH`, `V2-SCENE`, `V2-PLAN`, `V2-IMG`, `V2-ANIM`, `V2-PUB`, `V2-ERR`)
- ✅ Frontière V1/V2 : nœud unique `C-V2-03` de lecture JOIN sur `scripts + analyses + contenus`
- ✅ Séquentialité Image → Animation par plan
- ✅ Catalogue V2 recentré sur des outils finaux web ; stack open source / locale réservée à la V3
- ✅ Schéma V2 corrigé : `execution_id`, `nb_plans_total`, `nb_plans_traites` sur `v2_dossiers_production` ; `statut` sur `v2_plans` ; création `v2_journal_execution`
- ✅ 23 nœuds V2 spécifiés avec SQL exact et syntaxe n8n réelle
- ✅ Barrière de phase C-V2-11b garantissant `nb_plans_total` verrouillé avant lancement des prompts
- ✅ Checklist de production auto-générée à la création du dossier (9 étapes standards)
- ✅ Plan de tests V2 formalisé : 31 tests couvrant unitaire, intégration, E2E, non-régression V1, idempotence, résilience isolée
- ✅ **ADR-V2-01** : Hiérarchie de vérité `Supabase > V2-010 > V2-008` actée — `v2_dossiers_production` fait foi (06/08/2026)
- ✅ **ADR-V2-02** : Pattern n8n monolithique acté — 1 seul workflow `V2 — Créateur de Dossier de Production` + V2-ERR séparé (06/08/2026)

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
| `03.V2_Architecture_des_Workflows` | ✅ (pour référence métier — voir ADR-V2-01 pour l'implémentation) |
| `04.V2_Specification_des_Composants` | ✅ |
| `04.1.V2_Catalogue_Outils` | ✅ |
| `05.V2_Implementation_Technique` | ✅ |
| `06.V2_Journal_des_Decisions_d_Architecture` | ✅ (ADR-V2-01 + ADR-V2-02 actés le 06/08/2026) |
| `07.V2_Plan_de_tests` | ✅ |

**🎉 Conception V2 : 12 documents produits, 100 % complets + 2 ADR structurants actés.**

### Implémentation V2

| Artefact | Statut |
|----------|--------|
| DDL V2 appliqué dans Supabase | ✅ Fait |
| Catalogue `v2_outils` peuplé (8 outils) | ✅ Fait |
| Workflow V2-ERR (Gestionnaire d'Erreurs) | ✅ Créé, importé, activé (Published), pushé sur GitHub |
| Workflow monolithique `V2 — Créateur de Dossier de Production` | ⬜ À faire (6 blocs : ORCH/SCENE/PLAN/IMG/ANIM/PUB) |
| Credentials n8n (Anthropic API + Supabase PostgreSQL) | ✅ Fait |
| Rattachement V2-ERR au workflow monolithique | ⏳ En attente |
| Smoke test TE2E-01 | ⬜ À faire |

---

## ➜ Prochaine tâche

**V2-DEV — Développement V2 (en cours, ~35 %) — Étape suivante : construire le bloc V2-ORCH du workflow monolithique**

Poursuivre l'implémentation du workflow monolithique `V2 — Créateur de Dossier de Production` selon `05.V2_Implementation_Technique.md` et les ADR-V2-01/02 :

1. Créer le workflow `V2 — Créateur de Dossier de Production` dans n8n.
2. Implémenter le **bloc V2-ORCH** (C-V2-01 → C-V2-05b : webhook, validations, lecture V1, création dossier + checklist).
3. Tester le bloc V2-ORCH en isolation (webhook avec un `script_id` réel → vérif en base `v2_dossiers_production` + `v2_checklists` + `v2_etapes_checklist`).
4. Enchaîner les blocs suivants : V2-SCENE (C-V2-06 → C-V2-08), puis V2-PLAN (C-V2-09 → C-V2-11b).
5. Puis blocs V2-IMG, V2-ANIM, V2-PUB.
6. Rattacher V2-ERR comme `errorWorkflow` du workflow monolithique.
7. Exporter le JSON final dans `workflows/V2/` et pusher sur GitHub.
8. Lancer le smoke test **TE2E-01** du plan de tests.

Après implémentation complète : exécuter les 31 tests du plan de tests V2.

---

## 📌 TODO transverses

| ID | Titre | Priorité | Statut |
|----|-------|----------|--------|
| DOC-002 | Aligner 02.1, 02.2, 02.3 avec le schéma Supabase réel | Moyenne | ✅ Terminé |
| DOC-003 | Enrichir `06_Journal_des_Decisions_d_Architecture` avec les ADR V1 | Basse | ⬜ À faire |
| DOC-004 | Créer une entrée ADR pour la décision d'architecture V2 (E3 + E3-a) | Moyenne | ⬜ À faire |
| DOC-005 | Créer une entrée ADR pour la décision "Scène → Plans" | Basse | ⬜ À faire |
| DOC-006 | Créer une entrée ADR pour la décision "outil_id conservé dans les prompts" | Basse | ⬜ À faire |
| DOC-007 | Créer une entrée ADR pour les conventions physiques V2 | Basse | ⬜ À faire |
| DOC-008 | Créer une entrée ADR pour la règle "V2 en lecture seule sur V1" | Moyenne | ⬜ À faire |
| DOC-009 | Créer une entrée ADR pour la décision "workflows modulaires V2 + résilience isolée par plan" | Moyenne | ⬜ À faire |
| DOC-010 | Créer une entrée ADR pour la décision "frontière V1/V2 via un nœud unique C-V2-03" | Moyenne | ⬜ À faire |
| DOC-011 | Créer une entrée ADR pour la décision "catalogue V2 = outils finaux web, stack locale reportée en V3" | Basse | ⬜ À faire |
| DOC-012 | Créer une entrée ADR pour la décision "barrière de phase C-V2-11b" | Moyenne | ⬜ À faire |
| DOC-013 | Créer une entrée ADR pour la décision "clôture automatique du dossier par le workflow" | Moyenne | ⬜ À faire |
| DOC-014 | Mettre à jour `02.4.V2_Mapping_des_Donnees` : ajouter `execution_id`, `nb_plans_total`, `nb_plans_traites`, `statut` sur `v2_plans`, table `v2_journal_execution` | Moyenne | ⬜ À faire |
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
| Plan de tests V2 | ✅ |
| **🎉 Conception V2 — 100 % terminée** | ✅ |
| **Développement V2** | 🟡 En cours (~35 %) |
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
| 2025-11-12 | 🔀 **Architecture des workflows V2 formalisée** | `03.V2_Architecture_des_Workflows.md` — 6 workflows modulaires + `V2-ERR` |
| 2025-11-12 | 🧱 **Spécification des composants V2 formalisée** | `04.V2_Specification_des_Composants.md` — composants détaillés, prompts IA structurés |
| 2025-11-12 | 🧰 **Catalogue des outils V2 formalisé** | `04.1.V2_Catalogue_Outils.md` — 4 outils image + 4 outils animation |
| 2025-11-12 | ⚙️ **Implémentation technique V2 formalisée** | `05.V2_Implementation_Technique.md` + correctifs `02.3.V2` — 23 nœuds SQL/n8n prêts à implémenter |
| 2025-11-12 | 🧪 **Plan de tests V2 formalisé** | `07.V2_Plan_de_tests.md` — 31 tests couvrant unitaire, intégration, E2E, non-régression V1, idempotence, résilience isolée |
| 2025-11-12 | 🎉 **CONCEPTION V2 — 100 % TERMINÉE** | 12 documents de conception V2 produits et validés. Prêt pour l'implémentation dans n8n et Supabase. |
| 2026-08-06 | 🛠️ **DDL V2 exécuté dans Supabase** | Toutes les tables `v2_*` créées, colonnes `execution_id` / `nb_plans_total` / `nb_plans_traites` ajoutées sur `v2_dossiers_production`, colonne `statut` ajoutée sur `v2_plans`, table `v2_journal_execution` créée |
| 2026-08-06 | 🧰 **Catalogue `v2_outils` peuplé** | 8 outils insérés (4 image + 4 animation) selon `05.V2_Implementation_Technique.md` section 2.4 |
| 2026-08-06 | 🚨 **Workflow V2-ERR opérationnel dans n8n** | Créé, importé, activé (Published), exporté en JSON dans `workflows/V2/V2-ERR_Gestionnaire_Erreurs.json`, pushé sur GitHub (commit `9a4f1b0`). Credentials n8n configurés (Anthropic API + Supabase PostgreSQL `ia-contenu-prod`) |
| 2026-08-06 | 📐 **ADR-V2-01 acté** | Hiérarchie de vérité `Supabase > V2-010 > V2-008` validée. Terme `v2_campagnes` banni au profit de `v2_dossiers_production` |
| 2026-08-06 | 🏛️ **ADR-V2-02 acté** | Pattern n8n monolithique validé : 1 seul workflow `V2 — Créateur de Dossier de Production` (C-V2-01 → C-V2-22) + V2-ERR séparé |

---

## 🧭 Règles de gouvernance du tracker

- Le tracker est **le seul document qui bouge à chaque séance**.
- Toute décision d'architecture prise en séance → à consigner dans `06.V2_Journal_des_Decisions_d_Architecture.md`.
- Toute modification de la V1 STABLE → refusée par défaut, sauf bug critique documenté.
- La V2 se construit dans **de nouveaux fichiers** dédiés (`01.V2_`, `02.V2_`, etc.), pour préserver la référence V1.
- Les critères de fin de séance doivent être remplis avant de clôturer une session.