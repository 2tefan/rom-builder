#!/bin/env bash

set -eu

VARIABLES_BEFORE=$(compgen -v)
for arg in "$@"; do
    case "${arg}" in
    --push | -p)
        PUSH=YES
        ;;
    --launch)
        LAUNCH=YES
        ;;
    --launch-guess-settings)
        LAUNCH=YES
        GUESS_SETTINGS=YES
        : "${GIT_EMAIL:=$(git config user.email)}"
        : "${GIT_USERNAME:=$(git config user.name)}"
        : "${EDITOR:=$(git config core.editor)}"
        ;;
    --linux-distro=*)
        LINUX_DISTRO="${arg#*=}"
        ;;
    --linux-distro-release=*)
        LINUX_DISTRO_RELEASE="${arg#*=}"
        ;;
    esac
done

: "${PUSH:=NO}"
: "${LAUNCH:=NO}"
: "${GUESS_SETTINGS:=NO}"

: "${SCRIPT:=$(realpath "$(basename "$0")")}"
: "${REPO_ROOT:=$(dirname "${SCRIPT}")}"
: "${DOCKERFILE:=$(realpath "${REPO_ROOT}/Dockerfile")}"

source "${REPO_ROOT}/versioning.sh"

: "${IMAGE_NAME:=2tefan/android-rom-builder}"
: "${LINUX_DISTRO:=ubuntu}"
: "${LINUX_DISTRO_RELEASE:=20.04}"
: "${ARB_VERSION:=${BUILDER_VERSION}-${LINUX_DISTRO}-${LINUX_DISTRO_RELEASE}}"
: "${IMAGE:="${IMAGE_NAME}:${ARB_VERSION}"}"

VARIABLES_AFTER=$(compgen -v)

NEW_VARIABLES=$(echo "${VARIABLES_BEFORE[@]}" "${VARIABLES_AFTER[@]}" | tr ' ' '\n' | sort | uniq -u | grep -v 'VARIABLES_BEFORE' | grep -v 'VARIABLES_AFTER')

for VARIABLE in ${NEW_VARIABLES[@]}; do
    echo "${VARIABLE}=${!VARIABLE}"
done

docker build "${REPO_ROOT}" \
    --build-arg LINUX_DISTRO="${LINUX_DISTRO}" \
    --build-arg LINUX_DISTRO_RELEASE="${LINUX_DISTRO_RELEASE}" \
    --build-arg ARB_VERSION="${ARB_VERSION}" \
    --tag "${IMAGE}"

if [ "${PUSH}" = "YES" ]; then
    docker login --username "${DOCKER_USERNAME}" --password "${DOCKER_PASSWORD}"
    docker push "${IMAGE}"
fi

if [ "${LAUNCH}" = "YES" ]; then
    RUN_PARAMETERS=""

    if [ "${GUESS_SETTINGS}" = "YES" ]; then
        RUN_PARAMETERS="-e "GIT_EMAIL=${GIT_EMAIL}" \
                        -e "GIT_USERNAME=${GIT_USERNAME}" \
                        -e "EDITOR=${EDITOR}""
    fi

    docker run --rm \
        -it \
        ${RUN_PARAMETERS} \
        "${IMAGE}"
fi
