---
name: etterlev
description: >-
  Dokumenterer et etterlevelseskrav for EESSI Pensjon. Tar inn krav-ID
  (f.eks. K255.1), leser agent-input-filen og utfører oppgaven beskrevet der.
model: claude-opus-4.8
agent: eessi-pensjon-etterlevelse
---

# Etterlev — Dokumenter etterlevelseskrav

Denne skillen tar inn en krav-ID og utfører etterlevelsesdokumentasjonen beskrevet i den tilhørende agent-input-filen.

> **Agent:** Denne skillen skal kjøres med agenten **eessi-pensjon-etterlevelse** (`@eessi-pensjon-etterlevelse`).
> Bytt til agenten med `/agent eessi-pensjon-etterlevelse` før du utfører stegene under.
>
> **Modellkrav:** Bruk **Claude Opus 4.8** (`/model claude-opus-4.8`).

## Input

Brukeren kan oppgi en krav-ID direkte, f.eks.:
- `K255.1`
- `K267.1`

Hvis brukeren **ikke** oppgir en krav-ID (eller bare skriver `/etterlev` uten argument):

1. List alle tilgjengelige krav fra `etterlevelse/agent-input/`-mappen.
2. For hvert krav, vis krav-ID og tittel (les første linje i hver `.txt`-fil for tittelen).
3. **Spør brukeren** (med `ask_user`) hvilket krav de vil dokumentere — vis en liste der de kan velge.

## Steg

0. **Velg krav.** Hvis krav-ID ikke er oppgitt, list tilgjengelige krav fra `etterlevelse/agent-input/` og la brukeren velge (se "Input" over). Fortsett med valgt krav-ID.

1. **Aktiver riktig agent.** Sørg for at agenten `eessi-pensjon-etterlevelse` er aktiv (`.github/agents/eessi-pensjon-etterlevelse.agent.md`). Alle skriveregler, avgrensninger, kilder og arbeidsflyt er definert der.

2. **Sjekk om kravet allerede er dokumentert.** Les `etterlevelse/status.md` og se om krav-IDen allerede har en rad. Hvis ja:
   - Vis brukeren gjeldende status og antall suksesskriterier.
   - List eksisterende filer i `etterlevelse/agent-output/` som matcher krav-IDen.
   - **Spør brukeren** (med `ask_user`) om de vil:
     - **Overskrive** — generere nye tekster som erstatter de eksisterende
     - **Avbryte** — stopp her uten endringer
   - Hvis brukeren velger å avbryte, avslutt skillen.
   - Hvis brukeren velger å overskrive, **ta vare på innholdet i de eksisterende filene** i minnet (for diff-oppsummering til slutt), og fortsett.

3. **Finn agent-input-filen.** Les filen `etterlevelse/agent-input/<krav-ID>.txt` (f.eks. `etterlevelse/agent-input/K255.1.txt`). Hvis filen ikke finnes, si fra til brukeren og foreslå å bruke `/etterlevelse-input` først.

4. **Utfør oppgaven i filen.** Filen inneholder en komplett prompt med:
   - Kravnavn og hensikt
   - Antall tekster som skal lages
   - Suksesskriterier med utfyllende beskrivelser

   Følg instruksjonene i filen som om brukeren hadde limt dem inn direkte. Dette betyr: produser én fil per suksesskriterium i `etterlevelse/agent-output/`.

5. **Følg eessi-pensjon-etterlevelse-agentens regler.** Hele arbeidsflyten er definert i `.github/agents/eessi-pensjon-etterlevelse.agent.md`. Spesielt:
   - Les `architecture.md` for teknisk kontekst
   - Les relevante filer i `etterlevelse/doc/` for bakgrunn
   - Skriv på norsk, klart språk, for lesere som ikke kjenner EESSI Pensjon
   - Ikke start tekster med "Ja, …" eller statusbekreftelse
   - Flagg antagelser i `etterlevelse/apne-sporsmal.md`
   - Oppdater `etterlevelse/status.md`

6. **Bekreft til brukeren.** Oppsummer kort hva som ble produsert (filnavn og 1–2 setninger per fil). Nevn eventuelle åpne spørsmål.

7. **Diff-oppsummering (ved overskriving).** Hvis kravet allerede var dokumentert fra før (steg 2), vis en kort oppsummering av endringene:
   - Hvilke filer som ble lagt til, fjernet eller erstattet
   - For hver erstattet fil: en 1–2 setningers beskrivelse av hva som endret seg (f.eks. "Lagt til avgrensning mot EUX", "Omformulert fra teknisk til funksjonelt språk", "Ny antagelse om backup")
   - Eventuell endring i samlet status (f.eks. "Status endret fra Ja (delvis) → Ja")
