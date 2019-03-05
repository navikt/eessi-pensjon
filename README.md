# EESSI Pensjon

En samling tjenester og verktøy, som utgjør EESSI Pensjon.

## Komme i gang

repo brukes til å sette opp repositories for alle komponentne. Det kan installeres manuelt eller via homebrew:

`brew install repo`

Repositoriene settes opp med:

```
mkdir eessi-pensjon
cd eessi-pensjon
repo init -u git@github.com:navikt/eessi-pensjon.git
repo sync
repo start --all master
```

Nå kan git brukes som normalt for hvert repo.

Dersom du nå åpner `build.gradle` med `Open` (som Project) i IntelliJ så får du alle komponentene inn i ett IntelliJ-oppsett.

## Dokumentasjon

### Architectural Decisions

Se [Architectural Decision Log](docs/adr/index.md) for prosjektet

## Henvendelser

Spørsmål knyttet til koden eller prosjektet kan rettes mot:

* Øyvind Buer oyvind.buer@nav.no

### For NAV-ansatte

Interne henvendelser kan sendes via Slack i kanalen #eessi-pensjonpub.
