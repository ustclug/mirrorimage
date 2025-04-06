#!/bin/bash

has_modified(){
    file=$1
    [[ `git diff $COMMIT_FROM $COMMIT_TO -- $file | wc -l` != 0 ]]
}

script=build-${IMAGE_NAME}.sh
if has_modified $script || [[ $GITHUB_EVENT == "schedule" ]] || true ; then
    # Docker Hub
    if [ -n "$DHDOCKER_USER" ]; then
        docker login -u "$DHDOCKER_USER" -p "$DHDOCKER_PASS"
        echo "Logged in to Docker Hub"
    fi
    # GitHub Container Registry
    if [ -n "$GITHUB_TOKEN" ]; then
        echo $GITHUB_TOKEN | docker login ghcr.io -u $GITHUB_ACTOR --password-stdin
        echo "Logged in to GitHub Container Registry"
    fi
    . $script
fi
