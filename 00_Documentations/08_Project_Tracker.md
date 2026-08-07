# 08 — Project Tracker

> **Point d'entrée officiel du projet Créateur de Contenu IA**  
> **Dernière mise à jour** : 10 août 2026

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
| **V2** | 🟡 DEV | **~90%** | Conception 100% OK. DDL, DB, V2-ORCH, V2-SCENE, V2-PLAN, V2-IMG & V2-ANIM opérationnels et testés. |

- **Projet** : Assistant IA pour Créateurs de Contenu  
- **Phase actuelle** : Implémentation n8n du workflow V2 — **Prochaine étape : Bloc V2-PUB**

---

## 🎯 Tâche active

- **ID** : `V2-DEV-PUB`
- **Titre** : Implémentation du Bloc V2-PUB (C-V2-20 → C-V2-22)
- **Priorité** : P0
- **Statut** : 🟡 Prêt à démarrer

### Objectifs de la séance :
1. Redistribuer le dossier finalisé (SELECT amont sur `v2_dossiers_production` + jointures nécessaires).
2. Générer les descriptions plateformes (titre, description, hashtags) via LLM.
3. Persister dans `v2_descriptions_reseaux` (UPSERT sur clé métier à confirmer).
4. Mettre à jour `v2_dossiers_production.nb_plans_traites` (choix acté séance V2-ANIM : `traité = publié`).
5. Basculer `v2_dossiers_production.statut` vers valeur finale autorisée (à vérifier via `information_schema`).
6. Barrière Aggregate finale (ADR-V2-06).
7. Tests end-to-end sur `dossier_id = 5`.

### Jeu de données de test (hérité) :
- `dossier_id = 5`
- 18 plans en statut `COMPLET`
- 18 prompts image + 18 prompts animation persistés
- `nb_plans_total = 18`, `nb_plans_traites = 0`

### Prérequis de vérification avant démarrage :
- Structure de `v2_descriptions_reseaux` via `information_schema`
- Contraintes (unicité, FK, CHECK sur statut dossier)
- Valeurs autorisées pour `v2_dossiers_production.statut` (contrainte CHECK)
- Prompt système du bloc V2-PUB dans `04.V2_Specification_des_Composants.md` §8

---

## 🚦 État d'avancement détaillé V2

### 1. Conception & Documentation V2 (100% ✅)
- ✅ 13 documents de conception validés (`01.V2` à `07.V2` + `04.1.V2` + `06.V2` Journal ADR).
- ✅ Audits de conformité réalisés (Audit V2-010 vs Supabase & Audit colonnes checklist).

### 2. Base de Données Supabase V2 (100% ✅)
- ✅ DDL V2 appliqué (`v2_dossiers_production`, `v2_checklists`, `v2_etapes_checklist`, `v2_scenes`, `v2_plans`, `v2_prompts_images`, `v2_prompts_animations`, `v2_descriptions_reseaux`, `v2_journal_execution`).
- ✅ Catalogue `v2_outils` peuplé (4 outils Image, 4 outils Animation).

### 3. Workflows n8n V2 (90% 🟡)

| Bloc n8n | Nœuds | Statut | Validation | Date |
|---|---|---|---|---|
| **V2-ERR** | Workflow d'erreur séparé | ✅ Terminé | Importé, activé, pushé GitHub | 06/08/2026 |
| **V2-ORCH** | C-V2-01 → C-V2-05b | ✅ Terminé | Tested OK (scénarios pos. & nég.) | 07/08/2026 |
| **V2-SCENE** | C-V2-06 → C-V2-08 | ✅ Terminé | Tested OK (5 scènes créées, script_id=13) | 08/08/2026 |
| **V2-PLAN** | C-V2-09 → C-V2-11b | ✅ Terminé | Tested OK (18 plans créés, 5 scènes) | 08/08/2026 |
| **V2-IMG** | C-V2-13 → C-V2-15e | ✅ Terminé | Tested OK (7 nœuds + Aggregate, 18 prompts générés en ~40s) | 09/08/2026 |
| **V2-ANIM** | C-V2-16 → C-V2-18 (7 nœuds + Aggregate) | ✅ Terminé | Tested OK end-to-end (18 prompts animations générés, plans basculés en COMPLET, cardinalité 1 item validée) | 10/08/2026 |
| **V2-PUB** | C-V2-20 → C-V2-22 | ⏳ **Prochaine étape** | En attente de démarrage | — |

---

## 🧠 Décisions d'Architecture Actées (ADR Summary)

*Consulter `06.V2_Journal_des_Decisions_d_Architecture.md` pour les textes d'origine.*

- **ADR-V2-01** : Hiérarchie de vérité documentaire (`Supabase > V2-010 > V2-008`).
- **ADR-V2-02** : Orchestration monolithique (1 seul workflow n8n principal + 1 workflow V2-ERR séparé).
- **ADR-V2-03 (rev)** : Frontière V1/V2 via C-V2-03 simplifié à 2 `JOIN`s (`scripts → contenus → campagnes`).
- **ADR-V2-04** : Validation stricte en amont `outil_id` ↔ catégorie (Image vs Animation).
- **ADR-V2-05** : Cardinalité 1-item garantie par bloc pour éviter les boucles accidentelles n8n.
- **ADR-V2-06** : Barrières de regroupement Aggregate pour isoler le fan-out par bloc.
- **ADR-V2-07** : Fusion des conventions d'outils (`v2_outils`) dans la requête `SELECT` amont du bloc. *(Validé empiriquement sur V2-IMG le 09/08/2026 et V2-ANIM le 10/08/2026)*.

---

## 📂 Documents à ouvrir (Ordre de séance)

1. `08_Project_Tracker.md` *(ce document)*
2. `06.V2_Journal_des_Decisions_d_Architecture.md` *(ADR-V2-01 à 07)*
3. `05.V2_Implementation_Technique.md` *(Spécifications exactes des nœuds C-V2-20 à C-V2-22)*
4. `04.V2_Specification_des_Composants.md` *(Prompts système du bloc V2-PUB)*
5. `07.V2_Plan_de_tests.md` *(Cas de tests pour validation)*

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
| **08/08/2026** | 📐 **V2-PLAN Opérationnel** | Découpage LLM en plans + barrière de phase C-V2-11b. 18 plans générés (3-4 par scène). Pattern Aggregate (ADR-V2-05). |
| **09/08/2026** | 🖼️ **V2-IMG Opérationnel** | 7 nœuds + Aggregate. 18 prompts image générés par Claude (~40s), persistés en base. Formalisation ADR-V2-07 (fusion outil amont). Progression : 65% → 75%. |
| **10/08/2026** | 🎥 **V2-ANIM Opérationnel** | 7 nœuds + Aggregate (miroir V2-IMG). 18 prompts animations Kling AI générés, plans basculés en `COMPLET`. Réplication réussie ADR-V2-07 sur `outil_animation_id`. Décision actée : `nb_plans_traites` sera mis à jour dans V2-PUB (sémantique "traité = publié"). Progression : 75% → 90%. |

---

## 🧭 Critères de fin de séance (Bloc V2-PUB)

La prochaine séance sera considérée comme terminée uniquement si :
- [ ] La structure de `v2_descriptions_reseaux` dans Supabase est vérifiée via `information_schema`.
- [ ] Les valeurs autorisées pour `v2_dossiers_production.statut` sont vérifiées via `information_schema`.
- [ ] Les nœuds C-V2-20, C-V2-21, C-V2-22 sont intégrés au workflow monolithique.
- [ ] Un test d'exécution crée les descriptions plateformes en base.
- [ ] `v2_dossiers_production.nb_plans_traites` est mis à jour (= 18 pour le test).
- [ ] `v2_dossiers_production.statut` bascule vers valeur finale (à confirmer, ex: `TERMINE`).
- [ ] La barrière Aggregate finale (ADR-V2-06) valide la cardinalité 1-item du bloc.
- [ ] Le JSON mis à jour du workflow est sauvegardé localement + commit Git.
- [ ] Le `08_Project_Tracker.md` est mis à jour avec le statut de V2-PUB et le passage à la clôture V2.