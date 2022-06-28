#!/usr/bin/env bash
set -e # fail on error

$(dirname -- "$0")/check_if_we_are_up_to_date.sh || exit 1

file="$(dirname -- "$0")/safe_dependency_upgrades.txt"

for f in $(cat $file);
do
  echo "Trying to upgrade $f ..."
  $(dirname -- "$0")/upgrade_dependency.sh "$f" | tail -n1
done

echo Commits:
git log --oneline origin/HEAD..HEAD
