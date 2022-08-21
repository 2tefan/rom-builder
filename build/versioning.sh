#!/bin/env bash

set -eu

cd "${REPO_ROOT}" || exit

if [[ -v CI ]]; then
    if [[ -v GITLAB_CI ]]; then
        if [[ -v CI_COMMIT_BRANCH ]]; then
            : "${GIT_BRANCH:=${CI_COMMIT_BRANCH}}"
        else
            # This is properly a tag commit, so just assume that this is the main branch
            : "${GIT_BRANCH:=main}"
        fi
    else
        echo "CI not supported"
        exit
    fi
else
    : "${GIT_BRANCH:=$(git rev-parse --abbrev-ref HEAD)}"
fi

: "${GIT_BRANCH_TYPE:=$(echo "${GIT_BRANCH}" | awk -F '/' '{ print $1 }')}"
echo "${GIT_BRANCH_TYPE}"

: "${CURRENT_COMMIT:=$(git rev-parse HEAD)}"

: "${LAST_TAG:=$(git describe --abbrev=0)}"
: "${LAST_VERSION:=$(echo "${LAST_TAG}" | cut -c 2-)}" # Remove the `v` from the tag
: "${VERSION_MAJOR:=$(echo "${LAST_VERSION}" | awk -F '.' '{ print $1 }')}"
: "${VERSION_MINOR:=$(echo "${LAST_VERSION}" | awk -F '.' '{ print $2 }')}"
: "${VERSION_PATCH:=$(echo "${LAST_VERSION}" | awk -F '.' '{ print $3 }')}"
: "${NEXT_VERSION:=${VERSION_MAJOR}.$((VERSION_MINOR + 1)).0}"

: "${VERSION_SPECIAL:=$(git describe --dirty | sed -r "s/${LAST_TAG}//")}"

COUNT_SINCE_TAG=$(git rev-list --count "${LAST_TAG}".."${CURRENT_COMMIT}")

case "${GIT_BRANCH_TYPE}" in
main)
    if [ "${COUNT_SINCE_TAG}" -eq 0 ]; then
        # No tags inbetween -> so this is the new version
        : "${BUILDER_VERSION:=${LAST_VERSION}}"
    else
        : "${BUILDER_VERSION:=${NEXT_VERSION}-beta-${COUNT_SINCE_TAG}}"
    fi
    ;;
develop)
    : "${BUILDER_VERSION:=${NEXT_VERSION}-alpha-${COUNT_SINCE_TAG}}"
    ;;
feature)
    : "${GIT_FEATURE_BRANCH_NAME:=$(echo "${GIT_BRANCH}" | awk -F '/' '{ print $2 }')}"
    : "${BUILDER_VERSION:=${NEXT_VERSION}-alpha-dev-${GIT_FEATURE_BRANCH_NAME}-${COUNT_SINCE_TAG}}"
    ;;
**)
    echo "This branch is NOT compatible with Gitflow..."
    exit 1
    ;;
esac
