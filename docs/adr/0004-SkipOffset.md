# En bedre løsning for å hoppe over feilede kafkameldinger

* Status: [accepted | superseeded by [ADR-0005](0005-example.md) | deprecated | …]
* Deciders: [Daniel, Jens, Mariam, Mo]
* Date: 2021-10-14

Technical Story: https://jira.adeo.no/browse/EP-1210

## Context and Problem Statement

Når feil oppstår under konsumering av kafkameldinger har vi en hack for å hoppe over meldingen(ene), dette fører
til at vi mister oversikt over hva vi har hoppet over og glemmer å konsumere meldingen i ettertid.
Ingen mulighet for å rekonsumere meldingen på en rask og enkel måte uten å deploye på nytt.

## Decision Drivers

* Glemmer å behandle hendelse tidsnok
* Manuell arbeid
* Unødvendig deploy
* Vanskelig å verifisere at det er trygt å rekonsumere meldingen
* Applikasjonen stopper helt inntil noen foretar seg noe

## Considered Options

* Benytte S3 for å lagre feilede meldinger, bruke timer/cronjob til å prøve på nytt 
* Benytte s3 for å lagre feilede meldinger, bruke GUI for å rekjøre ( fagperson kan rekjøre uten utvikler)
* Benytte en ny retryTopic som rekjører et par ganger før alternativ over
* Benytte retry med sjekk for hvor langt man har kommet og lage funksjonalitet for hva som mangler
* Splitte opp journalføring sånn at den bare lager journalposten og lager en ny kafkamelding som oppgave tar opp
* 
* … <!-- numbers of options can vary -->

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

https://www.confluent.io/blog/error-handling-patterns-in-kafka/

* [Link type] [Link to ADR] <!-- example: Refined by [ADR-0005](0005-example.md) -->
* … <!-- numbers of links can vary -->
