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

  DIFF_STRING=$(git diff -U0 --word-diff | cat | tail -n1)
  DIFF_MINUS=$(echo $DIFF_STRING | sed 's|.*\[-\(.*\)-\].*|\1|' | sed "s|\'|\"|g" )
  DIFF_PLUS=$(echo $DIFF_STRING | sed 's|.*{\+\(.*\)\+}.*|\1|' | sed "s|\'|\"|g" )

  if [[ "$DIFF_STRING" =~ [=] ]]
  then # vi har en endring i en variabel-linje
    OLD_VERSION=$(echo "$DIFF_MINUS"|cut -d'=' -f2| sed 's/"//g')
    NEW_VERSION=$(echo "$DIFF_PLUS"|cut -d'=' -f2| sed 's/"//g')
    OLD_DEP="$DEPENDENCY:$OLD_VERSION"
  elif [[ "$DIFF_STRING" =~ [:] ]] # mest sannsynlig endring i en dependency-linje
  then
    OLD_DEP=$(echo $DIFF_MINUS | perl -lpe 'if ($_ =~ m/"([a-zA-Z0-9-.]+):([a-zA-Z0-9-.]+):([a-zA-Z0-9-.]+)"/) { print "$1:$2:$3\n"; }' | head -n 1 )
    NEW_DEP=$(echo $DIFF_PLUS | perl -lpe 'if ($_ =~ m/"([a-zA-Z0-9-.]+):([a-zA-Z0-9-.]+):([a-zA-Z0-9-.]+)"/) { print "$1:$2:$3\n"; }' | head -n 1 )
    OLD_MODULE=$(echo $OLD_DEP | cut -d':' -f2)
    NEW_MODULE=$(echo $NEW_DEP | cut -d':' -f2)
    NEW_VERSION=$(echo $NEW_DEP | cut -d':' -f3)
    if [[ "$OLD_MODULE" != "$NEW_MODULE" ]]
    then
      echo "Noe er galt - ny modul ($NEW_MODULE) er ikke lik gammel ($OLD_MODULE)"
      exit 1
    fi
  else # tror vi bare har en revisjon
    OLD_VERSION=$(echo "$DIFF_MINUS"|sed 's/"//g')
    NEW_VERSION=$(echo "$DIFF_PLUS"|sed 's/"//g')
    OLD_DEP="$DEPENDENCY:$OLD_VERSION"
  fi

  if [[ -z $NEW_VERSION ]]
  then
    echo "No version number found after upgrade attempt - either already up-to-date, $DEPENDENCY_NAME not in use, or version is not specified by us (e.g set by Spring-BOM)."
  else
    MSG="Oppgraderer $OLD_DEP -> $NEW_VERSION"
    ./gradlew build --quiet && git commit -am "U - $MSG" -m"Automatisert oppgradering av $DEPENDENCY." && echo "$MSG - bygget og committet." || (echo "Noe feilet med bygg og commit."; exit 1)
  fi
fi