-- ============================================================================
-- DATA1500 - Oblig 1: Arbeidskrav I våren 2026
-- Initialiserings-skript for PostgreSQL
-- ============================================================================

-- Opprett grunnleggende tabeller

CREATE TABLE kunde (
    kunde_id SERIAL PRIMARY KEY,
    fornavn VARCHAR(50) NOT NULL,
    etternavn VARCHAR(50) NOT NULL,
    mobilnummer VARCHAR(15) UNIQUE NOT NULL
        CHECK (mobilnummer ~ '^\+47[0-9]{8}$'),
    epost VARCHAR(100) UNIQUE NOT NULL
        CHECK (epost ~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$')
);

CREATE TABLE stasjon (
    stasjon_id SERIAL PRIMARY KEY,
    navn VARCHAR(100) NOT NULL,
    adresse VARCHAR(150) NOT NULL
);

CREATE TABLE sykkel (
    sykkel_id SERIAL PRIMARY KEY,
    modell VARCHAR(100) NOT NULL,
    innkjopsdato DATE NOT NULL,
    status VARCHAR(20) NOT NULL
        CHECK (status IN ('tilgjengelig', 'utleid', 'service'))
);

CREATE TABLE las (
    las_id SERIAL PRIMARY KEY,
    stasjon_id INT NOT NULL REFERENCES stasjon(stasjon_id) ON DELETE CASCADE,
    nummer INT NOT NULL,
    UNIQUE (stasjon_id, nummer)
);

CREATE TABLE utleie (
    utleie_id SERIAL PRIMARY KEY,
    kunde_id INT NOT NULL REFERENCES kunde(kunde_id),
    sykkel_id INT NOT NULL REFERENCES sykkel(sykkel_id),
    start_stasjon_id INT NOT NULL REFERENCES stasjon(stasjon_id),
    slutt_stasjon_id INT REFERENCES stasjon(stasjon_id),
    start_tid TIMESTAMP NOT NULL,
    slutt_tid TIMESTAMP
);

-- Sett inn testdata

INSERT INTO kunde (fornavn, etternavn, mobilnummer, epost) VALUES
('Ole', 'Hansen', '+4791234567', 'ole.hansen@example.com'),
('Kari', 'Olsen', '+4792345678', 'kari.olsen@example.com'),
('Per', 'Andersen', '+4793456789', 'per.andersen@example.com'),
('Lise', 'Johansen', '+4794567890', 'lise.johansen@example.com'),
('Anna', 'Nilsen', '+4796789012', 'anna.nilsen@example.com');

INSERT INTO stasjon (navn, adresse) VALUES
('Sentrum Stasjon', 'Karl Johans gate 1 Oslo'),
('Universitetet Stasjon', 'Blindern Oslo'),
('Grünerløkka Stasjon', 'Thorvald Meyers gate 10 Oslo'),
('Aker Brygge Stasjon', 'Stranden 1 Oslo'),
('Majorstuen Stasjon', 'Bogstadveien 50 Oslo');

INSERT INTO sykkel (modell, innkjopsdato, status)
SELECT 
    CASE 
        WHEN i % 3 = 0 THEN 'City Bike Pro'
        WHEN i % 3 = 1 THEN 'Urban Cruiser'
        ELSE 'EcoBike 3000'
    END,
    DATE '2023-01-01' + (i || ' days')::interval,
    'tilgjengelig'
FROM generate_series(1,100) AS s(i);

INSERT INTO las (stasjon_id, nummer)
SELECT s.stasjon_id, l.nr
FROM stasjon s,
generate_series(1,20) AS l(nr);

INSERT INTO utleie (kunde_id, sykkel_id, start_stasjon_id, slutt_stasjon_id, start_tid, slutt_tid)
SELECT
    (RANDOM()*4 + 1)::INT,
    (RANDOM()*99 + 1)::INT,
    (RANDOM()*4 + 1)::INT,
    (RANDOM()*4 + 1)::INT,
    TIMESTAMP '2023-06-01 08:00:00' + (i || ' hours')::interval,
    TIMESTAMP '2023-06-01 09:00:00' + (i || ' hours')::interval
FROM generate_series(1,50) AS s(i);



-- Vis at initialisering er fullført (kan se i loggen fra "docker-compose log")
SELECT 'Database initialisert!' as status;