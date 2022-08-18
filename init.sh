#!/bin/env bash
# This script will be executed when a user tries to start our image
REPO_LOCATION=$(command -v repo)
REPO_VERSION=$(repo --version | grep version | awk '{print $4}')
GIT_VERSION=$(git --version | awk '{print $3}')
PYTHON2_VERSION=$(python2 --version 2>&1 | awk '{print $2}')
PYTHON3_VERSION=$(python3 --version | awk '{print $2}')


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

# Self Destruct
sed -i "/^.*init.*$/d" ~/.bashrc
rm "$0"
