import re
import subprocess


def projects_from_ls_cmd():
    subfolders_with_git_cmd = subprocess.run(["sh", "-c", "ls -d */.git"], stdout=subprocess.PIPE, text=True)
    if subfolders_with_git_cmd.returncode != 0:
        exit(subfolders_with_git_cmd.returncode)
    sub_folders_with_git = subfolders_with_git_cmd.stdout.split('\n')
    root_project_folder = "."
    return [root_project_folder] + [re.sub('/.git', '', folder) for folder in sub_folders_with_git if folder != ""]


def projects_info():
    result = []
    for project in projects_from_ls_cmd():
        result += [{
            "path": project,
            "module": re.sub("^\.$", "meta", re.sub("eessi-pensjon-", "", project)),
            "type": "library" if project.startswith("ep-") else "meta" if project.startswith(".") else "app"
        }]
    return result
