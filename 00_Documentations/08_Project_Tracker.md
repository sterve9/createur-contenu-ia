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
| **V1** | 🟢 STABLE | **100%** | Verrouillée. Tag `v1.0.0-stable` sur GitHub. Aucune modif. Workflow n8n `lancer-campagne` documenté + migré user_id en S6. |
| **V2** | 🟢 STABLE | **100%** | End-to-end validée sur 3 scripts distincts. Tag `v2.0.0-stable`. |
| **V2.1** | 🟢 STABLE | **100%** | Frontend Dashboard complet + déployé en prod sur `https://dashboard.sterveshop.cloud`. Tag `v2.1.0-stable` sur GitHub (10/08/2026). Plan initial 7 → 9 séances (S6+S7 fusionnées). |

---

## 🎯 Tâche active

- **ID** : — (V2.1 clôturée)
- **Titre** : Aucune tâche active
- **Statut** : ✅ V2.1 STABLE
- **Prochaine version** : V2.2 (cadrage à venir)
- **Objectif V2.2** : résolution dettes techniques prioritaires (Vue F contexte campagne, polling fin pipeline, RLS enfants V2).

### 🚨 CONTEXTE DÉCOUVERTE FIN S5 (à lire absolument)

**Verbatim user (fin S5)** :
> *"On ne peut pas déployer alors qu'on ne sait pas comment déclencher la machine en backend qui produit les scripts, ce n'est pas du tout logique."*

**Découverte** : jusqu'en fin S5, le dashboard permettait uniquement de **transformer** un script existant en dossier V2 (Vue F). Mais aucune interface ne permettait de **générer** ces scripts amont via le workflow V1 `lancer-campagne`.

**Décision produit DP-V2.1-03** : élargir le périmètre V2.1 pour couvrir aussi le déclenchement V1 avant tout déploiement. 
- **Vue E** : formulaire "Créer une campagne" → webhook `lancer-campagne`
- **Vue G** : liste des campagnes avec statuts + navigation vers Vue F  
**Résolution** : ✅ S6+S7 faites en une séance dense (10/08/2026).

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
  - Preuve : Dossier ID 8 créé via le frontend → pipeline complet V2 TERMINE (~4 min) → `user_id` correctement propagé.
- **V2.1-S6** : Vue "Créer une campagne" (E) + webhook n8n V1 `lancer-campagne` + migration `campagnes.user_id` → 🟢 TERMINÉ le 10/08/2026
  - Décisions séance : Q1 Option A (propre, ajouter user_id maintenant) + Q2 Option B (faire E+G ensemble)
  - Migration DB : `ALTER TABLE campagnes ADD COLUMN user_id uuid REFERENCES auth.users(id)` + index + RLS + 2 policies
  - Modifs n8n V1 : `Valider Paramètres` (5ème condition user_id) + `Créer Campagne` (ajout user_id, suppression nb_contenus_total/traites)
  - Commits : `feat(dashboard): add campagnes views (E create + G list) with V1 webhook trigger and user_id propagation`
  - Preuve : Campagnes 17 (Test PS via PowerShell) et 18 (Test Formulaire React via UI) créées avec user_id `f8e77d8b-3d54-4937-9302-4a920d48bd6e` → TERMINEE 1/1 et 2/2
- **V2.1-S7** : Vue "Liste des campagnes" (G) + affichage statuts + navigation → 🟢 TERMINÉ le 10/08/2026 (fusionné avec S6)
  - Route `/dashboard/campagnes` + badge statut coloré + progression X/Y + RLS auto-filtrée (2 lignes sur 19 affichées)
  - Ajout bouton "📋 Voir mes campagnes" sur Vue B
- **V2.1-S8** : Déploiement Vercel + domaine custom `dashboard.sterveshop.cloud` → 🟢 TERMINÉ le 10/08/2026
  - Build local vert (0 erreur TypeScript/ESLint, 10/10 pages générées)
  - Compte Vercel (Hobby) + Vercel GitHub App installée sur repo `createur-contenu-ia-dashboard`
  - Variables ENV Production+Preview : `NEXT_PUBLIC_SUPABASE_URL` + `NEXT_PUBLIC_SUPABASE_ANON_KEY`
  - Premier deploy OK → `createur-contenu-ia-dashboard.vercel.app`
  - Supabase Auth URL Configuration : Site URL = `https://dashboard.sterveshop.cloud` + 3 Redirect URLs (localhost, vercel.app, sterveshop.cloud)
  - DNS Hostinger : CNAME `dashboard` → `cname.vercel-dns.com` (TTL 300) + TXT `_vercel` (vérification propriété — domaine déjà lié à un autre compte Vercel)
  - Magic Link prod validé sur le domaine custom (login → /dashboard connecté, RLS OK)
  - Test E2E prod : campagne 19 "les avartar IA" → TERMINEE 2/2 (webhook V1 OK depuis Vercel)
  - Découverte UX en test : DT-V2.1-09 créée (dropdown scripts Vue F sans contexte campagne)

---

## 🚦 État d'avancement détaillé V2.1

### Séances V2.1 (plan révisé à 9 séances, S6+S7 fusionnées)

| Séance | Livrable | Statut | Date |
|---|---|---|---|
| **S1** | Setup Next.js + Supabase Auth Magic Link | 🟢 Terminé | 08/08/2026 |
| **S2** | Vue "Liste des dossiers" (B) | 🟢 Terminé | 08/08/2026 |
| **S3** | Vue "Détail d'un dossier" (C) complète | 🟢 Terminé | 09/08/2026 |
| **S4** | Composant "Copier" (D) intégré partout | 🟢 Terminé | 10/08/2026 |
| **S5** | Vue "Créer un dossier V2" (F) + webhook n8n V2-ORCH | 🟢 Terminé | 09/08/2026 |
| **S6** | Vue "Créer une campagne" (E) + webhook n8n V1 `lancer-campagne` + migration user_id | 🟢 Terminé | 10/08/2026 |
| **S7** | Vue "Liste des campagnes" (G) + affichage statuts + navigation vers Vue F | 🟢 Terminé (fusion S6) | 10/08/2026 |
| **S8** | Déploiement Vercel + domaine `dashboard.sterveshop.cloud` | 🟢 Terminé | 10/08/2026 |
| **S9** | Bilan V2.1 (ADR + Tracker) + tag `v2.1.0-stable` | 🟢 Terminé | 10/08/2026 |

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

### Micro-étapes S6+S7 réalisées ✅ (campagnes)
- ✅ Migration DB `campagnes` : add `user_id uuid NULL REFERENCES auth.users(id)` + index + RLS ENABLE + 2 policies (SELECT/INSERT)
- ✅ Modification workflow V1 `lancer-campagne` : `Valider Paramètres` (condition user_id is not empty) + `Créer Campagne` (mapping user_id + suppression nb_contenus_total/traites)
- ✅ Test manuel webhook via `Invoke-RestMethod` PowerShell → campagne 17 OK
- ✅ Route `/dashboard/campagnes/nouveau/page.tsx` (Server Component auth only + userId)
- ✅ Client Component `<CreateForm>` : 4 champs (sujet text + plateforme select YouTube only + langue select fr/en + nb_resultats number 1-10)
- ✅ Server Action `creerCampagne()` → POST webhook `lancer-campagne` payload `{ sujet, plateforme, langue, nb_resultats, user_id }`
- ✅ Test E2E formulaire → campagne 18 (2/2) TERMINEE
- ✅ Route `/dashboard/campagnes/page.tsx` (Server Component) + requête RLS `select id, sujet, plateforme, langue, nb_resultats, statut, nb_contenus_total, nb_contenus_traites, created_at` + badges statut + état vide
- ✅ Modification `app/dashboard/page.tsx` : ajout bouton "📋 Voir mes campagnes" (bg-purple-600)

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

### DP-V2.1-04 — Plateforme YouTube uniquement en Vue E (S6)
**Contexte** : le workflow V1 `lancer-campagne` ne collecte que YouTube (nœud `Collecte des contenus` = YouTube API).  
**Décision** : le select plateforme en Vue E n'affiche que `YouTube` avec message "TikTok et Instagram seront disponibles prochainement".  
**Justification** : honnêteté produit vs backend réel. Éviter de livrer un formulaire qui ment.

---

## 🔧 Architecture des workflows n8n (référence — documenté en fin S5, MAJ S6)

### Workflow V1 — `lancer-campagne`
**Webhook** : `POST https://automation.sterveshop.cloud/webhook/lancer-campagne`

**Payload attendu (MAJ S6)** :
```json
{
  "sujet": "Productivité au travail",
  "plateforme": "YouTube",
  "langue": "fr",
  "nb_resultats": 5,
  "user_id": "uuid-auth-user"
}
```
Modifications S6 : validation user_id + INSERT user_id + RLS active.  
Durée : ~30s à ~2min selon nb_resultats.

### Workflow V2 — `v2-creer-dossier`
**Webhook** : `POST https://automation.sterveshop.cloud/webhook/v2-creer-dossier`  
**Payload** : `{ script_id, outil_image_id, outil_animation_id, user_id }`  

Modifications S5 : C-V2-02 (validation user_id) + C-V2-05 (INSERT user_id)  
Durée : ~4 min.

---

## 🚦 État d'avancement détaillé V2 (rappel)

### Conception & Documentation V2 (100% ✅)

### Base de Données Supabase V2 (100% ✅)

### Workflows n8n V2 (100% ✅)
| Bloc n8n | Nœuds | Statut | Date |
|---|---|---|---|
| **V2-ERR** | Workflow séparé | ✅ Terminé | 06/08/2026 |
| **V2-ORCH** | C-V2-01 → C-V2-05b | ✅ Terminé | 07/08/2026 |
| **V2-SCENE** | C-V2-06 → C-V2-08 | ✅ Terminé | 08/08/2026 |
| **V2-PLAN** | C-V2-09 → C-V2-11b | ✅ Terminé | 08/08/2026 |
| **V2-IMG** | C-V2-13 → C-V2-15e (7 nœuds) | ✅ Terminé | 09/08/2026 |
| **V2-ANIM** | C-V2-16 → C-V2-18 (7 nœuds) | ✅ Terminé | 10/08/2026 |
| **V2-PUB** | C-V2-20 → C-V2-22 (7 nœuds) | ✅ Terminé | 10/08/2026 |

Modifications n8n en S5 : C-V2-02 (validation user_id) + C-V2-05 (INSERT user_id).  
Modifications n8n en S6 : V1 Valider Paramètres + Créer Campagne (user_id).

### Tests end-to-end (100% ✅)
| Test | dossier_id / campagne_id | sujet | Statut final | Durée |
|---|---|---|---|---|
| **Test 1 V2** | 5 | Intelligence Artificielle | ✅ TERMINE | Fragmenté |
| **Test 2 V2 (E2E complet)** | 6 | Productivité au travail | ✅ TERMINE | ~4m34s |
| **Test 3 V2 (via Vue F)** | 8 | Productivité au travail | ✅ TERMINE | ~4 min |
| **Test 1 V1 (cURL PS)** | 17 | Test PS | ✅ TERMINEE 1/1 | ~30s |
| **Test 2 V1 (Vue E)** | 18 | Test Formulaire React | ✅ TERMINEE 2/2 | ~1min |
| **Test 3 V1 (prod, via Vue E)** | 19 | les avartar IA | ✅ TERMINEE 2/2 | ~1min |

---

## 🧠 Décisions d'Architecture Actées (ADR Summary)
- **ADR-V2-01** : Hiérarchie de vérité documentaire (Supabase > V2-010 > V2-008).
- **ADR-V2-02** : Orchestration monolithique.
- **ADR-V2-03 (rev)** : Frontière V1/V2 via C-V2-03 simplifié à 2 JOINs.
- **ADR-V2-04** : Validation stricte en amont outil_id ↔ catégorie.
- **ADR-V2-05** : Cardinalité 1-item garantie par bloc.
- **ADR-V2-06** : Barrières Aggregate + .first().
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
| **07/08/2026** | 🏆 V2 STABLE — Test E2E complet réussi | Dossier 6 : pipeline complet en 4m34s. Tag v2.0.0-stable. |
| **08/08/2026** | ✅ V2.1-S1 terminée | Auth Magic Link opérationnelle end-to-end. |
| **08/08/2026** | ✅ V2.1-S2 terminée | Vue B Liste des dossiers opérationnelle avec RLS. |
| **09/08/2026** | ✅ V2.1-S3 terminée | Vue C Détail dossier complète. DP-V2.1-01 actée. |
| **10/08/2026** | ✅ V2.1-S4 terminée | Composant `<CopyButton />` + intégration sur tous les blocs (~47 boutons). |
| **09/08/2026** | ✅ V2.1-S5 terminée | Vue F "Créer un dossier V2" + webhook n8n V2-ORCH. Dossier 8 créé E2E. DP-V2.1-02 actée. |
| **09/08/2026** | 🔍 Découverte fin S5 | Élargissement périmètre V2.1 : ajout de 2 séances (S6 Vue E + S7 Vue G) pour intégrer aussi V1 avant déploiement. Plan de 7 → 9 séances. DP-V2.1-03 actée. |
| **10/08/2026** | ✅ V2.1-S6+S7 terminées | Vue E + Vue G + migration campagnes user_id + modifs workflow V1. Campagnes 17-18 créées via frontend avec RLS. DT-V2.1-07 résolue. |
| **10/08/2026** | ✅ **V2.1-S8 terminée** | Dashboard déployé en prod sur `https://dashboard.sterveshop.cloud` (Vercel + DNS Hostinger + Supabase Auth prod). Magic Link + RLS + webhook V1 validés E2E (campagne 19). DT-V2.1-09 et DT-V2.1-10 créées. |
| **10/08/2026** | 🏆 **V2.1 STABLE — Tag `v2.1.0-stable` posé** | Dashboard complet livré en production. ADR + Tracker finalisés. Fin officielle de la V2.1. |
---

## 📂 Documents de référence
- `08_Project_Tracker.md` (ce document)
- `01.V2.1_Besoin_Client.md` (périmètre V2.1, §5 vues MVP)
- `06.V2_Journal_des_Decisions_d_Architecture.md` (ADR-V2-01 à 07)
- `05.V2_Implementation_Technique.md` (Spécifications des nœuds)
- `04.V2_Specification_des_Composants.md` (Prompts système)
- `07.V2_Plan_de_tests.md` (Cas de tests)

---

## ⚠️ Dette technique

### DT-V2.1-01 — Migration middleware.ts → proxy.ts
- **Origine** : V2.1-S1
- **Priorité** : Basse
- **Résolution prévue** : Post-V2.1
- **Description** : Next.js 16 déprécie middleware au profit de proxy.
- **Action** : `npx @next/codemod@canary middleware-to-proxy .`

### DT-V2.1-02 — Descriptions générées trop longues pour être exploitables
- **Origine** : V2.1-S3
- **Priorité** : Moyenne
- **Résolution prévue** : Post-V2.1 (retour V2-PUB)
- **Cibles** :
  - TikTok ~300 car
  - Instagram Reels ~125 car
  - YouTube Shorts ~150 car
- **Nœuds à modifier** : C-V2-20 (TikTok), C-V2-21 (YouTube), C-V2-22 (Instagram).

### DT-V2.1-03 — Champs pipeline non affichés dans la Vue C
- **Origine** : V2.1-S3 (DP-V2.1-01)
- **Priorité** : Basse
- **Résolution prévue** : V3+

### DT-V2.1-04 — RLS désactivée sur les tables enfants V2
- **Origine** : V2.1-S3
- **Priorité** : Moyenne
- **Résolution prévue** : Avant multi-user (V2.2+)
- **Tables** : `v2_scenes`, `v2_plans`, `v2_prompts_images`, `v2_prompts_animations`, `v2_descriptions_publication`.

### DT-V2.1-05 — Tables campagnes et scripts sans user_id (partiellement résolu)
- **Origine** : V2.1-S5
- **Priorité** : Moyenne
- **Résolution prévue** : V2.2 pour contenus/analyses/scripts
- **Description** : les tables campagnes, contenus, analyses, scripts n'avaient pas de user_id (RLS disabled).
- **MAJ 10/08/2026** : campagnes ✅ migrée (user_id + RLS). Reste contenus, analyses, scripts globaux (OK pour MVP mono-user, à corriger en V2.2).

### DT-V2.1-06 — Champ scripts.script incohérent (JSON vs texte brut)
- **Origine** : V2.1-S5
- **Priorité** : Basse
- **Résolution prévue** : Post-V2.1
- **Cause** : le nœud "Normalisation Script IA" du workflow V1 fait parfois un JSON.parse réussi (texte brut) et parfois échoue (renvoie du JSON encapsulé).
- **Fix temporaire (S5)** : fonction `extraireApercuScript()` côté frontend.
- **Fix cible** : sécuriser le nœud "Normalisation Script IA" pour toujours renvoyer du texte brut.

### DT-V2.1-07 — V1 sans user_id (multi-user impossible) ✅ RÉSOLU 10/08/2026
- **Origine** : V2.1-S5 (analyse du workflow V1 lancer-campagne)
- **Priorité** : Moyenne
- **Résolution** : 10/08/2026 — Migration `campagnes.user_id` + policies RLS + modif workflow V1 (Valider Paramètres + Créer Campagne) + envoi user_id depuis frontend. Test E2E OK (campagnes 17-18).

### DT-V2.1-08 — Pas de mécanisme de polling / notification de fin de pipeline
- **Origine** : V2.1-S5 (analyse du comportement webhook async)
- **Priorité** : Moyenne
- **Résolution prévue** : Post-V2.1 (V2.2+)
- **Description** : les webhooks V1 et V2 répondent immédiatement (mode Immediately) mais le pipeline continue en async pendant plusieurs minutes. L'utilisateur ne sait pas quand c'est terminé sauf en rafraîchissant manuellement la liste (F5).
- **Solutions possibles** :
  - Option 1 : polling automatique côté client (setInterval sur /dashboard)
  - Option 2 : Supabase Realtime sur les tables campagnes et v2_dossiers_production
  - Option 3 : notification email/push quand la campagne/dossier est TERMINE
- **Mitigation temporaire S7** : Vue G affiche statut EN_COURS / TERMINEE lors du chargement de la page.

### DT-V2.1-09 — Vue F : dropdown script sans contexte campagne
- **Origine** : V2.1-S8 (test E2E en prod)
- **Priorité** : Moyenne
- **Résolution prévue** : V2.2
- **Description** : dans `/dashboard/dossiers/nouveau`, le dropdown "Choisir un script" affiche `#ID — début du script` sans lien visible avec la campagne parente. Après avoir lancé une campagne (ex: "les avartar IA"), l'utilisateur ne retrouve pas facilement les scripts générés par cette campagne.
- **Solutions possibles** :
  - Fix rapide : ajouter `[Campagne: {sujet}]` dans le libellé (JOIN scripts → contenus → campagnes)
  - Fix complet : refonte Vue F en 2 étapes (choisir campagne → choisir script)
  - Bonus : tri par date + recherche dans le dropdown

### DT-V2.1-10 — CNAME Vercel format legacy
- **Origine** : V2.1-S8
- **Priorité** : Basse
- **Résolution prévue** : Post-V2.1 (ou jamais)
- **Description** : le CNAME `dashboard` pointe vers `cname.vercel-dns.com` (format legacy). Vercel recommande `a16b628326eee6c7.vercel-dns-017.com` (badge "DNS Change Recommended" non bloquant). Le legacy continue de fonctionner officiellement.

---
## 🧭 Prochaine version — V2.2

### 🎯 Thème directeur
> **"Rendre le dashboard vraiment utilisable au quotidien"**  
> Focus : UX du pipeline + fiabilité multi-user + qualité des livrables.  
> Aucune nouvelle fonctionnalité — uniquement résolution des dettes techniques MUST + SHOULD.

### 📌 Priorités actées

**🟥 MUST** — impact UX direct
- DT-V2.1-09 — Vue F : afficher le contexte campagne dans les scripts
- DT-V2.1-08 — Suivi de fin de pipeline (polling ou Supabase Realtime)

**🟨 SHOULD** — dette sérieuse
- DT-V2.1-04 — RLS enfants V2
- DT-V2.1-05 — `user_id` sur contenus / analyses / scripts
- DT-V2.1-02 — Descriptions V2-PUB trop longues (nœuds C-V2-20/21/22)

**🟩 COULD** — reportées à V2.3+
- DT-V2.1-01, DT-V2.1-03, DT-V2.1-06, DT-V2.1-10

### 🗓️ Plan de séances V2.2 (prévisionnel — ~5 séances)

| Séance | Objectif |
|---|---|
| **S1** | DT-V2.1-09 — Refonte Vue F avec contexte campagne |
| **S2** | DT-V2.1-08 — Suivi de fin de pipeline (Realtime probable) |
| **S3** | DT-V2.1-04 + DT-V2.1-05 — Multi-user complet (RLS + user_id V1) |
| **S4** | DT-V2.1-02 — Fix descriptions V2-PUB en n8n |
| **S5** | Tests E2E + tag `v2.2.0-stable` |

### 📂 Documents à ouvrir en début de S1 V2.2
- `08_Project_Tracker.md`
- `06.V2_Journal_des_Decisions_d_Architecture.md`
- `01.V2.1_Besoin_Client.md` (référentiel UX)

### ✅ Critère de démarrage V2.2
- V2.1 tag `v2.1.0-stable` publié ✅ (10/08/2026)
- Prod stable, aucune régression signalée ✅
- Cadrage V2.2 validé ✅ (fin S9, 10/08/2026)