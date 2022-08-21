#!/bin/env bash

set -eu

# This script will be executed when a user tries to start our image
REPO_LOCATION=$(command -v repo)
REPO_VERSION=$(repo --version | grep version | awk '{print $4}')
GIT_VERSION=$(git --version | awk '{print $3}')
PYTHON2_VERSION=$(python2 --version 2>&1 | awk '{print $2}')
PYTHON3_VERSION=$(python3 --version | awk '{print $2}')
CCACHE_VERSION=$(ccache --version | head -n 1 | awk '{print $3}')

: "${CCACHE_SIZE:=100G}"

# ---- <functions> ----

function setup_ccache() {
    ccache -M "${CCACHE_SIZE}" > /dev/null
    REAL_CCACHE_SIZE=$(ccache -s | grep "max cache size" | awk '{print $4 $5}')
}

function env_exists_or_prompt {
    if [ -z "${!1:-}" ]; then
        printf "\"%s\" does not exist...\n" "${1}"
        printf "Please enter your %s now: " "${2}"
        read TEMP
        export "${1}=${TEMP}"
    fi
}

function check_version {
    if echo "${ARB_VERSION}" | grep -q ".*alpha-dev.*"; then
        echo '                ________  _______   ___      ___ '
        echo '               |\   ___ \|\  ___ \ |\  \    /  /|'
        echo '               \ \  \_|\ \ \   __/|\ \  \  /  / /'
        echo '                \ \  \ \\ \ \  \_|/_\ \  \/  / / '
        echo '                 \ \  \_\\ \ \  \_|\ \ \    / /  '
        echo '                  \ \_______\ \_______\ \__/ /   '
        echo '                   \|_______|\|_______|\|__|/    '
        echo ''
        echo 'This is a development release. This means that some features might not work or change in the next development release.'
        echo 'Proceed with care! [Not recommended]'
    elif echo "${ARB_VERSION}" | grep -q ".*alpha.*"; then
        echo '                ________  ___       ________  ___  ___  ________     '
        echo '               |\   __  \|\  \     |\   __  \|\  \|\  \|\   __  \    '
        echo '               \ \  \|\  \ \  \    \ \  \|\  \ \  \\\  \ \  \|\  \   '
        echo '                \ \   __  \ \  \    \ \   ____\ \   __  \ \   __  \  '
        echo '                 \ \  \ \  \ \  \____\ \  \___|\ \  \ \  \ \  \ \  \ '
        echo '                  \ \__\ \__\ \_______\ \__\    \ \__\ \__\ \__\ \__\'
        echo '                   \|__|\|__|\|_______|\|__|     \|__|\|__|\|__|\|__|'
        echo ''
        echo 'This is a alpha release. This means that some features might not work but most of them should.'
        echo 'Proceed with care!'
    elif echo "${ARB_VERSION}" | grep -q ".*beta.*"; then
        echo '                ________  _______  _________  ________     '
        echo '               |\   __  \|\  ___ \|\___   ___\\   __  \    '
        echo '               \ \  \|\ /\ \   __/\|___ \  \_\ \  \|\  \   '
        echo '                \ \   __  \ \  \_|/__  \ \  \ \ \   __  \  '
        echo '                 \ \  \|\  \ \  \_|\ \  \ \  \ \ \  \ \  \ '
        echo '                  \ \_______\ \_______\  \ \__\ \ \__\ \__\'
        echo '                   \|_______|\|_______|   \|__|  \|__|\|__|'
        echo ''
        echo 'This is a beta release. This should be pretty stable, but always except the worst'
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
echo ''
check_version
setup_ccache
printf "Using:\n"
printf "\tARB: %s\n" "$ARB_VERSION"
printf "\tRepo (%s): %s\n" "$REPO_LOCATION" "$REPO_VERSION"
printf "\tGit: %s\n" "$GIT_VERSION"
printf "\tPython2: %s\n" "$PYTHON2_VERSION"
printf "\tPython3: %s\n" "$PYTHON3_VERSION"
printf "\tCCache (Set: %s | Real: %s): %s\n" "$CCACHE_SIZE" "$REAL_CCACHE_SIZE" "$CCACHE_VERSION"
echo
env_exists_or_prompt "GIT_EMAIL" "git email"
env_exists_or_prompt "GIT_USERNAME" "git username"
git config --global user.email "${GIT_EMAIL}"
git config --global user.name "${GIT_USERNAME}"
[ -v EDITOR ] && git config --global core.editor "${EDITOR}"
echo
echo "Git config:"
git config --global -l | sed "s/^/$(printf "\t")/g"

# Self Destruct
sed -i "/^.*init.*$/d" ~/.bashrc
rm "$0"
