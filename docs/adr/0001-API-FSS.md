# [short title of solved problem and solution]

* Status: in progress [accepted | proposed | deprecated | …]
* Deciders: @kjetiljd, [list everyone involved in the decision]
* Date: [YYYY-MM-DD when the decision was last updated]

Technical Story: [description | ticket/issue URL] <!-- optional -->

## Context and Problem Statement

Vi har i dag to komponenter som deler ett repository:
* API-SBS - kjører i selvbetjeningssonen (SBS); tilbyr tjenester til frontend for _borgere_; kaller videre (via API Gateway) til API-FSS, samt til S3 i SBS(?)
* API-FSS - kjører i fagsystemsonen (FSS); tilbyr tjenester til frontend for _saksbehandlere_; kaller videre til en rekke tjenester i FSS-sonen

Det meldes om "API-spaghetti" - og er reist spørsmål om vi bør gjøre noe med dette.

## Decision Drivers

* Utvikleropplevelse - <...>
* Deploymentforhold - i dag deployes det som to komponenter i relativt rask rekkefølge
* [driver 3, e.g., a force, facing concern, …]
* [driver n, e.g., a force, facing concern, …]
* … <!-- numbers of drivers can vary -->

## Considered Options

* La det være slik det er (i én kodebase)
* Splitte i to kodebaser
* Fjerne API-FSS
* Fikse på problemene med at det er i én kodebase
* <finnes det flere alternativ?>

## Decision Outcome

Chosen option: "[option 1]", because [justification. e.g., only option, which meets k.o. criterion decision driver | which resolves force force | … | comes out best (see below)].

### Positive Consequences

* [e.g., improvement of quality attribute satisfaction, follow-up decisions required, …]
* …

### Negative consequences

* [e.g., compromising quality attribute, follow-up decisions required, …]
* …

## Pros and Cons of the Options <!-- optional -->

### La det være slik det er i én kodebase

[example | description | pointer to more information | …] <!-- optional -->

* Good, because [argument a]
* Good, because [argument b]
* Bad, because [argument c]
* … <!-- numbers of pros and cons can vary -->

### Splitte i to kodebaser

[example | description | pointer to more information | …] <!-- optional -->

* Good, because: mindre <spaghetti>
* Good, because [argument b]
* Bad, because [argument c]
* … <!-- numbers of pros and cons can vary -->

### Fjerne API-FSS

[example | description | pointer to more information | …] <!-- optional -->

* Good, because: en komponent mindre å vedlikeholde
* Good, because [argument b]
* Bad, because [argument c]
* … <!-- numbers of pros and cons can vary -->

### Fikse på problemene med at det er i én kodebase

[example | description | pointer to more information | …] <!-- optional -->

* Good, because: mindre <spaghetti>
* Good, because [argument b]
* Bad, because [argument c]
* … <!-- numbers of pros and cons can vary -->

### [option n]

[example | description | pointer to more information | …] <!-- optional -->

* Good, because [argument a]
* Good, because [argument b]
* Bad, because [argument c]
* … <!-- numbers of pros and cons can vary -->

## Links <!-- optional -->

* [Link type] [Link to ADR] <!-- example: Refined by [ADR-0005](0005-example.md) -->
* … <!-- numbers of links can vary -->
