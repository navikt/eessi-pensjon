---
name: periodisk-gjennomgang-tilganger-nais
description: >-
  Lager en copy-paste-klar revisjonsdokumentasjon for årlig gjennomgang av
  Nais-team-tilganger i EESSI Pensjon, iht. rutinen i
  docs/internkontroll/periodisk_gjennomgang_tilganger_nais.txt.
  Dokumenterer tjenstlig behov, kritikalitet og historikk-kontroller.
agent: eessi-pensjon-etterlevelse
---

# Periodisk gjennomgang av tilganger — Nais-team

Denne skillen dokumenterer årlig revisjon av medlemskap og tilganger i et
Nais-team, iht. rutinen i `docs/internkontroll/periodisk_gjennomgang_tilganger_nais.txt`.

Resultatet er en copy-paste-klar revisjonsrapport som tilfredsstiller
dokumentasjonskravene for internkontroll.

## Input

Brukeren oppgir normalt:

- Nais-team-navn (f.eks. `eessipensjon`)
- År for gjennomgangen (iht. frekvensplan)
- Liste over medlemmer som skal gjennomgås (eller «alle nåværende»)

## Kilder som skal brukes

1. `docs/internkontroll/periodisk_gjennomgang_tilganger_nais.txt` (regelgrunnlag)
2. `docs/internkontroll/kritikalitet_tilganger_nais.txt` (kritikalitetsnivå for roller)
3. **Nais-console** — Members-skjermbilde for teamet:
   - Medlemsnavn og rolle
   - Tilleggsdataflater (secrets, buckets, topics)
   - Historikk (endringstidspunkter, hvem som la til/fjernet)
4. **Manuelle kilder:**
   - Organisasjonsplan / HR-data — hvem har hvilket ansvarsområde
   - GitHub-commit-historikk — hvem bidrar aktivt til teamets repos
   - JIRA / issue-tracker — hvem jobber med teamets saker
   - Tapt kontakt / offboarding-records — hvem har sluttet

## Hvem har tjenstlig behov

**Tjenstlig behov** eksisterer normalt for:

- **Aktivt teammedlem:** Bidrar til utvikling, drift, ON-call, testing
- **Produktleder:** Ansvarlig for produktet som leveres
- **Arkitekt/Tech lead:** Ansvarlig for arkitektur og teknisk retning
- **Admin:** Administrerer tilganger, secrets, deployments

**Ingen tjenstlig behov** hvis:

- Person har sluttet eller er i permisjon
- Person har byttet rolle og ikke lenger jobber med teamet
- Person har ikke hatt yrkesmessige oppgaver i de siste 6 månedene

## Regler

1. **Ikke dikt opp tjenstlig behov.** Verifiser fra organisasjonsplan, GitHub-activity eller
   direkte spørring til produktleder.
2. **Kritikalitet:** ta fra `kritikalitet_tilganger_nais.txt`:
   - `HØY KRITIKALITET` — secrets, Kafka, REST API, Azure grupper
   - `LAV KRITIKALITET` — GCP buckets, logging
3. **Historikk-kontroll:**
   - Sjekk hvis noen ble lagt til eller fjernet de siste 12 månedene
   - Hvis fjernet: verifiser det fant sted ved terminering/bytteritt
   - Hvis lagt til: verifiser det var ønskelig og dokumentert
   - Red flag: tegn på at HØY/SVÆRT HØY-tilgang ble misbrukt
4. **Risikovurdering ved manglende behov:**
   - Hvis HØY/SVÆRT HØY-tilgang uten behov: undersøk mulig misbruk
   - Dokumenter konklusjon (ingen tegn / funn / rapport skal sendes teknologileder)
5. **Konservativ vurdering:** når i tvil, merk som `Må oppklares` og eskalér.
6. **Norsk, klart språk.**

## Steg

1. Naviger til Nais-console → velg team → tab "Members".
2. Ta skjermdump av hele Members-listen som revisjonsbevis.
3. For **hvert medlem:**
   - Skriv navn, nåværende rolle
   - Hent kritikalitetsnivå fra `kritikalitet_tilganger_nais.txt`
   - Verifiser tjenstlig behov fra kilder (HR, GitHub, JIRA, produktleder)
   - Skriv konklusjon: `Tjenstlig behov bekreftet` eller `Manglende behov`
4. Sjekk **Historikk** (kolonne til høyre i "Members"):
   - Klikk på hver person → se endringshistorikk
   - Verifiser at endringer matcher kjente events (onboarding, offboarding)
   - Hvis uforventet aktivitet: dokumenter og eskalér
5. For personer med **HØY/SVÆRT HØY-tilgang uten tjenstlig behov:**
   - Utfør risikovurdering: kunne tilgangen ha blitt misbrukt?
   - Dokumenter konklusjon med begrunnelse
   - Hvis fund: informer teknologileder
6. Generer rapport i formatet under.

## Output format

Returner kun denne markdown-strukturen:

```markdown
# Periodisk gjennomgang av tilganger — Nais-team <teamnavn>

**Rutine:** docs/internkontroll/periodisk_gjennomgang_tilganger_nais.txt
**År:** <YYYY>
**Gjennomført av:** <navn> (Produktleder), <navn> (Tech Lead)
**Dato:** <YYYY-MM-DD>
**Revisjonsbevis:** Vedlegg — skjermdump fra Nais-console Members, <dato>

## Medlemmers tilgangsgjennomgang

| Navn | Nåværende rolle | Kritikalitet | Tjenstlig behov | Status | Merknad |
|------|-----------------|--------------|-----------------|--------|---------|
| <navn> | <rolle> | HØY | Ja | ✅ OK | Aktiv utvikler, bekreftet av PL |
| <navn> | <rolle> | LAV | Nei | ⚠️ TERMINÉR | – |
| <navn> | <rolle> | HØY | Uklar | 🔴 ESKALÉR | Må oppklares med HR |

## Historikk-kontroll

**Periode kontrollert:** <YYYY-MM-DD> til <YYYY-MM-DD>

**Funn:**
- Alle endringer i perioden er registrert og verifisert
- Ingen tegn på uautorisert tilgangsgetting eller -fjerning
- Endringshistorikken er i samsvar med kjente onboarding/offboarding-events

**Åpne spørsmål:** (hvis noen)
- <navn>: ble lagt til <dato>, begrunnelse skal verifiseres

## Risikovurdering — HØY/SVÆRT HØY-tilgang uten tjenstlig behov

**Funn:** <hvis noen ble identifisert, beskriv kort>

**Vurdering:**
- Fant ingen tegn på misbruk i perioden
- **ELLER:** Tegn på potensielt misbruk — se vedlegg

**Handlinger:** 
- Tilgang skal umiddelbart fjernes (hvis relevant)
- Teknologileder informert: <ja/nei>
- JIRA-sak opprettet: <link eller avslåatt>

## Konklusjon

**Aggregert status:** ✅ AKSEPTERT / ⚠️ AKSEPTERT MED FORBEHOLD / 🔴 AVVIK

**Beskrivelse:**
<1–2 setninger om gjennomgangens resultat, hvilken tilstand teamet er i,
og eventuelle tiltak som er gjort.>

## Vedlegg

- Skjermdump Members-oversikt
- Risikovurdering (hvis relevant)
- Historikk-utdrag (hvis relevant)
```

## Kvalitetssjekk for levering

- Er alle nåværende medlemmer opplistet med gjeldende rolle?
- Er kritikalitetsnivå for hver rolle hentet fra kritikalitet_tilganger_nais.txt?
- Er tjenstlig behov verifisert fra kilder, ikke antatt?
- Er historikk-kontroll gjennomført og dokumentert?
- Er risikovurdering gjennomført for alle HØY/SVÆRT HØY-tilfeller uten behov?
- Er revisjonsbevis (skjermdump) vedlagt?
- Er ansvarsfordelingen (PL, Tech Lead, admin-med-tilgang) oppfylt?

