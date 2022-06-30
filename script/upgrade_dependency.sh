#!/usr/bin/env bash

if [[ -z $DEPENDENCY ]]
then
  if [[ "$1" == "" ]]
  then
    echo "You need to specify env variable DEPENDENCY!"
    exit 1
  else
    DEPENDENCY="$1"
  fi
fi
DEPENDENCY_NAME=$(echo $DEPENDENCY | cut -f2 -d':')

source $(dirname -- "$0")/java_use.sh
DEFAULT_JAVA=11
export JAVA_VERSION=$(test -f .java-version && cat .java-version || echo "$DEFAULT_JAVA")
java_use "$JAVA_VERSION"

if test ! -f build.gradle && test ! -f build.gradle.kts; then
  echo "Not a Gradle project."
else
  $(dirname -- "$0")/check_if_we_are_up_to_date.sh --allow-local-commits|| exit 1

  ./gradlew useLatestVersions --update-dependency $DEPENDENCY

  # FIXME! Feilet for implementation("no.nav.eessi.pensjon:ep-metrics:0.4.25") i eessi-pensjon-saksbehandling-api
  VERSION_NO=$(git diff -U0 --word-diff | cat | tail -n1 | sed 's|[^{]*{+\([^}]*\)+}|\1|')

  if [[ -z $VERSION_NO ]]
  then
    echo "No version number found after upgrade attempt - either already up-to-date or $DEPENDENCY_NAME not in use."
  else
    MSG="oppgraderer $DEPENDENCY_NAME -> $VERSION_NO"
    ./gradlew build --quiet && git commit -am "E $MSG" && echo "$MSG - bygget og committet." || (echo "Noe feilet med bygg og commit."; exit 1)
  fi
fi