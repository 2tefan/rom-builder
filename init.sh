#!/bin/env bash

set -eu

# This script will be executed when a user tries to start our image
REPO_LOCATION=$(command -v repo)
REPO_VERSION=$(repo --version | grep version | awk '{print $4}')
GIT_VERSION=$(git --version | awk '{print $3}')
PYTHON2_VERSION=$(python2 --version 2>&1 | awk '{print $2}')
PYTHON3_VERSION=$(python3 --version | awk '{print $2}')

# ---- <functions> ----

function env_exists_or_prompt {
    if [ -z "${!1:-}" ]; then
        printf "\"%s\" does not exist...\n" "${1}"
        printf "Please enter your %s now: " "${2}"
        read TEMP
        export "${1}=${TEMP}"
    fi
}

# ---- </functions> ----

printf "Hi, welcome to\n"
echo ''
echo '  _______  _________  _______   ________ ________  ________           ___ ________  ________  ________     '
echo ' /  ___  \|\___   ___|\  ___ \ |\  _____|\   __  \|\   ___  \        /  /|\   __  \|\   __  \|\   __  \    '
echo '/__/|_/  /\|___ \  \_\ \   __/|\ \  \__/\ \  \|\  \ \  \\ \  \      /  //\ \  \|\  \ \  \|\  \ \  \|\ /_   '
echo '|__|//  / /    \ \  \ \ \  \_|/_\ \   __\\ \   __  \ \  \\ \  \    /  //  \ \   __  \ \   _  _\ \   __  \  '
echo '    /  /_/__    \ \  \ \ \  \_|\ \ \  \_| \ \  \ \  \ \  \\ \  \  /  //    \ \  \ \  \ \  \\  \\ \  \|\  \ '
echo '   |\________\   \ \__\ \ \_______\ \__\   \ \__\ \__\ \__\\ \__\/_ //      \ \__\ \__\ \__\\ _\\ \_______\'
echo '    \|_______|    \|__|  \|_______|\|__|    \|__|\|__|\|__| \|__|__|/        \|__|\|__|\|__|\|__|\|_______|'
echo '                                                                                                         '
printf "Using:\n"
printf "\tARB: %s\n" "$ARB_VERSION"
printf "\tRepo (%s): %s\n" "$REPO_LOCATION" "$REPO_VERSION"
printf "\tGit: %s\n" "$GIT_VERSION"
printf "\tPython2: %s\n" "$PYTHON2_VERSION"
printf "\tPython3: %s\n" "$PYTHON3_VERSION"
echo
env_exists_or_prompt "GIT_EMAIL" "git email"
env_exists_or_prompt "GIT_USERNAME" "git username"
git config --global user.email "${GIT_EMAIL}"
git config --global user.name "${GIT_USERNAME}"
echo
echo "Git config:"
git config --global -l | sed "s/^/$(printf "\t")/g"

# Self Destruct
sed -i "/^.*init.*$/d" ~/.bashrc
rm "$0"
