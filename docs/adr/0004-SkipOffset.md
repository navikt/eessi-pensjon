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
* Bruke GUI for å rekjøre ( fagperson kan rekjøre uten utvikler)
* Benytte en ny retryTopic (deadletterqueue) som rekjører et par ganger før alternativ over
* Gjøre ingenting, ingen forbedringer
* … <!-- numbers of options can vary -->

## Decision Outcome

Chosen option: 2, Denne vil dekke et bredere spekter av feilede hendelser, samt gi en god oversikt over hendelsene. 
Fagperson kan også legge inn kommentar til hva som er årsaken til problemet. Dette valget vil også hinde JF i å stoppe.

### Positive Consequences

* Denne løsningen vil dekke et bredere spekter av feilede hendelser, samt gi en god oversikt over hendelsene.
  Fagperson kan også legge inn kommentar til hva som er årsaken til problemet. Dette valget vil også hinde JF i å stoppe.

### Negative consequences

* [e.g., compromising quality attribute, follow-up decisions required, …]
* …

## Pros and Cons of the Options <!-- optional -->

### 1.) Benytte S3 for å lagre feilede meldinger, bruke timer/cronjob til å prøve på nytt


* Good, fordi vi ikke benytter oss av noen enkel db.
* Good, rask til å hente ut data, kjent api, enkel api da den benyttes på andre av våre apper.
* Bad, må ha kjennskap til koden og db for å forstå mappingen

### 2.) Bruke GUI for å rekjøre hendelser ( fagperson kan rekjøre meldinger uten assistanse fra utvikler)

Tar utgangspunkt i at vi fremdeles benytter s3 for å lagre feilede meldinger <!-- optional -->


* Good, da vi får en fin oversikt via et grafisk grensesnitt.
* Good, fristiller utvikler til å ta til seg andre oppgaver, da fagperson kan selv betjene denne tjenesten selv
* Bad, må involvere frontendutvikler
* Bad, må ha tilgangskontroll/token (komplekst)

### 3.) Benytte en ny retryTopic og errorTopic som rekjører et par ganger før alternativ over

Meldinger som ikke går igjennom etter retry havner på errorTopicen <!-- optional -->

* Good, automatisert rekjøring av feilede hendelser 
* Good, enkelt å sette opp
* Bad, noen av de feilede vil mest sannsynlig feile igjen og deretter havne på errortopicen
* Bad, errortopicen krever manuell håndtering
* … <!-- numbers of pros and cons can vary -->

### 4.) Gjøre ingenting

* Good, gjøre ingenting 
* Bad, da problemet ikke blir borte.

## Links <!-- optional -->

https://www.confluent.io/blog/error-handling-patterns-in-kafka/

* [Link type] [Link to ADR] <!-- example: Refined by [ADR-0005](0005-example.md) -->
* … <!-- numbers of links can vary -->
