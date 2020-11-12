# EESSI Pensjon

En samling tjenester og verktøy, som utgjør EESSI Pensjon.

## Komme i gang

[repo](https://source.android.com/setup/develop/repo) brukes til å sette opp
repositories for alle komponentene. Det kan [installeres
manuelt](https://source.android.com/setup/build/downloading) eller via homebrew:

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

Interne henvendelser kan sendes via Slack i kanalen #eessi-pensjon.

# For å hente ut info om siste ukes commits
```bash
set -o pipefail
set -o errexit
for repo in $(find . -type d -name '.git'); do
  pushd "$(dirname "$repo")" >/dev/null
  # Debug prints
  # echo -e "\nNow in $(pwd)"
  # git rev-parse HEAD
  git log --reverse --format=' (%cr) %h %s' --since='8 days' \
  | sed "s@^@$(basename "$(pwd)"):@"
  popd >/dev/null
done
```
As one-liner:

`for repo in $(find . -type d -name '.git'); do pushd "$(dirname "$repo")" 1>/dev/null && git log --reverse --format=' (%cr) %h %s' --since='8 days' | sed "s@^@$(basename "$(pwd)"):@" && popd 1>/dev/null; done` 
