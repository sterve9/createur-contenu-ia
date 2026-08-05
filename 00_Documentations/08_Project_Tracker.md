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
- **Version courante** : **V2 — Modélisation des données en cours**
- **Statut global** : 🟢 V1 STABLE verrouillée. Mapping des données V2 formalisé. Passage au contrat des données V2.
- **Phase actuelle** : Modélisation des données de la V2 (niveau contrat)
- **Dernière mise à jour** : 12 novembre 2025

---

## 🎯 Tâche active

- **ID** : `V2-007`
- **Titre** : Contrat des Données V2 — formaliser les garanties d'échange de données entre les composants V2 et entre les composants V2 et V1, à un niveau abstrait indépendant de toute technologie.
- **Priorité** : P0
- **Statut** : 🟡 En cours

**Livrables attendus** :
1. Définition du contrat d'entrée principal V2 (création d'une campagne enrichie avec choix des outils).
2. Définition des contrats de sortie entre les composants V2 (découpage → plans → prompts, etc.).
3. Formalisation du contrat V2 ↔ V1 (garanties minimales attendues des données V1 pour que la V2 fonctionne).
4. Formalisation du contrat V2 ↔ Dashboard (agrégation des données à exposer).
5. Formalisation du contrat V2 ↔ Catalogue d'Outils (structure attendue).
6. Explicitation des règles de validation et des invariants à respecter.
7. Rédaction du document `02.5.V2_Contrat_des_Donnees.md`.

---

## 📂 Documents à ouvrir (dans cet ordre uniquement)

1. `08_Project_Tracker.md` (ce document)
2. `02.1.V2_Modele_de_Donnees.md` — objets métier V2
3. `02.2.V2_Dictionnaire_des_Donnees.md` — attributs V2
4. `02.3.V2_Schema_Physique_des_Donnees.md` — schéma physique V2
5. `02.4.V2_Mapping_des_Donnees.md` — mapping V2 (référence directe)
6. `02.5_Contrat_des_Donnees.md` — contrat V1 (référence de style)

---

## ✅ Critères de fin de séance

La séance est terminée uniquement si :
- le contrat d'entrée principal V2 est formalisé (structure attendue à la création d'une campagne enrichie) ;
- les contrats de sortie entre les composants V2 sont explicites ;
- les garanties minimales attendues des données V1 par la V2 sont documentées ;
- le contrat d'exposition vers le Dashboard est décrit ;
- la structure du catalogue d'outils est décrite comme un contrat clair ;
- les règles de validation sont exhaustives ;
- aucune technologie d'implémentation (HTTP, JSON, SQL, n8n) n'apparaît dans le document ;
- le document `02.5.V2_Contrat_des_Donnees.md` est créé et intégré à `00_Documentations/` ;
- le Project Tracker est mis à jour (statut V2-007, prochaine tâche définie).

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
- 1 liste de hashtags par plateforme.

Accessible depuis un **tableau de bord personnel**.

### Décisions structurantes validées

- ✅ Persona : Side-hustler ambitieux (Persona B)
- ✅ Axe : Production assistée (pas de génération auto d'images/vidéos)
- ✅ 1 seul script ultra-complet par campagne (choisi par le créateur parmi les scripts V1)
- ✅ Choix des outils par le créateur au lancement de la campagne
- ✅ Un seul outil d'image + un seul outil d'animation par campagne (cohérence visuelle)
- ✅ Catalogue d'outils intégré (gratuits, freemium, payants — avec spécificités)
- ✅ Interface : tableau de bord personnel (pas de SaaS, pas de multi-utilisateurs)
- ✅ Usage : solo, open source, démonstration de résolution de problème métier
- ✅ Architecture : **V2 lit les données V1 (base partagée), réutilise les workflows V1, écrit dans ses propres tables V2** (E3 + E3-a)
- ✅ Structure visuelle : **Scène → N Plans → 1 Prompt Image + 1 Prompt Animation par plan** (permet le rythme visuel réel du montage vidéo court)
- ✅ 1 Script V1 peut donner lieu à N Dossiers de Production (pour tester plusieurs outils)
- ✅ Traçabilité : les prompts conservent l'`outil_id` pour lequel ils ont été générés
- ✅ Conventions physiques V2 : préfixe `v2_`, PK en BIGINT, timestamps en `timestamptz`, VARCHAR/TEXT selon règle
- ✅ Unicité d'écriture : chaque colonne V2 possède un seul composant écrivain (règle de mapping)

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
- ⬜ Passage éventuel en SaaS multi-utilisateurs

### Documentation V2

| Document | Statut |
|----------|--------|
| `01.V2_Besoin_Client` | ✅ |
| `02.V2_Architecture_metier` | ✅ |
| `02.1.V2_Modele_de_Donnees` | ✅ |
| `02.2.V2_Dictionnaire_des_Donnees` | ✅ |
| `02.3.V2_Schema_Physique_des_Donnees` | ✅ |
| `02.4.V2_Mapping_des_Donnees` | ✅ |
| `02.5.V2_Contrat_des_Donnees` | 🟡 En cours (V2-007) |
| `03.V2_Architecture_des_Workflows` | ⬜ |
| `04.V2_Specification_des_Composants` | ⬜ |
| `05.V2_Implementation_Technique` | ⬜ |
| `07.V2_Plan_de_tests` | ⬜ |

---

## ➜ Prochaine tâche

**V2-007 — Contrat des Données V2**
Formaliser les garanties d'échange de données :
- entre les composants V2 ;
- entre la V2 et la V1 (données lues) ;
- entre la V2 et le Dashboard (données exposées) ;
- entre la V2 et le Catalogue d'Outils.

Rédiger le document `02.5.V2_Contrat_des_Donnees.md`.

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
| **Contrat des données V2** | 🟡 En cours |
| Architecture workflows V2 | ⬜ |
| Spécification composants V2 | ⬜ |
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
| 2025-11-12 | 🎯 **Cadrage V2 terminé** | `01.V2_Besoin_Client.md` rédigé et validé — persona et axe métier fixés |
| 2025-11-12 | 🏛️ **Architecture métier V2 formalisée** | `02.V2_Architecture_metier.md` rédigé et validé — flux, objets, règles et positionnement V1/V2 actés |
| 2025-11-12 | 🧩 **Modèle conceptuel V2 formalisé** | `02.1.V2_Modele_de_Donnees.md` rédigé et validé — 9 nouveaux objets métier introduits, dont l'objet Plan pour respecter le rythme visuel réel |
| 2025-11-12 | 📖 **Dictionnaire des données V2 formalisé** | `02.2.V2_Dictionnaire_des_Donnees.md` rédigé et validé — tous les attributs V2 documentés (description, obligation, origine) |
| 2025-11-12 | 🛠️ **Schéma physique V2 formalisé** | `02.3.V2_Schema_Physique_des_Donnees.md` rédigé et validé — 9 tables V2 prêtes à créer dans Supabase, DDL complet |
| 2025-11-12 | 🔗 **Mapping des données V2 formalisé** | `02.4.V2_Mapping_des_Donnees.md` rédigé et validé — correspondance objet↔table exhaustive, composants écrivains identifiés |

---

## 🧭 Règles de gouvernance du tracker

- Le tracker est **le seul document qui bouge à chaque séance**.
- Toute décision d'architecture prise en séance → à consigner dans `06_Journal_des_Decisions_d_Architecture.md`.
- Toute modification de la V1 STABLE → refusée par défaut, sauf bug critique documenté.
- La V2 se construit dans **de nouveaux fichiers** dédiés (`01.V2_`, `02.V2_`, etc.), pour préserver la référence V1.
- Les critères de fin de séance doivent être remplis avant de clôturer une session.