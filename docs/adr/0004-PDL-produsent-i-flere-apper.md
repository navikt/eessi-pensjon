# [short title of solved problem and solution]

* Status: WIP [accepted | superseeded by [ADR-0005](0005-example.md) | deprecated | …]
* Deciders: Mariam Pervez, Daniel Skarpås, Kjetil JD
* Date: [YYYY-MM-DD when the decision was last updated]

Technical Story: Relatert til [EP-1229 Innlesing av data fra SED til PDL](https://jira.adeo.no/browse/EP-1229)

## Context and Problem Statement

I SED'er fra utlandet mottar EESSI Pensjon informasjon om brukeres utenlandske identifikasjonsnummer (id'er), samt adresser. I mange tilfeller er dette data fra offiselle utenlandske kilder og NAV er derfor interessert i at dette meldes inn til Persondataløsningen (PDL).

Løsning for å melde utenlandske id'er er laget i app'en [eessi-pensjon-pdl-produsent](https://github.com/navikt/eessi-pensjon-pdl-produsent), som lytter på innkommende SED'er (på Kafka), vurderer opplysningene i SED opp mot PDL og enten generer en endringsmelding, lager en oppgave til saksbehandler, eller ignorerer dersom adressen er kjent.  

Å melde inn adresser til PDL har en del fellestrekk (inkludert en del felles kode) med å melde inn utenlandske id'er, men samtidig blir oppdateringen _separate_ kall mot PDL, og dermed er det en risiko for at den ene oppdateringen lykkes, mens den andre feiler - som gjør at vi ikke kan ACK'e en melding for begge deler og unngå potensiell dobbeltbehandling eller mistede oppdateringer. Vi har derfor bestemt oss for å ha to uavhengige lyttere. Spørsmålet denne ADR'en tar opp er om vi skal ha én eller to app'er. 

## Decision Drivers

* (U)avhengighet mellom kjøreinstanser
* Kodeduplisering
* Vedlikehold av app'er
* Initiell innsats med å sette opp to app'er
* 
* [driver x, e.g., a force, facing concern, …]
* … <!-- numbers of drivers can vary -->

## Considered Options

* Én app, to lyttere
* To uavhengige app'er (med hver sin lytter)
* Én kodebase, men to app'er, som kjører opp hver sin lytter.
* To app'er, mest mulig i bibliotek
* 
* 

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
