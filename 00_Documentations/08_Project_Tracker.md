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
| **V2** | 🟢 STABLE | **100%** | End-to-end validée sur 2 scripts distincts. Tag `v2.0.0-stable`. |
| **V2.1** | 🔵 EN COURS | **~75%** | Frontend Dashboard — S1 Auth ✅ + S2 Liste ✅ + S3 Détail ✅ + S4 Copier ✅. Prochain : S5 (Vue Créer F + webhook n8n). |
---
## 🎯 Tâche active

- **ID** : V2.1-S5 (à démarrer)
- **Titre** : Vue "Créer un dossier" (F) + déclenchement du webhook n8n
- **Statut** : ⏳ À DÉMARRER
- **Séance** : S5 / 7
- **Objectif** : Créer un formulaire minimal (choix campagne + choix script) qui, à la soumission, déclenche le webhook n8n de démarrage du pipeline V2 et redirige l'utilisateur vers la Vue B (Liste des dossiers).

### ✅ Séances précédentes terminées
- **V2.1-S1** : Setup Next.js 16 + Supabase Auth Magic Link → 🟢 TERMINÉ le 08/08/2026
- **V2.1-S2** : Vue Liste des dossiers (B) — Requête serveur + RLS + Table → 🟢 TERMINÉ le 08/08/2026
  - Commit : `feat(dashboard): add dossiers table with RLS-scoped data`
- **V2.1-S3** : Vue Détail dossier (C) complète + navigation Vue B → Vue C → 🟢 TERMINÉ le 09/08/2026
  - Commit : `feat(dashboard): complete dossier detail view with scenes, plans, prompts and navigation`
  - Preuve : Vue C hiérarchique (dossier → scènes → plans → prompts image + animation) + descriptions par plateforme + lien "Voir" fonctionnel depuis Vue B
- **V2.1-S4** : Composant "Copier" (D) intégré sur tous les blocs copiables → 🟢 TERMINÉ le 10/08/2026
  - Commits : 
    - `feat(dashboard): add CopyButton component on all copyable blocks`
    - `style(dashboard): use canonical Tailwind class shrink-0`
  - Preuve : ~47 boutons "Copier" fonctionnels sur le dossier 6 (5 narrations + 18 prompts image + 18 prompts animation + 3 descriptions + 3 hashtags) avec feedback visuel "Copié ✓" 2s.

---

## 🚦 État d'avancement détaillé V2.1

### Séances V2.1

| Séance | Livrable | Statut | Date |
|---|---|---|---|
| **S1** | Setup Next.js + Supabase Auth Magic Link | 🟢 Terminé | 08/08/2026 |
| **S2** | Vue "Liste des dossiers" (B) | 🟢 Terminé | 08/08/2026 |
| **S3** | Vue "Détail d'un dossier" (C) complète | 🟢 Terminé | 09/08/2026 |
| **S4** | Composant "Copier" (D) intégré partout | 🟢 Terminé | 10/08/2026 |
| **S5** | Vue "Créer un dossier" (F) + webhook n8n | ⏳ À démarrer | — |
| **S6** | Déploiement Vercel + domaine `dashboard.sterveshop.cloud` | ⏳ Planifié | — |
| **S7** | Documentation V2.1 + tag `v2.1.0-stable` | ⏳ Planifié | — |

### Micro-étapes S4 réalisées ✅ (récap)
- ✅ Création du composant client réutilisable `<CopyButton text="..." />` (`app/dashboard/dossiers/[id]/copy-button.tsx`)
- ✅ Utilisation de `navigator.clipboard.writeText()` avec `useState` pour l'état "copié"
- ✅ Feedback visuel : bascule "Copier" ↔ "Copié ✓" pendant 2s (`setTimeout`)
- ✅ Intégration progressive : narration → puis généralisation à tous les blocs copiables
- ✅ Rendering conditionnel : le bouton ne s'affiche que si le texte cible existe (évite les boutons vides)
- ✅ Correction cosmétique : classes Tailwind normalisées (`flex-shrink-0` → `shrink-0`) — 0 warning restant

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
| **10/08/2026** | ✅ **V2.1-S4 terminée** | **Composant `<CopyButton />` réutilisable + intégration sur tous les blocs copiables de la Vue C (~47 boutons). UX de copie rapide alignée avec le besoin §7.** |

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

### DT-V2.1-01 — Migration `middleware.ts` → `proxy.ts`
- **Origine** : V2.1-S1
- **Priorité** : Basse
- **Résolution prévue** : Post-V2.1
- **Description** : Next.js 16 déprécie `middleware` au profit de `proxy`. Warning affiché au démarrage : *"The 'middleware' file convention is deprecated. Please use 'proxy' instead."*
- **Action** : exécuter `npx @next/codemod@canary middleware-to-proxy .` puis vérifier le fonctionnement de l'auth.

---

### DT-V2.1-02 — Descriptions générées trop longues pour être exploitables
- **Origine** : V2.1-S3 (identifié par le user pendant l'analyse UX de la Vue C)
- **Priorité** : Moyenne
- **Résolution prévue** : Post-V2.1 (retour sur bloc V2-PUB)

**Observation factuelle (dossier 6, script 18)** :
Les 3 descriptions générées (TikTok, YouTube Shorts, Instagram Reels) font entre **~800 et 1000 caractères** et ressemblent davantage à des mini-scripts narratifs qu'à des captions optimisées pour l'engagement sur les plateformes.

**Verbatim user (S3)** :
> *"S'il s'agit uniquement du texte de description, je pense qu'il va falloir limiter le nombre de caractères. Je vois que je ne l'ai pas fait, car ce texte de description généré est presque similaire à un texte pour générer la vidéo entière, c'est trop."*

**Cibles recommandées** (basées sur les bonnes pratiques UX de chaque plateforme) :

| Plateforme | Limite plateforme | Cible engagement | Justification |
|---|---|---|---|
| TikTok | 2 200 car | **~300 car** | Sweet spot engagement 150-300 car |
| Instagram Reels | 2 200 car | **~125 car** | Partie visible avant "...plus" |
| YouTube Shorts | 5 000 car | **~150 car** | Hook des 3 premières lignes critiques |

**Action à réaliser** :
Modifier les prompts système des nœuds suivants dans le bloc V2-PUB :
- `C-V2-20` (TikTok) — ajouter contrainte "maximum 300 caractères"
- `C-V2-21` (YouTube Shorts) — ajouter contrainte "hook maximum 150 caractères"
- `C-V2-22` (Instagram Reels) — ajouter contrainte "hook maximum 125 caractères avant coupure"

**Impact attendu** :
- ⏱️ Gain de temps pour le créateur (pas besoin de raccourcir manuellement)
- 📈 Meilleure performance des publications (formats plus engageants)
- ✅ Meilleur alignement avec le besoin V2.1 §7 (UX de copie rapide)

---

### DT-V2.1-03 — Champs pipeline non affichés dans la Vue C
- **Origine** : V2.1-S3 (décision produit DP-V2.1-01)
- **Priorité** : Basse
- **Résolution prévue** : V3+

**Description** : trois champs produits par le pipeline V2 sont conservés en base mais **non affichés** dans la Vue C car non-actionnables pour l'utilisateur final :
- `ambiance_visuelle` (v2_scenes) — brief artistique intermédiaire
- `description_visuelle` (v2_plans) — redondant avec le prompt image en anglais
- `parametres_recommandes` (v2_prompts_images / v2_prompts_animations) — réglages techniques secondaires

**Décision à prendre en V3** :
- Option 1 : suppression DB (nettoyage)
- Option 2 : conservation pour usage pipeline interne uniquement
- Option 3 : affichage optionnel via accordéon "Réglages avancés"

---

### DT-V2.1-04 — RLS désactivée sur les tables enfants
- **Origine** : V2.1-S3
- **Priorité** : Moyenne
- **Résolution prévue** : Avant multi-user (V2.2+)

**Description** : les tables `v2_scenes`, `v2_plans`, `v2_prompts_images`, `v2_prompts_animations`, `v2_descriptions_publication` ont `RLS disabled`. Le scoping actuel repose uniquement sur la RLS de `v2_dossiers_production` via les jointures FK.

**Risque** : en cas de bug applicatif ou de contournement, un utilisateur pourrait accéder aux données enfants d'un autre user.

**Action** : activer RLS + policies (SELECT/INSERT/UPDATE/DELETE) sur chaque table enfant, basées sur la remontée jusqu'à `v2_dossiers_production.user_id`.

---

## 🧭 Prochaine séance

**Séance 6 — V2.1 (S5 : Vue "Créer un dossier" F + webhook n8n)**

- **Objectif prioritaire** : construire le formulaire de création d'un nouveau dossier (choix campagne + choix script) qui, à la soumission, déclenche le webhook n8n de démarrage du pipeline V2, puis redirige vers la Vue B.
- **Prérequis technique** :
  - Server Action ou Route Handler Next.js (à décider en séance)
  - URL du webhook n8n V2-ORCH à récupérer
  - Lecture des campagnes disponibles (à confirmer : y a-t-il une table `v2_campagnes` scopée user ?)
  - Lecture des scripts disponibles (à confirmer : structure de la table `scripts`)
- **⚠️ Prérequis DB à valider en début de séance** : screenshot Supabase des tables `campagnes` et `scripts` (règle zéro invention DB).
- **Documents à ouvrir** : `08_Project_Tracker.md`, `01.V2.1_Besoin_Client.md` (§5 Vue F).
- **Critère de fin** : à partir de la Vue A/B, l'utilisateur peut créer un nouveau dossier, le webhook n8n est déclenché, un nouveau dossier apparaît dans la liste avec statut initial "en cours" + commit + push GitHub.