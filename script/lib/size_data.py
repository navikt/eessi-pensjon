import datetime
import os
import time
from subprocess import Popen, PIPE

from .repos import projects_info


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
    return result


def size_data():
    today = datetime.datetime.today().strftime('%Y-%m-%d')
    size_stats = []

    projects = projects_info(os.getcwd())
    for project in projects:
        cloc_stats = cloc_for(project["path"])
        for row in cloc_stats:
            size_stats += [today + "," + project["path"] + "," + project["module"] + "," + project["type"] + "," + row]

    return size_stats


def change_data(tag):
    today = datetime.datetime.today().strftime('%Y-%m-%d')
    change_stats = []

    for project in projects_info(os.getcwd()):
        cloc_stats = cloc_change_since(project["path"], tag)
        for row in cloc_stats:
            change_stats += [today + "," + project["path"] + "," + project["module"] + "," + project["type"] + "," + row]

    return change_stats
