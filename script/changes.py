#!/usr/bin/env python3

import re
import subprocess
from datetime import datetime

projects_cmd = subprocess.run(["sh", "-c", "ls -d */.git"], stdout=subprocess.PIPE, text=True)
if projects_cmd.returncode != 0:
    exit(projects_cmd.returncode)

projects = ["."] + [re.sub('/.git', '', x) for x in projects_cmd.stdout.split('\n') if x != ""]

changes = []

risks = {
    '0': "no risk",
    '1': "known safe",
    '2': "validated",
    '3': "risky",
    '4': "(probably) broken",
    '5': "unknown risk",
}

intentions = {
    'F': "feature",
    'R': "refactoring",
    'T': "tests only",
    'B': "bugfix",
    'E': "environment",
    'D': "documentation",
    'P': "process (build/deploy)",
    'A': "automated formatting etc",
    'U': "dependency update",
    '*': "unknown"
}


def intention_from_message(message):
    if message.startswith("[Release Plugin]"):
        return "P"
    if message.lower().startswith("e oppgraderer"):
        return "U"
    if message.startswith("Revert \""):
        return intention_from_message(message[len("Revert \""):])
    if message[1:3] in (" -", "!!", "**") or message[1] == " ":  # last condition handles old messages
        return message[0].upper() if message[0].upper() in intentions.keys() else "*"
    return "*"


def text_intention(intention):
    return intentions.get(intention.upper(), "unknown")


def text_risk(risk):
    return risks.get(risk, "unknown")


def risk_from_message(message):
    if message.startswith("[Release Plugin]"):
        return "0"
    if message.startswith("Revert \""):
        return risk_from_message(message[len("Revert \""):])
    if message[1:3] not in (" -", "!!", "**") and message[1] != " ":  # last condition handles old messages
        return "5"
    if message[0].islower():
        return "1"
    if message[1:3] == "**":
        return "4"
    if message[1:3] == "!!":
        return "3"
    if message[1:3] == " -":
        return "2"
    if message[1] == " ": # handle old commits
        return "2"
    else:
        return "5"


for project in projects:
    module = re.sub("^\.$", "meta", re.sub("eessi-pensjon-", "", project))
    project_changes_cmd = subprocess.run(["sh", "-c",
                                          f"pushd '{project}' >/dev/null && git fetch >/dev/null && git log origin/HEAD --reverse --format='{project};%ci;{module};%h;%s' --since='178 hours'"],
                                         stdout=subprocess.PIPE, text=True)
    if project_changes_cmd.returncode != 0:
        exit(project_changes_cmd.returncode)

    project_changes = [x.split(";") for x in project_changes_cmd.stdout.split('\n') if x != ""]

    for change in project_changes:
        changes += [{
            "repo": change[0],
            "timestamp": datetime.strptime(change[1], "%Y-%m-%d %H:%M:%S %z"),
            "module": change[2],
            "type": "library" if change[0].startswith("ep-") else "meta" if change[2].startswith("meta") else "app",
            "hash": change[3],
            "message": change[4],
            "intention": intention_from_message(change[4]),
            "risk": risk_from_message(change[4])
        }]

changes.sort(key=lambda change: change['intention'])
changes.sort(key=lambda change: change['risk'], reverse=True)
changes.sort(key=lambda change: change['timestamp'])
changes.sort(key=lambda change: change['module'])
changes.sort(key=lambda change: change['type'])


def report_part(description, changes, filter_rule):
    print("*** " + description + " *** ")
    print()
    for change in filter(filter_rule, changes):
        print(f'{change["timestamp"].strftime("%d-%m-%Y %H:%M")} {change["module"]} - {change["message"]}  ({text_risk(change["risk"])})')
    print()


report_part("Highlight: Risky changes", changes, lambda change: 3 <= int(change["risk"]) < 5)
report_part("Changes with unknown intention", changes, lambda change: change["intention"] in {"*"})
report_part("Feature and bugfix changes", changes, lambda change: change["intention"] in {"F", "B"})
report_part("Refactoring, test and documentation changes", changes, lambda change: change["intention"] in {"R", "T", "D"})
report_part("Environment and process changes", changes, lambda change: change["intention"] in {"E", "P"})
report_part("Dependency updates", changes, lambda change: change["intention"] in {"U"})
report_part("Minor changes", changes, lambda change: change["intention"] in {"A"})
