#!/bin/bash

has_modified(){
    file=$1
    [[ `git diff $COMMIT_FROM $COMMIT_TO -- $file | wc -l` != 0 ]]
}

script=build-${IMAGE_NAME}.sh
if has_modified $script || [[ $GITHUB_EVENT == "schedule" ]] || true ; then
    docker login -u "$DOCKER_USER" -p "$DOCKER_PASS"
    . $script
fi
