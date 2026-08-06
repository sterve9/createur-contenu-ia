# 08 — Project Tracker

> **Point d'entrée officiel du projet Créateur de Contenu IA**  
> **Dernière mise à jour** : 08 août 2026

---

## 📌 Rôle du document

Le Project Tracker pilote l'avancement du projet. 
- Chaque séance commence par sa lecture et se termine par sa mise à jour.
- Il répond à 4 questions : **Où en est le projet ? Quelle est la prochaine tâche ? Quel document ouvrir ? Quand la séance est-elle terminée ?**
- Il ne contient aucune information d'architecture (voir `06.V2_Journal_des_Decisions_d_Architecture.md`).

---

## 📊 État global du projet

| Version | Statut | Progression | Description |
|---|---|---|---|
| **V1** | 🟢 STABLE | **100%** | Verrouillée. Tag `v1.0.0-stable` sur GitHub. Aucune modif. |
| **V2** | 🟡 DEV | **~65%** | Conception 100% OK. DDL, DB, V2-ORCH, V2-SCENE & V2-PLAN opérationnels et testés. |

- **Projet** : Assistant IA pour Créateurs de Contenu  
- **Phase actuelle** : Implémentation n8n du workflow V2 — **Prochaine étape : Bloc V2-IMG**

---

## 🎯 Tâche active

- **ID** : `V2-DEV-IMG`
- **Titre** : Implémentation du Bloc V2-IMG (C-V2-13 → C-V2-15)
- **Priorité** : P0
- **Statut** : 🟡 Prochaine tâche (Prêt à démarrer)

### Objectifs de la séance :
1. Redistribuer les 18 plans (récupérer un item par plan depuis la base).
2. Lire les conventions de l'outil image choisi (`outil_image_id = 1` : Playground AI).
3. Générer un prompt image optimisé pour chaque plan via LLM.
4. Persister les prompts dans `v2_prompts_images` (UPSERT sur `plan_id`).
5. Mettre à jour `v2_plans.statut = 'PROMPT_IMAGE_OK'` pour chaque plan traité.
6. Valider la structure de `v2_prompts_images` via `information_schema` avant toute écriture.

### Jeu de données de test (hérité) :
- `dossier_id` = `5`
- 18 plans en statut `EN_ATTENTE` prêts à être traités
- `outil_image_id` = `1` (Playground AI)

---

## 🚦 État d'avancement détaillé V2

### 1. Conception & Documentation V2 (100% ✅)
- ✅ 13 documents de conception validés (`01.V2` à `07.V2` + `04.1.V2` + `06.V2` Journal ADR).
- ✅ Audits de conformité réalisés (Audit V2-010 vs Supabase & Audit colonnes checklist).

### 2. Base de Données Supabase V2 (100% ✅)
- ✅ DDL V2 appliqué (`v2_dossiers_production`, `v2_checklists`, `v2_etapes_checklist`, `v2_scenes`, `v2_plans`, `v2_prompts`, `v2_descriptions_reseaux`, `v2_journal_execution`).
- ✅ Catalogue `v2_outils` peuplé (4 outils Image, 4 outils Animation).

### 3. Workflows n8n V2 (65% 🟡)

| Bloc n8n | Nœuds | Statut | Validation | Date |
|---|---|---|---|---|
| **V2-ERR** | Workflow d'erreur séparé | ✅ Terminé | Importé, activé, pushé GitHub | 06/08/2026 |
| **V2-ORCH** | C-V2-01 → C-V2-05b | ✅ Terminé | Tested OK (scénarios pos. & nég.) | 07/08/2026 |
| **V2-SCENE** | C-V2-06 → C-V2-08 | ✅ Terminé | Tested OK (5 scènes créées, script_id=13) | 08/08/2026 |
| **V2-PLAN** | C-V2-09 → C-V2-11b | ✅ Terminé | Tested OK (18 plans créés, 5 scènes) | 08/08/2026 |
| **V2-IMG** | C-V2-13 → C-V2-15 | ⏳ **Prochaine étape** | En attente de démarrage | — |
| **V2-ANIM** | C-V2-16 → C-V2-19 | ⬜ À faire | En attente de V2-IMG | — |
| **V2-PUB** | C-V2-20 → C-V2-22 | ⬜ À faire | En attente de V2-ANIM | — |

---

## 🧠 Décisions d'Architecture Actées (ADR Summary)

*Consulter `06.V2_Journal_des_Decisions_d_Architecture.md` pour les textes d'origine.*

- **ADR-V2-01** : Hiérarchie de vérité documentaire (`Supabase > V2-010 > V2-008`).
- **ADR-V2-02** : Orchestration monolithique (1 seul workflow n8n principal + 1 workflow V2-ERR séparé).
- **ADR-V2-03 (rev)** : Frontière V1/V2 via C-V2-03 simplifié à 2 `JOIN`s (`scripts → analyses → contenus`).
- **ADR-V2-04** : Validation stricte en amont `outil_id` ↔ catégorie (Image vs Animation).
- **ADR-V2-05** : Cardinalité 1-item garantie par bloc pour éviter les boucles accidentelles n8n.

---

## 📂 Documents à ouvrir (Ordre de séance)

1. `08_Project_Tracker.md` *(ce document)*
2. `06.V2_Journal_des_Decisions_d_Architecture.md` *(ADR-V2-01 à 05)*
3. `05.V2_Implementation_Technique.md` *(Spécifications exactes des nœuds C-V2-13 à C-V2-15)*
4. `04.1.V2_Catalogue_Outils.md` *(Conventions de prompt pour Playground AI - `outil_image_id = 1`)*
5. `04.V2_Specification_des_Composants.md` *(Prompts système du bloc V2-IMG)*
6. `07.V2_Plan_de_tests.md` *(Cas de tests pour validation)*

---

## 📈 Historique des Jalons Récents

| Date | Événement / Jalon | Impact |
|---|---|---|
| **03/08/2025** | 🎉 **V1 STABLE Livrée** | Baseline V1 verrouillée (`v1.0.0-stable`). |
| **12/11/2025** | 📐 **Conception V2 Terminée** | 12 documents de conception produits. |
| **06/08/2026** | 🛠️ **Infrastructure V2 posée** | DDL Supabase + Catalogue `v2_outils` + Workflow V2-ERR. |
| **06/08/2026** | 🏛️ **ADR-V2-01, 02, 03 Actés** | Choix du pattern monolithique et correction SQL C-V2-03. |
| **07/08/2026** | 🚀 **V2-ORCH Opérationnel** | Implémentation & test complet du bloc initial V2-ORCH. |
| **08/08/2026** | 🎬 **V2-SCENE Opérationnel** | Découpage LLM en scènes + persistance UPSERT. 5 scènes générées pour dossier de test. |
| **08/08/2026** | 📐 **V2-PLAN Opérationnel** | Découpage LLM en plans + barrière de phase C-V2-11b. 18 plans générés (3-4 par scène). Introduction du pattern Aggregate pour respecter ADR-V2-05. |

---

## 🧭 Critères de fin de séance (Bloc V2-IMG)

La prochaine séance sera considérée comme terminée uniquement si :
- [ ] La structure de `v2_prompts_images` dans Supabase est vérifiée via `information_schema`.
- [ ] Un nœud de redistribution récupère les 18 plans depuis la base (`SELECT`).
- [ ] Un nœud lit les conventions de l'outil image choisi (`v2_outils`).
- [ ] Les nœuds C-V2-13, C-V2-14, C-V2-15 sont intégrés au workflow monolithique.
- [ ] Un test d'exécution crée les 18 prompts images en base.
- [ ] Les 18 plans passent en statut `PROMPT_IMAGE_OK`.
- [ ] Le JSON mis à jour du workflow est sauvegardé localement.
- [ ] Le `08_Project_Tracker.md` est mis à jour avec le statut de V2-IMG et le passage à V2-ANIM.