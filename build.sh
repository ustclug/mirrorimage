#!/bin/bash

has_modified(){
    file=$1
    [[ `git diff HEAD~ HEAD -- $file | wc -l` != 0 ]]
}

ls build-*.sh |
while read script; do
    if has_modified $script || [[ $TRAVIS_EVENT_TYPE == "cron" ]] ; then
        . $script
    fi
done
