🎬 Créateur de Contenu IA — Automated Content Intelligence Pipeline
Système automatisé de veille, génération de scripts vidéo courts et préparation complète des dossiers de production, basé sur n8n, PostgreSQL et Claude AI.

Status
V1
V2
n8n
PostgreSQL
Anthropic
License

🎯 Le problème
Un créateur de contenu IA passe plusieurs heures par jour à :

Faire de la veille sur les tendances et analyser ce qui fonctionne.
Rédiger des scripts pour ses vidéos courtes (TikTok, YouTube Shorts, Reels).
Découper mentalement chaque script en scènes, imaginer les visuels, rédiger un prompt image et un prompt animation par plan, puis préparer les descriptions et hashtags pour chaque plateforme.
Ces tâches sont répétitives, chronophages et sans valeur ajoutée créative directe. Elles épuisent son énergie mentale avant même qu'il ait ouvert son outil de génération.

💡 La solution — Pipeline en 2 versions
Un pipeline automatisé en deux étages, chacun résolvant un problème métier distinct :

🅰️ V1 STABLE — Génération de scripts
À partir d'un simple sujet :

Collecte N contenus depuis YouTube via l'API officielle
Analyse chaque contenu par IA (résumé, thème, sentiment, score de qualité, mots-clés)
Génère un script vidéo prêt-à-tourner de moins de 60 secondes (hook + corps + CTA)
Historise l'ensemble dans PostgreSQL avec traçabilité complète
Supervise l'avancement en temps réel
Gère les incidents via un workflow d'erreur dédié
🅱️ V2 STABLE — Dossier de production complet
À partir d'un script V1 + du choix d'un outil image + du choix d'un outil animation :

Découpe le script en scènes narratives (2 à 5 par script)
Subdivise chaque scène en plans visuels (2 à 4 par scène)
Génère un prompt image optimisé par plan, adapté à l'outil image choisi
Génère un prompt animation optimisé par plan, adapté à l'outil animation choisi
Produit 3 jeux de descriptions/hashtags optimisés pour TikTok, YouTube Shorts et Instagram Reels
Clôture le dossier avec suivi d'avancement via checklist en 9 étapes
Résultat combiné (V1 + V2) :

Ce qui prenait 3+ heures de travail manuel (veille → analyse → script → découpage → prompts → descriptions) se fait en ~5 minutes de traitement automatique. Le créateur récupère un dossier complet et peut se concentrer sur son cœur de métier : générer les visuels dans ses outils, monter et publier.

📸 Aperçu
V1 — Workflow principal
Workflow principal n8n

V1 — Workflow d'erreur
Workflow d'erreur n8n

V1 — Résultat en base
Campagne terminée

V2 — Workflow monolithique complet
(Screenshot à ajouter : docs/assets/v2-workflow-complet.png)

V2 — Dossier de production terminé
(Screenshot à ajouter : docs/assets/v2-dossier-termine.png)

🏗️ Architecture en un coup d'œil
V1 — Pipeline de génération de scripts
text

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
V2 — Pipeline de préparation de dossier de production
text

┌─────────────┐
│   Webhook   │  POST /v2-creer-dossier
└──────┬──────┘
       │ {script_id, outil_image_id, outil_animation_id}
       ▼
┌──────────────────────────────────────────────────────┐
│  V2-ORCH   C-V2-01 → C-V2-05b   (Validation & Init)  │
│  V2-SCENE  C-V2-06 → C-V2-08    (Découpage scènes)   │
│  V2-PLAN   C-V2-09 → C-V2-11b   (Découpage plans)    │
│  V2-IMG    C-V2-13 → C-V2-15e   (Prompts images LLM) │
│  V2-ANIM   C-V2-16 → C-V2-18    (Prompts anim LLM)   │
│  V2-PUB    C-V2-20 → C-V2-22    (Descriptions + Fin) │
└──────────────────────────────────────────────────────┘
       │
       ▼
   PostgreSQL
   (v2_dossiers_production, v2_scenes, v2_plans,
    v2_prompts_images, v2_prompts_animations,
    v2_descriptions_publication, v2_checklists,
    v2_etapes_checklist, v2_outils)

Workflow d'erreur V2-ERR séparé (errorWorkflow n8n).
Corrélation technique/métier : chaque dossier possède un execution_id unique (UUID) qui trace l'ensemble du pipeline, y compris les incidents éventuels — sans partage d'état mémoire.

🛠️ Stack technique
Couche	Techno
Orchestration	n8n (self-hosted)
Base de données	PostgreSQL 16 (Supabase)
IA — Analyse sémantique (V1)	Claude Opus (Anthropic)
IA — Génération créative (V1 + V2)	Claude Sonnet 5 (Anthropic)
Source de données (V1)	YouTube Data API v3
Outils image supportés (V2)	Playground AI, SeaArt AI, Tensor.Art, Midjourney
Outils animation supportés (V2)	Kling AI, Pika, Hailuo AI, Runway Gen-3 Alpha
✨ Ce que ce projet démontre
Ce n'est pas juste "un workflow n8n". C'est une démarche d'architecte appliquée à un projet réel, sur deux itérations successives :

🧠 Pensée architecturale : séparation stricte des responsabilités, workflow d'erreur indépendant, corrélation par identifiant technique, extension V2 sans refonte V1.
📐 Modélisation métier avant technique : contexte, besoin, modèle de données, contrats d'interface — tout est documenté avant chaque ligne de code.
🔒 Idempotence garantie : UPSERT systématiques sur les clés métier, aucune duplication même en cas de relance.
📊 Observabilité native : compteurs, statuts et journaux d'exécution en base, aucune campagne ni dossier fantôme.
🧪 Testabilité rigoureuse : chaque bloc V2 testé unitairement + 2 tests end-to-end complets sur 2 sujets distincts (dossier_id=5 et dossier_id=6).
📚 Traçabilité des décisions : 19 ADR pour la V1 + 7 ADR pour la V2 — chaque choix est expliqué et daté.
🎯 Livrables versionnés : v1.0.0-stable et v2.0.0-stable sur GitHub, tags immuables.
🧑‍🎨 Respect du persona : la V2 ne remplace pas le créateur ; elle libère son énergie mentale pour la partie qui a réellement de la valeur — le montage et la créativité visuelle.
📖 Documentation
La documentation complète est dans 00_Documentations/.

📁 Documentation V1
Document	Rôle
00_Contexte_Du_Client	Qui est le client, son activité, ses outils
01_Besoin_Client	Le problème métier V1 à résoudre
02_Architecture_metier	Vue métier du système V1
02.1_Modele_de_Donnees	Objets métier V1 et relations
02.2_Dictionnaire_des_Donnees	Signification de chaque donnée V1
02.3_Schema_Physique_des_Donnees	DDL PostgreSQL V1
02.4_Mapping_des_Donnees	Propagation des données V1
02.5_Contrat_des_Donnees	Contrats des composants V1
03_Architecture_des_Workflows	Cycle de vie V1
04_Specification_des_Composants	Composants V1
05_Implementation_Technique	Configuration V1 dans n8n
06_Journal_des_Decisions_d_Architecture	19 ADR V1
07_Plan_de_tests	47 scénarios de tests V1
📁 Documentation V2
Document	Rôle
01.V2_Besoin_Client	Le problème métier V2 à résoudre
02.V2_Architecture_metier	Vue métier V2
03.V2_Modele_de_Donnees	Nouveau modèle V2 (9 tables)
04.V2_Specification_des_Composants	Prompts système des LLM V2
04.1.V2_Catalogue_Outils	Catalogue v2_outils
05.V2_Implementation_Technique	Spécifications des nœuds V2
06.V2_Journal_des_Decisions_d_Architecture	7 ADR V2
07.V2_Plan_de_tests	Cas de tests V2
📁 Suivi projet
Document	Rôle
08_Project_Tracker	Suivi d'avancement V1 + V2
🚀 Installation
Prérequis
n8n (v1.60+ recommandé)
PostgreSQL 16 (ou Supabase)
Un compte Anthropic (API key, modèles Opus + Sonnet 5)
Un compte Google Cloud avec YouTube Data API v3 activée (V1 uniquement)
1. Base de données
Bash

# Schéma V1
psql -U postgres -d createur_contenu -f database/schema.sql

# Schéma V2 (extension du schéma V1)
psql -U postgres -d createur_contenu -f database/schema_v2.sql
2. Import des workflows n8n
V1 :

Ouvrir n8n → Workflows → Import from File
Importer workflows/V1/01_workflow_principal.json
Importer workflows/V1/02_workflow_erreur.json
Configurer les credentials (PostgreSQL, YouTube API, Anthropic)
Settings du workflow principal V1 → Error Workflow → sélectionner le workflow d'erreur V1
V2 :

Importer workflows/V2/V2_Creer_Dossier_Production.json
Importer workflows/V2/V2-ERR_Gestionnaire_Erreurs.json
Vérifier les credentials Postgres + Anthropic (partagées avec V1)
Settings du workflow V2 → Error Workflow → sélectionner V2-ERR
3. Lancer une campagne V1
Bash

curl -X POST https://votre-instance-n8n.com/webhook/lancer-campagne \
  -H "Content-Type: application/json" \
  -d '{
    "sujet": "Automatisation IA",
    "plateforme": "YouTube",
    "langue": "fr",
    "nb_resultats": 5
  }'
4. Lancer la génération d'un dossier de production V2
Bash

curl -X POST https://votre-instance-n8n.com/webhook/v2-creer-dossier \
  -H "Content-Type: application/json" \
  -d '{
    "script_id": 18,
    "outil_image_id": 1,
    "outil_animation_id": 5
  }'
(Le script_id doit correspondre à un script généré par la V1 dans une campagne au statut TERMINEE.)

5. Consulter un dossier de production
SQL

SELECT
    d.id                AS dossier_id,
    d.statut,
    d.nb_plans_total,
    d.nb_plans_traites,
    (SELECT COUNT(*) FROM v2_scenes s WHERE s.dossier_id = d.id) AS nb_scenes,
    (SELECT COUNT(*) FROM v2_descriptions_publication dr WHERE dr.dossier_id = d.id) AS nb_descriptions
FROM v2_dossiers_production d
WHERE d.id = <ton_dossier_id>;
🗺️ Roadmap
✅ V1 STABLE — Pipeline complet : collecte → analyse → script (livré le 03/08/2025)
✅ V2 STABLE — Backend complet : script → scènes → plans → prompts image/animation → descriptions publications (livré le 10/08/2026)
🟡 V2.1 Frontend — Tableau de bord personnel de suivi des dossiers de production (en cadrage)
⬜ V3+ — Post-production : voix off, montage assemblé, publication automatique multi-plateformes
👤 Auteur
Sterve
🔗 LinkedIn
💡 Turning ideas into AI-powered automations | n8n • PostgreSQL • Claude AI

📄 Licence
Ce projet est distribué sous licence MIT.