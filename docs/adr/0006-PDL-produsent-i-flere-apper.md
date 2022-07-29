# Én PDL-produsent-app med to lyttere på samme topic 

* Status: Accepted
* Deciders: Kjetil JD, Daniel S
* Date: 2022-07-11

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

## Considered Options

0. Én app med én lytter
1. Én app, to lyttere (på samme topic)
2. To uavhengige app'er (med hver sin lytter)
3. Én kodebase, men to app'er, som kjører opp hver sin lytter.
4. To app'er, mest mulig i bibliotek

## Decision Outcome

Chosen option: Én app, to lyttere (på samme topic), because fordi vi tror fordelene med å ha dette i én app overveier
det uventede med å ha to lyttere på én topic.

### Positive Consequences

* Mindre duplisering i kodebasen, uten å måtte lage flere komponenter
* Én app å drifte

### Negative consequences

* Har i dag en client-id som ikke indikerer at det handler om lytte med tanke på "id-oppdatering" til PDL, den bør oppdateres, noe som kan være en risky operasjon for man kan komme til å lese alle meldinger på nytt.
* Kan være vrient å få med seg at én av to lyttere på samme topic er nede.

## Pros and Cons of the Options <!-- optional -->

### 0. Én app med én lytter

En lytter på sed-mottatt, som leder til oppdateringer for både id og adresse.

* Bad, because det vil bli problematisk å ACK'e dersom én av de to oppdateringene feiler.

### 1. Én app, to lyttere (på samme topic)

Legge to lyttere i samme pdl-konsument, på samme topic (dvs to group'ids).

* Good, because vi slipper med én app
* Good, because en del logikk er felles og vil være tilgjengelig og ikke trenge duplisering
* Bad, because det er litt forvirrende at én app lytter med to lyttere på samme topic
* Bad, because det operasjonelle blir mer komplisert (kan være i tilstand med én fungerende lytter)
* Bad, because konfigurasjon blir mer komplisert
* Bad, because dagens group id har et generisk navn (som ikke sier at det handler om id)

### 2. To uavhengige app'er (med hver sin lytter)

Lage to uavhengige app'er, i hvert sitt repo.

* Good, because det operasjonelle blir tydeligere
* Good, because app'ene er uavhengige
* Bad, because duplisering
* Bad, because det er en investering up front i å lage app

### 3. Én kodebase, men to app'er, som kjører opp hver sin lytter.

En kodebase, men som kan kjøres i to ulike modus, én for adresse og én for id.

* Good, because det operasjonelle blir tydeligere, men litt mer komplisert
* Good, because en del logikk er felles og vil være tilgjengelig og ikke trenge duplisering
* Bad, because det er et uvant mønster man må være klar over
* Bad, fordi det er kompliserende og kan være vanskelig å oppdage om begge lyttere plutselig er i gang i samme app
* Bad, because det er litt arbeid å lage to modus, kanskje like mye eller mer enn å sette opp to uavhengige app'er

### 4. To app'er, mest mulig i bibliotek

Lage to uavhengige app'er, i hvert sitt repo, men skille ut felles ting i bibliotek (ett eller flere)

* Good, because det operasjonelle blir tydeligere
* Good, because mindre kodeduplisering
* Bad, because det blir mer kopling mellom app'er
* Bad, det mer avhengigheter å holde ajour
* Bad, because det er en investering up front i å lage app

## Links 

* [EP-1229 Innlesing av data fra SED til PDL](https://jira.adeo.no/browse/EP-1229)
* [Skisse på Confluence](https://confluence.adeo.no/x/MkHDGQ)
