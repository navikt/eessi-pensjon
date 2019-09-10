# Delegering av tilgangsskontroll

* Status: Proposed
* Deciders: Mo Amini, Øyvind Buer, Petter Lowzow, Kjetil Jørgensen-Dahl, Jens Madsen
* Date: 2019-09-20

Technical Story: [EESSIPEN-543](https://jira.adeo.no/browse/EESSIPEN-543)

## Context and Problem Statement

EESSI Pensjon har et krav om tilgangsstyring til saksbehandler-grensesnittet, se [EESSIPEN-543](https://jira.adeo.no/browse/EESSIPEN-543) for nærmere beskrivelse.

Tilgangsstyring har tradisjonelt blitt løst med ABAC i NAV-løsninger, men etterhvert som team har tatt over ansvaret for utvikling, forvaltning og applikasjonsdrift er det team som velger å selv løse tilgangsstyringen for løsninger som teamet har ansvar for.

Oversikt over ABAC-regler finnes her:
- [ABAC Klartekst av forretningspolicyer](https://confluence.adeo.no/display/ABAC/ABAC+Klartekst+av+forretningspolicyer)

ABAC håndterer i dag i all hovedsak fire regler for saksbehandling:
* kode 6 - ren tilgangsstyring
* kode 7 - (som egentlig styrer at det skal behandles spesielt)
* navansatt (om man er Nav-ansatt kan man reservere seg mot oppslag)
* om det er oppslag på en selv.
* en regel om geografi - som det stilles spørsmål ved om faktisk gir sikkerhetsrelatert verdi i praksis (man begrenser ikke tilgangen til å behandle i eget geografisk område - men i andre)

I tillegg finnes det noen pensjonsrelaterte regler:
- [ABAC Klartekstpolicies felles for pensjon](https://confluence.adeo.no/display/ABAC/ABAC+Klartekstpolicies+felles+for+pensjon)

Av disse ser det ut til at det er to regler som er knyttet til utenlandsområdet:
* Saksbehandler tilgang til utenlands pensjonsak
* Saksbehandler tilgang til utenlands uføresak

Begge disse reglene er knyttet til roller i AD.

Noen retningslinjer som har blitt brukt i slike vurderinger tidligere er:
* Sikkerhet skal legges nær kilden til informasjon/data
* Den som eier informasjonen skal også beskytte den mot misbruk.
* Zero trust - Vi stoler i utgangspunktet ikke på noen.

Det er to forskjellige sett av informasjon som skal håndteres korrekt.
* Kontekst som kallet av tjenesten skjer i
* Informasjon som skal hentes

* Logikken man trenger anses som enkel å implementere

## Decision Drivers

* Risiko
  * Risiko og konsekvens knyttet til feil
  * Kompleksitet i implementasjon
  * Kompleksitet i testing / kvalitetssikring
* Brukervennlighet
  * Mulighet til å gi presis informasjon til bruker årsak til avslag på tilgang
* Endringer og endringsfrekvens på regler
* Utviklingshensyn
  * Utviklingsomfang
  * Utviklingsavhengigheter
  * Deling av domenespesifikke regler
  * Testing under utvikling
  * Utvikling på laptop
* Kjøretidshensyn
  * Kjøretidsavhengigheter
  * Nedetidsfri deploy
  * Responstider
* Eierskap til sikkerhetsimplementasjonen
* Tilgangskontroll-behovene
  * Generelle krav
  * Behov for egne tilpasninger


## Decision Outcome

Vi velger å delegere tilgangsskontroll til avgivende system ved å passe på å propagere brukerkontekst.
EESSI Pensjon har i dag kun informasjon som er hentet fra andre. Dette er informasjon som dermed skal sikres av systemene rundt oss.

Vi har tro på at dette gir tilstrekkelig sikkerhet med mindre innsats enn de andre løsningene.

For å skape trygghet for at tilgangskontrollen er ivaretatt lager vi tester som kontrollerer at reglene håndheves. Testene må sjekke de felles ABAC-reglene (kode 6, kode 7, egen ansatt og seg selv), samt "utlandstilgang" for pensjon og uføre.

Dersom testene avdekker hull vil vi først se om vi kan løse problemet med mer kontekst i kall til andre systemer, evt med enkle kall som verifiserer tilgangen.
Dersom det ikke gir tilstrekkelig tilgangskontroll må vi revidere denne beslutningen.

### Positive Consequences

* Mindre arbeid og kode for å etablere og vedlikeholde tilgangskontroll i EESSI Pensjon
* Tester vil avsløre at noe er galt, hos oss eller i avgivende systemer
* EESSI Pensjon gjør ikke redundante sjekker
* Ingen nye avhengigheter til "sentrale" løsninger

### Negative consequences

* Risiko for at vi må endre beslutningen dersom vi ikke klarer å gjennomføre denne fremgangsmåten
* Det kan oppstå hull dersom andres mekanismer svikter (i fremtiden)
* Det kan være vanskelig å teste dette siden det stiller krav til systemer utenfor teamets kontroll – vi er også spent på om vi klarer å automatisere testene
* Usikkert om vi klarer å propagere tilstrekkelig årsak til avslag på tilgang

---

## Considered Options

1. Beholde dagens forenklede løsning (inntil videre)
2. Bruke sentral ABAC til tilgangsstyring i EESSI Pensjon sine komponenter
3. Bruke egen ABAC-instans til tilgangsstyring i EESSI Pensjon sine komponenter
4. Implementere tilgangsstyring selv for EESSI Pensjon sine komponenter
5. Implementere tilgangsstyring selv for EESSI Pensjon som bibliotek
6. Delegere til avgivende system ved å passe på å propagere brukerkontekst (_on_behalf_of_?)
7. Kombinere 4/5 og 6
8. Spørre avgivende system om tilgangen (dersom Pesys eier "saken")?


## Pros and Cons of the Options

### 1. Beholde dagens forenklede løsning (inntil videre)

* Bra, fordi ingen endringer betyr mer tid til å løse andre viktige oppgaver i forbindelse med Conformance Test og prodsetting mot EU
* Bra, fordi vi har ikke hatt tekniske eller faglige problemer med dagens løsning
* Dårlig, fordi det er en grov tilgangsstyring , enten har saksbehanbdler tilgang til alt eller ingenting
* Dårlig, fordi teamet må vedlikeholde alle saksbehandlere som har tilgang manuelt, ny saksbehandler eller fjerning av saksbehandler fører til en oppgave for teamet
* Dårlig, fordi tilgangskontrollen i EP oppfører seg forskjellig i forhold til PSAK i PESYS

### 2. Bruke sentral ABAC til tilgangsstyring i EESSI Pensjon sine komponenter

* Bra, fordi felles tilgangskontroll regler kan gjenbrukes, det betyr at vi slipper å tenke ut reglene og siden policiene er felles oppstår ikke situasjoner hvor en applikasjon gir Deny mens en annen applikasjon gir Permit i en og samme verdikjede
* Bra, fordi policiene er dokumentert et felles sted og dersom det oppstår et problem er det et felles sted å sjekke dokumentasjon og en eventuell feil
* Bra, fordi hvis et problem oppstår er det stor sannsynelighet for at mange team opplever det samme og vil rapportere og løse den felles feilen raskt
* Bra, fordi saksbehandler vikl oppleve lik tilgang i EP og PSAK
* Dårlig, fordi enkle regler krever mange kall og nettverkshopp i kompleks verdikjede som kunne vært løst med en enkel if setning i den aktuelle applikasjonen
* Dårlig, fordi når KES teamet oppdaterer visse deler av sine applikasjoner , PDP / PIP vil det være nedetid, nedetid med Deny bias fører til at saksbehandler stoppes i sitt arbeid og teamet må bruke tid på å følge opp problemet
* Dårlig, fordi man ikke får informasjon om hvilke regler som brytes
* Dårlig, fordi det er vanskelig å teste
* Dårlig, fordi reglene utvikles i proprietært språk

### 3. Bruke egen ABAC-instans til tilgangsstyring i EESSI Pensjon sine komponenter

* Samme pros and cons som punkt 2. med unntak av at vi slipper nedetid, men har istedet enda en applikasjon å vedlikeholde og overvåke


### 4. Implementere tilgangsstyring selv for EESSI Pensjon sine komponenter


* Bra, fordi våre regler er enkle og kan løses med få enkle linjer kode og få nettverkshopp - mye mindre kompleksitet enn med ABAC
* Bra, fordi vi får færre avhengigheter til eksterne applikasjoner
* Bra, fordi vi slipper avhengighet til "ABAC-teamet" og deres backlog
* Bra, kan skrive enhets- og modultester som gjør oss trygge, kan enklere testes / mockes / kjøres
* Bra, fordi teamet må ta ansvar for sikkerheten
* Bra, bruker vanlige utviklerkompetanse for å lage og endre sikkerheten
* Dårlig, fordi vi må ha flere systembrukertilganger (kanskje)
* Dårlig, fordi vi får ikke godene ved å ha felles policies som nevnt i de øvrige punktene
* Kan legge på caching selv (knyttet til ytelsen - dersom det er behov)
* Uavhengighet til ABAC i forhold fremtid i skyen?

### 5. Delegere til avgivende system ved å passe på å propagere brukerkontekst (_on_behalf_of_?)

[example | description | pointer to more information | …] <!-- optional -->

* Good, fordi vi slipper å utvikle/vedlikeholde regler i vår kode
* Dårlig, fordi vi risikerer å tilgjengeliggjøre saksbehandler funksjonalitet som ved bruk viser seg å ikke ha tilgang til alikevel


### 6. Spørre avgivende system om tilgangen (dersom Pesys eier "saken")?

* Good, fordi vi slipper å utvikle/vedlikeholde regler i vår kode
* Dårlig, fordi vi får flere avhengigheter til eksterne applikasjoner og team
* Dårlig, fordi flere avhengigheter må mockes i tester


## Other comments used pre-decision

For at en tjeneste skal kunne hindre tilgang må den stole på konteksten som sendes inn. I praksis er det sertifikater/tokens som sikrer at nødvendig tillit er til stede.

I en kjede av tjenestekall vil første kall kunne ha en mer detaljert kontekst enn siste kall. Det kan/vil skje en kontekstendring fra pålogget bruker til systembruker underveis. Med en mindre detaljert kontekst så vil sjekken om tilgang bli tilsvarende enklere.

Når tjenesten returnerer må det sjekkes om kallende applikasjon skal ha tilgang til informasjonen som er hentet opp. Det er kombinasjonen kontekst og returnert informasjon som vil avdekke om det skal gis tilgang. I en lang kallkjede så vil resultatet bli forskjellig avhengig av tilgjengelig kontekst.

*PÅSTAND:*
* Ved en kontekstendring i en kallkjede skal bare ny kontekst sendes inn i tjenestekall.
* Alle tjenester må sjekke om kallende applikasjon har tilgang til tjenesten før den kjøres og etterpå må det sjekkes om kallende applikasjon skal ha tilgang til returnt informasjon.
