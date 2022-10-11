# Inkonsistent API mellom frontend og backend - spesielt for feilhåndtering [FYLL INN solution]

* Status: [accepted | superseeded by [ADR-0005](0005-example.md) | deprecated | …]
* Deciders: [list everyone involved in the decision]
* Date: [YYYY-MM-DD when the decision was last updated]

Technical Story: [description | ticket/issue URL] <!-- optional -->

## Context and Problem Statement

Sluttbrukere av EESSI-pensjon sin saksbehandlings-app får dårlige feilmeldinger på ulike formater.
Feilmeldingene som kommer fra backend (saksbehandling-api og fagmodul) har ymse ulike
payloads som varierer etter api og etter hva feilen er/hvor den kommer fra. I noen tilfeller er det feil fra
bakenforliggende systemer som propageres uendret, i andre tilfeller er det feilmeldinger som lages i våre
komponenter.

## Decision Drivers

* Arbeidsmengde, teamet har lite kapasitet
* Potensiale for gevinster utover bedre feilmeldinger
* Mulighet for samtidig å rydde i dagens API'er og app'er
* Kompleksitet i den endelige løsningen
* … <!-- numbers of drivers can vary -->

## Considered Options

0. La ting være som det er
1. Nytt contract-driven API basert på OpenAPI og kodegenerering (med http-problem)
1. Dagens API brukes som utgangspunkt for OpenAPI og så introduseres http-problem
1. http-problem tas i bruk på dagens API (ingen kontrakt med OpenAPI)
1. ??
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

* [Link type] [Link to ADR] <!-- example: Refined by [ADR-0005](0005-example.md) -->
* … <!-- numbers of links can vary -->
