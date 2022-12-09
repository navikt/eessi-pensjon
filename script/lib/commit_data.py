import subprocess
import re
from datetime import datetime

def projects_from_ls_cmd():
    global projects
    subfolders_with_git_cmd = subprocess.run(["sh", "-c", "ls -d */.git"], stdout=subprocess.PIPE, text=True)
    if subfolders_with_git_cmd.returncode != 0:
        exit(subfolders_with_git_cmd.returncode)
    sub_folders_with_git = subfolders_with_git_cmd.stdout.split('\n')
    root_project_folder = "."
    return [root_project_folder] + [re.sub('/.git', '', folder) for folder in sub_folders_with_git if folder != ""]


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


def gather_changes_from_subprojects(duration):
    hours, remainder = divmod(duration.total_seconds(), 3600)
    report_period = f"{str(hours + 1 if remainder > 0 else 0)} hours"

    changes = []

    for project in projects_from_ls_cmd():
        short_project_names = re.sub("^\.$", "meta", re.sub("eessi-pensjon-", "", project))

        commit_format_string=f"{project};%ci;{short_project_names};%h;%s"



        project_changes_cmd = subprocess.run(["sh", "-c",
                                              f"pushd '{project}' >/dev/null && git fetch >/dev/null && git log origin/HEAD --format='{commit_format_string}' --since='{report_period}'"],
                                             stdout=subprocess.PIPE, text=True)
        if project_changes_cmd.returncode != 0:
            exit(project_changes_cmd.returncode)

        commit_lines = project_changes_cmd.stdout.split('\n')
        project_commits = [line.split(";") for line in commit_lines if line != ""]

        for commit in project_commits:
            changes += [{
                "repo": commit[0],
                "timestamp": datetime.strptime(commit[1], "%Y-%m-%d %H:%M:%S %z"),
                "module": commit[2],
                "type": "library" if commit[0].startswith("ep-") else "meta" if commit[2].startswith("meta") else "app",
                "hash": commit[3],
                "message": commit[4],
                "intention": intention_from_message(commit[4]),
                "risk": risk_from_message(commit[4])
            }]
    return changes
