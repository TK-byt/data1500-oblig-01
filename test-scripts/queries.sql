-- ============================================================================
-- TEST-SKRIPT FOR OBLIG 1
-- ============================================================================

-- Kjør med: docker-compose exec postgres psql -h -U admin -d data1500_db -f test-scripts/queries.sql

-- En test med en SQL-spørring mot metadata i PostgreSQL (kan slettes fra din script)
select nspname as schema_name from pg_catalog.pg_namespace;


-- Oppgave 5.1

SELECT *
FROM sykkel;


-- Oppgave 5.2

SELECT etternavn, fornavn, mobilnummer
FROM kunde
ORDER BY etternavn ASC;


-- Oppgave 5.3

SELECT *
FROM sykkel
WHERE innkjopsdato > DATE '2023-04-01';


-- Oppgave 5.4

SELECT COUNT(*) AS antall_kunder
FROM kunde;