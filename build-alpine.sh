#!/bin/bash
source common.sh
docker-tags alpine | 
while read tag; do
    rocker build --push --auth $DOCKER_USER:$DOCKER_PASS -f <(cat << EOF
FROM alpine:$tag
RUN sed -i \
    -e 's/dl-.*.alpinelinux.org/mirrors.ustc.edu.cn/g' \
    /etc/apk/repositories
PUSH ustclug/alpine:$tag
EOF
)
done
