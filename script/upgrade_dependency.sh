#!/usr/bin/env bash

if [[ -z $DEPENDENCY ]]
then
  echo "You need to specify env variable DEPENDENCY!"
  exit 1
fi

DEPENDENCY_NAME=$(echo $DEPENDENCY | cut -f2 -d':')

source $(dirname -- "$0")/java_use.sh
DEFAULT_JAVA=11
export JAVA_VERSION=$(test -f .java-version && cat .java-version || echo "$DEFAULT_JAVA")
java_use "$JAVA_VERSION"

if test ! -f build.gradle && test ! -f build.gradle.kts; then
  echo "Not a Gradle project."
  exit 0
fi

echo "Switch to mainline"
$(dirname -- "$0")/switch_to_mainline.sh

echo "Pull from repo"
$(dirname -- "$0")/pull_from_repo.sh

./gradlew useLatestVersions --update-dependency $DEPENDENCY

# Feilet for implementation("no.nav.eessi.pensjon:ep-metrics:0.4.25") i eessi-pensjon-saksbehandling-api
VERSION_NO=$(git diff -U0 --word-diff | cat | tail -n1 | sed 's|[^{]*{+\([^}]*\)+}|\1|')

if [[ -z $VERSION_NO ]]
then
  echo "No version number found after upgrade attempt - either already up-to-date or $DEPENDENCY_NAME not in use."
  exit 0
fi

MSG="oppgraderer $DEPENDENCY_NAME -> $VERSION_NO"

./gradlew build && git commit -am "E $MSG" && echo "$MSG - bygget og committet." || (echo "Noe feilet med bygg og commit."; exit 1)
