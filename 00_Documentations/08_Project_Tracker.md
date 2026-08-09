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
| **V2.1** | 🔵 EN COURS | **~85%** | Frontend Dashboard — S1 Auth ✅ + S2 Liste ✅ + S3 Détail ✅ + S4 Copier ✅ + S5 Créer ✅. Prochain : S6 (Déploiement Vercel). |

---

## 🎯 Tâche active

- **ID** : V2.1-S6 (à démarrer)
- **Titre** : Déploiement Vercel + domaine `dashboard.sterveshop.cloud`
- **Statut** : ⏳ À DÉMARRER
- **Séance** : S6 / 7
- **Objectif** : Déployer le frontend sur Vercel, configurer le domaine personnalisé, vérifier l'auth et le bon fonctionnement en production.

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
- **V2.1-S5** : Vue "Créer un dossier" (F) + webhook n8n → 🟢 TERMINÉ le 09/08/2026
  - Commit : `feat(dashboard): add create dossier view (F) with n8n webhook trigger`
  - Preuve : Dossier ID 8 créé via le frontend → pipeline complet V2 TERMINE (~4 min) → `user_id` correctement propagé (frontend → n8n → DB)

---

## 🚦 État d'avancement détaillé V2.1

### Séances V2.1

| Séance | Livrable | Statut | Date |
|---|---|---|---|
| **S1** | Setup Next.js + Supabase Auth Magic Link | 🟢 Terminé | 08/08/2026 |
| **S2** | Vue "Liste des dossiers" (B) | 🟢 Terminé | 08/08/2026 |
| **S3** | Vue "Détail d'un dossier" (C) complète | 🟢 Terminé | 09/08/2026 |
| **S4** | Composant "Copier" (D) intégré partout | 🟢 Terminé | 10/08/2026 |
| **S5** | Vue "Créer un dossier" (F) + webhook n8n | 🟢 Terminé | 09/08/2026 |
| **S6** | Déploiement Vercel + domaine `dashboard.sterveshop.cloud` | ⏳ Planifié | — |
| **S7** | Documentation V2.1 + tag `v2.1.0-stable` | ⏳ Planifié | — |

### Micro-étapes S5 réalisées ✅ (récap)
- ✅ Route `/dashboard/dossiers/nouveau/page.tsx` créée (Server Component)
- ✅ Server Component lit les scripts (`scripts` table) + les outils actifs (`v2_outils`) depuis Supabase
- ✅ Composant client `<CreateForm>` avec 3 dropdowns : script + outil image + outil animation
- ✅ Fonction `extraireApercuScript()` : normalisation de l'affichage des scripts (gère le cas JSON parasité — DT-V2.1-06)
- ✅ Server Action `creerDossier()` → POST JSON vers webhook n8n V2-ORCH
- ✅ Payload : `{ script_id, outil_image_id, outil_animation_id, user_id }`
- ✅ Gestion d'erreur côté client (try/catch + affichage message d'erreur)
- ✅ Feedback visuel "Création en cours..." pendant le POST
- ✅ `revalidatePath('/dashboard')` pour rafraîchir la liste après création
- ✅ Redirection automatique vers `/dashboard` après succès
- ✅ Auth guard côté serveur (`supabase.auth.getUser()` + `redirect("/login")`)
- ✅ Bouton "+ Créer un nouveau dossier" ajouté sur la Vue B
- ✅ Corrections n8n : C-V2-02 (ajout validation `user_id not empty`) + C-V2-05 (INSERT avec `user_id`)
- ✅ Test E2E : Dossier ID 8 créé → pipeline V2 complet → TERMINE

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

### DP-V2.1-02 — Vue F : 3 dropdowns avec choix multi-outils (S5)
**Contexte** : le pipeline V2 génère des prompts adaptés à chaque outil (Midjourney ≠ Playground AI, Kling AI ≠ Runway). Le user a besoin de comparer les résultats de la même production avec des outils différents.  
**Décision** : la Vue F propose **3 dropdowns** : script + outil image + outil animation. Les outils sont lus depuis la table `v2_outils` (filtre `actif=true`). Le `user_id` de l'utilisateur connecté est ajouté au payload webhook.  
**Justification** : préserve le cas d'usage principal (comparaison d'outils), prépare le multi-user (propagation `user_id`), aligné avec ADR-V2-07 (conventions d'outils par catégorie).

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

**Modifications n8n en S5** :
- C-V2-02 : ajout condition `user_id not empty`
- C-V2-05 : ajout colonne `user_id` dans le INSERT SQL

### 4. Tests end-to-end (100% ✅)

| Test | dossier_id | script_id | Sujet | Statut final | Durée |
|---|---|---|---|---|---|
| Test 1 | 5 | 13 | Intelligence Artificielle | ✅ TERMINE | Fragmenté |
| **Test 2 (E2E complet)** | **6** | **18** | **Productivité au travail** | **✅ TERMINE** | **~4m34s** |
| **Test 3 (via Vue F)** | **8** | **26** | **Productivité au travail** | **✅ TERMINE** | **~4 min** |

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
| **09/08/2026** | ✅ **V2.1-S5 terminée** | **Vue F "Créer un dossier" + Server Action → webhook n8n V2-ORCH. Payload {script_id, outil_image_id, outil_animation_id, user_id}. Test E2E réussi (dossier 8). Bouton "+ Créer" ajouté sur Vue B. Décision produit DP-V2.1-02 (3 dropdowns multi-outils) actée.** |

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

### DT-V2.1-05 — Tables `campagnes` et `scripts` sans `user_id`
- **Origine** : V2.1-S5 (identifié lors de la lecture des scripts/outils pour la Vue F)
- **Priorité** : Moyenne
- **Résolution prévue** : Avant multi-user (V2.2+)

**Description** : les tables `campagnes` et `scripts` n'ont **pas de colonne `user_id`** et ont RLS disabled. Elles sont globales/shared.

**Risque** : en multi-user, tous les utilisateurs verront toutes les campagnes et tous les scripts (pas de scoping par user).

**Action** :
- Ajouter colonne `user_id` (UUID, nullable en migration) + FK sur `auth.users(id)`
- Activer RLS + policies (SELECT/INSERT/UPDATE/DELETE) basées sur `user_id`
- Attention : le pipeline n8n (service_role) bypass RLS, pas d'impact côté backend

---

### DT-V2.1-06 — Champ `scripts.script` incohérent (JSON vs texte brut)
- **Origine** : V2.1-S5 (visible lors de l'affichage des scripts dans le `<select>` de la Vue F)
- **Priorité** : Basse
- **Résolution prévue** : Post-V2.1

**Description** : le champ `scripts.script` contient parfois du texte brut, parfois du JSON encapsulé dans des balises markdown (` ```json { "script": "..." } ``` `). Résultat : l'affichage dans le dropdown est incohérent.

**Observation factuelle** :
- Scripts 18, 19, 20, 21, 22, 24, 25, 27 → texte brut ✅
- Scripts 1, 2, 11, 15, 23, 26 → JSON avec balises markdown ❌

**Solution frontend temporaire** (appliquée en S5) : fonction `extraireApercuScript()` qui détecte le JSON et extrait le champ `"script"` à l'affichage. **Ne corrige pas la cause racine.**

**Action à réaliser** : normaliser la génération dans le workflow n8n amont (nœud V1 qui produit les scripts). S'assurer que la sortie est toujours du texte brut sans encapsulation JSON.

---

## 🧭 Prochaine séance

**Séance 7 — V2.1 (S6 : Déploiement Vercel + domaine)**

- **Objectif prioritaire** : déployer le frontend sur Vercel, configurer le domaine personnalisé `dashboard.sterveshop.cloud`, vérifier que l'auth Magic Link fonctionne en production.
- **Prérequis technique** :
  - Compte Vercel connecté au repo GitHub `createur-contenu-ia-dashboard`
  - Variables d'environnement Supabase configurées dans Vercel
  - DNS `dashboard.sterveshop.cloud` prêt à pointer vers Vercel
- **Documents à ouvrir** : `08_Project_Tracker.md`, `01.V2.1_Besoin_Client.md` (§6 Déploiement).
- **Critère de fin** : le dashboard est accessible sur `https://dashboard.sterveshop.cloud`, l'auth Magic Link fonctionne, le bouton "+ Créer un dossier" déclenche le pipeline n8n, commit + push GitHub.