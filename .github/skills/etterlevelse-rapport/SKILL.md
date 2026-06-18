---
name: etterlevelse-rapport
description: >-
  Analyserer ett komponent-repo i EESSI Pensjon-domenet opp mot
  etterlevelseskravene (etterlevelse/agent-input/) og genererer en
  markdown-rapport som dokumenterer komponenten per krav og suksesskriterium.
  Kjøres lokalt i meta-repoet eller automatisk via GitHub Action i et
  komponent-repo.
model: claude-opus-4.8
agent: eessi-pensjon-etterlevelse
---

# Etterlevelse-rapport — komponent vs. etterlevelseskrav

Denne skillen analyserer **én applikasjon/ett bibliotek** i EESSI Pensjon-domenet
(f.eks. `eessi-pensjon-journalforing`) mot alle etterlevelseskravene som er lagt
inn i `etterlevelse/agent-input/`, og skriver en samlet **markdown-rapport** til
komponent-repoet.

Rapporten er en **intern analyse for teamet** — den viser hvordan akkurat denne
komponenten bidrar til (eller er irrelevant for) hvert krav, med konkrete
kodereferanser. Den er **ikke** paste-tekst til etterlevelse-portalen.

> **Agent og modell:** Kjør med agenten **eessi-pensjon-etterlevelse**
> (`/agent eessi-pensjon-etterlevelse`) og **Claude Opus 4.8**
> (`/model claude-opus-4.8`). Agenten gir domenekunnskap, terminologi og
> avgrensninger (mot EUX og mot fagsystemer). **Denne skillen overstyrer
> agentens output-regler:** du skal **ikke** skrive paste-tekst til
> `etterlevelse/agent-output/` og **ikke** oppdatere meta-repoets `status.md`.
> Du produserer kun den ene rapport-fila beskrevet under.

## Skill kontra de andre etterlevelse-skillene

- `/etterlevelse-input` — lager krav-input-filer fra portaltekst (meta-repo).
- `/etterlev` — skriver paste-klar **domene-dekkende** besvarelse per krav til
  portalen (meta-repo).
- `/etterlevelse-rapport` (denne) — skriver en **komponent-spesifikk**
  analyse-rapport i ett komponent-repo. Domene-besvarelsene i meta-repoet svarer
  "oppfyller EESSI Pensjon kravet?"; denne rapporten svarer "hva gjør *denne*
  komponenten for kravet?".

## Hvor input-filene ligger (CI og lokalt)

Krav-inputene og konteksten ligger normalt i meta-repoet `navikt/eessi-pensjon`.
Finn kildene i denne rekkefølgen:

1. **`.etterlevelse-kilde/`** i gjeldende repo — brukes når skillen kjøres i en
   GitHub Action i et komponent-repo. Workflowen laster ned hit:
   - `.etterlevelse-kilde/agent-input/*.txt` — kravene
   - `.etterlevelse-kilde/architecture.md` — domene-arkitektur
   - `.etterlevelse-kilde/agent.md` — agentdefinisjonen (domenekunnskap, skrivestil, avgrensninger)
   - `.etterlevelse-kilde/doc/*.txt` — temaintroduksjoner (valgfritt)
2. **`etterlevelse/agent-input/`** + `architecture.md` i rot — brukes når skillen
   kjøres lokalt fra meta-repoet (da analyserer du en underkatalog, se under).

Hvis ingen av disse finnes, si fra til brukeren og stopp.

## Hvilken komponent analyseres

- **I CI (komponent-repo):** komponenten er gjeldende repo (rotmappen). Navnet
  utledes fra repo-navnet (`basename` av repoet).
- **Lokalt fra meta-repoet:** spør brukeren (`ask_user`) hvilken komponent som
  skal analyseres hvis det ikke er oppgitt — list underkatalogene som finnes i
  `.meta` (f.eks. `eessi-pensjon-journalforing`, `ep-personoppslag`). Analyser da
  den valgte underkatalogen.

## Steg

1. **Finn kilder.** Lokaliser krav-input, `architecture.md` og agentdefinisjonen
   etter rekkefølgen over. Les agentdefinisjonen for domenekunnskap, terminologi
   og avgrensninger.

2. **Bestem komponent.** Avgjør hvilken komponent som analyseres (se over).
   Slå opp komponenten i `architecture.md` for å forstå rollen dens
   (synkron tjeneste / Kafka-lytter / UI / delt bibliotek), integrasjoner,
   dataflyt og hvilke personopplysninger den behandler.

3. **Forstå komponenten fra koden.** Undersøk komponentens kildekode for å danne
   et faktagrunnlag. Relevante spor (tilpass til Kotlin/Java/TypeScript):
   - Kafka-lyttere (`listener/`-pakker, `@KafkaListener`), topics som konsumeres/produseres
   - REST-kontrollere og endepunkter, tilgangsstyring/`@Protected`/Azure AD/OBO
   - Integrasjoner (PDL, PESYS, Dokarkiv/Joark, SAF, Nav Oppgave, NORG2, KRR, DVH, EUX-RINA)
   - Lagring (GCP Storage), logging (`ep-logging`, maskering av fnr), metrikker (`ep-metrics`)
   - Håndtering av fødselsnummer, adressebeskyttelse/gradering, sletting/retting
   - `nais.yaml`/`.nais/` (tilgang, secrets, ingress), avhengigheter, sikkerhetsskanning
   - README og eksisterende dokumentasjon i repoet

4. **Vurder hvert krav.** For **alle** krav i `agent-input/`, og for **hvert
   suksesskriterium** i kravet:
   - Avgjør om kriteriet er **relevant** for denne komponenten.
   - Sett status (se skala under) basert på hva koden faktisk gjør.
   - Begrunn kort og konkret, med **kodereferanser** (`sti/til/Fil.kt:linje` eller
     klasse-/funksjonsnavn) der det er mulig.
   - Respekter avgrensningene: generisk EESSI-infrastruktur (RINA-integrasjon,
     meldingsruting, hendelsesstrøm) ivaretas av EUX/eessibasis; vedtaksbehandling,
     brevproduksjon og lagringstider ligger i fagsystemene (PESYS m.fl.). Marker
     slikt som **Ikke relevant** for komponenten med en kort forklaring.

5. **Ikke dikt opp.** Påstander skal kunne spores til kode, `architecture.md`
   eller agentdefinisjonen. Hvis noe ikke kan verifiseres fra komponentens kode,
   skriv det eksplisitt (status **Uavklart**) og forklar hva som må sjekkes — ikke
   anta at kriteriet er oppfylt. Disse punktene samles i en egen seksjon i
   rapporten (ikke i meta-repoets `apne-sporsmal.md`).

6. **Skriv rapporten** til `etterlevelse/etterlevelse-rapport.md` i komponent-repoet
   (opprett `etterlevelse/`-mappen ved behov). Bruk formatet under. Overskriv hele
   fila hvis den finnes fra før.

7. **Bekreft til brukeren.** Kort oppsummering: hvilken komponent, antall krav
   vurdert, fordeling av statuser, og 1–2 setninger om de viktigste funnene/avvikene.

## Statusskala

Bruk **eksakt** én av disse per suksesskriterium og som samlet status per krav:

| Status | Betydning for komponenten |
|--------|---------------------------|
| `Ja` | Komponenten oppfyller kriteriet, verifisert i kode/konfigurasjon |
| `Ja (delvis)` | Delvis dekket, eller lener seg på en antagelse |
| `Nei (delvis)` | Sentralt kriterium er ikke dekket der det burde vært |
| `Nei` | Kriteriet er relevant, men ikke oppfylt |
| `Ikke relevant` | Kriteriet gjelder ikke denne komponenten (forklar kort hvorfor) |
| `Uavklart` | Kunne ikke verifiseres fra koden — må følges opp |

Samlet kravstatus settes konservativt: er ett relevant kriterium `Nei`/`Nei (delvis)`,
er samlet status maks `Nei (delvis)`. Lener besvarelsen seg på antagelser, er den
maks `Ja (delvis)`. Er alle kriterier `Ikke relevant`, settes kravet til
`Ikke relevant`.

## Rapportformat

Skriv ren markdown. Bruk dette oppsettet (eksempelinnhold i kursiv skal byttes ut):

```markdown
# Etterlevelsesrapport – <komponentnavn>

> Auto-generert analyse av hvordan komponenten **<komponentnavn>** bidrar til
> EESSI Pensjon-domenets etterlevelseskrav. Dette er en intern oversikt for
> team eessipensjon, ikke en besvarelse i etterlevelse-portalen.

- **Komponent:** <komponentnavn>
- **Rolle:** <kort rolle fra architecture.md>
- **Generert:** <YYYY-MM-DD>
- **Kilde for krav:** navikt/eessi-pensjon / etterlevelse/agent-input
- **Antall krav vurdert:** <N>

## Sammendrag

| Kravid | Tittel | Tema | Samlet status |
|--------|--------|------|---------------|
| K103.2 | ... | Personvern | Ja |
| ...    | ... | ...        | ... |

## Krav i detalj

### K<nr>.<v> – <tittel>

**Tema:** <tema> · **Samlet status:** <status>

<1–2 setninger om hvordan kravet berører denne komponenten, eller hvorfor det ikke gjør det.>

| SK | Suksesskriterium | Status | Begrunnelse (med kodereferanse) |
|----|------------------|--------|---------------------------------|
| 1 | <kort kriterietittel> | Ja | <begrunnelse>. Se `src/.../Foo.kt`. |
| 2 | ... | Ikke relevant | <hvorfor>. |

<gjenta per krav, sortert stigende på kravid>

## Avgrensninger

- Generisk EESSI-/RINA-infrastruktur ivaretas av EUX-plattformen (team eessibasis).
- Vedtaksbehandling, brevproduksjon og lagringstider ligger i fagsystemene (PESYS m.fl.).
<andre avgrensninger som er relevante for komponenten>

## Punkter som må følges opp

- [ ] <krav/SK>: <hva som er uavklart og hva som må verifiseres>
```

## Regler

- **Komponent-perspektiv, ikke domene.** Beskriv hva *denne* komponenten gjør.
  Det er greit at de fleste krav er `Ikke relevant` for en liten komponent.
- **Konkret og sporbar.** Foretrekk kodereferanser (filsti, klasse, funksjon)
  framfor generelle påstander. Tekniske detaljer er **ønsket** her (i motsetning
  til portalteksten) — dette er et internt arbeidsdokument.
- **Ikke oppdater meta-repoet.** Ikke skriv til `etterlevelse/agent-output/`,
  `status.md` eller `apne-sporsmal.md`. Oppfølgingspunkter hører hjemme i
  rapportens egen "Punkter som må følges opp"-seksjon.
- **Hele rapporten i én fil:** `etterlevelse/etterlevelse-rapport.md`.
- **Norsk, klart språk.** Bruk domenebegrep (SED, BUC, PDL, PESYS, Joark) korrekt.
- **Ikke dikt opp.** Ikke-verifiserbare påstander → `Uavklart` + oppfølgingspunkt.
