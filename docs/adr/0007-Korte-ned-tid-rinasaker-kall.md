# [short title of solved problem and solution]

* Status: [accepted | superseeded by [ADR-0005](0005-example.md) | deprecated | …]
* Deciders: [list everyone involved in the decision]
* Date: [YYYY-MM-DD when the decision was last updated]

Technical Story: [EP-1306](https://jira.adeo.no/browse/EP-1306)

## Context and Problem Statement

Det tar typisk fra 15 til 30 sekunder fra bruker kommer inn i EESSI Pensjon til man får se listen over BUC'er. Dette skydes i all hovedsak et kall (i EP kalt "HentRinasaker"), som bruker 15-20 sekunder, og av og til mer, til EUX/Rina for å hente liste med BUC'er for en bruker/pesys-sak.

Vi ser at responstidene på HentRinasaker varierer, tilsynelatende med den generelle aktiviteten. I perioder med lite aktivitet er responstiden lavere, 3-10 sekunder.

[Describe the context and problem statement, e.g., in free form using two to three sentences. You may want to articulate the problem in form of a question.]

## Decision Drivers

* Brukeropplevelse - dagens høye reponstid er frustrerende og reduserer produktiviten
* Hva kan vi selv gjøre noe med
* Nødvendig omfang av innsats
* Når kan man forvente å få til en forbedring, og hvor stor kan den bli?
* 
* [driver x, e.g., a force, facing concern, …]

## Considered Options

1. Undersøke nærmere ytelsesforbedringer på rinasaker-kallet til EUX/Rina

2. Oppfordre EESSI Basis til å gi Rina evt EUX mer server-ressurser (Siden vi ser at HentRinaSaker går kjappere i perioder med lavere last er det ikke helt umulig at dette kan være en idé.)

3. Undersøke om man kan gjøre noe lurt med "forhåndsbestemt søk"-funksjonaliteten

4. Appellere til "EU" om å fikse responstiden

5. Undersøke om det kan søkes med noe annet enn fnr/pensak-id

6. Undersøke å starte kallet tidligere i app'en

7. Unngå å liste alle buc'er (arbeidsflyt til saksbehandlere)

8. Bygge et nytt EUX-endepunkt som går rett mot databasen

9. Lage skygge-database av sammenhengen mellom ident/pensak-id og rinasak (gjennom f eks trigger på tabeller i Rina-databasen)

10. Bygge opp en indeks av sammenheng mellom ident/pensak-id og rinasak, basert på hendelser på Kafka eller liknende

11. Ta Pensjons-sakene ut av felles-Rina

12. Undersøke om det nye endepunkt på EUX (`v2/person/{fnr}/saker/oversikt`) er raskere og evtkan erstatte dagens HentRinaSaker

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
