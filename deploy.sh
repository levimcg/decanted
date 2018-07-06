#!/bin/sh

# Add some color to the output
# https://stackoverflow.com/questions/5947742/how-to-change-the-output-color-of-echo-in-linux#comment83473397_5947742

GREEN='\033[1;32m'
CYAN='\033[1;36m'
BLUE='\033[1;34m'
MAGENTA='\033[1;95m'
NC='\033[0m'

if [[ $(git status -s) ]]
then
    printf "\n🚫$MAGENTA The working directory is dirty. Please commit any pending changes.\n\n $NC"
    exit 1;
fi

echo "Deleting old publication"
rm -rf public
mkdir public
git worktree prune
rm -rf .git/worktrees/public/

echo "Checking out gh-pages branch into public"
git worktree add -B gh-pages public origin/gh-pages

echo "\n🗑️Removing existing files"
rm -rf public/*

echo "\n👷‍$GREEN Generating site$NC"
hugo

echo "Updating gh-pages branch"
cd public && git add --all && git commit -m "Publishing to gh-pages (deploy.sh)"

echo "Deploying to Github pages"
git push origin gh-pages

echo "\n👍 $GREEN Successfully pushed to gh-pages!$NC"