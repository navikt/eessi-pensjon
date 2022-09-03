# EESSI Pensjon

Et meta-repo, med en samling med applikasjoner, bibliotek og verktøy - som utgjør EESSI Pensjon-systemet.

## Komme i gang

[meta](https://github.com/mateodelnorte/meta) brukes til å sette opp
repositories for alle repoene.

Enn så lenge må du sørge for å ha `npm` installert (`brew install node`).

```
npm install meta -g --no-save
```

Merk! meta foran vanlig clone-kommando:
```
meta git clone git@github.com:navikt/eessi-pensjon.git
```

Nå kan git brukes som normalt for hvert repo.

Se [meta](https://github.com/mateodelnorte/meta) for flere kommandoer.

Dersom du nå åpner `build.gradle` med `Open` (som Project) i IntelliJ så får du alle komponentene inn i ett IntelliJ-oppsett.

## Dokumentasjon

### Architectural Decisions

Se [Architectural Decision Log](docs/adr/index.md) for prosjektet

### SonarQube

Les mer om bruk av [SonarQube](docs/dev/sonarqube.md)

## Henvendelser

Spørsmål knyttet til koden eller prosjektet kan rettes mot:

* Mariam (mariam.pervez at nav.no)

### For NAV-ansatte

Interne henvendelser kan sendes via Slack i kanalen #eessi-pensjon.

# For å hente ut info om siste ukes commits

(echo "./.git"; ls -d */.git) | sed 's#/.git##' | xargs -I{} sh -c "git pull --rebase --autostash > /dev/null ; pushd {} > /dev/null ; git log --reverse --format=' (%cr) %h %s' --since='8 days' | sed 's/^/{}:/' ; popd > /dev/null"

