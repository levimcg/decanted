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
    printf "\n🚫 $MAGENTA The working directory is dirty. Please commit any pending changes.$NC\n\n "
    exit 1;
fi

printf "$GREEN Deleting old publication\n$NC"
rm -rf public
mkdir public
git worktree prune
rm -rf .git/worktrees/public/

printf "Checking out gh-pages branch into public\n"
git worktree add -B gh-pages public origin/gh-pages

printf "\n🗑️ Removing existing files\n"
rm -rf public/*

printf "\n👷‍$GREEN Generating site$NC\n"
hugo

printf "Updating gh-pages branch\n"
cd public && git add --all && git commit -m "Publishing to gh-pages (deploy.sh)"

printf "Deploying to Github pages\n"
git push origin gh-pages

printf "\n👍 $GREEN Successfully pushed to gh-pages!$NC\n\n"

exit