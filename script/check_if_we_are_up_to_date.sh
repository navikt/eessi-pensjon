#!/usr/bin/env bash
set -e

mainline_branch="$(git branch --all | sed 's/^[* ] //' | egrep '^main|^master')"

[[ "$mainline_branch" != "$(git branch --show-current)" ]] &&  (echo "Du er ikke på $mainline_branch branch"; exit 1)

git fetch origin --quiet

git status | grep "nothing to commit, working tree clean" > /dev/null || (echo "Du har lokale endringer som ikke er commitet"; exit 1)

local_commit_count=$(git log --oneline origin/HEAD..HEAD | wc -l | sed 's#       ##')
no_commits=0
[[ $local_commit_count == $no_commits ]] || (echo "Du har lokale commits som ikke er pushet"; exit 1)
