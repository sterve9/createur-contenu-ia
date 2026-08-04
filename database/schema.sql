-- =====================================================================
-- SCHEMA POSTGRESQL — Créateur de Contenu IA
-- Version : V1 STABLE
-- Description : Schéma complet de la base pour le pipeline de veille
--               et de génération de scripts vidéo.
--
-- IMPORTANT : Ce schéma reflète exactement la base de production
-- (Supabase / PostgreSQL). La colonne "created_at" représente la date
-- de création de l'enregistrement (convention Supabase).
-- =====================================================================

-- ---------------------------------------------------------------------
-- Table : campagnes
-- ---------------------------------------------------------------------
-- Trace chaque campagne de veille, son état d'avancement et sa clôture.
-- created_at = date de création de la campagne.
-- execution_id = identifiant technique n8n permettant la corrélation
-- avec le workflow d'erreur.
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS campagnes (
    id                   BIGSERIAL PRIMARY KEY,
    sujet                TEXT NOT NULL,
    plateforme           TEXT NOT NULL,
    langue               TEXT NOT NULL,
    nb_resultats         INTEGER NOT NULL,
    statut               TEXT NOT NULL DEFAULT 'EN_COURS',
    nb_contenus_total    INTEGER NOT NULL DEFAULT 0,
    nb_contenus_traites  INTEGER NOT NULL DEFAULT 0,
    created_at           TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    date_fin             TIMESTAMP WITH TIME ZONE,
    execution_id         VARCHAR,
    CONSTRAINT chk_campagne_statut
        CHECK (statut IN ('EN_COURS', 'TERMINEE', 'ERREUR')),
    CONSTRAINT chk_campagne_compteurs
        CHECK (nb_contenus_traites <= nb_contenus_total OR nb_contenus_total = 0)
);

CREATE INDEX IF NOT EXISTS idx_campagnes_execution_id ON campagnes (execution_id);
CREATE INDEX IF NOT EXISTS idx_campagnes_statut       ON campagnes (statut);


-- ---------------------------------------------------------------------
-- Table : contenus
-- ---------------------------------------------------------------------
-- Conserve tous les contenus bruts collectés, historisés et rattachés
-- à une campagne. Clé métier : contenu_source_id (UNIQUE) garantit
-- l'idempotence via UPSERT.
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS contenus (
    id                 SERIAL PRIMARY KEY,
    campagne_id        INTEGER REFERENCES campagnes(id) ON DELETE CASCADE,
    contenu_source_id  VARCHAR NOT NULL UNIQUE,
    titre              TEXT NOT NULL,
    auteur             VARCHAR,
    description        TEXT,
    date_publication   TIMESTAMP WITH TIME ZONE,
    plateforme         VARCHAR NOT NULL,
    created_at         TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_contenus_campagne_id ON contenus (campagne_id);


-- ---------------------------------------------------------------------
-- Table : analyses
-- ---------------------------------------------------------------------
-- Stocke l'enrichissement sémantique et l'évaluation IA d'un contenu.
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS analyses (
    id             SERIAL PRIMARY KEY,
    contenu_id     INTEGER UNIQUE REFERENCES contenus(id) ON DELETE CASCADE,
    resume         TEXT NOT NULL,
    theme          VARCHAR NOT NULL,
    sentiment      VARCHAR NOT NULL,
    score_qualite  INTEGER,
    mots_cles      TEXT[],
    langue         VARCHAR NOT NULL,
    created_at     TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    CONSTRAINT chk_analyse_sentiment
        CHECK (sentiment IN ('Positif', 'Neutre', 'Négatif')),
    CONSTRAINT chk_analyse_score
        CHECK (score_qualite IS NULL OR (score_qualite BETWEEN 0 AND 100))
);


-- ---------------------------------------------------------------------
-- Table : scripts
-- ---------------------------------------------------------------------
-- Conserve le script vidéo généré par l'IA à partir d'une analyse.
-- Contrainte : un seul script par analyse (analyse_id UNIQUE).
-- Le contenu_id est propagé pour faciliter la traçabilité.
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS scripts (
    id          SERIAL PRIMARY KEY,
    analyse_id  INTEGER NOT NULL UNIQUE REFERENCES analyses(id) ON DELETE CASCADE,
    contenu_id  BIGINT REFERENCES contenus(id) ON DELETE SET NULL,
    script      TEXT NOT NULL,
    created_at  TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_scripts_contenu_id ON scripts (contenu_id);


-- ---------------------------------------------------------------------
-- Table : journal_execution
-- ---------------------------------------------------------------------
-- Journalise les incidents et événements techniques rattachés à une
-- campagne, à des fins d'audit et de diagnostic. Alimentée par le
-- workflow d'erreur (E03).
--
-- Note : la colonne s'appelle "date" (et non created_at) — spécificité
-- historique de cette table.
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS journal_execution (
    id           SERIAL PRIMARY KEY,
    campagne_id  INTEGER REFERENCES campagnes(id) ON DELETE CASCADE,
    niveau       VARCHAR NOT NULL,
    etape        VARCHAR,
    message      TEXT,
    date         TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_journal_campagne_id ON journal_execution (campagne_id);
CREATE INDEX IF NOT EXISTS idx_journal_niveau      ON journal_execution (niveau);


-- =====================================================================
-- FIN DU SCHEMA
-- =====================================================================