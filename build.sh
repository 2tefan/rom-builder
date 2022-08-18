#!/bin/env sh

VARIABLES_BEFORE=$(compgen -v)
for arg in "$@"; do
    case "${arg}" in
    --push | -p)
        PUSH=YES
        ;;
    --linux-distro=*)
        LINUX_DISTRO="${arg#*=}"
        ;;
    --linux-distro-release=*)
        LINUX_DISTRO_RELEASE="${arg#*=}"
        ;;
    esac
done

: "${IMAGE_NAME:=2tefan/android-rom-builder}"
: "${LINUX_DISTRO:=ubuntu}"
: "${LINUX_DISTRO_RELEASE:=20.04}"
: "${BUILDER_VERSION:=$(git describe --dirty)}"
: "${IMAGE:="${IMAGE_NAME}:${BUILDER_VERSION}-${LINUX_DISTRO}-${LINUX_DISTRO_RELEASE}"}"
: "${PUSH:=NO}"

: "${SCRIPT:=$(realpath "$(basename "$0")")}"
: "${REPO_ROOT:=$(dirname "${SCRIPT}")}"
: "${DOCKERFILE:=$(realpath "${REPO_ROOT}/Dockerfile")}"
VARIABLES_AFTER=$(compgen -v)

NEW_VARIABLES=$(echo "${VARIABLES_BEFORE[@]}" "${VARIABLES_AFTER[@]}" | tr ' ' '\n' | sort | uniq -u | grep -v 'VARIABLES_BEFORE' | grep -v 'VARIABLES_AFTER')

for VARIABLE in ${NEW_VARIABLES[@]}; do
    echo "${VARIABLE}=${!VARIABLE}"
done

docker build "${REPO_ROOT}" -t "${IMAGE}"


if [ "${PUSH}" = "YES" ]; then
    docker login --username "${DOCKER_USERNAME}" --password "${DOCKER_PASSWORD}"
    docker push "${IMAGE}"
fi
