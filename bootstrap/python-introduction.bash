#!/bin/bash
## Script that clones a repository

cd /home/jovyan/work
# git reflog requires a name and email if user is not in passwd
# even if you're only cloning
export GIT_COMMITTER_NAME=anonymous
export GIT_COMMITTER_EMAIL=anon@localhost
git clone https://github.com/csc-training/python-introduction.git

mkdir -p ~/.jupyter/custom/
wget https://raw.githubusercontent.com/csc-training/python-introduction/gh-pages/assets/custom.js -O ~/.jupyter/custom/custom.js
