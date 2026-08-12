# 06. Architecture Decisions & Product Decisions Record (ADR / DP)

**Projet :** Automation IA & Dashboard Pipeline (V1 / V2)  
**Auteur :** Sterve  
**Dernière mise à jour :** 12 Août 2026  
**Statut global :** V2.1 Stable (`v2.1.0-stable`) / V2.2 En Cours (S3 Terminée)

---

## 📑 Table des Matières
1. [Registre des Décisions d'Architecture (ADR)](#-registre-des-décisions-darchitecture-adr)
   - [ADR-0022 : Sécurisation des tables enfants sans user_id direct (RLS par JOIN)](#adr-0022--sécurisation-des-tables-enfants-sans-user_id-direct-rls-par-join)
2. [🧠 Décisions Produit (DP)](#-décisions-produit-dp)
   - [DP-V2.1 : Dashboard V2.1 & Intégration V1/V2](#dp-v21--dashboard-v21--intégration-v1v2)
   - [DP-V2.2 : Amélioration UX, Fiabilité & Qualité IA](#dp-v22--amélioration-ux-fiabilité--qualité-ia)
3. [🗂️ Index Thématique](#️-index-thématique)
4. [🔗 Dépendances Documentaires](#-dépendances-documentaires)
5. [🛠️ Guide de Maintenance](#️-guide-de-maintenance)

---

## 🏛️ Registre des Décisions d'Architecture (ADR)

### ADR-0022 — Sécurisation des tables enfants sans user_id direct (RLS par JOIN)
* **Créé :** V2.2-S3 (11/08/2026)  
* **Statut :** ✅ Validé & Appliqué  
* **Sujet :** Sécurité / Row Level Security (RLS) multi-utilisateur sur base Supabase PostgreSQL  

#### Contexte
Le frontend Next.js et l'API Supabase (PostgREST) doivent garantir une isolation multi-utilisateur stricte sur l'ensemble des données. Les tables enfants du pipeline (scènes, plans, prompts, contenus, analyses, scripts) ne possèdent pas de colonne `user_id` native. Pour éviter la redondance de données et limiter les impacts sur la base, il fallait sécuriser l'accès en lecture sans altérer le schéma existant ni modifier les workflows d'écriture automatisés dans n8n.

#### Décision
Mise en place de politiques Row Level Security (RLS) basées sur des requêtes imbriquées (`JOIN`s / `EXISTS`) remontant jusqu'à la table parente détenant la colonne `user_id` de propriété (posée lors de la DT-V2.1-07).

#### Chaînes réellement sécurisées

| Table Enfant | Sauts (JOINs) | Chemin de remontée jusqu'au `user_id` |
| :--- | :---: | :--- |
| `v2_scenes` | 1 | `v2_dossiers_production.user_id` |
| `v2_plans` | 2 | `v2_scenes` → `v2_dossiers_production.user_id` |
| `v2_prompts_images` | 3 | `v2_plans` → `v2_scenes` → `v2_dossiers_production.user_id` |
| `v2_prompts_animations` | 3 | `v2_plans` → `v2_scenes` → `v2_dossiers_production.user_id` |
| `v2_descriptions_publication` | 1 | `v2_dossiers_production.user_id` |
| `contenus` | 1 | `campagnes.user_id` |
| `analyses` | 2 | `contenus` → `campagnes.user_id` |
| `scripts` | 3 | `analyses` → `contenus` → `campagnes.user_id` |

#### Justification
* **Isolation Frontend :** Le frontend Next.js ne fait que lire (`SELECT`) ces tables enfants via le rôle `authenticated`.
* **Bypass n8n Natif :** n8n écrit via connexion Postgres directe (`ia-contenu-prod`) et bypass RLS naturellement.
* **Intégrité V1/V2 :** Zéro modification n8n = zéro risque de casser V1 ou V2.
* **Non-redondance :** On réutilise le `user_id` déjà posé en DT-V2.1-07, au lieu de le recopier partout.
* **Moindre Privilège :** Principe de moindre privilège : pas de policy `INSERT` / `UPDATE` / `DELETE` côté `authenticated`.

#### Alternatives Rejetées
* **`ALTER TABLE + user_id + modification n8n` :** Plus simple à lire en SQL, mais impose de toucher les workflows V1/V2, de backfiller les lignes existantes, et de maintenir une colonne redondante.
* **`Vues SQL sans RLS table` :** Déplace le problème, n’empêche pas un accès direct PostgREST aux tables enfants.

#### Conséquences & Impacts
* **Sécurité :** 8 tables enfants maintenant filtrées par propriétaire.
* **Codebase :** Aucun commit frontend, aucune modification n8n.
* **Performance :** Performance acceptable au volume actuel. À réévaluer si une table dépasse ~100k lignes, car les policies font 1 à 3 JOINs.
* **Découverte (Bonus) :** Tables encore `RLS DISABLED` découvertes en bonus, hors dettes S3 : `v2_checklists`, `v2_etapes_chemins`, `v2_journal_execution`, `v2_outils`, `journal_execution`. (`v2_outils` est un référentiel partagé : il doit probablement rester lisible par tous, à confirmer plus tard).

#### Preuves de Validation
* **Test SQL simulé cross-user :** Avec `SET LOCAL role = 'authenticated'` + `request.jwt.claims`.
  * Propriétaire du dossier 11 (`user_id f8e77d8b-3d54-4937-9302-4a920d48bd6e`) : 4 scènes visibles.
  * UUID bidon `00000000-...` : 0 scène visible.
* **Test frontend compte propriétaire (Vue C, dossier 11) :** Scènes / plans / prompts / descriptions visibles.
* **Test frontend cross-user (`sterve90237@gmail.com`) :**
  * Vue B : liste vide.
  * Vue G : liste vide.
  * Vue F : dropdown scripts vide.
  * **Résultat : Aucune fuite depuis le compte principal.**

#### Références
* **Dépendances :** DT-V2.1-04, DT-V2.1-05
* **Leçon apprise :** DT-V2.1-07 (V1 sans `user_id` natif)

---

## 🧠 Décisions Produit (DP)

### DP-V2.1 — Périmètre & Intégration V2.1
* **Portée :** Décisions produit prises pendant la V2.1 (dashboard Next.js + intégration V1/V2 + déploiement Vercel).
* **Statut V2.1 :** ✅ STABLE — Tag `v2.1.0-stable` (10/08/2026)

#### DP-V2.1-01 — Vue C minimaliste orientée action
* **Créé :** V2.1-S3
* **Contexte :** La Vue "Détail dossier" contenait à l'origine tous les champs techniques du pipeline, inutiles pour l'utilisateur final.
* **Décision :** La Vue C n'affiche que les champs actionnables : narration, prompt image, prompt animation, descriptions. Les champs pipeline restent masqués.

#### DP-V2.1-02 — Vue F : 3 dropdowns multi-outils
* **Créé :** V2.1-S5
* **Contexte :** Choix des outils lors de la création d'un dossier V2.
* **Décision :** Proposer 3 dropdowns indépendants : Script, Outil image, Outil animation.

#### DP-V2.1-03 — Élargissement du périmètre V2.1 : intégrer aussi V1
* **Créé :** V2.1 fin S5
* **Contexte :** L'utilisateur ne pouvait pas déclencher de campagne V1 depuis le dashboard.
* **Décision :** Ajouter 2 nouvelles vues : Vue E (Créer une campagne) et Vue G (Liste des campagnes).

#### DP-V2.1-04 — Plateforme YouTube uniquement en Vue E
* **Créé :** V2.1-S6
* **Contexte :** Seule la collecte YouTube est active en V1.
* **Décision :** Le select "plateforme" n'affiche que YouTube avec un message prévenant de la prise en charge future de TikTok/Instagram.

---

### DP-V2.2 — Amélioration UX, Fiabilité & Qualité IA
* **Portée :** Décisions produit prises pendant la V2.2 (amélioration UX + fiabilité multi-user + qualité des livrables IA).
* **Statut V2.2 :** 🟡 EN COURS — S1 + S2 + S3 terminées. Prochaine DP = DP-V2.2-06.

#### DP-V2.2-01 — Badges tarifs outils dans dropdown Vue F
* **Créé :** V2.2-S1
* **Contexte :** Manque de visibilité sur le modèle économique des outils lors de la sélection.
* **Décision :** Afficher un badge coloré à côté de chaque outil dans Vue F : 🟢 Gratuit · 🟡 Freemium · 🔴 Payant.

#### DP-V2.2-02 — Neutralisation systématique des CTA du créateur source
* **Créé :** V2.2-S1
* **Contexte :** Les scripts sources contenaient des CTA spécifiques aux créateurs d'origine ("Lien en bio", "Rejoins mon Skool") recopiés par les LLM.
* **Décision :** Ajouter une règle absolue dans les prompts C-V2-06 et C-V2-21a interdisant les CTA spécifiques au profit de CTA 100% génériques ("Abonne-toi", "Commente pour le tuto").

#### DP-V2.2-03 — Descriptions plateformes strictly courtes + 5 hashtags max
* **Créé :** V2.2-S1
* **Contexte :** Les descriptions générées étaient trop longues pour les standards 2026.
* **Décision :** Ajuster le nœud C-V2-21a avec des contraintes de longueur strictes : TikTok (≤ 300 car), YouTube Shorts (≤ 150 car), Instagram Reels (≤ 125 car) avec exactement 5 hashtags ciblés par plateforme pour économiser la bande passante et maximiser l'engagement.

#### DP-V2.2-04 — Redirection auth-based sur la route racine `/`
* **Créé :** V2.2-S1
* **Contexte :** La route racine `/` affichait encore le template par défaut de create-next-app.
* **Décision :** Remplacer par un Server Component silencieux qui redirige vers `/dashboard` si connecté, ou `/login` si anonyme.

#### DP-V2.2-05 — Toast visuel de fin de pipeline via `sonner`
* **Date :** 11 août 2026
* **Séance :** V2.2-S2
* **Lié à :** ADR-0021 (Realtime), DT-V2.1-08
* **Décision :** Ajout d'un toast visuel (bibliothèque `sonner`) affiché lorsqu'un dossier passe à TERMINE (V2) ou qu'une campagne passe à TERMINEE (V1). Le toast n'apparaît que sur transition (comparaison `payload.old.statut` vs `payload.new.statut`) — jamais sur un UPDATE intermédiaire (ex: incrément de `nb_contenus_traites`).
* **Justification :** Sans toast, le rafraîchissement Realtime est silencieux : si l'utilisateur ne regarde pas fixement l'écran, il rate la fin du pipeline. `sonner` : librairie moderne (~5 KB), recommandée par shadcn/ui, zéro config, pas de contexte à créer. Position top-right : standard dashboard, ne cache pas le contenu principal. Option `richColors` : différenciation visuelle (vert = succès).
* **Format du toast :**
  * Titre : *Dossier #12 terminé(e) ✅* ou *Campagne #17 terminé(e) ✅*
  * Description : *Le pipeline vient de se terminer.*
* **Implémentation :**
  * Installation : `npm install sonner`
  * `<Toaster richColors position="top-right" />` monté une fois dans `app/layout.tsx`
  * Appel `toast.success(...)` dans `RealtimeRefresher.tsx` sur détection de transition finale

---

## 🗂️ Index Thématique

| Thème | Décisions concernées |
| :--- | :--- |
| **Modèle métier** | ADR-0001, ADR-0002, ADR-0006, ADR-0007 |
| **Découplage plateforme** | ADR-0003, ADR-0004, ADR-0010 |
| **Intégrité et unicité** | ADR-0005, ADR-0014 |
| **Modularité** | ADR-0008 |
| **Persistance** | ADR-0009, ADR-0019 |
| **Gestion des erreurs** | ADR-0011, ADR-0012, ADR-0018 |
| **Observabilité et compteurs** | ADR-0013, ADR-0015 |
| **Choix IA (modèles LLM)** | ADR-0017, ADR-0020 |
| **Robustesse d'exécution** | ADR-0016, ADR-0018, ADR-0020 |
| **Architecture V2** | ADR-V2-01 à ADR-V2-07 |
| **Prompt engineering (V2.2+)** | DP-V2.2-02, DP-V2.2-03 |
| **UX Frontend** | DP-V2.1-01, DP-V2.1-02, DP-V2.2-01, DP-V2.2-05 |
| **Périmètre produit** | DP-V2.1-03, DP-V2.1-04, DP-V2.2-04 |
| **Sécurité / RLS multi-user** | ADR-0022, DT-V2.1-07 |
| **Temps réel frontend** | ADR-0021, DP-V2.2-05 |

---

## 🔗 Dépendances Documentaires

### S'appuie sur :
* `03.V2_Architecture_des_Workflows.md`
* `04.V2_Specification_des_Composants.md`
* `04.1.V2_Catalogue_Outils.md`
* `05.V2_Implementation_Technique.md`

### Sert de référence pour :
* N'importe quel ADR futur (V2.3+)
* Le Project Tracker (`08_Project_Tracker.md`)

---

## 🛠️ Guide de Maintenance

### 📝 Règles d'or
1. **Un ADR est immuable** — jamais réécrit. Si obsolète, créer un nouvel ADR qui référence l'ancien.
2. **Un ADR = une seule décision atomique** — pas de décisions groupées.
3. **Convention actuelle :** numérotation continue — le prochain ADR sera `ADR-0023`.
4. **DP peut évoluer** — une `DP-V2.1-XX` peut être révisée par une `DP-V2.2-YY`.
5. **Toujours ajouter dans l'Index Thématique** après création.

### 🆕 Format pour un nouvel ADR
```markdown
### ADR-XXXX — Titre court explicite
Créé : VX.Y-SN (JJ/MM/AAAA)

#### Contexte
Pourquoi la question s'est posée. Symptômes observés. Impact.

#### Décision
Ce qui a été choisi. Peut inclure du code court illustratif.

#### Justification
Pourquoi ce choix précis vs les alternatives.

#### Alternatives rejetées
- Alt 1 : ... — rejetée car ...
- Alt 2 : ... — rejetée car ...

#### Conséquences
- Impact positif : ...
- Dette créée : ...
- Points d'attention futurs : ...
🆕 Format pour une nouvelle Décision Produit (DP)
### DP-VX.Y-NN — Titre court
Créé : VX.Y-SN

#### Contexte
Bref rappel du problème / opportunité produit.

#### Décision
Ce qui a été choisi (UX, format, comportement).

#### Conséquences
Impact utilisateur + technique.
📝 Format de commit standardisé
docs(adr): [action] [contenu]

Exemples :

docs(adr): add ADR-0022 (RLS security on child tables via JOINs)

docs(adr): add DP-V2.2-05 (pipeline completion toast via sonner)