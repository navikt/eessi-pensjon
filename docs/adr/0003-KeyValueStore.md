# Valg av lagringsmedie/rammeverk for enkel persistering av data

* Status: In progress
* Deciders: Mo Amini, Jens Madsen, Nicolas Nordhagen, Daniel Skarpås, Mariam Pervez
* Date: 2021-01-13

Technical Story: https://jira.adeo.no/browse/EP-858 

## Context and Problem Statement
EESSI Pensjon har behov for å persistere data under preutfylling / statistikk generering i asynkrone prosesser. Til nå har vi hentet data fra Kafka og S3. 
Vi ser behovet for en key-value database

## Decision Drivers

* Risiko
    * Kompleksitet i implementasjon
    * Kompleksitet i testing / kvalitetssikring
* Utviklingshensyn
    * Utviklingsomfang
    * Utviklingsavhengigheter
    * Testing under utvikling
    * Plattform avhengighet ( GCP )
* Tidsforbruk
    * Kompetanse i teamet

## Considered Options

* PostgreSQL
* S3
* Redis
* Aiven
* Eksisterende registre


## Decision Outcome


### Positive Consequences


### Negative consequences


## Pros and Cons of the Options

1. PostgreSQL

* Bra, fordi det er kjent teknologi , de fleste kan SQL 
* Bra, mange bruker det og fungerer greit
* Bra, det finnes en egel postgeSQL kanal med et fagmiljø på slack
* Dårlig, overkill for dette formålet
* Dårlig, relasjonsdatabaser har en tendens til å ese ut og krever mer tid i vedlikehold


2. S3

* Bra, fordi det er kjent teknologi , vi bruker det allerede
* Bra, det er enkelt å ta i bruk
* Bra, det er en key-value store
* Dårlig, en gang mistet vi alt vi hadde på S3 på grunn av problemer på drift

3. Redis

* Dårlig, ukjent teknologi for teamet
* Dårlig, det er ikke persistent ( Kun persistent i GCP memorystore )
* Bra, det er en key-value store
* Bra, mange bruker det og fungerer stabilt
* Bra, in memory , rask cache

4. Aiven

* Dårlig, ingen har kjennskap til det i teamet
* Dårlig, ikke out of the box, må gå opp noen løyper

5. Eksisterende registre

* Bra, enkelt å bruke eksisterende registre i nav for lagring av data, eksempelvis: joark metadata, kafka etc.
* Dårlig, fort gjort å lagre domenespesifike data utenfor domenet
* Dårlig, få use caser hvor det er mulig


## Links 

https://nav-it.slack.com/archives/C60FFACN5/p1610522206319500
