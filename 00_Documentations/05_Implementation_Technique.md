# 05 — Implémentation Technique

## Rôle du document

Ce document traduit les spécifications fonctionnelles (`04`) et les contrats de données (`02.5`) en configurations techniques concrètes dans l'outil d'orchestration **n8n**.

Il répond à la question :

> **Comment paramétrer exactement chaque nœud, chaque requête HTTP, chaque requête SQL et chaque script afin de respecter le contrat de chaque composant ?**

Chaque section décrit un nœud tel qu'il existe réellement dans l'implémentation V1 STABLE.

---

## 1. Configuration globale

### 1.1 Instance
- Plateforme d'orchestration : **n8n**
- Base de données : **PostgreSQL** (schéma `public`)
- Credential PostgreSQL utilisé partout : **`ia-contenu-prod`**

### 1.2 Credentials
| Credential | Type | Utilisé par |
|------------|------|-------------|
| `ia-contenu-prod` | Postgres | C03, C05c, C06, C09, C10, C13, C15, E03, E04 |
| `youtube-api-key` | HTTP Header Auth | C04 |
| `Anthropic account 2` | Anthropic API | C07, C11 |

### 1.3 Rattachement du workflow d'erreur
Le workflow principal doit être configuré via *Workflow Settings → Error Workflow* pour pointer vers le workflow **"Gestion des erreurs"** (contenant E01→E04). Ce rattachement est ce qui active automatiquement E01 en cas d'exception.

### 1.4 Tables PostgreSQL utilisées
- `campagnes`
- `contenus`
- `analyses`
- `scripts`
- `journal_execution`

Le schéma détaillé est décrit dans `02.3 — Schéma Physique des Données`.

---

# Partie 1 — Workflow principal

## C01 — Recevoir Demande Campagne

**Type** : `n8n-nodes-base.webhook`
**Nom du nœud** : `Recevoir Demande Campagne`

**Paramètres** :
- Méthode : `POST`
- Path : `lancer-campagne`
- Response Mode : par défaut

**Payload attendu** :
```json
{
  "sujet": "Automatisation IA",
  "plateforme": "YouTube",
  "langue": "fr",
  "nb_resultats": 20
}
```

---

## C02 — Valider Paramètres

**Type** : `n8n-nodes-base.if`
**Nom du nœud** : `Valider Paramètres`

**Conditions** (combinator : `AND`) :

| Champ vérifié | Opérateur |
|---------------|-----------|
| `{{ $json.body.sujet }}` | non vide |
| `{{ $json.body.plateforme }}` | non vide |
| `{{ $json.body.langue }}` | non vide |
| `{{ $json.body.nb_resultats }}` | > 0 |

Si toutes les conditions sont vraies → C03. Sinon, le workflow s'arrête.

---

## C03 — Créer Campagne

**Type** : `n8n-nodes-base.postgres`
**Nom du nœud** : `Créer Campagne`
**Credential** : `ia-contenu-prod`

**Opération** : Insert
**Table** : `campagnes`

**Mapping** :
| Colonne | Valeur |
|---------|--------|
| `sujet` | `{{ $json.body.sujet }}` |
| `plateforme` | `{{ $json.body.plateforme }}` |
| `langue` | `{{ $json.body.langue }}` |
| `nb_resultats` | `{{ $json.body.nb_resultats }}` |
| `statut` | `"EN_COURS"` |
| `execution_id` | `{{ $execution.id }}` |

**Retour attendu** : `id` (utilisé comme `campagne_id` dans la suite du workflow).

---

## C04 — Collecte des contenus

**Type** : `n8n-nodes-base.httpRequest`
**Nom du nœud** : `Collecte des contenus`
**Credential** : `youtube-api-key` (HTTP Header Auth)

**URL** : `https://www.googleapis.com/youtube/v3/search`
**Méthode** : `GET`

**Query parameters** :
| Nom | Valeur |
|-----|--------|
| `part` | `snippet` |
| `type` | `video` |
| `q` | `{{ $json.sujet }}` |
| `maxResults` | `{{ $json.nb_resultats }}` |

**Retour** : payload YouTube API v3 contenant un tableau `items`.

---

## C05 — Normalisation

**Type** : `n8n-nodes-base.code`
**Nom du nœud** : `Normalisation`

```javascript
// Récupère l'ID de la campagne depuis le nœud amont
const campagneId = $('Créer Campagne').first().json.id;

// Récupère la liste des vidéos depuis l'API YouTube
const inputData = $input.first().json;
const videos = inputData.items || [];

// Transformation propre, lisible et explicite avec .map()
return videos
  .filter(video => video.id && video.snippet)
  .map(video => {
    // On isole l'extraction de l'identifiant pour raconter l'intention métier
    const contenuSourceId =
      video.id.videoId ??
      video.id.channelId ??
      video.id.playlistId ??
      null;

    return {
      json: {
        campagne_id: campagneId,
        contenu_source_id: contenuSourceId,
        titre: video.snippet.title,
        auteur: video.snippet.channelTitle,
        description: video.snippet.description,
        date_publication: video.snippet.publishedAt,
        plateforme: "YouTube"
      }
    };
  });
```

---

## C05a — Aggregate Contenus

**Type** : `n8n-nodes-base.aggregate`
**Nom du nœud** : `Aggregate Contenus`

**Paramètre** : `aggregate` = `aggregateAllItemData`

**Effet** : produit un unique item contenant `{ data: [...contenus] }`.

---

## C05b — Préparer Total Campagne

**Type** : `n8n-nodes-base.code`
**Nom du nœud** : `Préparer Total Campagne`

```javascript
const aggregated = $input.first().json;

// Le tableau complet des contenus est maintenant dans "data"
const contenus = aggregated.data;

// On récupère l'id campagne depuis le premier contenu
const campagneId = contenus[0].campagne_id;

return [{
  json: {
    campagne_id: campagneId,
    nb_total: contenus.length,
    contenus: contenus
  }
}];
```

---

## C05c — Update Total Campagne

**Type** : `n8n-nodes-base.postgres`
**Nom du nœud** : `Update Total Campagne`
**Credential** : `ia-contenu-prod`

**Opération** : Execute Query

```sql
UPDATE campagnes
SET nb_contenus_total = {{ $json.nb_total }}
WHERE id = {{ Number($json.campagne_id) }};
```

**Importance** : cette étape doit obligatoirement précéder la boucle sur les contenus.

---

## C05d — Redistribuer Contenus

**Type** : `n8n-nodes-base.code`
**Nom du nœud** : `Redistribuer Contenus`

```javascript
const data = $('Préparer Total Campagne').first().json;
const contenus = data.contenus || [];

return contenus.map(contenu => ({
  json: contenu
}));
```

---

## C06 — Persistance des contenus

**Type** : `n8n-nodes-base.postgres`
**Nom du nœud** : `Persistance des contenus`
**Credential** : `ia-contenu-prod`

**Opération** : `upsert`
**Table** : `contenus`
**Clé de matching** : `contenu_source_id`

**Mapping** :
| Colonne | Valeur |
|---------|--------|
| `campagne_id` | `{{ $json.campagne_id }}` |
| `contenu_source_id` | `{{ $json.contenu_source_id }}` |
| `titre` | `{{ $json.titre }}` |
| `auteur` | `{{ $json.auteur }}` |
| `description` | `{{ $json.description }}` |
| `date_publication` | `{{ $json.date_publication }}` |
| `plateforme` | `{{ $json.plateforme }}` |

**Retour attendu** : `id` (utilisé comme `contenu_id`).

---

## C07 — Analyse IA

**Type** : `@n8n/n8n-nodes-langchain.anthropic`
**Nom du nœud** : `Analyse IA`
**Credential** : `Anthropic account 2`

**Modèle** : `claude-opus-5`
**Max Tokens** : `1000`

**Prompt** :
```
Analyse ce contenu de manière experte et renvoie UNIQUEMENT un objet JSON valide
(sans markdown autour si possible, ou un bloc JSON pur) respectant exactement cette structure :

{
  "contenu_id": {{ $json.id }},
  "resume": "Un court résumé de l'idée principale",
  "theme": "Le thème principal",
  "sentiment": "Positif, Neutre ou Négatif",
  "score_qualite": 85,
  "mots_cles": ["mot1", "mot2"],
  "langue": "fr"
}

Voici les données à analyser :
- Titre : {{ $json.titre }}
- Description : {{ $json.description }}
- Plateforme : {{ $json.plateforme }}
```

---

## C08 — Normalisation Analyse IA

**Type** : `n8n-nodes-base.code`
**Nom du nœud** : `Normalisation Analyse IA`

```javascript
// Récupération des items entrants de l'IA
const cleanedItems = [];

for (const item of $input.all()) {
  // On vérifie si la structure "content" existe
  if (item.json && item.json.content && Array.isArray(item.json.content)) {
    // On cherche l'élément de type "text" (et on ignore les "thinking")
    const textBlock = item.json.content.find(c => c.type === 'text');

    if (textBlock && textBlock.text) {
      let rawText = textBlock.text.trim();

      // Nettoyage des balises markdown ```json ... ``` si présentes
      if (rawText.startsWith('```')) {
        rawText = rawText.replace(/^```[a-z]*\n?/i, '');
        rawText = rawText.replace(/```\s*$/, '');
        rawText = rawText.trim();
      }

      try {
        // Parse la chaîne de caractères en objet JSON propre
        const parsedJson = JSON.parse(rawText);
        cleanedItems.push({ json: parsedJson });
      } catch (e) {
        // En cas d'échec du parse, on conserve une trace pour le debug
        cleanedItems.push({
          json: {
            error: "Failed to parse JSON",
            raw: rawText
          }
        });
      }
    }
  }
}

return cleanedItems;
```

---

## C09 — Persistance Analyse

**Type** : `n8n-nodes-base.postgres`
**Nom du nœud** : `Persistance Analyse`
**Credential** : `ia-contenu-prod`

**Opération** : `upsert`
**Table** : `analyses`
**Clé de matching** : `contenu_id`

**Mapping** :
| Colonne | Valeur |
|---------|--------|
| `contenu_id` | `{{ $json.contenu_id }}` |
| `resume` | `{{ $json.resume }}` |
| `theme` | `{{ $json.theme }}` |
| `sentiment` | `{{ $json.sentiment }}` |
| `score_qualite` | `{{ $json.score_qualite }}` |
| `mots_cles` | `{{ $json.mots_cles }}` |
| `langue` | `{{ $json.langue }}` |

**Retour attendu** : `id` (utilisé comme `analyse_id`).

---

## C10 — Lecture Analyse et Contenu

**Type** : `n8n-nodes-base.postgres`
**Nom du nœud** : `Lecture Analyse et Contenu`
**Credential** : `ia-contenu-prod`

**Opération** : Execute Query

```sql
SELECT
    a.id AS analyse_id,
    c.id AS contenu_id,
    c.campagne_id,
    c.titre,
    c.auteur,
    c.description,
    c.date_publication,
    c.plateforme,
    a.resume,
    a.theme,
    a.sentiment,
    a.score_qualite,
    a.mots_cles,
    a.langue
FROM analyses a
JOIN contenus c ON c.id = a.contenu_id
WHERE a.id = {{ $('Persistance Analyse').item.json.id }}
LIMIT 1;
```

---

## C11 — Génération Script IA

**Type** : `@n8n/n8n-nodes-langchain.anthropic`
**Nom du nœud** : `Génération Script IA`
**Credential** : `Anthropic account 2`

**Modèle** : `claude-sonnet-5`

**Prompt** :
```
Tu es un expert en création de scripts vidéo viraux pour TikTok, YouTube Shorts et Reels.

Voici le contenu analysé :

- Titre : {{ $json.titre }}
- Auteur : {{ $json.auteur }}
- Plateforme : {{ $json.plateforme }}
- Résumé : {{ $json.resume }}
- Thème : {{ $json.theme }}
- Sentiment : {{ $json.sentiment }}
- Score qualité : {{ $json.score_qualite }}
- Mots-clés : {{ $json.mots_cles.join(', ') }}

Rédige un script vidéo de moins de 60 secondes avec :
1. Un hook très fort dès la première phrase.
2. Une explication simple et dynamique.
3. Un appel à l'action final.

Retourne uniquement un JSON valide au format :

{
  "script": "..."
}
```

---

## C12 — Normalisation Script IA

**Type** : `n8n-nodes-base.code`
**Nom du nœud** : `Normalisation Script IA`

```javascript
const results = [];

for (let i = 0; i < $input.all().length; i++) {
  const currentItem = $input.all()[i].json;

  // Récupération des infos liées via l'item correspondant en amont
  const lecture = $('Lecture Analyse et Contenu').all()[i].json;

  const campagneId = lecture.campagne_id;
  const contenuId = lecture.contenu_id;
  const analyseId = lecture.analyse_id;

  // Recherche du bloc texte renvoyé par le LLM
  let raw = '';

  if (Array.isArray(currentItem.content)) {
    const textBlock = currentItem.content.find(item => item.type === 'text');
    if (textBlock) {
      raw = textBlock.text;
    }
  } else if (currentItem.script) {
    raw = currentItem.script;
  }

  // Parsing sécurisé
  let parsed;
  try {
    parsed = JSON.parse(raw);
  } catch (e) {
    parsed = { script: raw };
  }

  results.push({
    json: {
      campagne_id: campagneId,
      contenu_id: contenuId,
      analyse_id: analyseId,
      script: parsed.script || ''
    }
  });
}

return results;
```

---

## C13 — Persistance Script

**Type** : `n8n-nodes-base.postgres`
**Nom du nœud** : `Persistance Script`
**Credential** : `ia-contenu-prod`

**Opération** : `upsert`
**Table** : `scripts`
**Clé de matching** : `analyse_id`

**Mapping** :
| Colonne | Valeur |
|---------|--------|
| `analyse_id` | `{{ $json.analyse_id }}` |
| `contenu_id` | `{{ $json.contenu_id }}` |
| `script` | `{{ $json.script }}` |

**Retour attendu** : `id` (utilisé comme `script_id`).

---

## C14 — Préparer Increment

**Type** : `n8n-nodes-base.code`
**Nom du nœud** : `Préparer Increment`

```javascript
const results = [];

for (let i = 0; i < $input.all().length; i++) {
  const scriptPersiste = $input.all()[i].json;
  const normScript = $('Normalisation Script IA').all()[i].json;

  results.push({
    json: {
      script_id: scriptPersiste.id,
      campagne_id: normScript.campagne_id,
      contenu_id: normScript.contenu_id,
      analyse_id: normScript.analyse_id
    }
  });
}

return results;
```

---

## C15 — Increment Traites

**Type** : `n8n-nodes-base.postgres`
**Nom du nœud** : `Increment Traites`
**Credential** : `ia-contenu-prod`

**Opération** : Execute Query
**Query Replacement** : `{{ $json.campagne_id }}`

```sql
UPDATE campagnes
SET
  nb_contenus_traites = nb_contenus_traites + 1,
  statut = CASE
    WHEN nb_contenus_traites + 1 >= nb_contenus_total THEN 'TERMINEE'
    ELSE statut
  END,
  date_fin = CASE
    WHEN nb_contenus_traites + 1 >= nb_contenus_total THEN NOW()
    ELSE date_fin
  END
WHERE id = $1;
```

**Effet** :
- incrémente le compteur ;
- bascule automatiquement en `TERMINEE` avec `date_fin` quand la totalité des contenus a été traitée ;
- laisse le statut inchangé sinon (pour ne pas écraser un éventuel `ERREUR`).

---

# Partie 2 — Workflow d'erreur

Ce workflow est **indépendant** du workflow principal. Il est déclenché automatiquement par le mécanisme *Error Workflow* de n8n dès qu'une exception survient.

## E01 — Capture Erreur

**Type** : `n8n-nodes-base.errorTrigger`
**Nom du nœud** : `E01 · Capture Erreur`

Aucun paramètre à configurer. Reçoit automatiquement le contexte d'erreur.

---

## E02 — Structurer Erreur

**Type** : `n8n-nodes-base.code`
**Nom du nœud** : `E02 · Structurer Erreur`

```javascript
const exec = $json.execution || {};
const error = exec.error || {};

return [
  {
    json: {
      execution_id: exec.id || null,
      niveau: "ERREUR",
      etape: error.node?.name || exec.lastNodeExecuted || "INCONNU",
      message: error.description
        || error.message
        || (error.messages ? error.messages.join(" | ") : null)
        || "Erreur inconnue"
    }
  }
];
```

---

## E03 — Log Erreur

**Type** : `n8n-nodes-base.postgres`
**Nom du nœud** : `E03 · Log Erreur`
**Credential** : `ia-contenu-prod`

**Opération** : Execute Query

```sql
INSERT INTO journal_execution (campagne_id, niveau, etape, message)
SELECT id, '{{ $json.niveau }}', '{{ $json.etape }}', '{{ $json.message }}'
FROM campagnes
WHERE execution_id = '{{ $json.execution_id }}';
```

**Mécanisme** : la campagne est retrouvée par jointure sur `execution_id`, sans dépendance mémoire au workflow principal.

---

## E04 — Update Campagne Erreur

**Type** : `n8n-nodes-base.postgres`
**Nom du nœud** : `E04 · Update Campagne Erreur`
**Credential** : `ia-contenu-prod`

**Opération** : Execute Query

```sql
UPDATE campagnes
SET statut = 'ERREUR',
    date_fin = NOW()
WHERE execution_id = '{{ $('Structurer Erreur').item.json.execution_id }}';
```

**Effet** : bascule la campagne concernée en état terminal `ERREUR` avec date de fin.

---

## 2. Sécurité & Robustesse

Le workflow garantit :

- **Aucune duplication des contenus** grâce à l'UPSERT sur `contenu_source_id` (C06).
- **Aucune duplication d'analyse** grâce à l'UPSERT sur `contenu_id` (C09).
- **Aucune duplication de script** grâce à l'UPSERT sur `analyse_id` (C13).
- **Traçabilité complète** via `campagne_id → contenu_id → analyse_id → script_id`.
- **Corrélation technique** entre workflow principal et workflow d'erreur via `execution_id`.
- **Journalisation systématique** des erreurs dans `journal_execution` (E03).
- **Détection automatique de fin de campagne** (C15) avec bascule `TERMINEE`.
- **Marquage explicite des campagnes en erreur** (E04) — aucune campagne ne reste indéfiniment `EN_COURS` en cas d'incident.
- **Idempotence** : une campagne peut être rejouée sans corrompre les données existantes.

---

## 3. Dépendances documentaires

**S'appuie sur** :
- `03 — Architecture des Workflows`
- `04 — Spécification des Composants`
- `02.3 — Schéma Physique des Données`
- `02.5 — Contrat des Données`

**Sert de référence pour** :
- `07 — Plan de Tests`
- `08 — Project Tracker`