# Oppgaveruting - som [FYLL INN solution]

* Status: [accepted | superseeded by [ADR-0005](0005-example.md) | deprecated | …]
* Deciders: [list everyone involved in the decision]
* Date: [YYYY-MM-DD when the decision was last updated]

Technical Story: [description | ticket/issue URL] <!-- optional -->

## Context and Problem Statement

I dag har vi behov for å rute oppgaver i både Journalføring- og PDL-produsent-app'ene. 
Logikken for dette er ikke-triviell og er allerede duplisert.

## Decision Drivers

* Vedlikehold
* Kubernetes-ressurser (én eller to nye instanser)
* Arbeidsflyt ved fiks
* Jobb med å etablere (nå)
* Kohesjon?
* … <!-- numbers of drivers can vary -->

## Considered Options With Pros/Cons

0. Ha to "like" implementasjoner - som i dag
  - BAD, det er lett å glemme å oppdatere to steder, kan/vil? føre til feil
  - Bad, om man endrer grensesnitt blir det vanskelig å se hva som er likt/ulikt mellom varianter
  - Bad, veldig lite fristende å refaktorere (dobbelt opp)
  + Good, kan enkelt endre grensesnitt
  + Good, minst arbeid nå
1. Oppgaveruting inn i Oppgave
  - Bad, vil endre kontrakten/kafka-meldingen til Oppgave (versjonering av meldinger?)
  + Good, er kanskje naturlig å se etter oppgaverutingslogikk i Oppgave-app'en
2. Oppgaveruting i bibliotek
  - Bad, må oppdatere tre prosjekt (eller flere) for å rulle ut fiks/endring
  - Bad, litt jobb med å lage repo
  - Bad, endring av grensesnitt krever litt tenking
  + Good, oppgaveruting er skilt ut for seg selv
3. Oppgaveruting som asynk applikasjon (mellom dagens app'er)
  - Bad, vil måtte "frakte" selve oppgaven videre til Oppgave
  - Bad, en viss overhead med oppfølging og oppsett
  - Bad, litt jobb med å lage repo
  - Bad, endring av grensesnitt krever litt tenking
  - Bad, enda en Kafka-kø
  + Good, enkelt å rullet ut fiks i fremtiden
  + Good, oppgaveruting er skilt ut for seg selv
4. Oppgaveruting som asynk applikasjon - "rapids&rivers-aktig"
  - Bad, vil måtte "frakte" selve oppgaven videre til Oppgave
  - Bad, en viss overhead med oppfølging og oppsett
  - Bad, litt jobb med å lage repo
  - Bad, endring av grensesnitt krever litt tenking
  - BAD, ulike typer meldinger på samme kø (usynlig orkestrering, kompliserende)
  + Good, enkelt å rullet ut fiks i fremtiden
  + Good, oppgaveruting er skilt ut for seg selv
5. Oppgaveruting som synk applikasjon (kalles fra dagens app'er)
  - Bad, en viss overhead med oppfølging og oppsett
  - Bad, må kjøre to instanser eller ha lang retry mot oss selv
  - Bad, litt jobb med å lage repo
  - Bad, endring av grensesnitt krever litt tenking
  + Good, enkelt å rullet ut fiks i fremtiden
  + Good, oppgaveruting er skilt ut for seg selv

## Decision Outcome

Chosen option: "[option 1]", because [justification. e.g., only option, which meets k.o. criterion decision driver | which resolves force force | … | comes out best (see below)].

### Positive Consequences

* [e.g., improvement of quality attribute satisfaction, follow-up decisions required, …]
* …

### Negative consequences

* [e.g., compromising quality attribute, follow-up decisions required, …]
* …

## Links <!-- optional -->

* [Link type] [Link to ADR] <!-- example: Refined by [ADR-0005](0005-example.md) -->
* … <!-- numbers of links can vary -->
