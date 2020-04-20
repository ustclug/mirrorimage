#!/bin/bash
source common.sh
docker-tags centos |
while read tag; do
    dockerfile=$(mktemp)
    cat << EOF > $dockerfile
FROM centos:$tag
RUN sed -i \
    -e 's/mirrorlist/#mirrorlist/g' \
    -e 's/#baseurl/baseurl/g' \
    -e 's/mirror.centos.org/mirrors.ustc.edu.cn/g' \
    /etc/yum.repos.d/CentOS-Base.repo
EOF
    docker build -f $dockerfile -t ustclug/centos:$tag .
    docker push ustclug/centos:$tag
    rm $dockerfile
done
