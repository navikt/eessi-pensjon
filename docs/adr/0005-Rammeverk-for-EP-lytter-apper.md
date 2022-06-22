# [short title of solved problem and solution]

* Status: WIP [accepted | superseeded by [ADR-0005](0005-example.md) | deprecated | …]
* Deciders: Daniel Skarpås, Mariam Pervez, Kjetil JD [list everyone involved in the decision]
* Date: [YYYY-MM-DD when the decision was last updated]

Technical Story: [description | ticket/issue URL] <!-- optional -->

## Context and Problem Statement

EESSI Pensjon-teamet sin løsning har etterhvert blitt til omkring ti app'er, hvorav de fleste er asynkrone og tilstandsløse app'er som konsumerer fra Kafka og enten produserer til Kafka eller oppdaterer eksterne tjenester. Disse app'ene har mye av de samme tekniske behovene/funksjonene og til en viss grad deler de også behov innenfor EESSI-pensjon-domenet (som SED-modell-info). Det er derfor en god del duplisering mellom disse app'ene, noe som gjør det tidkrevende med både oppdatering av bibliotek, men også om man finner feil eller ønsker å rydde.  

Per i dag er noe fellesfunksjonalitet tatt ut i bibliotek (det er laget seks slike), men det er fortsatt ganske mye _mer eller mindre_ boilerplate, felles tekniske og funksjonelle "behov" – som må dekkes i mange eller alle app'ene.

Kan det å lage en felles "rammeverkskomponent" som tar unna mye "boilerplate" være lurt, slik at en app bare trenger å legge til sin konfigurasjon og sin spesifikke funksjonalitet?

Fra _Object Design: Roles, Responsibilities, and Collaborations_ av Rebecca Wirfs-Brock:

> Frameworks offer a number of advantages to the developer:
> * Efficiency: A framework means less design and coding.
> * Consistency: Developers become familiar with the approach imposed by the framework.
> * Predictability: A framework has undergone several iterations of development and testing.

> But they don’t come without costs:
> * Complexity: Frameworks often have a steep learning curve.
> * If you only have a hammer, everything looks like a nail: Frameworks require a specific approach to solving the problem.
> * Performance: A framework often trades flexibility and reusability for performance.

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

0. Fortsette som i dag
1. Lage en rammeverkskomponent som tas i bruk på (ny) pdl-produsent app, i første omgang
2. Lage en rammeverkskomponent som tas i bruk på alle Kafka-lytter app'er
3. Lage en rammeverkskomponent som tas i bruk på én eksisterende app i første omgang
4. Droppe rammeverkskomponent, lage mer i bibliotek
5. Lage mer bibliotek og en modul som inneholder avhengighet til bibliotekene - slik at man bare oppdaterer én avhengighet for alt
6. 
7. [option x]
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

### 0. Fortsette som i dag

Dvs lage nye app'er ved behov og av og til trekke ut felles funksjonalitet i bibliotek.

* Good, because dette vet vi hvordan vi gjør.
* Good, because app'er er praktisk talt uavhengige av hverandre.
* Bad, because det er mye boilerplate som går igjen mellom app'er.
* Bad, because det blir mye duplisering, eller mange avhengigheter å oppdatere.
* 
* … <!-- numbers of pros and cons can vary -->

### 1. Lage en rammeverkskomponent som tas i bruk på (ny) pdl-produsent app, i første omgang

Gjøre dette som en del av pdl-adresse-saken. 

* Good, because det er en reell oppgave som vi skal jobbe med
* Good, because det gir oss en rammeverkskomponent.
* Bad, because det øker risikoen på tid på pdl-adresse-oppgaven
* Bad, because det skaper avhengighet mellom de to oppgavene
* Bad, because det utsetter arbeidet med å få app'ene over på ny komponent
* 
* … <!-- numbers of pros and cons can vary -->

### 2. Lage en rammeverkskomponent som tas i bruk på alle Kafka-lytter app'er

Dvs lage en rammeverkskomponent og ta den i bruk på alle Kafka-lytter app'er.

* Good, because da blir jobben gjort ...
* Good, because det blir betydelig redusert kodebase 
* Bad, because det er sannsynligvis mye jobb, og vil påvirke andre oppgaver
* 
* … <!-- numbers of pros and cons can vary -->

### 3. Lage en rammeverkskomponent som tas i bruk på én eksisterende app i første omgang

Dvs lage en rammeverkskomponent og ta den i bruk på én eksisterende app'er, først.

* Good, because det fjerner avhengighet til pdl-adresse-oppgaven
* Good, because det gir oss en rammeverkskomponent
* Bad, because det utsetter arbeidet med å få app'ene over på ny komponent
* Bad, because pdl-adresse-app'en vil lage enda mer duplisering enn vi har fra før 
* 
* … <!-- numbers of pros and cons can vary -->

### 4. Droppe rammeverkskomponent, lage mer i bibliotek

Lage mer bibliotek.

* Good, because det reduserer kodeduplisering
* Good, because det er en enklere oppgave
* Bad, because det øker antall avhengigheter i app'ene
*
* … <!-- numbers of pros and cons can vary -->

### 5. Lage mer bibliotek og en modul som inneholder avhengighet til bibliotekene - slik at man bare oppdaterer én avhengighet for alt

Lage en (eller flere?) "modul" som inkluderer felles avhengigheter som app'er bruker.

* Good, because det reduserer antall avhengigheter som må oppdateres
* Bad, because vi vil fortsatt ha en del boilerplate i app'ene
* Bad, because det øker koplingen mellom bibliotekene
* Bad, because det er risiko for at app'er kan feil'e på ett av bibliotekene, og da kan det være vanskelig å se hvilket.
* 
* … <!-- numbers of pros and cons can vary -->

## Links <!-- optional -->

* [Link type] [Link to ADR] <!-- example: Refined by [ADR-0005](0005-example.md) -->
* … <!-- numbers of links can vary -->
