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
| **V2** | 🟢 STABLE | **100%** | End-to-end validée sur 2 scripts distincts. Tag `v2.0.0-stable`. |
| **V2.1** | 🔵 EN COURS | **~45%** | Frontend Dashboard — S1 Auth ✅ + S2 Liste ✅ + S3 Détail (partielle : route + dossier). |
---
## 🎯 Tâche active

- **ID** : V2.1-S3 (à poursuivre)
- **Titre** : Vue "Détail d'un dossier" (C) — suite : scènes + plans + descriptions
- **Statut** : 🟡 PARTIELLEMENT TERMINÉE
- **Séance** : S3 / 7
- **Objectif restant** : Compléter la page `/dashboard/dossiers/[id]` avec la lecture des `v2_scenes`, `v2_plans` (imbriqués), et `v2_descriptions_publication`. Ajouter le lien "Voir" depuis la Vue B vers la Vue C.

### 📌 Micro-étapes S3 réalisées ✅
- ✅ Structure route dynamique `/dashboard/dossiers/[id]` créée
- ✅ Route dynamique fonctionnelle (params.id capturé)
- ✅ Protection auth ajoutée (redirect /login si non connecté)
- ✅ Lecture sécurisée du dossier via `.eq("id", id).single()` + RLS (dossier 999 → introuvable)
- ✅ Affichage infos dossier (Campagne, Script, Statut, Date)

### 📌 Micro-étapes S3 restantes ⏳
- ⏳ Lire les scènes (`v2_scenes` filtrées par `dossier_id`)
- ⏳ Lire les plans (`v2_plans` imbriqués sous chaque scène)
- ⏳ Lire les descriptions (`v2_descriptions_publication`)
- ⏳ Ajouter lien "Voir" depuis Vue B (colonne Actions)
- ⏳ Commit final S3

### ✅ Séances précédentes terminées
- **V2.1-S1** : Setup Next.js 16 + Supabase Auth Magic Link → 🟢 TERMINÉ le 08/08/2026
- **V2.1-S2** : Vue Liste des dossiers (B) — Requête serveur + RLS + Table → 🟢 TERMINÉ le 08/08/2026
  - Commit frontend : `feat(dashboard): add dossiers table with RLS-scoped data`
  - Preuve : Screenshot table `/dashboard` avec dossiers id 5 et 6 (TERMINE) visibles
---

## 🚦 État d'avancement détaillé V2

### 1. Conception & Documentation V2 (100% ✅)
- ✅ 13 documents de conception validés.
- ✅ Audits de conformité réalisés.

### 2. Base de Données Supabase V2 (100% ✅)
- ✅ DDL V2 appliqué (10 tables).
- ✅ Catalogue `v2_outils` peuplé.
- ✅ Correction ADR-V2-01 : nom réel `v2_descriptions_publication` (et non `v2_descriptions_reseaux`).

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
| Test 1 | 5 | 13 | Intelligence Artificielle | ✅ TERMINE | Fragmenté (test par bloc) |
| **Test 2 (E2E complet)** | **6** | **18** | **Productivité au travail** | **✅ TERMINE** | **~4m34s** |

**Volumétrie produite par exécution** : 5 scènes + 18 plans + 18 prompts image + 18 prompts animation + 3 descriptions + 1 checklist (9 étapes)

---

## 🧠 Décisions d'Architecture Actées (ADR Summary)

*Consulter `06.V2_Journal_des_Decisions_d_Architecture.md` pour les textes d'origine.*

- **ADR-V2-01** : Hiérarchie de vérité documentaire (`Supabase > V2-010 > V2-008`).
- **ADR-V2-02** : Orchestration monolithique.
- **ADR-V2-03 (rev)** : Frontière V1/V2 via C-V2-03 simplifié à 2 `JOIN`s.
- **ADR-V2-04** : Validation stricte en amont `outil_id` ↔ catégorie.
- **ADR-V2-05** : Cardinalité 1-item garantie par bloc.
- **ADR-V2-06** : Barrières Aggregate + `.first()`.
- **ADR-V2-07** : Fusion des conventions d'outils dans le SELECT amont *(validé sur V2-IMG et V2-ANIM)*.

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
| **07/08/2026** | 🏆 **V2 STABLE — Test E2E complet réussi** | **Dossier 6 (script 18) : pipeline complet en 4m34s. Tag `v2.0.0-stable` créé.** |
| **08/08/2026** | 🔵 **V2.1 — Séance 1 démarrée** | **Démarrage Frontend Dashboard. Setup Next.js + Auth.** |
| **08/08/2026** | ✅ **V2.1 — Séance 1 terminée** | **Auth Magic Link Supabase opérationnelle. Page dashboard protégée + déconnexion validées end-to-end. Push GitHub effectué.** |
| **08/08/2026** | ✅ **V2.1 — Séance 2 terminée** | **Vue B Liste des dossiers opérationnelle. Lecture serveur RLS + table Tailwind validées. Push GitHub effectué.** |
| **08/08/2026** | 🟡 **V2.1 — Séance 3 démarrée (partielle)** | **Vue C Détail : route dynamique `/dashboard/dossiers/[id]` + auth + lecture dossier (RLS) opérationnels. Suite (scènes/plans/descriptions) à la S4.** |
---

## 📂 Documents de référence

1. `08_Project_Tracker.md` *(ce document)*
2. `06.V2_Journal_des_Decisions_d_Architecture.md` *(ADR-V2-01 à 07)*
3. `05.V2_Implementation_Technique.md` *(Spécifications des nœuds)*
4. `04.V2_Specification_des_Composants.md` *(Prompts système)*
5. `07.V2_Plan_de_tests.md` *(Cas de tests)*
## ⚠️ Dette technique

| ID | Origine | Description | Priorité | Résolution prévue |
|---|---|---|---|---|
| **DT-V2.1-01** | V2.1-S1 | Migration `middleware.ts` → `proxy.ts` (Next.js 16 déprécie `middleware`). Commande : `npx @next/codemod@canary middleware-to-proxy .` | Basse | Post-V2.1 |

---
## 🧭 Prochaine séance

**Séance 4 — V2.1 (S3 suite + démarrage D)**

- **Objectif prioritaire** : Terminer la Vue C (scènes + plans + descriptions) puis démarrer le composant "Copier" (D)
- **Documents à ouvrir** : `08_Project_Tracker.md`, `01.V2.1_Besoin_Client.md` (§5)
- **Critère de fin** : Vue C complète (hiérarchie scènes/plans/descriptions affichée) + navigation Vue B → Vue C fonctionnelle
---

## docs(tracker): close V2.1-S1 + prep V2.1-S2

- V2.1-S1 terminée : Auth Magic Link opérationnelle end-to-end
- Migration DB préalable S2 exécutée : user_id + RLS sur v2_dossiers_production
- Dette technique DT-V2.1-01 tracée (middleware → proxy Next.js 16)
- Prochaine séance : V2.1-S2 (vue Liste des dossiers)