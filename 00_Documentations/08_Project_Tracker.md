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
| **V2.1** | 🔵 EN COURS | **~15%** | Frontend Dashboard — Séance 1 terminée (Auth Magic Link ✅). |

---

## 🎯 Tâche active

## 🎯 Tâche active

- **ID** : V2.1-S2
- **Titre** : Vue "Liste des dossiers" (B) end-to-end
- **Statut** : ⚪ À démarrer
- **Séance** : S2 / 7
- **Objectif** : Afficher dans le dashboard une table paginée listant tous les dossiers de production du user connecté, avec colonnes : `id`, `sujet campagne`, `script`, `statut`, `dates`, `actions`. Données lues depuis Supabase via un Server Component. Scoping `user_id` obligatoire.

### 📌 Critères de fin de séance S2
- Une route `/dashboard/dossiers` (ou `/dashboard` enrichi) affiche la liste des dossiers du user connecté
- Les données sont réellement lues depuis la table `v2_dossiers_production` de Supabase
- Un utilisateur non connecté est redirigé vers `/login`
- Aucun dossier d'un autre user n'est visible (scoping `user_id`)
- Le rendu est propre (shadcn/ui + Tailwind), avec au minimum les colonnes prévues au §5

### ✅ Séance précédente terminée
- **V2.1-S1** : Setup Next.js 16 + Supabase Auth Magic Link → 🟢 TERMINÉ le 08/08/2026
  - Auth Magic Link opérationnelle (envoi email → callback → dashboard protégé → déconnexion)
  - Commit : `feat(auth): setup Supabase Magic Link authentication`

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

---

## 🧭 Prochaine séance

## 🧭 Prochaine séance

**Séance 2 — V2.1**

- **Objectif** : Vue "Liste des dossiers" (B) end-to-end
- **Documents à ouvrir en début de séance** : `08_Project_Tracker.md`, `01.V2.1_Besoin_Client.md` (§5 et §7)
- **Critère de fin de séance** : Un utilisateur connecté voit la liste de ses dossiers de production lus depuis Supabase, avec redirection `/login` si non authentifié et scoping `user_id` respecté

### ⚠️ Prérequis technique à anticiper (bloquant possible)
Le §7 du besoin client mentionne :  
> *"Une seule migration DB : ajout d'une colonne `user_id NOT NULL` sur `v2_dossiers_production` (avec rétro-assignation des dossiers existants au user admin)"*

Cette migration Supabase devra être **exécutée avant de pouvoir filtrer par user** dans S2. À trancher en début de S2 : est-ce qu'on fait la migration d'abord, ou est-ce qu'on affiche d'abord sans filtre puis on ajoute le scoping ?