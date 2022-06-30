
# Oppgradere avhengigheter

Det er mange avhengigheter i de forskjellige repoene våre så vi har laget verktøy for å 
hjelpe til litt med prosessen.


## Før man oppgraderer

Pass på at alle lokale endringer er commit'et, pushet og at du er på mainline (master/main) (`make mainline`) og man har gjort pull (`make pull`).

Denne kommandoen sjekker at alt er ok:

```shell
make check-if-up-to-date
```

## "Trygge" oppgraderinger

I filen [safe_dependency_upgrades.txt](../../script/safe_dependency_upgrades.txt) ligger liste
med avhengigheter som vi tror kan oppgraderes "trygt" uten å gjøre annet enn et nytt bygg.

Fra rotprosjektet kan man kjøre:

```shell
make upgrade-safe-dependencies
```
Etter å ha sett over commits kan man deretter push'e endringene (det skal være bygget lokalt for hver enkelt commit).

## Enkelt-avhengigheter

For å oppgradere en enkelt-avhengighet på tvers av alle prosjekter kan man gjøre:

```shell
DEPENDENCY=group:name make upgrade-dependency
```

Etter å ha sett over commits kan man deretter push'e endringene (det skal være bygget lokalt for hver enkelt commit).
