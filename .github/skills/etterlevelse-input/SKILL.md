---
name: etterlevelse-input
description: >-
  Tar inn rå tekst kopiert fra etterlevelse-portalen og oppretter en
  agent-input-fil (etterlevelse/agent-input/K<nr>.<versjon>.txt) klar for
  bruk med eessi-pensjon-etterlevelse-agenten.
model: claude-sonnet-4.6
---

# Etterlevelse Input

> **Modellkrav:** Denne skillen skal kjøres med **Claude Sonnet 4.6**.
> Før du utfører stegene under: bytt til `claude-sonnet-4.6` med `/model claude-sonnet-4.6`.
> Når skillen er ferdig, bytt tilbake til forrige modell.

Tar rå tekst kopiert fra etterlevelse-portalen (https://etterlevelse.ansatt.nav.no/) og oppretter en strukturert agent-input-fil som kan brukes av `eessi-pensjon-etterlevelse`-agenten til å dokumentere kravet.

## Hva brukeren gir deg

Brukeren limer inn rå tekst fra portalen. Teksten inneholder typisk:

- **Kravnavn** og **krav-ID** (f.eks. "K255.1 Nav skal beskytte brukere med adressebeskyttelse")
- **Hensikt** — en beskrivelse av hvorfor kravet finnes
- **Suksesskriterier** — en liste med kriterier, hvert med en tittel og en utfyllende beskrivelse

Teksten kan komme i mange formater — det viktige er at du identifiserer:
1. Krav-ID (K<nummer>.<versjon>)
2. Kravnavn/tittel
3. Hensikten med kravet
4. Alle suksesskriterier med tittel og utfyllende beskrivelse

## Hva du skal produsere

Én fil: `etterlevelse/agent-input/K<nummer>.<versjon>.txt`

## Filformat

Filen skal følge dette eksakte formatet:

```
# Hjelp meg å dokumentere: K<nummer>.<versjon> <kravnavn>

## Hensikten med kravet
<hensiktstekst, ren tekst uten HTML-tags, maks ~120 tegn per linje>

## Oppgave til AI
Skriv en tekst til meg for "Hvordan oppfylles kriteriet?" som jeg kan paste inn. ...

du skal lage <N> tekster:

Suksesskriterium 1 av <N>
<kriterietittel>

Utfyllende om kriteriet
<utfyllende beskrivelse, ren tekst uten HTML-tags>

Suksesskriterium 2 av <N>
<kriterietittel>

Utfyllende om kriteriet
<utfyllende beskrivelse>

...
```

## Regler

1. **Strip HTML.** Fjern alle HTML-tags (`<p>`, `<ul>`, `<li>`, `<br>`, `&nbsp;` osv.) fra portalteksten. Behold ren tekst med linjeskift og bindestrek-lister der det passer.
2. **Behold innholdet intakt.** Ikke omformuler, forkorte eller endre meningsinnholdet i hensikt eller suksesskriterier. Du er en formaterer, ikke en redaktør.
3. **Identifiser krav-ID korrekt.** Krav-IDen er på formen K<tall>.<tall>. Finn den i teksten brukeren gir deg. Hvis den ikke er eksplisitt, spør brukeren.
4. **Tell suksesskriterier.** Sett riktig N (antall suksesskriterier) i "du skal lage N tekster:"-linjen.
5. **En tom linje** mellom hvert suksesskriterium (mellom utfyllende tekst og neste "Suksesskriterium X av N").
6. **Filen skal ende med en tom linje.**
7. **Ikke skriv noe annet enn filen.** Ingen markdown-headers i selve filen utover de som er spesifisert i formatet.
8. **Oppgave-teksten** er alltid: `Skriv en tekst til meg for "Hvordan oppfylles kriteriet?" som jeg kan paste inn. ...`
9. **Hvis filen allerede eksisterer**, spør brukeren om den skal overskrives.

## Steg

1. **Parse input.** Les brukerens tekst og identifiser krav-ID, kravnavn, hensikt og suksesskriterier.
2. **Valider.** Bekreft at du har funnet minst krav-ID og ett suksesskriterium. Hvis noe mangler, spør brukeren.
3. **Formater.** Bygg filen etter formatet over.
4. **Skriv til disk.** Lagre filen som `etterlevelse/agent-input/K<nummer>.<versjon>.txt`.
5. **Bekreft.** Si til brukeren hva som ble opprettet: filnavn, kravnavn, og antall suksesskriterier.

## Eksempel

Bruker limer inn:

> K267.1 Applikasjoner skal ha et forsvarlig sikkerhetsnivå
> Hensikt: Alle applikasjoner i Nav skal ha et forsvarlig sikkerhetsnivå...
> Suksesskriterium 1: Vi følger med på og håndterer våre sårbarheter
> Beskrivelse: Applikasjoner skal holdes oppdatert...

Resultat: `etterlevelse/agent-input/K267.1.txt` med riktig format.
