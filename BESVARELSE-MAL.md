# Besvarelse - Refleksjon og Analyse

**Student:** Tore Kristoffer Ølberg

**Studentnummer:** 0689

**Dato:** 01.03.26

---

## Del 1: Datamodellering

### Oppgave 1.1: Entiteter og attributter

**Identifiserte entiteter:**

Kunde, sykkel, stasjon, lås og utleie

Disse entitetene representerer de viktigste objektene systemet må holde informasjon om. Systemet må lagre hvem som leier sykler (kunde), hvilke sykler som finnes (sykkel), hvor de befinner seg (stasjon og lås), samt informasjon om leieforholdet (utleie).


**Attributter for hver entitet:**

Kunde: kunde_id, fornavn, etternavn, mobilnummer, epost
En kunde må kunne identifiseres entydig i systemet og det må lagres kontaktinformasjon.

Sykkel: sykkel_id, tatt_i_bruk_dato, stasjon_id, lås_id
Hver sykkel har en unik ID. I tillegg lagres hvilken stasjon og lås den står på.

Stasjon: stasjon_id, navn, adresse
En stasjon må kunne identifiseres og ha et navn og en fysisk plassering.

Lås: lås_id, stasjon_id
Hver lås tilhører en bestemt stasjon, og en stasjon kan ha mange låser.

Utleie: utleie_id, kunde_id, sykkel_id, start_tid, slutt_tid, beløp
Utleie representerer selve leieforholdet. Den kobler en kunde til en sykkel over et tidsintervall.

---

### Oppgave 1.2: Datatyper og `CHECK`-constraints

**Valgte datatyper og begrunnelser:**

For primærnøkler er det brukt SERIAL, slik at PostgreSQL automatisk genererer unike ID-er.

Navn og adresse: VARCHAR, fordi lengden varierer og det er tekstfelt.

Mobilnummer: VARCHAR, siden det kan inneholde et plusstegn.

Dato for sykkel tatt i bruk: DATE, fordi vi kun trenger dato.

Start- og sluttid: TIMESTAMP, siden både dato og klokkeslett må lagres.

Beløp: NUMERIC, for presis lagring av penger.


**`CHECK`-constraints:**

Mobilnummer:
Sikrer at feltet kun inneholder tall.

E-post:
Enkel sjekk for at verdien inneholder @.

Beløp:
Sikrer at beløpet ikke kan være negativt.

Dette gjør at ugyldige verdier stoppes på databasenivå.

**ER-diagram:**

erDiagram

    KUNDE {
        int kunde_id 
        varchar fornavn
        varchar etternavn
        varchar mobilnummer
        varchar epost
    }

    STASJON {
        int stasjon_id 
        varchar navn
        varchar adresse
    }

    LAS {
        int las_id 
        int stasjon_id 
    }

    SYKKEL {
        int sykkel_id 
        date tatt_i_bruk_dato
        int stasjon_id 
        int las_id 
    }

    UTLEIE {
        int utleie_id 
        int kunde_id 
        int sykkel_id 
        datetime start_tid
        datetime slutt_tid
        float belop
    }

    KUNDE ||--o{ UTLEIE : har
    SYKKEL ||--o{ UTLEIE : gjelder
    STASJON ||--o{ LAS : inneholder
    STASJON ||--o{ SYKKEL : har

---

### Oppgave 1.3: Primærnøkler

**Valgte primærnøkler og begrunnelser:**

Alle entitetene har fått en egen primærnøkkel:

kunde_id, stasjon_id, lås_id, sykkel_id og utleie_id

Jeg har valgt å bruke surrogatnøkler (SERIAL) fremfor naturlige nøkler. For eksempel kunne mobilnummer vært brukt som primærnøkkel for kunde, men dette er ikke alltid optimalt siden mobilnummer kan endres. Surrogatnøkler gir større fleksibilitet og gjør relasjoner enklere å håndtere.


**Naturlige vs. surrogatnøkler:**

Jeg har valgt å bruke surrogatnøkler som primærnøkler fordi de er stabile, enkle og gir bedre ytelse. Naturlige nøkler som e-post eller mobilnummer kan endre seg, og brukes dermed heller med UNIQUE-constraints.

**Oppdatert ER-diagram:**

erDiagram

    KUNDE {
        int kunde_id PK
        varchar fornavn
        varchar etternavn
        varchar mobilnummer
        varchar epost
    }

    STASJON {
        int stasjon_id PK
        varchar navn
        varchar adresse
    }

    LAS {
        int las_id PK
        int stasjon_id 
    }

    SYKKEL {
        int sykkel_id PK
        date tatt_i_bruk_dato
        int stasjon_id 
        int las_id 
    }

    UTLEIE {
        int utleie_id PK
        int kunde_id 
        int sykkel_id 
        datetime start_tid
        datetime slutt_tid
        float belop
    }

    KUNDE ||--o{ UTLEIE : har
    SYKKEL ||--o{ UTLEIE : gjelder
    STASJON ||--o{ LAS : inneholder
    STASJON ||--o{ SYKKEL : har


---

### Oppgave 1.4: Forhold og fremmednøkler

**Identifiserte forhold og kardinalitet:**

En kunde kan ha mange utleier, 1:N

En sykkel kan være med i mange utleier over tid, 1:N

En stasjon har mange låser, 1:N

En stasjon har mange sykler, 1:N

**Fremmednøkler:**

utleie.kunde_id - kunde.kunde_id

utleie.sykkel_id - sykkel.sykkel_id

lås.stasjon_id - stasjon.stasjon_id

sykkel.stasjon_id - stasjon.stasjon_id

sykkel.lås_id - lås.lås_id

Dette fører til referanseintegritet mellom tabellene.

**Oppdatert ER-diagram:**

erDiagram

    KUNDE {
        int kunde_id PK
        varchar fornavn
        varchar etternavn
        varchar mobilnummer
        varchar epost
    }

    STASJON {
        int stasjon_id PK
        varchar navn
        varchar adresse
    }

    LAS {
        int las_id PK
        int stasjon_id FK
    }

    SYKKEL {
        int sykkel_id PK
        date tatt_i_bruk_dato
        int stasjon_id FK
        int las_id FK
    }

    UTLEIE {
        int utleie_id PK
        int kunde_id FK
        int sykkel_id FK
        datetime start_tid
        datetime slutt_tid
        float belop
    }

    KUNDE ||--o{ UTLEIE : har
    SYKKEL ||--o{ UTLEIE : gjelder
    STASJON ||--o{ LAS : inneholder
    STASJON ||--o{ SYKKEL : har

---

### Oppgave 1.5: Normalisering

**Vurdering av 1. normalform (1NF):**

Modellen tilfredsstiller 1NF fordi det finnes ingen gjentatte grupper eller lister i en kolonne.

**Vurdering av 2. normalform (2NF):**

Alle tabeller har én enkel primærnøkkel, og ingen attributter er avhengige av en sammensatt nøkkel. Derfor er modellen på 2NF.

**Vurdering av 3. normalform (3NF):**

Det finnes ingen avhengigheter. For eksempel lagres ikke kundenavn i utleie tabellen, kun en fremmednøkkel til kunde. Dermed unngås unødvendig lagring av den samme dataen og modellen tilfredsstiller 3NF.

**Eventuelle justeringer:**

Jeg gjorde ingen justeringer.

---

## Del 2: Database-implementering

### Oppgave 2.1: SQL-skript for database-initialisering

**Plassering av SQL-skript:**

Jeg bekrefter at jeg har lagt SQL-skriptet i `init-scripts/01-init-database.sql`

**Antall testdata:**

- Kunder: 5
- Sykler: 100
- Sykkelstasjoner: 5
- Låser: 100
- Utleier: 50

---

### Oppgave 2.2: Kjøre initialiseringsskriptet

**Dokumentasjon av vellykket kjøring:**

[Skriv ditt svar her - f.eks. skjermbilder eller output fra terminalen som viser at databasen ble opprettet uten feil]

**Spørring mot systemkatalogen:**

```sql
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
  AND table_type = 'BASE TABLE'
ORDER BY table_name;
```

**Resultat:**

```
[Skriv resultatet av spørringen her - list opp alle tabellene som ble opprettet]
```

---

## Del 3: Tilgangskontroll

### Oppgave 3.1: Roller og brukere

**SQL for å opprette rolle:**

```sql
[Skriv din SQL-kode for å opprette rollen 'kunde' her]
```

**SQL for å opprette bruker:**

```sql
[Skriv din SQL-kode for å opprette brukeren 'kunde_1' her]
```

**SQL for å tildele rettigheter:**

```sql
[Skriv din SQL-kode for å tildele rettigheter til rollen her]
```

---

### Oppgave 3.2: Begrenset visning for kunder

**SQL for VIEW:**

```sql
[Skriv din SQL-kode for VIEW her]
```

**Ulempe med VIEW vs. POLICIES:**

[Skriv ditt svar her - diskuter minst én ulempe med å bruke VIEW for autorisasjon sammenlignet med POLICIES]

---

## Del 4: Analyse og Refleksjon

### Oppgave 4.1: Lagringskapasitet

**Gitte tall for utleierate:**

- Høysesong (mai-september): 20000 utleier/måned
- Mellomsesong (mars, april, oktober, november): 5000 utleier/måned
- Lavsesong (desember-februar): 500 utleier/måned

**Totalt antall utleier per år:**

[Skriv din utregning her]

**Estimat for lagringskapasitet:**

[Skriv din utregning her - vis hvordan du har beregnet lagringskapasiteten for hver tabell]

**Totalt for første år:**

[Skriv ditt estimat her]

---

### Oppgave 4.2: Flat fil vs. relasjonsdatabase

**Analyse av CSV-filen (`data/utleier.csv`):**

**Problem 1: Redundans**

[Skriv ditt svar her - gi konkrete eksempler fra CSV-filen som viser redundans]

**Problem 2: Inkonsistens**

[Skriv ditt svar her - forklar hvordan redundans kan føre til inkonsistens med eksempler]

**Problem 3: Oppdateringsanomalier**

[Skriv ditt svar her - diskuter slette-, innsettings- og oppdateringsanomalier]

**Fordeler med en indeks:**

[Skriv ditt svar her - forklar hvorfor en indeks ville gjort spørringen mer effektiv]

**Case 1: Indeks passer i RAM**

[Skriv ditt svar her - forklar hvordan indeksen fungerer når den passer i minnet]

**Case 2: Indeks passer ikke i RAM**

[Skriv ditt svar her - forklar hvordan flettesortering kan brukes]

**Datastrukturer i DBMS:**

[Skriv ditt svar her - diskuter B+-tre og hash-indekser]

---

### Oppgave 4.3: Datastrukturer for logging

**Foreslått datastruktur:**

[Skriv ditt svar her - f.eks. heap-fil, LSM-tree, eller annen egnet datastruktur]

**Begrunnelse:**

**Skrive-operasjoner:**

[Skriv ditt svar her - forklar hvorfor datastrukturen er egnet for mange skrive-operasjoner]

**Lese-operasjoner:**

[Skriv ditt svar her - forklar hvordan datastrukturen håndterer sjeldne lese-operasjoner]

---

### Oppgave 4.4: Validering i flerlags-systemer

**Hvor bør validering gjøres:**

[Skriv ditt svar her - argumenter for validering i ett eller flere lag]

**Validering i nettleseren:**

[Skriv ditt svar her - diskuter fordeler og ulemper]

**Validering i applikasjonslaget:**

[Skriv ditt svar her - diskuter fordeler og ulemper]

**Validering i databasen:**

[Skriv ditt svar her - diskuter fordeler og ulemper]

**Konklusjon:**

[Skriv ditt svar her - oppsummer hvor validering bør gjøres og hvorfor]

---

### Oppgave 4.5: Refleksjon over læringsutbytte

**Hva har du lært så langt i emnet:**

[Skriv din refleksjon her - diskuter sentrale konsepter du har lært]

**Hvordan har denne oppgaven bidratt til å oppnå læringsmålene:**

[Skriv din refleksjon her - koble oppgaven til læringsmålene i emnet]

Se oversikt over læringsmålene i en PDF-fil i Canvas https://oslomet.instructure.com/courses/33293/files/folder/Plan%20v%C3%A5ren%202026?preview=4370886

**Hva var mest utfordrende:**

[Skriv din refleksjon her - diskuter hvilke deler av oppgaven som var mest krevende]

**Hva har du lært om databasedesign:**

[Skriv din refleksjon her - reflekter over prosessen med å designe en database fra bunnen av]

---

## Del 5: SQL-spørringer og Automatisk Testing

**Plassering av SQL-spørringer:**

[Bekreft at du har lagt SQL-spørringene i `test-scripts/queries.sql`]


**Eventuelle feil og rettelser:**

[Skriv ditt svar her - hvis noen tester feilet, forklar hva som var feil og hvordan du rettet det]

---

## Del 6: Bonusoppgaver (Valgfri)

### Oppgave 6.1: Trigger for lagerbeholdning

**SQL for trigger:**

```sql
[Skriv din SQL-kode for trigger her, hvis du har løst denne oppgaven]
```

**Forklaring:**

[Skriv ditt svar her - forklar hvordan triggeren fungerer]

**Testing:**

[Skriv ditt svar her - vis hvordan du har testet at triggeren fungerer som forventet]

---

### Oppgave 6.2: Presentasjon

**Lenke til presentasjon:**

[Legg inn lenke til video eller presentasjonsfiler her, hvis du har løst denne oppgaven]

**Hovedpunkter i presentasjonen:**

[Skriv ditt svar her - oppsummer de viktigste punktene du dekket i presentasjonen]

---

**Slutt på besvarelse**
