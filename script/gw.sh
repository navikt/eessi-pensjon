#!/usr/bin/env bash

source $(dirname -- "$0")/java_use.sh
DEFAULT_JAVA=11
export JAVA_VERSION=$(test -f .java-version && cat .java-version || echo "$DEFAULT_JAVA")
java_use $JAVA_VERSION

# GW_QUIET=false lets callers see Gradle's lifecycle-level console output (e.g. the
# dependencyUpdates plain-text report, which io.github.ben-manes.versions >= 0.60 only
# prints to stdout when logger.isLifecycleEnabled - i.e. NOT suppressed by --quiet).
QUIET_FLAG="--quiet"
if [ "$GW_QUIET" = "false" ]; then
  QUIET_FLAG=""
fi

test ! -f build.gradle && test ! -f build.gradle.kts || ./gradlew "$@" $QUIET_FLAG

