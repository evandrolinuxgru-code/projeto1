#!/bin/bash

REPO_URL="https://github.com/evandrosantiagoawx/repositorio.unificado.git"
BRANCH="main"

if [ ! -d .git ]; then
  git init
  git branch -M $BRANCH
  git remote add origin $REPO_URL
fi

git add .
git commit -m "sync $(date +%F_%H-%M-%S)" || exit 0
git push -u origin $BRANCH
