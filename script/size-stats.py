#!/usr/bin/env python3

import os
import csv
import datetime
from subprocess import Popen, PIPE

from lib.repos import projects_info

today = datetime.datetime.today().strftime('%Y-%m-%d')
filename = f"{os.getcwd()}/analysis/cloc-{today}.csv"


def cloc_for(path):
    cloc_command_string = 'cloc . --csv --vcs git --exclude-dir=dist,build,buildSrc,gradle --exclude-list-file=.clocignore --exclude-lang=JSON,XML --quiet | egrep -v "^$" | cut -d, -f1-5'
    cloc_command = Popen(cloc_command_string, shell=True, stdout=PIPE, cwd=path, text=True)
    if cloc_command.returncode:
        exit(cloc_command.returncode)
    result = []
    for line in cloc_command.stdout:
        result += [line.rstrip()]
    return result[1:-1]  # fjerner header og SUM


all_stats = []

projects = projects_info(os.getcwd())
for project in projects:
    cloc_stats = cloc_for(project["path"])
    for row in cloc_stats:
        all_stats += [today + "," + project["path"] + "," + project["module"] + "," + project["type"] + "," + row]

if os.path.exists(filename):
    os.remove(filename)

with open(filename, 'w', encoding="UTF-16") as csvfile:  # UTF-16 because Excel is stupid
    writer = csv.writer(csvfile, delimiter=';', dialect='excel')
    writer.writerow(["date", "repo", "module", "type", "files", "language", "blank lines", "comment lines", "code lines"])
    for line in all_stats:
        writer.writerow(line.split(","))
