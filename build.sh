#!/bin/bash

has_modified(){
    file=$1
    [[ -z $TRAVIS_COMMIT_RANGE ]] && return false
    COMMIT_FROM=${TRAVIS_COMMIT_RANGE%...*}
    COMMIT_TO=${TRAVIS_COMMIT_RANGE#*...}
    [[ `git diff $COMMIT_FROM $COMMIT_TO -- $file | wc -l` != 0 ]]
}

script=build-${IMAGE_NAME}.sh
if has_modified $script || [[ $TRAVIS_EVENT_TYPE == "cron" ]] || true ; then
    docker login -u "$DOCKER_USER" -p "$DOCKER_PASS"
    . $script
fi
