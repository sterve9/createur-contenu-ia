# 08 — Project Tracker

> **Point d'entrée officiel du projet Créateur de Contenu IA**  
> **Dernière mise à jour** : 09 août 2026

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
| **V2** | 🟢 STABLE | **100%** | End-to-end validée sur 2 scripts distincts. Tag `v2.0.0-stable`. |
| **V2.1** | 🔵 EN COURS | **~60%** | Frontend Dashboard — S1 Auth ✅ + S2 Liste ✅ + S3 Détail complète ✅. Prochain : S4 (composant Copier D). |
---
## 🎯 Tâche active

- **ID** : V2.1-S4 (à démarrer)
- **Titre** : Composant "Copier" (D) — bouton copie sur chaque prompt/description
- **Statut** : ⏳ À DÉMARRER
- **Séance** : S4 / 7
- **Objectif** : Ajouter un bouton "Copier" fonctionnel avec feedback visuel à côté de chaque prompt image, prompt animation et description plateforme. Utiliser `navigator.clipboard.writeText()` dans un composant client (`"use client"`).

### ✅ Séances précédentes terminées
- **V2.1-S1** : Setup Next.js 16 + Supabase Auth Magic Link → 🟢 TERMINÉ le 08/08/2026
- **V2.1-S2** : Vue Liste des dossiers (B) — Requête serveur + RLS + Table → 🟢 TERMINÉ le 08/08/2026
  - Commit : `feat(dashboard): add dossiers table with RLS-scoped data`
- **V2.1-S3** : Vue Détail dossier (C) complète + navigation Vue B → Vue C → 🟢 TERMINÉ le 09/08/2026
  - Commit : `feat(dashboard): complete dossier detail view with scenes, plans, prompts and navigation`
  - Preuve : Vue C hiérarchique (dossier → scènes → plans → prompts image + animation) + descriptions par plateforme + lien "Voir" fonctionnel depuis Vue B

---

## 🚦 État d'avancement détaillé V2.1

### Séances V2.1

| Séance | Livrable | Statut | Date |
|---|---|---|---|
| **S1** | Setup Next.js + Supabase Auth Magic Link | 🟢 Terminé | 08/08/2026 |
| **S2** | Vue "Liste des dossiers" (B) | 🟢 Terminé | 08/08/2026 |
| **S3** | Vue "Détail d'un dossier" (C) complète | 🟢 Terminé | 09/08/2026 |
| **S4** | Composant "Copier" (D) intégré partout | ⏳ À démarrer | — |
| **S5** | Vue "Créer un dossier" (F) + webhook n8n | ⏳ Planifié | — |
| **S6** | Déploiement Vercel + domaine `dashboard.sterveshop.cloud` | ⏳ Planifié | — |
| **S7** | Documentation V2.1 + tag `v2.1.0-stable` | ⏳ Planifié | — |

### Micro-étapes S3 réalisées ✅ (récap)
- ✅ Structure route dynamique `/dashboard/dossiers/[id]`
- ✅ Protection auth (redirect `/login`)
- ✅ Lecture sécurisée du dossier via RLS
- ✅ Lecture scènes (`v2_scenes` filtrées par `dossier_id`, triées par `numero_scene`)
- ✅ Lecture plans (`v2_plans` via `.in("scene_id", sceneIds)`, triés par `numero_plan`)
- ✅ Lecture prompts image (`v2_prompts_images` via `.in("plan_id", planIds)`)
- ✅ Lecture prompts animation (`v2_prompts_animations` via `.in("plan_id", planIds)`)
- ✅ Lecture descriptions (`v2_descriptions_publication` filtrées par `dossier_id`)
- ✅ Affichage hiérarchique minimaliste (dossier → scènes → plans → 2 prompts)
- ✅ Descriptions par plateforme en grille 3 colonnes
- ✅ Lien "Voir" depuis Vue B (colonne Actions avec `<Link>` Next.js)

---

## 🧠 Décisions produit V2.1 actées

### DP-V2.1-01 — Vue C minimaliste orientée action (S3)
**Contexte** : le pipeline V2 produit plusieurs champs par plan/scène (`ambiance_visuelle`, `description_visuelle`, `parametres_recommandes`) qui ne sont pas directement copiés par l'utilisateur dans ses outils IA.  
**Décision** : la Vue C n'affiche **que les champs actionnables** : narration (voix off), prompt image, prompt animation, descriptions par plateforme.  
**Justification** : cohérent avec §7 du besoin V2.1 → *"UX orientée copie rapide : passer d'un dossier à ses outils en < 30 secondes"*. Les champs non affichés sont conservés en base (aucune suppression DB).

---

## 🚦 État d'avancement détaillé V2 (rappel)

### 1. Conception & Documentation V2 (100% ✅)
### 2. Base de Données Supabase V2 (100% ✅)
### 3. Workflows n8n V2 (100% ✅)

| Bloc n8n | Nœuds | Statut | Date |
|---|---|---|---|
| **V2-ERR** | Workflow séparé | ✅ Terminé | 06/08/2026 |
| **V2-ORCH** | C-V2-01 → C-V2-05b | ✅ Terminé | 07/08/2026 |
| **V2-SCENE** | C-V2-06 → C-V2-08 | ✅ Terminé | 08/08/2026 |
| **V2-PLAN** | C-V2-09 → C-V2-11b | ✅ Terminé | 08/08/2026 |
| **V2-IMG** | C-V2-13 → C-V2-15e (7 nœuds) | ✅ Terminé | 09/08/2026 |
| **V2-ANIM** | C-V2-16 → C-V2-18 (7 nœuds) | ✅ Terminé | 10/08/2026 |
| **V2-PUB** | C-V2-20 → C-V2-22 (7 nœuds) | ✅ Terminé | 10/08/2026 |

### 4. Tests end-to-end (100% ✅)

| Test | dossier_id | script_id | Sujet | Statut final | Durée |
|---|---|---|---|---|---|
| Test 1 | 5 | 13 | Intelligence Artificielle | ✅ TERMINE | Fragmenté |
| **Test 2 (E2E complet)** | **6** | **18** | **Productivité au travail** | **✅ TERMINE** | **~4m34s** |

---

## 🧠 Décisions d'Architecture Actées (ADR Summary)

*Consulter `06.V2_Journal_des_Decisions_d_Architecture.md` pour les textes d'origine.*

- **ADR-V2-01** : Hiérarchie de vérité documentaire (`Supabase > V2-010 > V2-008`).
- **ADR-V2-02** : Orchestration monolithique.
- **ADR-V2-03 (rev)** : Frontière V1/V2 via C-V2-03 simplifié à 2 `JOIN`s.
- **ADR-V2-04** : Validation stricte en amont `outil_id` ↔ catégorie.
- **ADR-V2-05** : Cardinalité 1-item garantie par bloc.
- **ADR-V2-06** : Barrières Aggregate + `.first()`.
- **ADR-V2-07** : Fusion des conventions d'outils dans le SELECT amont.

---

## 📈 Historique des Jalons

| Date | Événement / Jalon | Impact |
|---|---|---|
| **03/08/2025** | 🎉 V1 STABLE Livrée | Baseline V1 verrouillée. |
| **04/08/2025** | 📐 Conception V2 Terminée | 12 documents produits. |
| **04/08/2026** | 🛠️ Infrastructure V2 posée | DDL + Catalogue + V2-ERR. |
| **05/08/2026** | 🚀 V2-ORCH Opérationnel | Bloc initial testé. |
| **05/08/2026** | 🎬 V2-SCENE & V2-PLAN Opérationnels | 5 scènes + 18 plans générés. |
| **06/08/2026** | 🖼️ V2-IMG Opérationnel | 18 prompts image + ADR-V2-07 formalisé. |
| **06/08/2026** | 🎥 V2-ANIM Opérationnel | 18 prompts animations Kling AI. |
| **07/08/2026** | 🎯 V2-PUB Opérationnel | 3 descriptions plateformes + clôture dossier. |
| **07/08/2026** | 🏆 **V2 STABLE — Test E2E complet réussi** | **Dossier 6 : pipeline complet en 4m34s. Tag `v2.0.0-stable`.** |
| **08/08/2026** | ✅ **V2.1-S1 terminée** | **Auth Magic Link opérationnelle end-to-end.** |
| **08/08/2026** | ✅ **V2.1-S2 terminée** | **Vue B Liste des dossiers opérationnelle avec RLS.** |
| **09/08/2026** | ✅ **V2.1-S3 terminée** | **Vue C Détail dossier complète : hiérarchie scènes → plans → prompts image/animation + descriptions par plateforme. Navigation Vue B → Vue C fonctionnelle. Décision produit DP-V2.1-01 (affichage minimaliste) actée.** |

---

## 📂 Documents de référence

1. `08_Project_Tracker.md` *(ce document)*
2. `01.V2.1_Besoin_Client.md` *(périmètre V2.1, §5 vues MVP)*
3. `06.V2_Journal_des_Decisions_d_Architecture.md` *(ADR-V2-01 à 07)*
4. `05.V2_Implementation_Technique.md` *(Spécifications des nœuds)*
5. `04.V2_Specification_des_Composants.md` *(Prompts système)*
6. `07.V2_Plan_de_tests.md` *(Cas de tests)*

---

## ⚠️ Dette technique

| ID | Origine | Description | Priorité | Résolution prévue |
|---|---|---|---|---|
| **DT-V2.1-01** | V2.1-S1 | Migration `middleware.ts` → `proxy.ts` (Next.js 16 déprécie `middleware`). Commande : `npx @next/codemod@canary middleware-to-proxy .` | Basse | Post-V2.1 |
| **DT-V2.1-02** | V2.1-S3 | Descriptions générées par le pipeline V2-PUB trop longues (ressemblent à des scripts narratifs plutôt qu'à des captions optimisées). Ajouter contrainte de longueur dans les prompts système : TikTok ~300 car, IG ~125 car (partie visible), YouTube ~150 car (hook). | Moyenne | Post-V2.1 (retour sur V2-PUB) |
| **DT-V2.1-03** | V2.1-S3 | Champs `ambiance_visuelle` (v2_scenes), `description_visuelle` (v2_plans) et `parametres_recommandes` (v2_prompts_*) produits par le pipeline mais non affichés dans la Vue C car non-actionnables pour l'utilisateur (voir DP-V2.1-01). Décider en V3 : suppression DB, usage interne uniquement, ou affichage optionnel (accordéon "Réglages avancés"). | Basse | V3+ |
| **DT-V2.1-04** | V2.1-S3 | Tables enfants (`v2_scenes`, `v2_plans`, `v2_prompts_images`, `v2_prompts_animations`, `v2_descriptions_publication`) ont `RLS disabled`. Scoping actuel repose sur la RLS de `v2_dossiers_production` via jointure. À évaluer : activer RLS + policies sur tables enfants pour défense en profondeur. | Moyenne | Avant multi-user (V2.2+) |

---

## 🧭 Prochaine séance

**Séance 5 — V2.1 (S4 : Composant "Copier" D)**

- **Objectif prioritaire** : Ajouter un bouton "Copier" fonctionnel avec feedback visuel à côté de chaque prompt image, prompt animation et description plateforme dans la Vue C.
- **Prérequis technique** : composant client (`"use client"`) utilisant `navigator.clipboard.writeText()`.
- **Documents à ouvrir** : `08_Project_Tracker.md`, `01.V2.1_Besoin_Client.md` (§5 Vue D).
- **Critère de fin** : chaque bloc copiable dispose d'un bouton "Copier" avec confirmation visuelle ("Copié ✓" pendant 2s) + commit + push GitHub.

---

## docs(tracker): close V2.1-S3 + prep V2.1-S4

- V2.1-S3 terminée : Vue C complète (dossier → scènes → plans → prompts image/animation → descriptions par plateforme) + navigation Vue B → Vue C fonctionnelle
- Décision produit DP-V2.1-01 actée : affichage minimaliste orienté action (masquage `ambiance_visuelle`, `description_visuelle`, `parametres_recommandes`)
- 3 nouvelles dettes techniques tracées (DT-V2.1-02 descriptions trop longues, DT-V2.1-03 champs non affichés, DT-V2.1-04 RLS tables enfants)
- Prochaine séance : V2.1-S4 (composant "Copier" D)