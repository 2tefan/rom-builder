#!/bin/env bash

VARIABLES_BEFORE=$(compgen -v)
: "${IMAGE_NAME:=2tefan/android-rom-builder}"
: "${LINUX_DISTRO:=ubuntu}"
: "${LINUX_DISTRO_RELEASE:=20.04}"
: "${BUILDER_VERSION:=0.0.0}"

: "${SCRIPT:=$(realpath "$(basename "$0")")}"
: "${REPO_ROOT:=$(dirname "${SCRIPT}")}"
: "${DOCKERFILE:=$(realpath "${REPO_ROOT}/Dockerfile")}"
VARIABLES_AFTER=$(compgen -v)

NEW_VARIABLES=$(echo "${VARIABLES_BEFORE[@]}" "${VARIABLES_AFTER[@]}" | tr ' ' '\n' | sort | uniq -u | grep -v 'VARIABLES_BEFORE' | grep -v 'VARIABLES_AFTER')

for VARIABLE in ${NEW_VARIABLES[@]}; do
    echo "${VARIABLE}=${!VARIABLE}"
done

docker build "${REPO_ROOT}" -t "${IMAGE_NAME}:${LINUX_DISTRO}-${LINUX_DISTRO_RELEASE}-${BUILDER_VERSION}"
