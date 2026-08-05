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
- **Statut global** : 🟢 V1 STABLE verrouillée. Modèle conceptuel V2 formalisé. Passage au dictionnaire des données V2.
- **Phase actuelle** : Modélisation des données de la V2 (niveau dictionnaire)
- **Dernière mise à jour** : 12 novembre 2025

---

## 🎯 Tâche active

- **ID** : `V2-004`
- **Titre** : Dictionnaire des Données V2 — définir précisément toutes les données manipulées par les nouveaux objets métier V2, leur signification, leur caractère obligatoire ou facultatif, et leur origine.
- **Priorité** : P0
- **Statut** : 🟡 En cours

**Livrables attendus** :
1. Pour chaque nouvel objet V2 (Dossier de Production, Scène, Plan, Prompt Image, Prompt Animation, Description de Publication, Outil, Checklist, Étape de Checklist), lister l'ensemble des attributs.
2. Pour chaque attribut : description claire, caractère obligatoire, origine (utilisateur, système, IA, catalogue).
3. Explicitation des valeurs possibles pour les attributs à choix contraint (ex. statuts, modèle économique).
4. Vérification de la cohérence entre les attributs du dictionnaire et ceux du modèle conceptuel `02.1.V2`.
5. Rédaction du document `02.2.V2_Dictionnaire_des_Donnees.md`.

---

## 📂 Documents à ouvrir (dans cet ordre uniquement)

1. `08_Project_Tracker.md` (ce document)
2. `01.V2_Besoin_Client.md` — besoin V2 validé
3. `02.V2_Architecture_metier.md` — architecture métier V2 validée
4. `02.1.V2_Modele_de_Donnees.md` — modèle conceptuel V2 (référence directe)
5. `02.2_Dictionnaire_des_Donnees.md` — dictionnaire V1 (référence de style et de format)

**Ne pas consulter les documents techniques V1 (02.3, 03, 04, 05) pendant la rédaction du dictionnaire V2** — le risque est d'introduire prématurément des concepts techniques.

---

## ✅ Critères de fin de séance

La séance est terminée uniquement si :
- tous les attributs du modèle conceptuel V2 sont documentés dans le dictionnaire ;
- chaque attribut possède une description claire et non ambiguë ;
- le caractère obligatoire de chaque attribut est indiqué ;
- l'origine de chaque attribut est identifiée ;
- les valeurs possibles des attributs à choix contraint sont explicites ;
- aucune technologie d'implémentation n'apparaît dans le document ;
- le document `02.2.V2_Dictionnaire_des_Donnees.md` est créé et intégré à `00_Documentations/` ;
- le Project Tracker est mis à jour (statut V2-004, prochaine tâche définie).

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
La V2 apporte le contexte d'exécution qui manque à la V1 : transformer un script en dossier de production 