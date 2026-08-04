# 🎬 Créateur de Contenu IA — Automated Content Intelligence Pipeline

> Système automatisé de veille et de génération de scripts vidéo courts pour créateurs de contenu, basé sur **n8n**, **PostgreSQL** et **Claude AI**.

[![Status](https://img.shields.io/badge/status-V1%20STABLE-success)]()
[![n8n](https://img.shields.io/badge/n8n-workflow-EA4B71?logo=n8n&logoColor=white)]()
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-16-336791?logo=postgresql&logoColor=white)]()
[![Anthropic](https://img.shields.io/badge/Claude-Opus%20%2B%20Sonnet-D4A373)]()
[![License](https://img.shields.io/badge/license-MIT-blue)](LICENSE)

---

## 🎯 Le problème

Un créateur de contenu IA passe **plusieurs heures par jour** à faire de la veille sur les tendances, analyser ce qui fonctionne, puis rédiger des scripts pour ses vidéos courtes (TikTok, YouTube Shorts, Reels).
Ces tâches sont **répétitives, chronophages et sans valeur ajoutée créative directe**.

## 💡 La solution

Un pipeline automatisé qui, à partir d'un simple sujet :

1. **Collecte** N contenus depuis YouTube via l'API officielle
2. **Analyse** chaque contenu par IA (résumé, thème, sentiment, score de qualité, mots-clés)
3. **Génère** un script vidéo prêt-à-tourner de moins de 60 secondes (hook + corps + CTA)
4. **Historise** l'ensemble dans une base PostgreSQL avec traçabilité complète
5. **Supervise** l'avancement en temps réel avec statuts et compteurs
6. **Gère les incidents** via un workflow d'erreur dédié

**Résultat** : ce qui prenait 2 à 3 heures de travail manuel se fait en quelques minutes, avec une base de scripts exploitables.

---

## 📸 Aperçu

### Workflow principal
![Workflow principal n8n](docs/assets/workflow-principal.png)

### Workflow d'erreur
![Workflow d'erreur n8n](docs/assets/workflow-erreur.png)

### Résultat en base
![Campagne terminée](docs/assets/campagne-resultat.png)

---

## 🏗️ Architecture en un coup d'œil

```
┌─────────────┐
│   Webhook   │  POST /lancer-campagne
└──────┬──────┘
       │ {sujet, plateforme, langue, nb_resultats}
       ▼
┌─────────────────────────────────────┐
│  C01 → C02 → C03  (Création)        │
│  C04 → C05 → C05a-d  (Collecte)     │
│  C06  (Persistance contenus)        │
│  C07 → C08 → C09  (Analyse IA)      │
│  C10 → C11 → C12 → C13  (Script IA) │
│  C14 → C15  (Suivi compteur)        │
└─────────────────────────────────────┘
       │
       ▼
   PostgreSQL
   (campagnes, contenus, analyses, scripts)

En parallèle, sur exception :
┌────────────────────────────────────┐
│  E01 → E02 → E03 → E04             │
│  (Capture, Structure, Log, Update) │
└────────────────────────────────────┘
```

**Corrélation technique/métier** via `execution_id` — le workflow d'erreur retrouve toujours la campagne concernée sans partage d'état mémoire.

---

## 🛠️ Stack technique

| Couche | Techno |
|--------|--------|
| Orchestration | **n8n** (self-hosted) |
| Base de données | **PostgreSQL 16** |
| IA — Analyse sémantique | **Claude Opus** (Anthropic) |
| IA — Génération créative | **Claude Sonnet** (Anthropic) |
| Source de données | **YouTube Data API v3** |

---

## ✨ Ce que ce projet démontre

Ce n'est pas juste "un workflow n8n". C'est une **démarche d'architecte** appliquée à un projet réel :

- 🧠 **Pensée architecturale** : séparation stricte des responsabilités, workflow d'erreur indépendant, corrélation par identifiant technique
- 📐 **Modélisation métier avant technique** : contexte, besoin, modèle de données, contrats d'interface — tout est documenté
- 🔒 **Idempotence garantie** : UPSERT systématiques sur les clés métier, aucune duplication même en cas de relance
- 📊 **Observabilité native** : compteurs et statuts en base, aucune campagne fantôme
- 🧪 **Testabilité** : 23 tests unitaires, 14 d'intégration, 4 E2E, 6 de robustesse — chacun tracé à un composant
- 📚 **Traçabilité des décisions** : 19 ADR (Architecture Decision Records) expliquant *pourquoi* chaque choix a été fait
- 🎯 **Livrable stable** : V1 marquée, testée, versionnée — pas de "ça marche sur ma machine"

---

## 📖 Documentation

La documentation complète est dans [`00_Documentations/`](./00_Documentations/) :

| Document | Rôle |
|----------|------|
| [`00_Contexte_Du_Client`](./00_Documentations/00_Contexte_Du_Client.md) | Qui est le client, son activité, ses outils |
| [`01_Besoin_Client`](./00_Documentations/01_Besoin_Client.md) | Le problème métier à résoudre |
| [`02_Architecture_metier`](./00_Documentations/02_Architecture_metier.md) | Vue métier du système |
| [`02.1_Modele_de_Donnees`](./00_Documentations/02.1_Modele_de_Donnees.md) | Objets métier et relations |
| [`02.2_Dictionnaire_des_Donnees`](./00_Documentations/02.2%20-%20Dictionnaire%20des%20Données.md) | Signification de chaque donnée |
| [`02.3_Schema_Physique_des_Donnees`](./00_Documentations/02.3_Schema_Physique_des_Donnees.md) | DDL PostgreSQL |
| [`02.4_Mapping_des_Donnees`](./00_Documentations/02.4_Mapping_des_Donnees.md) | Propagation des données entre composants |
| [`02.5_Contrat_des_Donnees`](./00_Documentations/02.5_Contrat_des_Donnees.md) | Contrats d'entrée/sortie de chaque composant |
| [`03_Architecture_des_Workflows`](./00_Documentations/03_Architecture_des_Workflows.md) | Cycle de vie des workflows |
| [`04_Specification_des_Composants`](./00_Documentations/04_Specification_des_Composants.md) | Description détaillée de chaque nœud |
| [`05_Implementation_Technique`](./00_Documentations/05_Implementation_Technique.md) | Configuration réelle dans n8n |
| [`06_Journal_des_Decisions_d_Architecture`](./00_Documentations/06_Journal_des_Decisions_d_Architecture.md) | Les 19 ADR du projet |
| [`07_Plan_de_tests`](./00_Documentations/07_Plan_de_tests.md) | 47 scénarios de tests |
| [`08_Project_Tracker`](./00_Documentations/08_Project_Tracker.md) | Suivi d'avancement |

---

## 🚀 Installation

### Prérequis
- n8n (v1.60+ recommandé)
- PostgreSQL 16
- Un compte Anthropic (API key)
- Un compte Google Cloud avec YouTube Data API v3 activée

### 1. Base de données
```bash
psql -U postgres -d createur_contenu -f database/schema.sql
```

### 2. Import des workflows n8n
1. Ouvrir n8n → Workflows → Import from File
2. Importer `workflows/01_workflow_principal.json`
3. Importer `workflows/02_workflow_erreur.json`
4. Configurer les credentials (`PostgreSQL`, `YouTube API`, `Anthropic`)
5. Dans les Settings du workflow principal → *Error Workflow* → sélectionner le workflow d'erreur

### 3. Lancer une campagne
```bash
curl -X POST https://votre-instance-n8n.com/webhook/lancer-campagne \
  -H "Content-Type: application/json" \
  -d '{
    "sujet": "Automatisation IA",
    "plateforme": "YouTube",
    "langue": "fr",
    "nb_resultats": 5
  }'
```

---

## 🗺️ Roadmap

- ✅ **V1 STABLE** — Pipeline complet : collecte → analyse → script (livré)
- 🟡 **V2** — En cours de cadrage (résolution d'un vrai problème créateur identifié)
- ⬜ **V3+** — Extension multi-plateformes, tableau de bord, publication automatisée

---

## 👤 Auteur

**Sterve**
🔗 [LinkedIn](https://www.linkedin.com/in/sterve-ai)
💡 *Turning ideas into AI-powered automations | n8n • Telegram • Google*

---

## 📄 Licence

Ce projet est distribué sous licence [MIT](LICENSE).