#!/bin/bash
source common.sh
docker-tags centos | 
while read tag; do
    rocker build --push --auth $DOCKER_USER:$DOCKER_PASS -f <(cat << EOF
FROM centos:$tag
RUN sed -i \
    -e 's/mirrorlist/#mirrorlist/g' \
    -e 's/#baseurl/baseurl/g' \
    -e 's/mirror.centos.org/mirrors.ustc.edu.cn/g' \
    /etc/yum.repos.d/CentOS-Base.repo
PUSH ustclug/centos:$tag
EOF
)
done
