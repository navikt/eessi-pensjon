#!/usr/bin/env python3

import os
import csv
import datetime

from lib.size_data import size_data, change_data

tag = "2022T2END"

today = datetime.datetime.today().strftime('%Y-%m-%d')
now_file = f"{os.getcwd()}/analysis/cloc-{today}.csv"
change_file = f"{os.getcwd()}/analysis/cloc-change-{tag}-{today}.csv"

if os.path.exists(now_file):
    os.remove(now_file)

with open(now_file, 'w', encoding="UTF-16") as csvfile:  # UTF-16 because Excel is stupid
    writer = csv.writer(csvfile, delimiter=';', dialect='excel')
    writer.writerow(["date", "repo", "module", "type", "files", "language", "blank lines", "comment lines", "code lines"])
    for line in size_data():
        writer.writerow(line.split(","))

if os.path.exists(change_file):
    os.remove(change_file)

with open(change_file, 'w', encoding="UTF-16") as csvfile:  # UTF-16 because Excel is stupid
    writer = csv.writer(csvfile, delimiter=';', dialect='excel')
    writer.writerow(
        ["date", "repo", "module", "type", "language", "== files", "!= files", "+ files", "- files", "== blank",
         "!= blank", "+ blank", "- blank", "== comment", "!= comment", "+ comment", "- comment", "== code", "!= code",
         "+ code", "- code"])
    for line in change_data(tag):
        writer.writerow(line.split(","))
