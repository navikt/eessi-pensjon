#!/usr/bin/env python3

import os
import csv
import datetime
from subprocess import Popen, PIPE

from lib.repos import projects_info
import time

tag = "2022T2END"

today = datetime.datetime.today().strftime('%Y-%m-%d')
now_file = f"{os.getcwd()}/analysis/cloc-{today}.csv"
change_file = f"{os.getcwd()}/analysis/cloc-change-{tag}-{today}.csv"


def cloc_for(path):
    cloc_command_string = 'cloc --csv --vcs git --exclude-dir=dist,build,gradle --exclude-list-file=.clocignore --exclude-lang=JSON,XML --quiet .'
    cloc_command = Popen(cloc_command_string, shell=True, stdout=PIPE, cwd=path, text=True)
    if cloc_command.returncode:
        exit(cloc_command.returncode)
    result = []
    for line in cloc_command.stdout:
        result += [line.rstrip()]
    return result[1:-1]  # fjerner header og SUM


def cloc_change_since(path, tag):  #  --exclude-list-file=.clocignore fungerer ikke her ser det ut til
    cloc_command_string = f'cloc --csv --vcs git --exclude-dir=dist,build,gradle --exclude-lang=JSON,XML --quiet --diff --git {tag} origin/HEAD'
    cloc_command = Popen(cloc_command_string, shell=True, stdout=PIPE, cwd=path, text=True)
    if cloc_command.returncode:
        exit(cloc_command.returncode)
    time.sleep(2)
    result = []
    for line in cloc_command.stdout:
        result += [line.rstrip()]
    return result  # fjerner header og SUM


size_stats = []

projects = projects_info(os.getcwd())
for project in projects:
    cloc_stats = cloc_for(project["path"])
    for row in cloc_stats:
        size_stats += [today + "," + project["path"] + "," + project["module"] + "," + project["type"] + "," + row]

if os.path.exists(now_file):
    os.remove(now_file)

with open(now_file, 'w', encoding="UTF-16") as csvfile:  # UTF-16 because Excel is stupid
    writer = csv.writer(csvfile, delimiter=';', dialect='excel')
    writer.writerow(["date", "repo", "module", "type", "files", "language", "blank lines", "comment lines", "code lines"])
    for line in size_stats:
        writer.writerow(line.split(","))

change_stats = []

for project in projects:
    cloc_stats = cloc_change_since(project["path"], tag)
    for row in cloc_stats:
        change_stats += [today + "," + project["path"] + "," + project["module"] + "," + project["type"] + "," + row]

if os.path.exists(change_file):
    os.remove(change_file)

with open(change_file, 'w', encoding="UTF-16") as csvfile:  # UTF-16 because Excel is stupid
    writer = csv.writer(csvfile, delimiter=';', dialect='excel')
    writer.writerow(
        ["date", "repo", "module", "type", "language", "== files", "!= files", "+ files", "- files", "== blank",
         "!= blank", "+ blank", "- blank", "== comment", "!= comment", "+ comment", "- comment", "== code", "!= code",
         "+ code", "- code"])
    for line in change_stats:
        writer.writerow(line.split(","))
