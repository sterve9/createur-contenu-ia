# V2-DEV — Audit des Colonnes des Tables Checklist vs V2-010

> **Date** : 07/08/2026  
> **Auteur** : Sterve (validation) + Claude (rédaction)  
> **Contexte** : Session de développement V2-ORCH  
> **Portée** : Tables `v2_checklists` et `v2_etapes_checklist`

---

## 🎯 Objectif

Documenter les écarts de nommage détectés entre le document `05.V2_Implementation_Technique.md` (V2-010) et la structure réelle des tables `v2_checklists` et `v2_etapes_checklist` dans Supabase.

Ce document est le pendant de `V2-DEV_Audit_V2-010_vs_Realite_Supabase_2026-08-06.md`, focalisé sur les tables checklist qui n'avaient pas été auditées à ce niveau de granularité.

---

## 📊 Méthodologie

Requête `information_schema` exécutée le 07/08/2026 :

```sql
SELECT
  table_name,
  column_name,
  data_type,
  is_nullable
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name IN ('v2_checklists', 'v2_etapes_checklist')
ORDER BY table_name, ordinal_position;
🔴 Écarts détectés
Table v2_checklists
Colonne supposée par V2-010	Colonne réelle Supabase	Statut
id	id (bigint)	✅ Conforme
dossier_id	dossier_id (bigint)	✅ Conforme
statut (varchar)	❌ N'EXISTE PAS	🔴 Écart bloquant
created_at	created_at (timestamptz)	✅ Conforme
—	updated_at (timestamptz)	ℹ️ Colonne supplémentaire non documentée
Impact : la requête initiale de C-V2-05b (1/2) tentait d'insérer une colonne statut inexistante → erreur SQL.

Correction appliquée :

SQL

-- AVANT (bugué)
INSERT INTO v2_checklists (dossier_id, statut)
VALUES (?, 'EN_COURS')
RETURNING id, dossier_id;

-- APRÈS (corrigé)
INSERT INTO v2_checklists (dossier_id)
VALUES (?)
RETURNING id, dossier_id;
Table v2_etapes_checklist
Colonne supposée par V2-010	Colonne réelle Supabase	Statut
id	id (bigint)	✅ Conforme
checklist_id	checklist_id (bigint)	✅ Conforme
nom_etape (text)	❌ libelle (text)	🔴 Écart bloquant
ordre (integer)	❌ ordre_affichage (integer)	🔴 Écart bloquant
statut (varchar 'A_FAIRE')	❌ est_realisee (boolean)	🔴 Écart bloquant + changement de sémantique
—	date_realisation (timestamptz nullable)	ℹ️ Colonne supplémentaire non documentée
Impact : la requête initiale de C-V2-05b (2/2) référençait 3 noms de colonnes inexistants → erreur SQL.

Correction appliquée :

SQL

-- AVANT (bugué)
INSERT INTO v2_etapes_checklist (checklist_id, nom_etape, ordre, statut)
VALUES
  (?, 'Scènes générées', 1, 'A_FAIRE'),
  ...

-- APRÈS (corrigé)
INSERT INTO v2_etapes_checklist (checklist_id, libelle, ordre_affichage, est_realisee)
VALUES
  (?, 'Scènes générées', 1, false),
  ...
🧠 Analyse — Pourquoi ces écarts n'ont pas été détectés dans l'audit du 06/08
L'audit V2-DEV_Audit_V2-010_vs_Realite_Supabase_2026-08-06.md portait sur 21 nœuds sur 22 et a validé la conformité globale des colonnes principales de :

v2_dossiers_production
v2_outils
v2_journal_execution
Mais il n'a pas vérifié au niveau colonne les tables :

v2_checklists
v2_etapes_checklist
Ces tables étaient référencées dans V2-010 (section 3, nœud C-V2-05b) avec des noms de colonnes supposés, non confrontés à information_schema.

Leçon retenue : tout nœud SQL doit passer un contrôle information_schema par table impactée, pas seulement par nœud principal.

📋 Impact sur les autres blocs V2
Les tables v2_checklists et v2_etapes_checklist sont référencées par plusieurs blocs futurs :

Bloc	Nœud(s) potentiellement impacté(s)	Action requise
V2-SCENE	(à vérifier lors du développement)	Contrôle information_schema préalable
V2-PLAN	Mise à jour des étapes (probablement est_realisee)	Contrôle information_schema préalable
V2-IMG	Idem	Contrôle information_schema préalable
V2-ANIM	Idem	Contrôle information_schema préalable
V2-PUB	Idem + étape finale	Contrôle information_schema préalable
V2-ERR	Mise à jour du statut de la checklist en cas d'erreur	À vérifier
Recommandation : refaire un audit information_schema complet des tables V2 avant chaque bloc, comme prérequis systématique.

📊 Écarts documentaires — Mise à jour V2-010
Le document 05.V2_Implementation_Technique.md doit être corrigé :

Section C-V2-05b (1/2)
À remplacer :

SQL

INSERT INTO v2_checklists (dossier_id, statut)
VALUES (:dossier_id, 'EN_COURS')
Par :

SQL

INSERT INTO v2_checklists (dossier_id)
VALUES (:dossier_id)
Section C-V2-05b (2/2)
À remplacer :

SQL

INSERT INTO v2_etapes_checklist (checklist_id, nom_etape, ordre, statut)
Par :

SQL

INSERT INTO v2_etapes_checklist (checklist_id, libelle, ordre_affichage, est_realisee)
Et les valeurs 'A_FAIRE' doivent être remplacées par false.

✅ Statut de correction
Élément	Statut
Workflow n8n V2-ORCH	✅ Corrigé et testé (07/08/2026)
Doc V2-010 (section C-V2-05b)	⏳ À corriger (prochaine session)
Journal ADR	✅ ADR-V2-05 acté
Audit publié	✅ Ce document
