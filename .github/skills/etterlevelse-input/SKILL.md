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

Brukeren gir deg tekst fra portalen på én av to måter:

### Alternativ A: Fil (anbefalt)

Brukeren kjører paste-scriptet fra prosjektroten:
```bash
etterlevelse/script/paste.sh
```
Dette skriver clipboard til `etterlevelse/agent-input/raw.txt`. Deretter ber de deg prosessere filen. **Bruk denne metoden når linjeskift er viktig** — chat-grensesnittet kan strippe linjeskift fra innlimt tekst.

### Alternativ B: Direkte i chatten

Brukeren limer inn teksten direkte i meldingen. **OBS:** Chat-grensesnittet kan fjerne linjeskift, slik at all tekst fremstår som én sammenhengende blokk. Se regel 2 for hvordan dette håndteres.

### Innholdet

Teksten inneholder typisk:

- **Kravnavn** og **krav-ID** (f.eks. "K255.1 Nav skal beskytte brukere med adressebeskyttelse")
- **Tema** — kategorien kravet hører til (f.eks. "Informasjonssikkerhet", "Personvern")
- **Hensikt** — en beskrivelse av hvorfor kravet finnes
- **Suksesskriterier** — en liste med kriterier, hvert med en tittel og en utfyllende beskrivelse

Teksten kan komme i mange formater — det viktige er at du identifiserer:
1. Krav-ID (K<nummer>.<versjon>)
2. Tema
3. Kravnavn/tittel
4. Hensikten med kravet
5. Alle suksesskriterier med tittel og utfyllende beskrivelse

### Tema

Tema er kategorien kravet tilhører i portalen. Gyldige temaer:

- Personvern
- Saksbehandling og forvaltningsrett
- Arkiv og dokumentasjon
- Elektronisk kommunikasjon
- Informasjonssikkerhet
- Interoperabilitet og samhandling
- Likestilling og ikke-diskriminering
- Språk
- Statistikk og styringsinformasjon
- Økonomi

Tema står typisk i portalen sammen med krav-ID, før eller over kravtittelen. Hvis tema ikke kan utledes fra teksten brukeren gir deg, **spør brukeren** hvilket tema kravet tilhører (vis listen over gyldige temaer).

## Hva du skal produsere

Én fil: `etterlevelse/agent-input/K<nummer>.<versjon>.txt`

## Filformat

Filen skal følge dette eksakte formatet:

```
# Hjelp meg å dokumentere: K<nummer>.<versjon> <kravnavn>

Tema: <tema>

## Hensikten med kravet
<hensiktstekst, ren tekst uten HTML-tags, behold originale linjeskift>

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

1. **Strip HTML.** Fjern alle HTML-tags (`<p>`, `<ul>`, `<li>`, `<br>`, `&nbsp;` osv.) fra portalteksten. Behold ren tekst med bindestrek-lister der det passer.
2. **Behold linjeskift fra originalteksten.** Enkle linjeskift i kildeteksten skal beholdes som enkle linjeskift. Doble linjeskift markerer nye avsnitt. Ikke legg inn kunstig linjebryting (f.eks. ved 80 eller 120 tegn). **Fil-input (alternativ A):** Linjeskift i filen er autoritative — behold dem nøyaktig. **Chat-input (alternativ B):** Chat-grensesnittet stripper ofte linjeskift. Hvis teksten mangler linjeskift, be brukeren bruke fil-metoden i stedet, eller inferer avsnitt forsiktig fra kontekst (nye seksjoner i portalen er typisk egne avsnitt). Listelementer (fra `<li>`/`•` i portalen) konverteres alltid til bindestrek-lister på egne linjer.
3. **Behold innholdet intakt.** Ikke omformuler, forkorte eller endre meningsinnholdet i hensikt eller suksesskriterier. Du er en formaterer, ikke en redaktør.
4. **Identifiser krav-ID korrekt.** Krav-IDen er på formen K<tall>.<tall>. Finn den i teksten brukeren gir deg. Hvis den ikke er eksplisitt, spør brukeren.
5. **Tell suksesskriterier.** Sett riktig N (antall suksesskriterier) i "du skal lage N tekster:"-linjen.
6. **En tom linje** mellom hvert suksesskriterium (mellom utfyllende tekst og neste "Suksesskriterium X av N").
7. **Filen skal ende med en tom linje.**
8. **Ikke skriv noe annet enn filen.** Ingen markdown-headers i selve filen utover de som er spesifisert i formatet.
9. **Oppgave-teksten** er alltid: `Skriv en tekst til meg for "Hvordan oppfylles kriteriet?" som jeg kan paste inn. ...`
10. **Hvis filen allerede eksisterer**, spør brukeren om den skal overskrives.

## Steg

1. **Sjekk input-metode.** Hvis `etterlevelse/agent-input/raw.txt` eksisterer, les den med `view`-verktøyet. Hvis teksten er limt direkte i chatten uten linjeskift, be brukeren kjøre `etterlevelse/script/paste.sh` først.
2. **Parse input.** Les teksten og identifiser krav-ID, kravnavn, hensikt og suksesskriterier.
3. **Valider.** Bekreft at du har funnet minst krav-ID og ett suksesskriterium. Hvis noe mangler, spør brukeren.
4. **Formater.** Bygg filen etter formatet over.
5. **Skriv til disk.** Lagre filen som `etterlevelse/agent-input/K<nummer>.<versjon>.txt`.
6. **Rydd opp.** Slett `etterlevelse/agent-input/raw.txt` hvis den eksisterer.
7. **Bekreft.** Si til brukeren hva som ble opprettet: filnavn, kravnavn, og antall suksesskriterier.

## Eksempel

Bruker limer inn:

> K267.1 Applikasjoner skal ha et forsvarlig sikkerhetsnivå
> Hensikt: Alle applikasjoner i Nav skal ha et forsvarlig sikkerhetsnivå...
> Suksesskriterium 1: Vi følger med på og håndterer våre sårbarheter
> Beskrivelse: Applikasjoner skal holdes oppdatert...

Resultat: `etterlevelse/agent-input/K267.1.txt` med riktig format.
