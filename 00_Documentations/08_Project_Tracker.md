# 08 — Project Tracker

> **Point d'entrée officiel du projet Créateur de Contenu IA**  
> **Dernière mise à jour** : 11 août 2026

---

## 📌 Rôle du document

Le Project Tracker pilote l'avancement du projet.
- Chaque séance commence par sa lecture et se termine par sa mise à jour.
- Il répond à 4 questions : **Où en est le projet ? Quelle est la prochaine tâche ? Quel document ouvrir ? Quand la séance est-elle terminée ?**
- Il ne contient aucune information d'architecture (voir `06.V2_Journal_des_Decisions_d_Architecture.md`).

---

## 🗺️ Table des matières

1. [📊 État global du projet](#etat-global)
2. [🎯 Tâche active](#tache-active)
3. [📅 Historique des séances](#historique-seances)
   - [V1 — Baseline](#v1-baseline)
   - [V2 — Pipeline IA](#v2-pipeline)
   - [V2.1 — Frontend Dashboard](#v21-frontend)
   - [V2.2 — Amélioration UX](#v22-ux)
4. [🧠 Décisions produit](#decisions-produit)
   - [DP-V2.1](#dp-v21)
   - [DP-V2.2](#dp-v22)
5. [⚠️ Dettes techniques](#dettes-techniques)
   - [🟢 Résolues](#dettes-resolues)
   - [🔴 MUST actives](#dettes-must)
   - [🟨 SHOULD actives](#dettes-should)
   - [🟩 COULD reportées](#dettes-could)
6. [🔧 Architecture n8n (référence)](#architecture-n8n)
7. [🚦 Plans détaillés par version](#plans-detailles)
   - [Plan V2.1 (archivé)](#plan-v21)
   - [Plan V2.2 (actif)](#plan-v22)
   - [Plan V2.3 (roadmap)](#plan-v23)
8. [📈 Historique des jalons](#historique-jalons)
9. [📂 Documents de référence](#docs-reference)
10. [🛠️ Guide de maintenance du tracker](#guide-maintenance)

---

## 📊 État global du projet <a id="etat-global"></a>

| Version | Statut | Progression | Tag Git | Description |
|---|---|---|---|---|
| **V1** | 🟢 STABLE | 100% | `v1.0.0-stable` | Workflow n8n `lancer-campagne`. Verrouillée. |
| **V2** | 🟢 STABLE | 100% | `v2.0.0-stable` | Pipeline complet V2-ORCH → V2-PUB. E2E validé. |
| **V2.1** | 🟢 STABLE | 100% | `v2.1.0-stable` | Frontend Dashboard + prod sur `dashboard.sterveshop.cloud`. |
| **V2.2** | 🟡 EN COURS | ~20% | — | S1 terminée (5 dettes résolues). Reste S2 → S5. |
| **V2.3** | ⚪ PRÉVUE | 0% | — | Roadmap "DevOps & Portfolio Compétences". |

---

## 🎯 Tâche active <a id="tache-active"></a>

| Champ | Valeur |
|---|---|
| **ID** | V2.2-S2 |
| **Titre** | DT-V2.1-08 — Suivi de fin de pipeline (Supabase Realtime probable) |
| **Statut** | ⏳ À planifier |
| **Version** | V2.2 |
| **Documents à ouvrir** | `08_Project_Tracker.md`, `06.V2_Journal_des_Decisions_d_Architecture.md` |

**Séance précédente** : V2.2-S1 — terminée le 11/08/2026 (voir [Historique V2.2](#v22-ux)).

---

## 📅 Historique des séances <a id="historique-seances"></a>

### V1 — Baseline STABLE <a id="v1-baseline"></a>
Livrée le 03/08/2025. Tag `v1.0.0-stable`. Voir historique de jalons pour détails.

### V2 — Pipeline IA STABLE <a id="v2-pipeline"></a>

| Bloc n8n | Nœuds | Statut | Date |
|---|---|---|---|
| V2-ERR | Workflow séparé | ✅ | 06/08/2026 |
| V2-ORCH | C-V2-01 → C-V2-05b | ✅ | 07/08/2026 |
| V2-SCENE | C-V2-06 → C-V2-08 | ✅ | 08/08/2026 |
| V2-PLAN | C-V2-09 → C-V2-11b | ✅ | 08/08/2026 |
| V2-IMG | C-V2-13 → C-V2-15e | ✅ | 09/08/2026 |
| V2-ANIM | C-V2-16 → C-V2-18 | ✅ | 10/08/2026 |
| V2-PUB | C-V2-20 → C-V2-22 | ✅ | 10/08/2026 |

Tests E2E V2 (100% ✅) :
| Test | ID | Sujet | Statut | Durée |
|---|---|---|---|---|
| Test 1 V2 | 5 | Intelligence Artificielle | ✅ TERMINE | Fragmenté |
| Test 2 V2 E2E | 6 | Productivité au travail | ✅ TERMINE | ~4m34s |
| Test 3 V2 (Vue F) | 8 | Productivité au travail | ✅ TERMINE | ~4 min |

### V2.1 — Frontend Dashboard STABLE <a id="v21-frontend"></a>

| Séance | Livrable | Statut | Date |
|---|---|---|---|
| S1 | Setup Next.js + Supabase Auth Magic Link | 🟢 | 08/08/2026 |
| S2 | Vue B — Liste des dossiers | 🟢 | 08/08/2026 |
| S3 | Vue C — Détail dossier complet | 🟢 | 09/08/2026 |
| S4 | Composant `<CopyButton />` | 🟢 | 10/08/2026 |
| S5 | Vue F — Créer dossier V2 | 🟢 | 09/08/2026 |
| S6+S7 | Vues E + G (campagnes) + migration user_id | 🟢 | 10/08/2026 |
| S8 | Déploiement Vercel + `dashboard.sterveshop.cloud` | 🟢 | 10/08/2026 |
| S9 | Bilan + tag `v2.1.0-stable` | 🟢 | 10/08/2026 |

Tests E2E V1 (via Vue E) :
| Test | Campagne ID | Sujet | Statut | Durée |
|---|---|---|---|---|
| Test 1 V1 (PS) | 17 | Test PS | ✅ 1/1 | ~30s |
| Test 2 V1 (Vue E) | 18 | Test Formulaire React | ✅ 2/2 | ~1min |
| Test 3 V1 (prod) | 19 | les avartar IA | ✅ 2/2 | ~1min |

### V2.2 — Amélioration UX (EN COURS) <a id="v22-ux"></a>

#### V2.2-S1 — DT-V2.1-09 + fixes bonus (11/08/2026) 🟢

**Objectif initial** : résoudre DT-V2.1-09 (Vue F contexte campagne).

**Livrables réels (rendement 500%)** :
- ✅ DT-V2.1-09 résolue (dropdown script enrichi `[Campagne] #ID — aperçu`)
- ✅ DT-V2.1-02 anticipée depuis S4 (descriptions courtes + hashtags ≤5)
- ✅ DT-V2.2-01 créée + résolue (badges tarifs outils 🟢🟡🔴)
- ✅ DT-V2.2-02 créée + résolue (neutralisation CTA source narration)
- ✅ DT-V2.2-03 créée + résolue (redirection auth-based sur route `/`)

**Commits frontend** (`createur-contenu-ia-dashboard`) :
- `feat(dashboard): enrich script dropdown with campaign context + tool pricing badge`
- `fix(app): replace default Next.js template on / with auth-based redirect`

**Commits doc** (`createur-contenu-ia`) :
- `docs(tracker): close V2.2-S1 + add V2.3 roadmap DevOps/portfolio`
- `docs(adr): add V2.2-S1 decisions (DP-V2.2-01/02/03 + ADR-0020 extended thinking)`
- `docs: track DT-V2.2-03 resolution (root URL auth-based redirect)`

**Modifs n8n (hors Git)** :
- C-V2-06 : prompt neutralisation CTA source + maxTokens 2000→3000
- C-V2-21a : contraintes strictes descriptions + neutralisation CTA
- C-V2-21b : maxTokens 1500→2000
- C-V2-21c : parsing robuste mode extended thinking Claude Sonnet 5

**Décisions actées** : DP-V2.2-01, DP-V2.2-02, DP-V2.2-03, DP-V2.2-04, ADR-0020

**Preuves E2E** : dossier 10 (fail narration → correctif) puis dossier 11 (✅ complet).

---

## 🧠 Décisions produit <a id="decisions-produit"></a>

### DP-V2.1 <a id="dp-v21"></a>

#### DP-V2.1-01 — Vue C minimaliste orientée action (S3)
La Vue C n'affiche que les champs actionnables (narration, prompt image, prompt animation, descriptions). Champs pipeline (`ambiance_visuelle`, `description_visuelle`, `parametres_recommandes`) conservés en DB mais masqués.

#### DP-V2.1-02 — Vue F : 3 dropdowns multi-outils (S5)
La Vue F propose 3 dropdowns (script + outil image + outil animation) lus depuis `v2_outils` (filtre `actif=true`). Préserve le cas "comparer différents outils sur le même script".

#### DP-V2.1-03 — Élargissement V2.1 : intégrer aussi V1 (fin S5)
Ajout de 2 vues (E + G) au périmètre V2.1 avant tout déploiement, pour couvrir aussi le déclenchement V1. Plan 7 → 9 séances (S6+S7 fusionnées).

#### DP-V2.1-04 — Plateforme YouTube uniquement en Vue E (S6)
Le workflow V1 ne collecte que YouTube. Le select plateforme affiche uniquement YouTube + message "TikTok et Instagram prochainement".

### DP-V2.2 <a id="dp-v22"></a>

#### DP-V2.2-01 — Badges tarifs outils Vue F (S1)
Affichage `🟢 Gratuit / 🟡 Freemium / 🔴 Payant` à côté de chaque outil + légende sous chaque dropdown. SELECT enrichi avec `modele_economique`.

#### DP-V2.2-02 — Neutralisation des CTA source (S1)
"RÈGLE ABSOLUE" ajoutée dans C-V2-06 (narration) et C-V2-21a (descriptions) pour supprimer les mentions Skool / lien en bio / marques personnelles du créateur source. Remplacement par CTA génériques réutilisables.

#### DP-V2.2-03 — Descriptions strictement courtes + 5 hashtags max (S1)
Cibles ajustées dans C-V2-21a :
- TikTok : max 300 car + 5 hashtags
- YouTube Shorts : max 150 car + 5 hashtags (dont #Shorts)
- Instagram Reels : max 125 car + 5 hashtags

#### DP-V2.2-04 — Redirection auth-based sur route `/` (S1 post-fix)
La route racine `/` remplace le template `create-next-app` par un Server Component qui redirige vers `/dashboard` (connecté) ou `/login` (anonyme).

---

## ⚠️ Dettes techniques <a id="dettes-techniques"></a>

### 🟢 Résolues <a id="dettes-resolues"></a>

| ID | Titre | Résolue le | Séance |
|---|---|---|---|
| DT-V2.1-07 | V1 sans user_id (multi-user impossible) | 10/08/2026 | V2.1-S6 |
| DT-V2.1-02 | Descriptions générées trop longues | 11/08/2026 | V2.2-S1 (anticipée) |
| DT-V2.1-09 | Vue F dropdown script sans contexte campagne | 11/08/2026 | V2.2-S1 |
| DT-V2.2-01 | Vue F dropdowns outils sans indication tarifaire | 11/08/2026 | V2.2-S1 |
| DT-V2.2-02 | Narration voix off polluée par CTA source | 11/08/2026 | V2.2-S1 |
| DT-V2.2-03 | Page d'accueil `/` non professionnelle | 11/08/2026 | V2.2-S1 (post) |

<details>
<summary>📖 Détails des résolutions (cliquer pour déplier)</summary>

**DT-V2.1-07** : Migration `campagnes.user_id` + policies RLS + modif workflow V1 (Valider Paramètres + Créer Campagne). Test E2E OK (campagnes 17-18).

**DT-V2.1-02** : Fusion avec S1 V2.2. Modifs C-V2-21a (contraintes strictes) + maxTokens C-V2-21b (2000) + parsing robuste C-V2-21c (extended thinking). Test E2E OK (dossiers 10 + 11).

**DT-V2.1-09** : JOIN scripts → contenus → campagnes. Enrichissement Server Component + fonction `construireLabelScript()` côté client. Fallback `[Campagne inconnue]` pour scripts orphelins.

**DT-V2.2-01** : Enrichissement Server Component avec `modele_economique` + fonction `construireLabelOutil()` avec badges emoji + légende.

**DT-V2.2-02** : Modification du prompt du nœud C-V2-06 avec "RÈGLE ABSOLUE — NEUTRALISATION DES ÉLÉMENTS DU CRÉATEUR SOURCE" + augmentation maxTokens à 3000.

**DT-V2.2-03** : Remplacement du template `create-next-app` par un Server Component minimaliste qui redirige selon l'état d'authentification.

</details>

### 🔴 MUST actives <a id="dettes-must"></a>

| ID | Titre | Version cible | Séance prévue |
|---|---|---|---|
| DT-V2.1-08 | Pas de mécanisme polling / notification de fin pipeline | V2.2 | S2 |

**DT-V2.1-08** — Les webhooks V1/V2 répondent immédiatement mais le pipeline continue en async pendant plusieurs minutes. L'utilisateur ne sait pas quand c'est terminé sauf en rafraîchissant manuellement (F5).
- Solutions possibles : polling client, Supabase Realtime, notification email/push
- Mitigation temporaire : Vue G affiche statut au chargement

### 🟨 SHOULD actives <a id="dettes-should"></a>

| ID | Titre | Version cible | Séance prévue |
|---|---|---|---|
| DT-V2.1-04 | RLS enfants V2 désactivée | V2.2 | S3 |
| DT-V2.1-05 | user_id sur contenus/analyses/scripts | V2.2 | S3 |

**DT-V2.1-04** — Tables sans RLS : `v2_scenes`, `v2_plans`, `v2_prompts_images`, `v2_prompts_animations`, `v2_descriptions_publication`.

**DT-V2.1-05** — Restant : contenus, analyses, scripts (globaux). OK pour MVP mono-user, à corriger avant vrai multi-user.

### 🟩 COULD reportées <a id="dettes-could"></a>

| ID | Titre | Priorité | Version cible |
|---|---|---|---|
| DT-V2.1-01 | Migration middleware.ts → proxy.ts | Basse | V2.3+ |
| DT-V2.1-03 | Champs pipeline masqués Vue C | Basse | V3+ |
| DT-V2.1-06 | Champ `scripts.script` JSON incohérent | Basse | V2.3+ |
| DT-V2.1-10 | CNAME Vercel format legacy | Basse | Optionnel |

<details>
<summary>📖 Détails (cliquer pour déplier)</summary>

**DT-V2.1-01** : `npx @next/codemod@canary middleware-to-proxy .`

**DT-V2.1-03** : Champs pipeline conservés en DB mais masqués UI (DP-V2.1-01). À réévaluer si besoin métier apparaît.

**DT-V2.1-06** : Nœud "Normalisation Script IA" V1 renvoie parfois texte brut, parfois JSON encapsulé. Fix temporaire côté frontend (`extraireApercuScript()`). Fix cible : sécuriser le nœud n8n.

**DT-V2.1-10** : CNAME `dashboard` → `cname.vercel-dns.com` (legacy). Vercel recommande `a16b628326eee6c7.vercel-dns-017.com`. Legacy continue de fonctionner officiellement.

</details>
---

## 🔧 Architecture n8n (référence) <a id="architecture-n8n"></a>

### Workflow V1 — lancer-campagne
- Webhook : POST https://automation.sterveshop.cloud/webhook/lancer-campagne
- Payload (MAJ V2.1-S6) :
    {
      "sujet": "Productivité au travail",
      "plateforme": "YouTube",
      "langue": "fr",
      "nb_resultats": 5,
      "user_id": "uuid-auth-user"
    }
- Durée : ~30s à ~2min selon nb_resultats.

### Workflow V2 — v2-creer-dossier
- Webhook : POST https://automation.sterveshop.cloud/webhook/v2-creer-dossier
- Payload : { script_id, outil_image_id, outil_animation_id, user_id }
- Durée : ~4 min.

### Historique des modifications n8n
| Séance | Nœuds impactés | Description |
|---|---|---|
| V2.1-S5 | C-V2-02, C-V2-05 | Validation + INSERT user_id (V2) |
| V2.1-S6 | Valider Paramètres, Créer Campagne | Validation + INSERT user_id (V1) |
| V2.2-S1 | C-V2-06 | Neutralisation CTA source + maxTokens 3000 |
| V2.2-S1 | C-V2-21a | Contraintes strictes descriptions + neutralisation |
| V2.2-S1 | C-V2-21b | maxTokens 1500→2000 |
| V2.2-S1 | C-V2-21c | Parsing robuste extended thinking Claude Sonnet 5 |

---

## 🚦 Plans détaillés par version <a id="plans-detailles"></a>

### Plan V2.1 (archivé) <a id="plan-v21"></a>
Voir Historique des séances V2.1.  
✅ STABLE — Tag `v2.1.0-stable` (10/08/2026)

### Plan V2.2 (actif) <a id="plan-v22"></a>
**Thème directeur** : "Rendre le dashboard vraiment utilisable au quotidien"  
**Focus** : UX du pipeline + fiabilité multi-user + qualité des livrables.

| Séance | Objectif | Statut | Date |
|---|---|---|---|
| S1 | DT-V2.1-09 + bonus (DT-V2.1-02, DT-V2.2-01, DT-V2.2-02, DT-V2.2-03) | 🟢 | 11/08/2026 |
| S2 | DT-V2.1-08 — Suivi de fin de pipeline (Realtime) | ⏳ | — |
| S3 | DT-V2.1-04 + DT-V2.1-05 — Multi-user complet | ⏳ | — |
| S4 | Séance libérée (DT-V2.1-02 déjà résolue en S1) | 🔄 | — |
| S5 | Tests E2E + tag `v2.2.0-stable` | ⏳ | — |

*Critère de démarrage V2.2 : ✅ Tag `v2.1.0-stable` + prod stable + cadrage validé (10/08/2026).*

### Plan V2.3 (roadmap DevOps & Portfolio) <a id="plan-v23"></a>
**Thème directeur** : "Transformer le projet en portfolio DevOps prouvable"  
**Focus** : acquérir les compétences CI/CD recherchées par les recruteurs.

| Séance | Objectif | Compétence acquise |
|---|---|---|
| S1 | CI GitHub Actions basique (lint + build) + badge README | GitHub Actions, workflows YAML, secrets |
| S2 | Environnement staging Vercel + branche staging | Environnements multiples, GitFlow, Vercel Preview |
| S3 | Installation Playwright + 2-3 tests E2E critiques | Tests E2E, Playwright, sélecteurs stables |
| S4 | Intégration Playwright dans CI + blocage PR | CI avancé, quality gates, PR checks |
| S5 | Notifications Discord/Slack + tag `v2.3.0-stable` | Webhooks, release automation |

---

## 📈 Historique des jalons <a id="historique-jalons"></a>

| Date | Événement | Impact |
|---|---|---|
| 03/08/2025 | 🎉 V1 STABLE livrée | Baseline V1 verrouillée. |
| 04/08/2025 | 📐 Conception V2 terminée | 12 documents produits. |
| 04/08/2026 | 🛠️ Infrastructure V2 posée | DDL + Catalogue + V2-ERR. |
| 05/08/2026 | 🚀 V2-ORCH opérationnel | Bloc initial testé. |
| 05/08/2026 | 🎬 V2-SCENE & V2-PLAN opérationnels | 5 scènes + 18 plans générés. |
| 06/08/2026 | 🖼️ V2-IMG opérationnel | ADR-V2-07 formalisé. |
| 06/08/2026 | 🎥 V2-ANIM opérationnel | 18 prompts animations Kling AI. |
| 07/08/2026 | 🎯 V2-PUB opérationnel | 3 descriptions plateformes + clôture. |
| 07/08/2026 | 🏆 V2 STABLE — Tag `v2.0.0-stable` | Test E2E dossier 6 en 4m34s. |
| 08/08/2026 | ✅ V2.1-S1 terminée | Auth Magic Link opérationnelle. |
| 08/08/2026 | ✅ V2.1-S2 terminée | Vue B opérationnelle avec RLS. |
| 09/08/2026 | ✅ V2.1-S3 terminée | Vue C complète. DP-V2.1-01 actée. |
| 09/08/2026 | ✅ V2.1-S5 terminée | Vue F + Dossier 8 E2E. DP-V2.1-02 actée. |
| 09/08/2026 | 🔍 Découverte fin S5 | Élargissement V2.1 : +2 séances (E+G). DP-V2.1-03. |
| 10/08/2026 | ✅ V2.1-S4 terminée | `<CopyButton/>` sur ~47 blocs. |
| 10/08/2026 | ✅ V2.1-S6+S7 terminées | Vues E + G + migration `user_id`. DT-V2.1-07 résolue. |
| 10/08/2026 | ✅ V2.1-S8 terminée | Prod sur `dashboard.sterveshop.cloud`. |
| 10/08/2026 | 🏆 V2.1 STABLE — Tag `v2.1.0-stable` | Dashboard complet livré. Fin V2.1. |
| 11/08/2026 | ✅ V2.2-S1 terminée | 5 dettes résolues. 4 DP actées. |
| 11/08/2026 | 📚 Cadrage V2.3 acté | Roadmap "DevOps & Portfolio Compétences". |

---

## 📂 Documents de référence <a id="docs-reference"></a>

| Document | Rôle |
|---|---|
| `08_Project_Tracker.md` | Ce document — point d'entrée officiel |
| `01.V2.1_Besoin_Client.md` | Périmètre V2.1, §5 vues MVP |
| `03.V2_Architecture_des_Workflows.md` | Architecture workflows n8n V2 |
| `04.V2_Specification_des_Composants.md` | Prompts système + spec composants |
| `04.1.V2_Catalogue_Outils.md` | Catalogue des outils image/animation |
| `05.V2_Implementation_Technique.md` | Spécifications techniques des nœuds |
| `06.V2_Journal_des_Decisions_d_Architecture.md` | ADR V1 + V2 + décisions produit |
| `07.V2_Plan_de_tests.md` | Cas de tests V2 |
| `99_Prompt_de_reprise.md` | Prompts de reprise entre séances |

---

## 🛠️ Guide de maintenance du tracker <a id="guide-maintenance"></a>

### 📝 Règles d'or
- Le tracker est mis à jour EN FIN DE SÉANCE, pas pendant.
- Chaque bloc a sa section unique — pas de doublons entre sections.
- Chronologie descendante : les infos les plus récentes en haut de chaque section.
- Séparer résolu / actif : les dettes résolues vont dans la table 🟢 Résolues.
- Un DP ou une DT = un ID unique jamais réutilisé (même si résolu).

### 🆕 Ajouter une nouvelle séance terminée
Copier ce template dans la section **Historique des séances** sous la version en cours :

#### VX.Y-SN — Titre séance (DD/MM/YYYY) 🟢

**Objectif** : ...

**Livrables** :
- ✅ ...

**Commits** (frontend/backend/doc) :
- `type(scope): message`

**Modifs n8n (hors Git)** :
- Nœud X : ...

**Décisions actées** : DP-VX.Y-NN, ADR-XXXX

**Preuves E2E** : dossier NN / campagne NN

Puis :
1. Ajouter la ligne dans 📈 **Historique des jalons**
2. Mettre à jour 🎯 **Tâche active** avec la prochaine séance
3. Si dette résolue : la déplacer de "actives" vers 🟢 **Résolues**

### 🆕 Ajouter une nouvelle dette technique
Dans la bonne section (🔴 MUST / 🟨 SHOULD / 🟩 COULD) :

### DT-VX.Y-NN — Titre
- **Origine** : VX.Y-SN
- **Priorité** : Haute / Moyenne / Basse
- **Résolution prévue** : VX.Y-SN ou "Post-VX.Y"
- **Description** : ...
- **Solutions possibles** : ...

### 🆕 Ajouter une nouvelle décision produit
Dans la section 🧠 **Décisions produit** → sous-section DP-VX.Y :

#### DP-VX.Y-NN — Titre (SN)
Décision courte (2-3 lignes). Justification si non triviale.

### 📝 Format de commit standardisé
Pour ce fichier :
`docs(tracker): [action] [contenu]`

Exemples :
- `docs(tracker): close V2.2-S1 + add DT-V2.2-03`
- `docs(tracker): open V2.2-S2 (Realtime)`
- `docs(tracker): reorganize sections + add TOC`

### 🔄 Fréquence de refonte structurelle
- Après chaque fin de version majeure (tag Git posé)
- Ou si le fichier dépasse ~800 lignes
- Ou si la table des matières ne suffit plus à trouver une info en < 30s