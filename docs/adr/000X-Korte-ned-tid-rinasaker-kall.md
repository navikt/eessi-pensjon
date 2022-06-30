# [short title of solved problem and solution]

* Status: [accepted | superseeded by [ADR-0005](0005-example.md) | deprecated | …]
* Deciders: [list everyone involved in the decision]
* Date: [YYYY-MM-DD when the decision was last updated]

Technical Story: [EP-1306](https://jira.adeo.no/browse/EP-1306)

## Context and Problem Statement

Det tar typisk fra 15 til 30 sekunder (og av og til mer) fra bruker kommer inn i EESSI Pensjon til man 
får se listen over BUC'er. Dette skydes i all hovedsak et kall til EUX/Rina for å hente liste med
BUC'er for en bruker/pesys-sak. 

[Describe the context and problem statement, e.g., in free form using two to three sentences. You may want to articulate the problem in form of a question.]

## Decision Drivers

* Brukeopplevelse - dagens lekstreme reponstid er frustrerende og reduserer produktiviten
* Hva kan vi selv gjøre noe med
* Nødvendig omfang av innsats
* Når kan man forvente å få til en forbedring, og hvor stor kan den bli?
* 
* [driver x, e.g., a force, facing concern, …]

## Considered Options

1. Kan man forbedre ytelse på rinasaker-kallet til EUX/rina

2. Kan vi unngå å liste alle buc'er (arbeidsflyt til saksbehandlere)

3. Kan vi søke med noe annet enn fnr/pensak-id?

4. Kan vi få "EU" til å fikse responstiden?

5. Kan vi starte kallet tidligere i app'en?

6. Kan vi lage skygge-database av sammenhengen mellom ident/pensak-id og rinasak (gjennom f eks trigger på tabeller i Rina-databasen)?

7. Finnes det en Kafka-strøm vi kan bruke til å bygeg opp en indeks av sammenheng mellom ident/pensak-id og rinasak?

8. Kan man bygeget nytt EUX-endepunkt som går rett mot databasen?

9. Kan det hjelpe å gi RIna mer server-ressurser?

10. Kan man ta Pensjons-sakene ut av felles-Rina?

11. Kan vi gjøre noe lurt med "forhåndsbestemt søk"-funksjonaliteten?

12. 

## Decision Outcome

Chosen option: "[option 1]", because [justification. e.g., only option, which meets k.o. criterion decision driver | which resolves force force | … | comes out best (see below)].

### Positive Consequences

* [e.g., improvement of quality attribute satisfaction, follow-up decisions required, …]
* …

### Negative consequences

* [e.g., compromising quality attribute, follow-up decisions required, …]
* …

## Pros and Cons of the Options <!-- optional -->

### [option 1]

[example | description | pointer to more information | …] <!-- optional -->

* Good, because [argument a]
* Good, because [argument b]
* Bad, because [argument c]
* … <!-- numbers of pros and cons can vary -->

### [option 2]

[example | description | pointer to more information | …] <!-- optional -->

* Good, because [argument a]
* Good, because [argument b]
* Bad, because [argument c]
* … <!-- numbers of pros and cons can vary -->

### [option 3]

[example | description | pointer to more information | …] <!-- optional -->

* Good, because [argument a]
* Good, because [argument b]
* Bad, because [argument c]
* … <!-- numbers of pros and cons can vary -->

## Links <!-- optional -->

* [Link type] [Link to ADR] <!-- example: Refined by [ADR-0005](0005-example.md) -->
* … <!-- numbers of links can vary -->
