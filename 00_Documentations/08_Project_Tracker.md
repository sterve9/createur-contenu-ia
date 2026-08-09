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
| **V1** | 🟢 STABLE | **100%** | Verrouillée. Tag `v1.0.0-stable` sur GitHub. Aucune modif. Workflow n8n `lancer-campagne` documenté en fin S5. |
| **V2** | 🟢 STABLE | **100%** | End-to-end validée sur 3 scripts distincts. Tag `v2.0.0-stable`. |
| **V2.1** | 🔵 EN COURS | **~70%** | Frontend Dashboard — S1 Auth ✅ + S2 Liste dossiers ✅ + S3 Détail ✅ + S4 Copier ✅ + S5 Créer dossier ✅. Prochain : S6 (Vue Créer Campagne — déclenchement V1). Plan élargi à 9 séances suite à la découverte fin S5. |

---

## 🎯 Tâche active

- **ID** : V2.1-S6 (à démarrer)
- **Titre** : Vue "Créer une campagne" (E) + déclenchement webhook V1 `lancer-campagne`
- **Statut** : ⏳ À DÉMARRER
- **Séance** : S6 / 9
- **Objectif** : Créer un formulaire minimal (sujet, plateforme, langue, nb_resultats) qui déclenche le pipeline V1 pour générer de nouveaux scripts, disponibles ensuite dans la Vue F (créer un dossier V2).

### 🚨 CONTEXTE DÉCOUVERTE FIN S5 (à lire absolument)

**Verbatim user (fin S5)** :
> *"On ne peut pas déployer alors qu'on ne sait pas comment déclencher la machine en backend qui produit les scripts, ce n'est pas du tout logique."*

**Découverte** : jusqu'en fin S5, le dashboard permettait uniquement de **transformer** un script existant en dossier V2 (Vue F). Mais aucune interface ne permettait de **générer** ces scripts amont via le workflow V1 `lancer-campagne`.

**Décision produit DP-V2.1-03** : élargir le périmètre V2.1 pour couvrir aussi le déclenchement V1 avant tout déploiement. Nouveau plan de 9 séances (au lieu de 7).

### ✅ Séances précédentes terminées
- **V2.1-S1** : Setup Next.js 16 + Supabase Auth Magic Link → 🟢 TERMINÉ le 08/08/2026
- **V2.1-S2** : Vue Liste des dossiers (B) — Requête serveur + RLS + Table → 🟢 TERMINÉ le 08/08/2026
  - Commit : `feat(dashboard): add dossiers table with RLS-scoped data`
- **V2.1-S3** : Vue Détail dossier (C) complète + navigation Vue B → Vue C → 🟢 TERMINÉ le 09/08/2026
  - Commit : `feat(dashboard): complete dossier detail view with scenes, plans, prompts and navigation`
- **V2.1-S4** : Composant "Copier" (D) intégré sur tous les blocs copiables → 🟢 TERMINÉ le 10/08/2026
  - Commits : 
    - `feat(dashboard): add CopyButton component on all copyable blocks`
    - `style(dashboard): use canonical Tailwind class shrink-0`
- **V2.1-S5** : Vue "Créer un dossier" (F) + webhook n8n V2-ORCH → 🟢 TERMINÉ le 09/08/2026
  - Commits : 
    - `feat(dashboard): add create dossier view (F) with n8n webhook trigger`
    - `docs(tracker): close V2.1-S5 + define S6 (Vercel deployment)` *(à remplacer par le commit actuel)*
  - Preuve : Dossier ID 8 créé via le frontend → pipeline complet V2 TERMINE (~4 min) → `user_id` correctement propagé.
  - **Découverte fin de séance** : nécessité d'ajouter le déclenchement V1 avant déploiement (voir contexte ci-dessus).

---

## 🚦 État d'avancement détaillé V2.1

### Séances V2.1 (plan révisé à 9 séances)

| Séance | Livrable | Statut | Date |
|---|---|---|---|
| **S1** | Setup Next.js + Supabase Auth Magic Link | 🟢 Terminé | 08/08/2026 |
| **S2** | Vue "Liste des dossiers" (B) | 🟢 Terminé | 08/08/2026 |
| **S3** | Vue "Détail d'un dossier" (C) complète | 🟢 Terminé | 09/08/2026 |
| **S4** | Composant "Copier" (D) intégré partout | 🟢 Terminé | 10/08/2026 |
| **S5** | Vue "Créer un dossier V2" (F) + webhook n8n V2-ORCH | 🟢 Terminé | 09/08/2026 |
| **S6** | Vue "Créer une campagne" (E) + webhook n8n V1 `lancer-campagne` | ⏳ À démarrer | — |
| **S7** | Vue "Liste des campagnes" (G) + affichage statuts + navigation vers Vue F | ⏳ Planifié | — |
| **S8** | Déploiement Vercel + domaine `dashboard.sterveshop.cloud` | ⏳ Planifié | — |
| **S9** | Documentation V2.1 + tag `v2.1.0-stable` | ⏳ Planifié | — |

### Micro-étapes S5 réalisées ✅ (récap)
- ✅ Route `/dashboard/dossiers/nouveau/page.tsx` (Server Component)
- ✅ Lecture serveur des scripts + outils actifs (`v2_outils`)
- ✅ Composant client `<CreateForm>` : 3 dropdowns (script + outil image + outil animation)
- ✅ Fonction utilitaire `extraireApercuScript()` (gère DT-V2.1-06)
- ✅ Server Action `creerDossier()` → POST JSON webhook n8n V2-ORCH
- ✅ Payload : `{ script_id, outil_image_id, outil_animation_id, user_id }`
- ✅ Modifications n8n : C-V2-02 (validation `user_id`) + C-V2-05 (INSERT `user_id`)
- ✅ Bouton "+ Créer un nouveau dossier" ajouté sur Vue B
- ✅ Test E2E : Dossier ID 8 → pipeline complet V2 TERMINE

---

## 🧠 Décisions produit V2.1 actées

### DP-V2.1-01 — Vue C minimaliste orientée action (S3)
**Décision** : la Vue C n'affiche **que les champs actionnables** (narration, prompt image, prompt animation, descriptions). Champs pipeline (`ambiance_visuelle`, `description_visuelle`, `parametres_recommandes`) conservés en DB mais masqués.

### DP-V2.1-02 — Vue F : 3 dropdowns avec choix multi-outils (S5)
**Décision** : la Vue F propose 3 dropdowns (script + outil image + outil animation) lus depuis `v2_outils` (filtre `actif=true`). Préserve le cas d'usage "comparer les résultats de la même production avec des outils différents".

### DP-V2.1-03 — Élargissement du périmètre V2.1 : intégrer aussi V1 (fin S5)
**Contexte** : le dashboard permettait uniquement de transformer un script existant en dossier V2, mais aucune interface ne permettait de déclencher V1 pour générer ces scripts amont.  
**Décision** : ajouter 2 nouvelles vues (E + G) au périmètre V2.1 avant tout déploiement.  
- **Vue E** : formulaire "Créer une campagne" → webhook `lancer-campagne`
- **Vue G** : liste des campagnes avec statuts + navigation vers Vue F  
**Justification** : un utilisateur ne peut pas être livré un dashboard où la moitié du pipeline (V1) est déclenchable uniquement depuis n8n en interne.

---

## 🔧 Architecture des workflows n8n (référence — documenté en fin S5)

### Workflow V1 — `lancer-campagne`
**Webhook** : `POST https://automation.sterveshop.cloud/webhook/lancer-campagne`

**Payload attendu** :
```json
{
  "sujet": "Productivité au travail",
  "plateforme": "YouTube",
  "langue": "fr",
  "nb_resultats": 5
}
Pipeline : voir bloc "État d'avancement détaillé V2" ci-dessous.

Durée : ~4 min.

🚦 État d'avancement détaillé V2 (rappel)
1. Conception & Documentation V2 (100% ✅)
2. Base de Données Supabase V2 (100% ✅)
3. Workflows n8n V2 (100% ✅)
Bloc n8n	Nœuds	Statut	Date
V2-ERR	Workflow séparé	✅ Terminé	06/08/2026
V2-ORCH	C-V2-01 → C-V2-05b	✅ Terminé	07/08/2026
V2-SCENE	C-V2-06 → C-V2-08	✅ Terminé	08/08/2026
V2-PLAN	C-V2-09 → C-V2-11b	✅ Terminé	08/08/2026
V2-IMG	C-V2-13 → C-V2-15e (7 nœuds)	✅ Terminé	09/08/2026
V2-ANIM	C-V2-16 → C-V2-18 (7 nœuds)	✅ Terminé	10/08/2026
V2-PUB	C-V2-20 → C-V2-22 (7 nœuds)	✅ Terminé	10/08/2026
Modifications n8n en S5 : C-V2-02 (validation user_id) + C-V2-05 (INSERT user_id).

4. Tests end-to-end (100% ✅)
Test	dossier_id	script_id	Sujet	Statut final	Durée
Test 1	5	13	Intelligence Artificielle	✅ TERMINE	Fragmenté
Test 2 (E2E complet)	6	18	Productivité au travail	✅ TERMINE	~4m34s
Test 3 (via Vue F)	8	26	Productivité au travail	✅ TERMINE	~4 min
🧠 Décisions d'Architecture Actées (ADR Summary)
ADR-V2-01 : Hiérarchie de vérité documentaire (Supabase > V2-010 > V2-008).
ADR-V2-02 : Orchestration monolithique.
ADR-V2-03 (rev) : Frontière V1/V2 via C-V2-03 simplifié à 2 JOINs.
ADR-V2-04 : Validation stricte en amont outil_id ↔ catégorie.
ADR-V2-05 : Cardinalité 1-item garantie par bloc.
ADR-V2-06 : Barrières Aggregate + .first().
ADR-V2-07 : Fusion des conventions d'outils dans le SELECT amont.
📈 Historique des Jalons
Date	Événement / Jalon	Impact
03/08/2025	🎉 V1 STABLE Livrée	Baseline V1 verrouillée.
04/08/2025	📐 Conception V2 Terminée	12 documents produits.
04/08/2026	🛠️ Infrastructure V2 posée	DDL + Catalogue + V2-ERR.
05/08/2026	🚀 V2-ORCH Opérationnel	Bloc initial testé.
05/08/2026	🎬 V2-SCENE & V2-PLAN Opérationnels	5 scènes + 18 plans générés.
06/08/2026	🖼️ V2-IMG Opérationnel	18 prompts image + ADR-V2-07 formalisé.
06/08/2026	🎥 V2-ANIM Opérationnel	18 prompts animations Kling AI.
07/08/2026	🎯 V2-PUB Opérationnel	3 descriptions plateformes + clôture dossier.
07/08/2026	🏆 V2 STABLE — Test E2E complet réussi	Dossier 6 : pipeline complet en 4m34s. Tag v2.0.0-stable.
08/08/2026	✅ V2.1-S1 terminée	Auth Magic Link opérationnelle end-to-end.
08/08/2026	✅ V2.1-S2 terminée	Vue B Liste des dossiers opérationnelle avec RLS.
09/08/2026	✅ V2.1-S3 terminée	Vue C Détail dossier complète. DP-V2.1-01 actée.
10/08/2026	✅ V2.1-S4 terminée	Composant <CopyButton /> + intégration sur tous les blocs (~47 boutons).
09/08/2026	✅ V2.1-S5 terminée	Vue F "Créer un dossier V2" + webhook n8n V2-ORCH. Dossier 8 créé E2E. DP-V2.1-02 actée.
09/08/2026	🔍 Découverte fin S5	Élargissement périmètre V2.1 : ajout de 2 séances (S6 Vue E + S7 Vue G) pour intégrer aussi V1 avant déploiement. Plan de 7 → 9 séances. DP-V2.1-03 actée.
📂 Documents de référence
08_Project_Tracker.md (ce document)
01.V2.1_Besoin_Client.md (périmètre V2.1, §5 vues MVP)
06.V2_Journal_des_Decisions_d_Architecture.md (ADR-V2-01 à 07)
05.V2_Implementation_Technique.md (Spécifications des nœuds)
04.V2_Specification_des_Composants.md (Prompts système)
07.V2_Plan_de_tests.md (Cas de tests)
⚠️ Dette technique
DT-V2.1-01 — Migration middleware.ts → proxy.ts
Origine : V2.1-S1
Priorité : Basse
Résolution prévue : Post-V2.1
Description : Next.js 16 déprécie middleware au profit de proxy.
Action : npx @next/codemod@canary middleware-to-proxy .
DT-V2.1-02 — Descriptions générées trop longues pour être exploitables
Origine : V2.1-S3
Priorité : Moyenne
Résolution prévue : Post-V2.1 (retour V2-PUB)
Cibles :

Plateforme	Cible
TikTok	~300 car
Instagram Reels	~125 car
YouTube Shorts	~150 car
Nœuds à modifier : C-V2-20 (TikTok), C-V2-21 (YouTube), C-V2-22 (Instagram).

DT-V2.1-03 — Champs pipeline non affichés dans la Vue C
Origine : V2.1-S3 (DP-V2.1-01)
Priorité : Basse
Résolution prévue : V3+
DT-V2.1-04 — RLS désactivée sur les tables enfants V2
Origine : V2.1-S3
Priorité : Moyenne
Résolution prévue : Avant multi-user (V2.2+)
Tables : v2_scenes, v2_plans, v2_prompts_images, v2_prompts_animations, v2_descriptions_publication.

DT-V2.1-05 — Tables campagnes et scripts sans user_id
Origine : V2.1-S5
Priorité : Moyenne
Résolution prévue : Avant multi-user (V2.2+) — OU en S6 selon décision Q1
Description : les tables campagnes, contenus, analyses, scripts n'ont pas de user_id (RLS disabled). Tables globales.
Question ouverte pour S6 : ajouter user_id maintenant (Option A, propre) ou reporter (Option B, rapide) ?
DT-V2.1-06 — Champ scripts.script incohérent (JSON vs texte brut)
Origine : V2.1-S5
Priorité : Basse
Résolution prévue : Post-V2.1
Cause : le nœud "Normalisation Script IA" du workflow V1 fait parfois un JSON.parse réussi (texte brut) et parfois échoue (renvoie du JSON encapsulé).
Fix temporaire (S5) : fonction extraireApercuScript() côté frontend.
Fix cible : sécuriser le nœud "Normalisation Script IA" pour toujours renvoyer du texte brut.
DT-V2.1-07 — V1 sans user_id (multi-user impossible) 🆕 identifiée en fin S5
Origine : V2.1-S5 (analyse du workflow V1 lancer-campagne)
Priorité : Moyenne
Résolution prévue : S6 (à discuter en début de séance) ou V2.2
Description : le workflow V1 lancer-campagne crée des campagnes sans user_id. Impact identique à DT-V2.1-05 mais concerne le pipeline amont.
Action à réaliser (si Option A retenue en S6) :
Ajouter colonne user_id sur campagnes (migration DB)
Modifier nœud "Valider Paramètres" pour valider user_id
Modifier nœud "Créer Campagne" pour insérer user_id
Frontend : Server Action Vue E passe user_id dans le payload
DT-V2.1-08 — Pas de mécanisme de polling / notification de fin de pipeline 🆕 identifiée en fin S5
Origine : V2.1-S5 (analyse du comportement webhook async)
Priorité : Moyenne
Résolution prévue : Post-V2.1 (V2.2+)
Description : les webhooks V1 et V2 répondent immédiatement (mode Immediately) mais le pipeline continue en async pendant plusieurs minutes. L'utilisateur ne sait pas quand c'est terminé sauf en rafraîchissant manuellement la liste (F5).
Solutions possibles :
Option 1 : polling automatique côté client (setInterval sur /dashboard)
Option 2 : Supabase Realtime sur les tables campagnes et v2_dossiers_production
Option 3 : notification email/push quand la campagne/dossier est TERMINE
Mitigation temporaire S7 : la Vue G (liste campagnes) affichera au moins le statut EN_COURS / TERMINEE lors du chargement de la page.
🧭 Prochaine séance
Séance 6 — V2.1 (S6 : Vue "Créer une campagne" E + webhook V1 lancer-campagne)

Objectif prioritaire : formulaire minimal (sujet, plateforme, langue, nb_resultats) qui déclenche V1.
Prérequis technique :
Server Action Next.js (même pattern que S5)
URL webhook : https://automation.sterveshop.cloud/webhook/lancer-campagne
Payload : { sujet, plateforme, langue, nb_resultats } (+ éventuellement user_id selon décision)
⚠️ Décision produit à prendre en début de séance :
Q1 : Ajouter user_id à campagnes maintenant (Option A propre) ou reporter en V2.2 (Option B rapide) ?
Q2 : Faire aussi la Vue G (liste campagnes) dans la même séance ou la reporter à S7 ?
Documents à ouvrir : 08_Project_Tracker.md, 01.V2.1_Besoin_Client.md (§5).
Critère de fin : depuis le dashboard, l'utilisateur peut créer une campagne, elle se déclenche en n8n, et 5 nouveaux scripts apparaissent dans la Vue F au bout de ~2 min. Commit + push GitHub.