# Egen applikasjon for håndtering av dødsmeldinger (H070)

* Status: Accepted
* Deciders: Daniel S
* Date: 2026-05-21

Technical Story: Utvikling av H070-behandling for dødsfall, opprinnelig startet i branch `feature/h070-behandling-for-dødsfall` under eessi-pensjon-pdl-produsent

## Context and Problem Statement

EESSI Pensjon har behov for å håndtere dødsmeldinger og leveattester i samspill mellom norske og utenlandske trygdemyndigheter:

1. **Dødsmeldinger fra PDL**: Når en person dør i Norge, mottar vi dødsmelding fra Persondataløsningen (PDL)
2. **Leveattester fra utlandet**: Vi mottar bekreftelse på leveattest (H070) fra utenlandske institusjoner
3. **Utsending av dødsmeldinger**: Når vi mottar dødsmelding fra PDL, skal vi sende H070 til de utenlandske institusjonene vi har mottatt leveattest fra
4. **Verifisering via Joark**: Vi skal også sende dødsmelding hvis vi via Joark kan bekrefte at personen har sendt en P6000 (pensjonsvedtak) som ligger i Joark

Utviklingen startet opprinnelig som en del av eessi-pensjon-pdl-produsent i branch `feature/h070-behandling-for-dødsfall`, men etterhvert som logikken ble mer spesifikk og kravene tydeligere, ble det klart at denne funksjonaliteten ikke passet naturlig inn i pdl-produsent. Spørsmålet er om dødsmelding-håndtering skal forbli i pdl-produsent eller skilles ut som egen applikasjon.

## Decision Drivers

* Ansvarsområde og separasjon av bekymringer (separation of concerns)
* Kommunikasjonsmønster - lytter på PDL (dødsfall) og sender til utlandet (motsatt av pdl-produsent)
* Integrasjon med flere systemer (PDL, Joark, RINA/EUX)
* Vedlikeholdbarhet og forståelighet av kode
* Uavhengig deployment og skalering
* Feilhåndtering og resiliens

## Considered Options

1. Beholde funksjonaliteten i eessi-pensjon-pdl-produsent
2. Skille ut som egen applikasjon (eessi-pensjon-dodsmelding)

## Decision Outcome

Chosen option: "Skille ut som egen applikasjon (eessi-pensjon-dodsmelding)", fordi funksjonaliteten har motsatt dataflyt og et distinkt ansvarsområde som skiller seg vesentlig fra pdl-produsent.

### Positive Consequences

* Tydelig ansvarsfordeling - dødsmelding-app håndterer flyt fra PDL til utlandet
* Motsatt dataflyt fra pdl-produsent (som går fra utlandet til PDL) - logisk separasjon
* Uavhengig deployment - endringer i dødsmelding-logikk påvirker ikke PDL-oppdateringer
* Egen integrasjon mot Joark for å verifisere P6000-dokumenter
* Kan håndtere lagring og oppslag av mottatte leveattester fra utlandet
* Enklere feilsøking - problemer kan isoleres til spesifikk applikasjon

### Negative consequences

* Én ekstra applikasjon å drifte og vedlikeholde
* Potensielt noe kodeduplisering for felles funksjonalitet
* Flere repositories/moduler å holde oversikt over

## Pros and Cons of the Options

### 1. Beholde funksjonaliteten i eessi-pensjon-pdl-produsent

Fortsette utviklingen i pdl-produsent med utvidet funksjonalitet.

* Good, because færre applikasjoner å vedlikeholde
* Good, because felles infrastruktur og konfigurasjon
* Bad, because pdl-produsent *mottar* fra RINA og *sender* til PDL, mens dødsmelding *mottar* fra PDL og *sender* til RINA - motsatt dataflyt
* Bad, because økt kompleksitet i én applikasjon
* Bad, because krever integrasjon med Joark for å sjekke P6000
* Bad, because krever lagring/oppslag av leveattester mottatt fra utlandet

### 2. Skille ut som egen applikasjon (eessi-pensjon-dodsmelding)

Lage en dedikert applikasjon for håndtering av dødsmeldinger.

* Good, because tydelig separasjon av dataflyt (PDL → utland vs utland → PDL)
* Good, because dødsmelding-spesifikk logikk kan utvikles fritt
* Good, because integrasjon med Joark og leveattest-håndtering isoleres
* Good, because enklere å forstå og vedlikeholde hver applikasjon
* Good, because uavhengig feilhåndtering og retry-mekanismer
* Bad, because én ekstra applikasjon å drifte
* Bad, because initiell innsats for å sette opp ny app

## Links

* Relatert til [ADR-0006](0006-PDL-produsent-i-flere-apper.md) - Én PDL-produsent-app med to lyttere på samme topic

