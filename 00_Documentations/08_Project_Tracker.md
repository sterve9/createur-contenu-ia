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
- **Version courante** : **V1 STABLE** ✅
- **Statut global** : 🟢 V1 STABLE livrée, documentée et sauvegardée. Cadrage V2 en cours.
- **Phase actuelle** : Cadrage métier de la V2
- **Dernière mise à jour** : (à mettre à jour à chaque séance)

---

## 🎯 Tâche active

- **ID** : `V2-001`
- **Titre** : Cadrage du besoin métier V2 — identifier un vrai problème de créateur de contenu que la V2 doit résoudre.
- **Priorité** : P0
- **Statut** : 🟡 En cours

**Livrables attendus** :
1. Formalisation du problème créateur adressé.
2. Proposition de 2 à 3 axes de solution (métier, pas technique).
3. Choix de l'axe retenu et justification.
4. Rédaction du besoin V2 (nouveau fichier `01.V2_Besoin_Client.md` ou mise à jour de `01_Besoin_Client.md`).

---

## 📂 Documents à ouvrir (dans cet ordre uniquement)

1. `08_Project_Tracker.md` (ce document)
2. `00_Contexte_Du_Client.md` — pour re-contextualiser le persona
3. `01_Besoin_Client.md` — pour rappeler le besoin V1
4. `02_Architecture_metier.md` — pour situer la V1 dans son intention initiale

**Ne pas consulter les documents techniques (02.x, 03, 04, 05) pendant la phase de cadrage V2** — le risque est de rester dans la logique technique V1 au lieu de repartir du besoin utilisateur.

---

## ✅ Critères de fin de séance

La séance est terminée uniquement si :
- le problème créateur adressé par la V2 est formalisé par écrit ;
- au moins 2 axes de solution sont posés sur la table ;
- un axe est choisi et justifié ;
- le Project Tracker est mis à jour (statut V2-001, prochaine tâche définie).

**Ne pas démarrer la spécification technique V2 avant d'avoir validé le besoin.**

---

## 🔒 Avancement V1 STABLE (verrouillé)

La V1 STABLE est **livrée, testée et documentée**. Aucune modification de la V1 n'est prévue.

### Documentation V1

| Document | Statut |
|----------|--------|
| `00_Contexte_Du_Client` | ✅ |
| `01_Besoin_Client` | ✅ |
| `02_Architecture_metier` | ✅ |
| `02.1_Modele_de_Donnees` | ✅ |
| `02.2_Dictionnaire_des_Donnees` | ✅ |
| `02.3_Schema_Physique_des_Donnees` | ✅ |
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

## 🚀 Roadmap V2 (à définir)

### Objectif de la V2

**Résoudre un vrai problème de créateur de contenu.**
La V2 n'est pas une amélioration technique de la V1 : elle doit apporter une valeur métier nouvelle et mesurable.

### Axes candidats (à arbitrer pendant V2-001)

*(À compléter lors du cadrage V2)*

- ⬜ Axe A : *(à définir)*
- ⬜ Axe B : *(à définir)*
- ⬜ Axe C : *(à définir)*

### Ce que la V2 n'est PAS
- une simple amélioration technique ;
- un ajout de plateformes sans problème utilisateur clair derrière ;
- une refonte de l'architecture V1 (sauf nécessité imposée par le besoin).

---

## ➜ Prochaine tâche

**V2-001 — Cadrage métier de la V2**
Identifier et formaliser le problème créateur à résoudre, proposer les axes de solution, choisir l'axe retenu.

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
| **Cadrage métier V2** | 🟡 En cours |
| Conception V2 | ⬜ |
| Développement V2 | ⬜ |
| Tests & validation V2 | ⬜ |
| Déploiement V2 | ⬜ |

---

## 📜 Historique des jalons

| Date | Jalon | Détail |
|------|-------|--------|
| *(à dater)* | 🎉 **V1 STABLE livrée** | Workflow principal C01→C15 + workflow d'erreur E01→E04 opérationnels, testés, sauvegardés |
| *(à dater)* | 📚 Alignement documentaire V1 STABLE | Toute la doc `00_Documentations/` synchronisée avec l'implémentation réelle |
| *(aujourd'hui)* | 🎯 Ouverture du cadrage V2 | Démarrage de V2-001 |

---

## 🧭 Règles de gouvernance du tracker

- Le tracker est **le seul document qui bouge à chaque séance**.
- Toute décision d'architecture prise en séance → à consigner dans `06_Journal_des_Decisions_d_Architecture.md`.
- Toute modification de la V1 STABLE → refusée par défaut, sauf bug critique documenté.
- La V2 se construit dans **de nouveaux fichiers** ou dans des sections `V2` clairement identifiées, pour préserver la référence V1.