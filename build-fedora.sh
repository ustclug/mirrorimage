#!/bin/bash
source common.sh
docker-tags fedora | 
while read tag; do
    rocker build --push --auth $DOCKER_USER:$DOCKER_PASS -f <(cat << EOF
FROM fedora:$tag
RUN sed -i \
    -e 's/metalink/#metalink/g' \
    -e 's/#baseurl/baseurl/g' \
    -e 's|download.fedoraproject.org/pub/fedora/linux|mirrors.ustc.edu.cn/fedora|g' \
    /etc/yum.repos.d/fedora.repo /etc/yum.repos.d/fedora-updates.repo
PUSH ustclug/fedora:$tag
EOF
)
done
