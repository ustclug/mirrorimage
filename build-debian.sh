#!/bin/bash
source common.sh
docker-tags debian | 
while read tag; do
    unset backports_list
    echo $tag | grep -qP -- '-\d{8}' && continue
    echo $tag | grep backports && backports_list=/etc/apt/sources.list.d/backports.list
    rocker build --push --auth $DOCKER_USER:$DOCKER_PASS -f <(cat << EOF
FROM debian:$tag
RUN sed -i \
    -e 's/deb.debian.org/mirrors.ustc.edu.cn/g' \
    -e 's/security.debian.org/mirrors.ustc.edu.cn\/debian-security/g' \
    /etc/apt/sources.list $backports_list
PUSH ustclug/debian:$tag
EOF
)
done
