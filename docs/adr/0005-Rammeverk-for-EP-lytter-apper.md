# [short title of solved problem and solution]

* Status: WIP [accepted | superseeded by [ADR-0005](0005-example.md) | deprecated | …]
* Deciders: Daniel Skarpås, Mariam Pervez, Kjetil JD [list everyone involved in the decision]
* Date: [YYYY-MM-DD when the decision was last updated]

Technical Story: [description | ticket/issue URL] <!-- optional -->

## Context and Problem Statement

EESSI Pensjon-teamet sin løsning har etterhvert blitt til omkring ti app'er, hvorav de fleste er asynkrone og tilstandsløse app'er som konsumerer fra Kafka og enten produserer til Kafka eller oppdaterer eksterne tjenester. Disse app'ene har mye av de samme tekniske behovene/funksjonene og til en viss grad deler de også behov innenfor EESSI-pensjon-domenet (som SED-modell-info). Det er derfor en god del duplisering mellom disse app'ene, noe som gjør det tidkrevende med både oppdatering av bibliotek, men også om man finner feil eller ønsker å rydde.  

Per i dag er noe fellesfunksjonalitet tatt ut i bibliotek (det er laget seks slike), men det er fortsatt ganske mye _mer eller mindre_ boilerplate, felles tekniske og funksjonelle "behov" – som må dekkes i mange eller alle app'ene.

Kan det å lage en felles "rammeverkskomponent" som tar unna mye "boilerplate" være lurt, slik at en app bare trenger å legge til sin konfigurasjon og sin spesifikke funksjonalitet?

[Describe the context and problem statement, e.g., in free form using two to three sentences. You may want to articulate the problem in form of a question.]

## Decision Drivers

* Tid til å utvikle/trekke ut/bygge en rammeverkskomponent
* Kompetanse til å lage en rammeverkskomponent
* Kopling mellom app'er (via felles rammeverkskomponent)
* Vedlikehold av avhengigheter som flyttes til rammeverkskomponent
* Vedlikehold av (de-)duplisert kode
* Kompleksitet i koden
* 
* [driver 2, e.g., a force, facing concern, …]
* … <!-- numbers of drivers can vary -->

## Considered Options

* Fortsette som i dag
* Lage en rammeverkskomponent som tas i bruk på (ny) pdl-konsument app i første omgang
* Lage en rammeverkskomponent som tas i bruk på alle Kafka-lytter app'er
* Droppe rammeverkskomponent, lage mer i bibliotek
* Lage mer bibliotek og en modul som inneholder avhengighet til bibliotekene - slik at man bare oppdaterer én avhengighet for alt
* 
* [option x]
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
