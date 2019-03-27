# [short title of solved problem and solution]

* Status: in progress [accepted | proposed | deprecated | …]
* Deciders: @kjetiljd, @mammut89, @jensnav [list everyone involved in the decision]
* Date: [YYYY-MM-DD when the decision was last updated]

Technical Story: [description | ticket/issue URL] <!-- optional -->

https://github.com/navikt/eessi-pensjon/blob/feature/ADR-for-API/docs/adr/oidc-ark-integrasjon-idporten.PNG

## Context and Problem Statement

Vi har i dag to komponenter som deler ett repository:
* API-SBS - kjører i selvbetjeningssonen (SBS); tilbyr tjenester til frontend for _borgere_; kaller videre (via API Gateway) til API-FSS, samt til S3 i SBS(?)
* API-FSS - kjører i fagsystemsonen (FSS); tilbyr tjenester til frontend for saksbehandlere og kaller nav registre for SBS soinen

Det meldes om "API-spaghetti" - og er reist spørsmål om vi bør gjøre noe med dette.

Problemmer:
1.  Vi har kode som skal kun kjøres i en sone tilgjengelig i begge soner. Dette fører til overflødig kode i visse tilfeller.
2.  Applikasjonen må hele tiden holde styr på hvilken sone den kjører i sånn at den velger riktig variant av en metode. Testene må også skrives deretter i henhold til sone.
3.  Unødvendig videresendingskall fra SBS til FSS som til slutt egentlig skal til en 3. tjeneste. Dette gjelder oggså kall fra FSS   saksbehandler UI i FSS api og videresenderkall til f.eks fagmodul.

## Decision Drivers

* Utvikleropplevelse - Forenkle verdikjeden. Forenkle kodestrukturen med renere skille. 


* Deploymentforhold - i dag deployes det som to komponenter i relativt rask rekkefølge
* [driver 3, e.g., a force, facing concern, …]
* [driver n, e.g., a force, facing concern, …]
* … <!-- numbers of drivers can vary -->

## Considered Options

* La det være slik det er (i én kodebase)
* Splitte i to kodebaser
* Fjerne API-FSS, opprett 1 eller flere applikasjoner med nytt navn som har konkret ansvarsområde
* Fikse på problemene med at det er i én kodebase

## Decision Outcome

Chosen option: "[option 1]", because [justification. e.g., only option, which meets k.o. criterion decision driver | which resolves force force | … | comes out best (see below)].

### Positive Consequences

Mindre kode i hver kodebase. Mer lesbart hvilke tjenester som tilbys av hvilken app. 
Mindre sjangse for produksjonsfeil fordi man forsøkte å kjøre en kode i feil sone, eller at kode som ikke skulle vært kjørt ble kjørt i feil sone.

* [e.g., improvement of quality attribute satisfaction, follow-up decisions required, …]
* …

### Negative consequences

Det tar litt tid å utføre dette
* [e.g., compromising quality attribute, follow-up decisions required, …]
* …

## Pros and Cons of the Options <!-- optional -->

### La det være slik det er i én kodebase

[example | description | pointer to more information | …] <!-- optional -->

Bra fordi da bruker vi ikke tid på det nå og kan fokusere på conformance test
Dårlig fordi det vil fortsette å oppstå feil og det vil fortsette å ta lenger tid å utvikle på API
 
* Good, because [argument a]
* Good, because [argument b]
* Bad, because [argument c]
* … <!-- numbers of pros and cons can vary -->

### Splitte i to kodebaser

Bra fordi da har vi et klart lesbart skille av hva som utføres av hvilken applikasjon. Mindre feil. Kortere tid å utvikle og forstå koden i fremtiden

[example | description | pointer to more information | …] <!-- optional -->

* Good, because: mindre <spaghetti>
* Good, because [argument b]
* Bad, because [argument c]
* … <!-- numbers of pros and cons can vary -->

### Fjerne API-FSS

Bra for da kan vi lage mer granulert microservices som har mer avgrensede ansvarsområder.
Dårlig fordi da må vi bruker litt mer tid på å utføre dette. Frontend må for eksempel søtte CORS for flere pather/apper

[example | description | pointer to more information | …] <!-- optional -->

* Good, because: en komponent mindre å vedlikeholde
* Good, because [argument b]
* Bad, because [argument c]
* … <!-- numbers of pros and cons can vary -->

### Fikse på problemene med at det er i én kodebase

Dårlig for det er et tidsspørsmål før vi uansett må gjøre dette. Det vil smerte mer og med med tiden og bli mer og mer vanskelig å løsrive.

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