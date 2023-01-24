import os
import shutil
import subprocess
import requests
import unicodedata
import re
import zipfile
from github import Github
from datetime import datetime

def slugify(value, allow_unicode=False):
    """
    Taken from https://github.com/django/django/blob/master/django/utils/text.py
    Convert to ASCII if 'allow_unicode' is False. Convert spaces or repeated
    dashes to single dashes. Remove characters that aren't alphanumerics,
    underscores, or hyphens. Convert to lowercase. Also strip leading and
    trailing whitespace, dashes, and underscores.
    """
    value = str(value)
    if allow_unicode:
        value = unicodedata.normalize('NFKC', value)
    else:
        value = unicodedata.normalize('NFKD', value).encode('ascii', 'ignore').decode('ascii')
    value = re.sub(r'[^\w\s-]', '', value.lower())
    return re.sub(r'[-\s]+', '-', value).strip('-_')

# Define the repository URL and the folder to clone to
repo_name = "Leopard20/All-In-One-Command-Menu"
repo_url = "https://github.com/"+repo_name
local_folder = r"F:\Python\ww2\tmp"

# Define the list of files to keep in the folder
files_to_keep = [".git",".github",".gitignore","LICENSE","README.md"]

# Create an instance of the Github API client
# and authenticate using a token or username and password
g = Github(GITHUB_TOKEN)

# Get the repository
repo = g.get_repo(repo_name)

# Clone the repository
result = subprocess.run(["git", "clone", repo_url, local_folder], stdout=subprocess.PIPE)
print("Repository cloned!")
print(result.stdout.decode())

# Get the list of releases from the repository
releases = repo.get_releases().reversed

# Loop through the releases and download them
for release in releases:
    # if release.created_at < datetime(2019, 8, 22, 16, 35, 54):
    #     print(f"Skipping release {release.title}, too old ({release.created_at})")
    #     continue
    release_file = os.path.join(local_folder, f"{slugify(release.title)}.zip")
    download_url = release.zipball_url
    # Remove files from the folder
    removed = 0
    for item in os.listdir(local_folder):
        if item not in files_to_keep:
            s = os.path.join(local_folder, item)
            if os.path.isdir(s): shutil.rmtree(s)
            else: os.unlink(s)
            removed += 1
    print(f"{removed} Unwanted files removed!")
    
    # Download the release
    r = requests.get(download_url)
    open(release_file, "wb").write(r.content)
    print(f"{release.title} downloaded!")

    # Unpack the release
    # result = subprocess.run(["unzip", , "-d", local_folder], stdout=subprocess.PIPE)
    # print(result.stdout.decode())
    with zipfile.ZipFile(release_file, 'r') as zfile:
        zfile.extractall(local_folder)
    print(f"{release_file} unpacked!")
    os.unlink(release_file)
    print(f"{release_file} deleted!")

    # Add and commit the files with the release name as the commit message
    result = subprocess.run(["git", "-C", local_folder, "add", "."], stdout=subprocess.PIPE)
    print(result.stdout.decode())
    result = subprocess.run(["git", "-C", local_folder, "commit", "-m", release.title], stdout=subprocess.PIPE)
    print(f"{release.title} commited!")
    print(result.stdout.decode())

input("test")

# Push the changes to GitHub
result = subprocess.run(["git", "-C", local_folder, "push", "origin", "master"], stdout=subprocess.PIPE)
print("Changes pushed to GitHub!")
print(result.stdout.decode())
