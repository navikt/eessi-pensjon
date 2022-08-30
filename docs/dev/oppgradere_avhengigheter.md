
# Oppgradere avhengigheter

## Motivasjon

Avhengigheter gir potensiale for sårbarheter - denne kommandoen kan vise sårbare avhenighter i et prosjekt.

(Pass på at du kan nå `ossindex.sonatype.org` og `nvd.nist.gov` gjennom evt proxy e.l. Om kommandoen feiler 
kan det hende at det fungerer om du forsøker igjen et par ganger ...)

```
./gradlew dependencyCheckAnalyze && open build/reports/dependency-check-report.html
```

## I enkeltprosjekter

Sjekke om man har utdaterte avhengigheter (forsøker å unngå milestones og beta-versjoner):

```
./gradlew dependencyUpdates
```

Dersom du er supertrygg på testene kan du forsøke en oppdatering av alle avhengighetene:

```
./gradlew useLatestVersions && ./gradlew useLatestVersionsCheck
```

Et verktøy man også kan forsøke er `gradle-upgrade-interactive`.

Installeres med (forutsetter at du har node):

```shell
npm i -g gradle-upgrade-interactive
```

Kjør deretter: 

```shell
gradle-upgrade-interactive
```

## Oppdatering i mange prosjekter samtidig

Dersom man vil gjøre ting på tvers av prosjekter - kan man sette opp dette meta-repoet se [README.md](../../README.md),
og deretter forsøke noen av kommandoene det gir:

### Før man oppgraderer

Pass på at alle lokale endringer er commit'et, pushet og at du er på mainline (master/main) (`make mainline`) og man har gjort pull (`make pull`).

Denne kommandoen sjekker at alt er ok:

```shell
make check-if-up-to-date
```

### "Trygge" oppgraderinger

I filen [safe_dependency_upgrades.txt](../../script/safe_dependency_upgrades.txt) ligger liste
med avhengigheter som vi tror kan oppgraderes "trygt" uten å gjøre annet enn et nytt bygg.

Fra rotprosjektet kan man kjøre:

```shell
make upgrade-safe-dependencies
```
Etter å ha sett over commits (`make list-local-commits` for å liste ut) kan man deretter push'e endringene (det skal være bygget lokalt for hver enkelt commit).

### Enkelt-avhengigheter

For å oppgradere en enkelt-avhengighet på tvers av alle prosjekter kan man gjøre:

```shell
DEPENDENCY=group:name make upgrade-dependency
```

Etter å ha sett over commits kan man deretter push'e endringene (det skal være bygget lokalt for hver enkelt commit).

### Liste ut utdaterte avhengigheter på tvers av prosjektene

```shell
make upgradable-dependencies-report
```

### Oppgrader avhengigheter til ep-bibliotek

Når man har gjort oppdatering av eksterne avhengigheter er det laget et sett med kommandoer for å ta unna oppdateringen av avhengighetene til ep-*-bibliotekene:

```shell
make upgrade-ep-libraries-part-1
make upgrade-ep-libraries-part-2
... osv ...
make upgrade-ep-libraries-part-9
```