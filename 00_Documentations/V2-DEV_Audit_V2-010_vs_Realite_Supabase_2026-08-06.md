# Audit V2-010 vs Réalité Supabase — 2026-08-06

**Projet** : Créateur de Contenu IA
**Version** : V2
**Type de document** : Rapport d'audit technique
**Auteur** : Session collaborative Sterve / Muse
**Contexte** : Reprise de la phase V2-DEV, session du 06/08/2026
**Statut** : ✅ VALIDÉ — corrections appliquées à V2-010

---

## 1. Objectif de l'audit

Vérifier la conformité du document `05.V2_Implementation_Technique.md`
(V2-010) avec le schéma réel de la base Supabase, avant toute
implémentation des workflows V2 dans n8n.

Cet audit fait suite à la découverte, au début de la construction du
workflow V2-ORCH, d'une erreur de référence dans la requête C-V2-03
(colonne `s.campagne_id` inexistante dans la table `scripts`).

---

## 2. Méthode

Trois requêtes système ont été exécutées dans Supabase pour
photographier la vérité opérationnelle :

- **R1** : Liste des clés étrangères sur toutes les tables V1 et V2
- **R2** : Structure complète (colonnes + types) de toutes les tables V2
- **R3** : Structure complète des 5 tables V1 partagées
- **R4** : Liste de toutes les contraintes UNIQUE et PRIMARY KEY sur les tables V2

Chaque nœud SQL de V2-010 a ensuite été confronté à ces 4 photos
de la réalité, à la recherche de :
- colonnes inexistantes
- jointures cassées
- types incompatibles
- clauses `ON CONFLICT` sans contrainte UNIQUE correspondante

---

## 3. Résultat de l'audit — Vue synthétique

**Périmètre audité** : 22 nœuds fonctionnels V2 (C-V2-01 → C-V2-22),
répartis en 6 blocs fonctionnels + le workflow V2-ERR.

| Statut | Nombre de nœuds | Détail |
|---|---|---|
| ✅ Conformes | 21 | Aucune modification nécessaire |
| 🔴 Bloquants | 1 | C-V2-03 (requête cassée) |

**Bilan** : V2-010 est globalement fiable. Un seul correctif est
nécessaire avant démarrage de l'implémentation n8n.

---

## 4. Détail — Écart bloquant identifié

### 🔴 C-V2-03 · Lire Contexte V1

**Requête V2-010 originale** :

```sql
SELECT
  s.id            AS script_id,
  s.script        AS script_texte,
  s.campagne_id   AS campagne_id,
  a.id            AS analyse_id,
  ...
FROM public.scripts s
JOIN public.analyses  a    ON a.contenu_id = s.contenu_id
JOIN public.contenus  c    ON c.id         = s.contenu_id
JOIN public.campagnes camp ON camp.id      = s.campagne_id
WHERE s.id = {{ $json.body.script_id }}
  AND camp.statut = 'TERMINEE'
LIMIT 1;
Problèmes identifiés :

Colonne s.campagne_id inexistante — la table scripts ne
contient pas cette colonne. Sa structure réelle est :

id (integer, PK)
analyse_id (integer, FK → analyses.id)
contenu_id (bigint, sans FK déclarée)
script (text)
created_at (timestamptz)
Chemin FK réel pour remonter à la campagne :

text

scripts.analyse_id  → analyses.id
analyses.contenu_id → contenus.id
contenus.campagne_id → campagnes.id
Trois JOINs sont nécessaires, pas un seul.

Anomalie de type sur scripts.contenu_id : cette colonne est
déclarée en bigint alors que contenus.id est en integer.
La FK n'est pas déclarée officiellement. Il est plus sûr de passer
par scripts.analyse_id, qui a une FK propre (fk_scripts_analyse).

Requête corrigée (validée par l'audit) :

SQL

SELECT
  s.id            AS script_id,
  s.script        AS script_texte,
  a.id            AS analyse_id,
  a.theme         AS theme,
  a.mots_cles     AS mots_cles,
  a.sentiment     AS sentiment,
  a.score_qualite AS score_qualite,
  a.resume        AS resume,
  c.id            AS contenu_id,
  c.titre         AS titre_contenu,
  c.auteur        AS auteur_contenu,
  c.plateforme    AS plateforme_contenu,
  c.campagne_id   AS campagne_id,
  camp.statut     AS statut_campagne_v1
FROM public.scripts s
JOIN public.analyses  a    ON a.id    = s.analyse_id
JOIN public.contenus  c    ON c.id    = a.contenu_id
JOIN public.campagnes camp ON camp.id = c.campagne_id
WHERE s.id = {{ $json.body.script_id }}
  AND camp.statut = 'TERMINEE'
LIMIT 1;
Différences essentielles :

Nouveau chemin de jointure : scripts → analyses → contenus → campagnes
Ajout de c.campagne_id AS campagne_id dans le SELECT
(nécessaire pour C-V2-05 qui insère campagne_id dans v2_dossiers_production)
Suppression de toute référence à s.campagne_id
Suppression de s.contenu_id comme clé de jointure
5. Détail — Contrôles positifs
5.1 Contraintes UNIQUE — toutes conformes
Les 5 clauses ON CONFLICT de V2-010 ont toutes une contrainte UNIQUE
correspondante en base :

Clause ON CONFLICT	Contrainte réelle
v2_scenes (dossier_id, numero_scene)	uniq_scene_dossier_numero ✅
v2_plans (scene_id, numero_plan)	uniq_plan_scene_numero ✅
v2_prompts_images (plan_id)	v2_prompts_images_plan_id_key ✅
v2_prompts_animations (plan_id)	v2_prompts_animations_plan_id_key ✅
v2_descriptions_publication (dossier_id, plateforme_cible)	uniq_description_dossier_plateforme ✅
Conclusion : le mécanisme d'idempotence prévu par V2-010 fonctionnera
tel quel, sans DDL correctif additionnel.

5.2 Contraintes UNIQUE bonus (non exploitées par V2-010 mais utiles)
v2_checklists.dossier_id UNIQUE — garantit 1 seule checklist par dossier
v2_etapes_checklist (checklist_id, ordre_affichage) UNIQUE — évite les collisions d'ordre
v2_outils.nom UNIQUE — évite les doublons de nom d'outil
5.3 Colonnes de suivi V2 — toutes présentes
Le DDL correctif V2-010 a bien été appliqué :

v2_dossiers_production.execution_id (varchar, nullable) ✅
v2_dossiers_production.nb_plans_total (integer NOT NULL default 0) ✅
v2_dossiers_production.nb_plans_traites (integer NOT NULL default 0) ✅
v2_plans.statut (varchar NOT NULL) ✅
Table v2_journal_execution créée avec 6 colonnes conformes ✅
6. Anomalies non bloquantes signalées pour information
6.1 Type mismatch scripts.contenu_id
scripts.contenu_id est déclaré en bigint
contenus.id est déclaré en integer
Aucune FK n'est déclarée entre ces deux colonnes
Impact : aucun tant que V2 n'utilise pas cette colonne (le correctif
C-V2-03 passe par analyses.contenu_id qui est propre).

Recommandation V3 : réaligner le type de scripts.contenu_id sur
integer et déclarer la FK manquante. Hors périmètre V2, à traiter
lors d'une future migration V1.

6.2 Construction de C-V2-04
La requête C-V2-04 utilise un pattern FROM v2_outils oi JOIN v2_outils oa ON oa.id = X
qui fonctionne mais est peu élégant. Un WHERE id IN (X, Y) avec
regroupement serait plus lisible.

Impact : aucun sur le résultat.
Recommandation : simplification cosmétique lors d'une future refactorisation.

7. Actions prises à l'issue de l'audit
Action	Statut
Rédaction du présent rapport	✅
Correction de la requête C-V2-03 dans 05.V2_Implementation_Technique.md	✅
Création de l'ADR-V2-03 documentant la correction	✅
Mise à jour du Project Tracker	✅
Note dans le prompt de reprise pour la prochaine session	⬜ À appliquer (fin de séance)
8. Recommandation méthodologique pour la suite
Règle qui découle de cet audit (à intégrer aux règles de gouvernance) :

Toute requête SQL introduite dans un document d'implémentation V2
DOIT être vérifiée contre le schéma réel Supabase avant validation
du document. Aucun nom de table, colonne ou clé étrangère ne peut
être introduit "de mémoire".

Cette règle sera formalisée dans l'ADR-V2-03.

Rapport produit dans le cadre du cycle de développement V2.
Ce rapport est un artefact d'audit ponctuel et n'est pas destiné à
être modifié après sa validation.