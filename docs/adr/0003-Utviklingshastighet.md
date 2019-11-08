# Økt utviklingshastighet EESSI Pensjon

* Status: Proposed
* Deciders: Mo Amini, Jens Christian Madsen, Nuno Cardoso, Petter Lowzow, Kjetil Jørgensen-Dahl
* Date: 2019-11-07

Technical Story: [EESSIPEN-690 - ADR for økt Utviklingshastighet](https://jira.adeo.no/browse/EESSIPEN-690)

## Context and Problem Statement

Denne ADR startet opprinnelig som et tiltak for å øke autotestdekningen i EESSI Pensjon. Men den ble raskt utvidet til å gjelde alle tiltak som kan gi økt utviklingshastighet. EESSI Pensjon har som mål å levere funksjonalitet raskest mulig til produksjon. Dette forutsetter optimale praksiser og rutiner. Men hyppige leveranser vil også ha en selvforsterkende effekt når det kommer til effektivisering, da repeterende arbeid i seg selv fremtvinnger automatisering og forenkling. 

Resultatet av denne ADR vil være en prioritert liste av tiltak vi vil fokusere på for økt utviklingshastighet. ADR'en har ikke som henikt å finne ett konkret tiltak som skal velges, men heller identifisere flere tiltak som vi ønsker å jobbe videre med. Enkelte av tiltakene vil også kunne kreve egne konkrete ADR'er for å avgjøre strategi og løsningsvalg.

## Decision Drivers

* Endringsdyktighet
  * Rask Feilretting
  * Hyppige endringer Produksjon
* Risiko
  * Risiko og konsekvens knyttet til feil
  * Kompleksitet i testing/ kvalitetssikring
  * Kompleksitet i gjennomføring (manuelle vs. automatisk deploy/ prodsetting)
* Kostnader
  * Automatisering vs. manuelle prosesser/ rutiner
* Utviklerhensy
  * Utviklingsomfang
  * Testing under utvikling
  * Utvikling på laptop
* Kjøretidshensyn 
  * Nedetidsfri deploy
  * Manuelt arbeid/ applikasjonsdrift
* Kompetanse
  * Personavhengighet
  * Domenekunnskap


## Considered Options

* [1. Prosess, organisasjon og metodikk](https://github.com/navikt/eessi-pensjon/blob/feature/adr-utviklingshastighet/docs/adr/0003-Utviklingshastighet.md#1-prosess-organisasjon-og-metodikk)
* [2. Teknologi](https://github.com/navikt/eessi-pensjon/blob/feature/adr-utviklingshastighet/docs/adr/0003-Utviklingshastighet.md#2-teknologi)
* [3. Applikasjonsdrift, Logging og Monitorering](https://github.com/navikt/eessi-pensjon/blob/feature/adr-utviklingshastighet/docs/adr/0003-Utviklingshastighet.md#3-Applikasjonsdrift-Logging-og-Monitorering)
* [4. Kvalitetssiring og Autotest](https://github.com/navikt/eessi-pensjon/blob/feature/adr-utviklingshastighet/docs/adr/0003-Utviklingshastighet.md#5-kvalitetssikring-og-autotest)
* [5. Kompetanse](https://github.com/navikt/eessi-pensjon/blob/feature/adr-utviklingshastighet/docs/adr/0003-Utviklingshastighet.md#5-kompetanse)
* [6. Deployrutiner (CI/CD)](https://github.com/navikt/eessi-pensjon/blob/feature/adr-utviklingshastighet/docs/adr/0003-Utviklingshastighet.md#6-6.-deployrutiner-(CI/CD))
6. Deployrutiner (CI/CD)

## Decision Outcome

Chosen option: "[option 1]", because [justification. e.g., only option, which meets k.o. criterion decision driver | which resolves force force | … | comes out best (see below)].

### Positive Consequences

* Mer endringsdyktig
* Økt ledetid
* Får gjort mer ved å fokusere på mindre
* Flere mindre endringer gir færre feil
* Lettere å rette feil ved små endringer
* Raskere feilretting
* Reduserte kostnader ved automatiserte prosesser (over tid)
* Lettter å reagere på endrede behov

### Negative consequences

* Automatisering er komplisert/ ressurskrevende til å begynne med

## Pros and Cons of the Options 

### 1. Prosess, organisasjon og metodikk

Hva kan gjøres med prosess, organisering og metodikk for å øke utviklkingshastigheten?

* Er teamet organisert på optimal måte?
* Jobbes det med de til enhver tid viktigeste oppgavene?
* Jobbers det effektivt med hver enkelt oppgave?
* Context Switching 
* Avbrytelser
* Fullføre enkeltoppgaver vs. flere oppgaver i paralell
* Avhengigheter til andre team
* Avhengigheter innad i team
* Høy ledetid
* Enhetstestdekning
* TDD

### 2. Teknologi  

Har vi noen begrensninger i teknologien som er valgt som hindrer utviklingshastighet?

* Camel?
* Modularisering
* 

### 3. Applikasjonsdrift, Logging og Monitorering

Har vi god nok kontroll på produksjon? Bedre applikasjonsdrift, logging og monitorering gi oss trygghet for økt utviklingshastighet?

* Good, because [argument a]
* Good, because [argument b]
* Bad, because [argument c]
* … <!-- numbers of pros and cons can vary -->

### 4. Kvalitetssikring og Autotest

Autotester er nødvendig for økt utviklngshastighet. Reduserer behovet for manuelle tester.

Integrasjonstest og Kompetansetest?

### 5. Kompetanse

* Få erfarne utviklere
* Kompetansedeling
* Personavhengighet (Fagmodul og FrontEnd)

### 6. Deployrutiner (CI/CD)

Deploy bør ikke være tidskrevende. Kan automatiseres.

### 7. Konfigurasjonsstyring

Sørg for enkel konfigurasjonsstyring

### 8. 

## Links 

* [Kontinuerlige leveranser - Bekk Radar] [https://radar.bekk.no/tech2018/prosess-og-kvalitet/kontinuerlige-leveranser]
* [A maturity Model for Continuous Delivery - Bekk Blog](https://blogg.bekk.no/a-maturity-model-for-continuous-delivery-991be2a64e4c)
