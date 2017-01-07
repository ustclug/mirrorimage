#!/bin/bash
source common.sh
docker-tags ubuntu | 
while read tag; do
    rocker build --push --auth $DOCKER_USER:$DOCKER_PASS -f <(cat << EOF
FROM ubuntu:$tag
RUN sed -i \
    -e 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' \
    -e 's/security.ubuntu.com/mirrors.ustc.edu.cn/g' \
    /etc/apt/sources.list
PUSH ustclug/ubuntu:$tag
EOF
)
done
