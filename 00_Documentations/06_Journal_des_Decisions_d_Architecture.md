# 06 — Journal des Décisions d'Architecture (ADR)

> **Journal unifié de toutes les décisions du projet Créateur de Contenu IA**  
> **Dernière mise à jour** : 11 août 2026

---

## 📌 Rôle du document <a id="role-du-document"></a>

Ce document consigne **toutes les décisions d'architecture et de produit** prises tout au long du projet, de la V1 fondatrice à la version en cours.

Chaque décision explique :
- le **contexte** (pourquoi la question s'est posée) ;
- la **décision retenue** (ce qui a été choisi) ;
- la **justification** (pourquoi ce choix précis) ;
- les **conséquences** (impact positif ou dette générée) ;
- les **alternatives rejetées** *(pour les ADR techniques, pas systématique pour les DP)*.

Il permet de comprendre *pourquoi* certaines orientations techniques ou fonctionnelles ont été choisies.

---

## 🗺️ Table des matières <a id="table-des-matieres"></a>

1. [📖 Convention de rédaction](#convention-de-redaction)
2. [🏛️ ADR fondateurs V1 (ADR-0001 à 0010)](#adr-fondateurs-v1)
3. [🔧 ADR techniques V1 STABLE (ADR-0011 à 0019)](#adr-techniques-v1)
4. [🚀 ADR techniques V2 (ADR-V2-01 à V2-07)](#adr-techniques-v2)
5. [🆕 ADR techniques V2.2+ (ADR-0020+)](#adr-techniques-v22)
   - [ADR-0020 — Gestion robuste extended thinking Claude Sonnet 5](#adr-0020)
6. [🧠 Décisions produit](#decisions-produit)
   - [DP-V2.1](#dp-v21)
   - [DP-V2.2](#dp-v22)
7. [🗂️ Index thématique](#index-thematique)
8. [🔗 Dépendances documentaires](#dependances-documentaires)
9. [🛠️ Guide de maintenance](#guide-de-maintenance)

---

## 📖 Convention de rédaction <a id="convention-de-redaction"></a>

### Types de décisions

| Type | Format | Portée |
|---|---|---|
| **ADR** (Architecture Decision Record) | ADR-XXXX (numérotation continue) | Décision technique architecturale, immuable |
| **DP** (Décision Produit) | DP-VX.Y-NN (par version) | Choix UX / fonctionnel / produit |

### Règles

- Les **ADR sont immuables** : une fois écrits, jamais réécrits. Une décision qui en remplace une autre fait l'objet d'un **nouvel ADR** qui référence l'ancien.
- Les **ADR sont numérotés chronologiquement**, sans trou. Convention actuelle : numérotation continue globale (ex: ADR-0020 après ADR-0019).
- Chaque décision est **atomique** : un seul sujet par ADR/DP.
- Les **DP peuvent évoluer** entre versions (une DP-V2.1-XX peut être révisée par une DP-V2.2-YY).

### ⚠️ Note historique sur le nommage

Le projet utilise historiquement 3 conventions coexistantes :
- **ADR-XXXX** (V1 STABLE) : numérotation continue à 4 chiffres → **ADR-0001 à ADR-0019**
- **ADR-V2-XX** (V2) : convention temporaire lors de la conception V2 → **ADR-V2-01 à ADR-V2-07**
- **ADR-XXXX** (V2.2+) : retour à la numérotation continue → **ADR-0020, ADR-0021, etc.**

Convention adoptée à partir de V2.2 : **numérotation continue uniquement** (prochain ADR = ADR-0021).

---

## 🏛️ ADR fondateurs V1 (ADR-0001 à 0010) <a id="adr-fondateurs-v1"></a>

> Ces ADR ont été écrits lors de la conception V1 STABLE (03/08/2025). Ils constituent le socle métier immuable du projet.

---

### ADR-0001 — Le contenu est l'objet métier central

#### Contexte
Le système manipule plusieurs objets : campagne, contenu, analyse IA, script, publication / tableau de bord.

#### Décision
Le contenu est défini comme l'objet métier central.

#### Justification
Toutes les opérations du système sont réalisées autour d'un contenu : collecte, normalisation, sauvegarde, analyse IA, génération de script.

#### Conséquences
Tous les composants propagent le `contenu_id`.

---

### ADR-0002 — Une campagne regroupe les contenus

#### Contexte
Un utilisateur peut lancer plusieurs recherches successives.

#### Décision
Chaque exécution crée une nouvelle campagne.

#### Justification
Cela garantit la traçabilité, l'historique et la comparaison entre campagnes.

#### Conséquences
Tous les contenus possèdent un `campagne_id`.

---

### ADR-0003 — Les données brutes sont conservées

#### Contexte
Les plateformes peuvent modifier leur format de réponse.

#### Décision
La collecte conserve les données sans transformation métier. La normalisation est réalisée dans un composant dédié.

#### Justification
Séparer la collecte de la transformation facilite la maintenance et permet de changer de source de données sans impacter le reste du système.

#### Conséquences
Le composant de collecte reste indépendant du modèle de données interne.

---

### ADR-0004 — La normalisation précède toute persistance

#### Contexte
Les plateformes retournent des formats hétérogènes.

#### Décision
Toutes les données sont converties vers un modèle commun avant d'être enregistrées.

#### Justification
La base PostgreSQL ne dépend plus du format des plateformes.

#### Conséquences
Le remplacement d'une API ne nécessite pas de modifier le schéma de la base.

---

### ADR-0005 — Unicité des contenus

#### Contexte
Une même vidéo peut être retrouvée lors de plusieurs campagnes.

#### Décision
L'identifiant d'origine (`contenu_source_id`) devient la clé métier de référence.

#### Justification
Éviter les doublons et permettre les mises à jour.

#### Conséquences
Les insertions utilisent un mécanisme d'Upsert.

---

### ADR-0006 — L'IA enrichit les données sans les modifier

#### Contexte
Le contenu d'origine doit rester fidèle à la source.

#### Décision
L'IA produit des données complémentaires (`resume`, `theme`, `sentiment`, `score_qualite`, `mots_cles`, `langue`) sans altérer les données collectées.

#### Justification
Séparer les faits observés des interprétations générées par l'IA.

#### Conséquences
Les analyses sont stockées dans une table dédiée (`analyses`) reliée par `contenu_id`, et propagent un `analyse_id`.

---

### ADR-0007 — Les scripts sont des objets indépendants

#### Contexte
Un même contenu ou une même analyse peut donner lieu à plusieurs variantes de scripts réutilisables.

#### Décision
Les scripts sont stockés séparément des analyses IA.

#### Justification
Permettre la génération et l'évolution de scripts sans modifier l'analyse initiale.

#### Conséquences
Les scripts disposent de leur propre table (`scripts`) liée à l'analyse via `analyse_id`, propageant un `script_id`.

---

### ADR-0008 — Les composants sont indépendants

#### Contexte
Le système doit évoluer facilement.

#### Décision
Chaque composant possède une responsabilité unique.

#### Justification
Un composant peut être remplacé ou réécrit sans impacter les autres.

#### Conséquences
L'architecture reste modulaire et évolutive.

---

### ADR-0009 — La base PostgreSQL est la source de vérité

#### Contexte
Les résultats peuvent être affichés dans plusieurs interfaces (tableaux de bord, application web, exports).

#### Décision
Toutes les données officielles sont enregistrées dans PostgreSQL. Les interfaces ne sont que des vues ou des exports consolidés (composants prévus en V2).

#### Justification
Éviter les incohérences entre plusieurs supports de consultation.

#### Conséquences
Toute évolution de l'interface n'affecte pas la persistance des données.

---

### ADR-0010 — L'ajout de nouvelles plateformes ne modifie pas l'architecture

#### Contexte
Le système doit pouvoir intégrer de nouvelles sources (TikTok, YouTube, Instagram, LinkedIn, etc.).

#### Décision
La plateforme de collecte est considérée comme un détail d'implémentation.

#### Justification
L'architecture repose sur un modèle de données normalisé et non sur une plateforme spécifique.

#### Conséquences
L'ajout d'une nouvelle source nécessite uniquement un nouveau composant de collecte et d'adaptation, sans remettre en cause les autres composants du système.

---

## 🔧 ADR techniques V1 STABLE (ADR-0011 à 0019) <a id="adr-techniques-v1"></a>

> Ces ADR ont été écrits lors du développement V1 STABLE (03/08/2025). Ils formalisent les patterns techniques du pipeline V1.

---

### ADR-0011 — Le workflow d'erreur est un workflow indépendant

#### Contexte
La V1 doit garantir qu'aucune campagne ne reste indéfiniment en `EN_COURS` en cas d'incident.

#### Décision
Créer un **workflow d'erreur indépendant** (E01→E04), rattaché au workflow principal via le mécanisme *Error Workflow* de n8n.

#### Justification
- **Séparation des responsabilités** : la logique métier reste lisible.
- **Couverture universelle** : le workflow d'erreur intercepte les exceptions de tout nœud.
- **Réutilisabilité** : le même workflow d'erreur pourra couvrir plusieurs workflows futurs.

#### Alternatives rejetées
- **Try/catch dans chaque nœud** : verbeux, difficile à maintenir.
- **Composant final "Gestion d'erreurs"** : n'aurait pas capté les exceptions au milieu du flux.

#### Conséquences
- Deux workflows n8n distincts à maintenir.

---

### ADR-0012 — Corrélation entre workflows via `execution_id`

#### Contexte
Le workflow d'erreur doit pouvoir retrouver la campagne concernée par l'incident, sans partager de mémoire avec le workflow principal.

#### Décision
Stocker `execution_id` sur la table `campagnes` au moment de la création. Le workflow d'erreur retrouve la campagne par jointure SQL sur `execution_id`.

#### Justification
- **Découplage total** entre les deux workflows.
- **Pas de dépendance** au mécanisme mémoire de n8n.
- **Auditable** : la corrélation reste visible en base.

#### Alternatives rejetées
- **Passer `campagne_id` via variables globales** : couplage fort.
- **Chercher la dernière campagne en `EN_COURS`** : race condition en cas de campagnes parallèles.

#### Conséquences
- Ajout de la colonne `execution_id` (indexée) sur `campagnes`.

---

### ADR-0013 — Les compteurs et statuts sont portés par la campagne

#### Contexte
Il faut pouvoir connaître l'avancement d'une campagne à tout moment.

#### Décision
Ajouter sur la table `campagnes` : `nb_contenus_total`, `nb_contenus_traites`, `statut` ∈ {`EN_COURS`, `TERMINEE`, `ERREUR`}, `date_fin`.

#### Justification
- Observabilité en temps réel via un simple SELECT.
- Auto-détection de fin de campagne sans planificateur externe.

#### Conséquences
- Contrainte CHECK : `nb_contenus_traites ≤ nb_contenus_total`.

---

### ADR-0014 — Idempotence par UPSERT systématique

#### Contexte
Une campagne peut être relancée (bug, retry). Il faut garantir qu'aucun doublon n'est créé.

#### Décision
Utiliser des **UPSERT** systématiques sur les 3 clés métier : `contenus.contenu_source_id`, `analyses.contenu_id`, `scripts.analyse_id`.

#### Justification
- Idempotence garantie au niveau de la base de données.
- Simplicité : pas besoin de vérifier l'existence avant chaque insert.

#### Conséquences
- Contraintes UNIQUE obligatoires sur les 3 clés.

---

### ADR-0015 — Le total est calculé avant la boucle de traitement

#### Contexte
Le composant de fin doit détecter la fin de campagne en comparant `nb_contenus_traites` à `nb_contenus_total`.

#### Décision
Introduire les composants C05a → C05d : agrégation de tous les contenus, calcul du total, écriture sur la campagne, puis redistribution en items individuels.

#### Justification
- Détection de fin fiable et déterministe.
- Robustesse aux erreurs partielles.

#### Conséquences
- Total écrit sur la campagne avant la boucle de traitement.

---

### ADR-0016 — Rechargement SQL entre l'analyse et la génération de script

#### Contexte
La génération de script (C11) a besoin du contenu + de son analyse.

#### Décision
Introduire un `SELECT JOIN` qui recharge fraîchement les données depuis la base juste avant la génération de script.

#### Justification
- Découplage du flux mémoire.
- Garantit que le script est généré sur des données effectivement persistées.

#### Conséquences
- Un SELECT supplémentaire par contenu (impact négligeable).

---

### ADR-0017 — Modèles Claude différenciés selon la tâche

#### Contexte
L'analyse nécessite de la rigueur, tandis que le script demande de la créativité.

#### Décision
- **Analyse (C07)** : `claude-opus-5` (raisonnement puissant).
- **Script (C11)** : `claude-sonnet-5` (rapide, créatif, économique).

#### Justification
- Adéquation modèle/tâche et optimisation des coûts.

#### Conséquences
- Gestion de modèles différenciés selon l'étape du pipeline.

---

### ADR-0018 — Un statut terminal n'est jamais écrasé

#### Contexte
Gérer les accès concurrents entre le workflow d'erreur et le workflow principal.

#### Décision
Un statut `ERREUR` ne peut plus basculer vers `TERMINEE`. Le statut `ERREUR` est absorbant.

#### Justification
Garantit la cohérence métier (une campagne en erreur ne passe pas en succès par accident).

---

### ADR-0019 — Journalisation dans une table dédiée `journal_execution`

#### Contexte
Conserver les incidents pour audit, indépendamment de la rétention mémoire de n8n.

#### Décision
Créer une table `journal_execution` alimentée lors de chaque incident.

#### Justification
Audit long terme consultable directement en SQL.

---

## 🚀 ADR techniques V2 (ADR-V2-01 à V2-07) <a id="adr-techniques-v2"></a>

> Ces ADR ont été écrits lors de la conception V2 (04-07/08/2026).

**Liste des ADR V2** :
- **ADR-V2-01** — Hiérarchie de vérité documentaire (Supabase > V2-010 > V2-008)
- **ADR-V2-02** — Orchestration monolithique
- **ADR-V2-03 (rev)** — Frontière V1/V2 via C-V2-03 simplifié à 2 JOINs
- **ADR-V2-04** — Validation stricte en amont outil_id ↔ catégorie
- **ADR-V2-05** — Cardinalité 1-item garantie par bloc
- **ADR-V2-06** — Barrières Aggregate + `.first()`
- **ADR-V2-07** — Fusion des conventions d'outils dans le SELECT amont

> ⚠️ **Note** : le contenu détaillé de ces ADR n'est actuellement pas dans ce fichier. Voir historique Git ou reconstituer à partir du contexte projet si besoin.

---

## 🆕 ADR techniques V2.2+ (ADR-0020+) <a id="adr-techniques-v22"></a>

> À partir de la V2.2, retour à la convention de numérotation continue.

---

### ADR-0020 — Gestion robuste du mode "extended thinking" de Claude Sonnet 5 <a id="adr-0020"></a>

**Créé** : V2.2-S1 (11/08/2026)

#### Contexte

Suite à la mise à jour vers Claude Sonnet 5, le modèle active **automatiquement** un mode "extended thinking" quand le prompt utilisateur devient complexe. Ce mode se manifeste dans la réponse API par une structure `content[]` contenant plusieurs blocs :

- `{ "type": "thinking", "thinking": "...", "signature": "..." }`
- `{ "type": "text", "text": "{ ... vrai JSON ... }" }`

Deux problèmes observés en V2.2-S1 sur le nœud C-V2-21c :
1. **Consommation invisible de tokens** : le bloc `thinking` tronque le bloc `text` si `maxTokens` est trop bas.
2. **Absence défensive du bloc `text`** : le code original plantait avec un message générique sans diagnostic.

#### Décision

Adopter **3 mesures cumulatives** de robustesse dans tous les nœuds de normalisation Claude :
1. **Concaténer TOUS les blocs `text`** au lieu de prendre le premier.
2. **Extraction robuste du JSON** via recherche du premier `{` et du dernier `}`.
3. **Diagnostic détaillé** en cas d'échec (types de blocs + dump 500 caractères).

**Complément** : augmenter `maxTokens` sur les nœuds Claude concernés (C-V2-21b : 1500 → 2000, C-V2-06 : 2000 → 3000).

#### Justification
- Robustesse aux évolutions de structure API.
- Diagnostic immédiatement actionnable dans les logs.

#### Conséquences
- Nœuds Code de normalisation plus robustes.
- Coût IA légèrement supérieur dû à l'augmentation de `maxTokens`.

---

## 🧠 Décisions produit <a id="decisions-produit"></a>

### DP-V2.1 <a id="dp-v21"></a>

> Portée : Décisions produit prises pendant la V2.1 (dashboard Next.js + intégration V1/V2 + déploiement Vercel).  
> Statut V2.1 : ✅ **STABLE** — Tag `v2.1.0-stable` (10/08/2026)

---

#### DP-V2.1-01 — Vue C minimaliste orientée action

**Créé** : V2.1-S3

##### Contexte
La Vue "Détail dossier" contenait à l'origine tous les champs techniques du pipeline, inutiles pour l'utilisateur final.

##### Décision
La Vue C n'affiche **que les champs actionnables** : narration, prompt image, prompt animation, descriptions. Les champs pipeline restent masqués.

---

#### DP-V2.1-02 — Vue F : 3 dropdowns multi-outils

**Créé** : V2.1-S5

##### Contexte
Choix des outils lors de la création d'un dossier V2.

##### Décision
Proposer 3 dropdowns indépendants : Script, Outil image, Outil animation.

---

#### DP-V2.1-03 — Élargissement du périmètre V2.1 : intégrer aussi V1

**Créé** : V2.1 fin S5

##### Contexte
L'utilisateur ne pouvait pas déclencher de campagne V1 depuis le dashboard.

##### Décision
Ajouter 2 nouvelles vues : **Vue E** (Créer une campagne) et **Vue G** (Liste des campagnes).

---

#### DP-V2.1-04 — Plateforme YouTube uniquement en Vue E

**Créé** : V2.1-S6

##### Contexte
Seule la collecte YouTube est active en V1.

##### Décision
Le select "plateforme" n'affiche que YouTube avec un message prévenant de la prise en charge future de TikTok/Instagram.

---

### DP-V2.2 <a id="dp-v22"></a>

> Portée : Décisions produit prises pendant la V2.2 (amélioration UX + fiabilité multi-user + qualité des livrables IA).  
> Statut V2.2 : 🟡 **EN COURS** — S1 terminée le 11/08/2026

---

#### DP-V2.2-01 — Badges tarifs outils dans dropdown Vue F

**Créé** : V2.2-S1

##### Contexte
Manque de visibilité sur le modèle économique des outils lors de la sélection.

##### Décision
Afficher un badge coloré à côté de chaque outil dans Vue F : 🟢 Gratuit · 🟡 Freemium · 🔴 Payant.

---

#### DP-V2.2-02 — Neutralisation systématique des CTA du créateur source

**Créé** : V2.2-S1

##### Contexte
Les scripts sources contenaient des CTA spécifiques aux créateurs d'origine ("Lien en bio", "Rejoins mon Skool") recopiés par les LLM.

##### Décision
Ajouter une règle absolue dans les prompts C-V2-06 et C-V2-21a interdisant les CTA spécifiques au profit de CTA 100% génériques ("Abonne-toi", "Commente pour le tuto").

---

#### DP-V2.2-03 — Descriptions plateformes strictement courtes + 5 hashtags max

**Créé** : V2.2-S1

##### Contexte
Les descriptions générées étaient trop longues pour les standards 2026.

##### Décision
Ajuster le nœud C-V2-21a avec des contraintes de longueur strictes : TikTok (≤ 300 car), YouTube Shorts (≤ 150 car), Instagram Reels (≤ 125 car) avec exactement 5 hashtags ciblés par plateforme pour économiser la bande passante et maximiser l'engagement.

---

#### DP-V2.2-04 — Redirection auth-based sur la route racine `/`

**Créé** : V2.2-S1

##### Contexte
La route racine `/` affichait encore le template par défaut de `create-next-app`.

##### Décision
Remplacer par un Server Component silencieux qui redirige vers `/dashboard` si connecté, ou `/login` si anonyme.

---

## 🗂️ Index thématique <a id="index-thematique"></a>

| Thème | Décisions concernées |
|---|---|
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
| **UX Frontend** | DP-V2.1-01, DP-V2.1-02, DP-V2.2-01 |
| **Périmètre produit** | DP-V2.1-03, DP-V2.1-04, DP-V2.2-04 |

---

## 🔗 Dépendances documentaires <a id="dependances-documentaires"></a>

### S'appuie sur
- `03.V2_Architecture_des_Workflows.md`
- `04.V2_Specification_des_Composants.md`
- `04.1.V2_Catalogue_Outils.md`
- `05.V2_Implementation_Technique.md`

### Sert de référence pour
- N'importe quel ADR futur (V2.3+)
- Le Project Tracker (`08_Project_Tracker.md`)

---

## 🛠️ Guide de maintenance <a id="guide-de-maintenance"></a>

### 📝 Règles d'or

1. **Un ADR est immuable** — jamais réécrit. Si obsolète, créer un nouvel ADR qui référence l'ancien.
2. **Un ADR = une seule décision atomique** — pas de décisions groupées.
3. **Convention actuelle : numérotation continue** — le prochain ADR sera `ADR-0021`.
4. **DP peut évoluer** — une DP-V2.1-XX peut être révisée par une DP-V2.2-YY.
5. **Toujours ajouter dans l'index thématique** après création.

### 🆕 Ajouter un nouvel ADR technique

Format minimum requis :

#### ADR-XXXX — Titre court explicite

**Créé** : VX.Y-SN (JJ/MM/AAAA)

##### Contexte
Pourquoi la question s'est posée. Symptômes observés. Impact.

##### Décision
Ce qui a été choisi. Peut inclure du code court illustratif.

##### Justification
Pourquoi ce choix précis vs les alternatives.

##### Alternatives rejetées
- Alt 1 : ... — rejetée car ...
- Alt 2 : ... — rejetée car ...

##### Conséquences
- Impact positif : ...
- Dette créée : ...
- Points d'attention futurs : ...

Puis :
- Ajouter la ligne dans la [Table des matières](#table-des-matieres)
- Ajouter dans l'[Index thématique](#index-thematique) sous le bon thème

### 🆕 Ajouter une nouvelle Décision Produit (DP)

Format minimum requis :

#### DP-VX.Y-NN — Titre court

**Créé** : VX.Y-SN

##### Contexte
Bref rappel du problème / opportunité produit.

##### Décision
Ce qui a été choisi (UX, format, comportement).

##### Conséquences
Impact utilisateur + technique.

Puis :
- Ajouter dans l'[Index thématique](#index-thematique) sous le bon thème
- Si applicable : ajouter la DT associée dans le Project Tracker

### 📝 Format de commit standardisé

Pour ce fichier :  
`docs(adr): [action] [contenu]`

Exemples :
- `docs(adr): add ADR-0021 (Supabase Realtime subscription strategy)`
- `docs(adr): add DP-V2.2-05 (staging environment naming)`
- `docs(adr): reorganize sections + add TOC`

### 🔄 Fréquence de refonte structurelle

- Après chaque fin de version majeure (tag Git posé)
- Ou si le fichier dépasse ~1000 lignes
- Ou si la table des matières ne suffit plus à trouver un ADR en < 30s
- Ou lors d'une découverte de dette documentaire

### 🚨 Vigilance recommandée

À partir de maintenant :
- **Chaque décision technique importante** = un ADR immédiat, pas "plus tard"
- **Chaque choix UX significatif** = une DP immédiate, pas "je vais y penser"
- **Chaque séance qui se termine** = vérification que les ADR/DP créés sont bien tracés dans ce fichier
- **Aucun ADR ne doit être perdu** — c'est le patrimoine documentaire du projet.