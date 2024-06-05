#!/bin/bash
source common.sh
docker-tags rockylinux |
while read tag; do
    dockerfile=$(mktemp)
    cat << EOF > $dockerfile
FROM rockylinux:$tag
RUN sed -i \
    -e 's/mirrorlist/#mirrorlist/g' \
    -e 's/#baseurl/baseurl/g' \
    -e 's|dl.rockylinux.org/\$contentdir|mirrors.ustc.edu.cn/rocky|g' \
    /etc/yum.repos.d/Rocky-*.repo || \
    sed -i \
    -e 's/mirrorlist/#mirrorlist/g' \
    -e 's/#baseurl/baseurl/g' \
    -e 's|dl.rockylinux.org/\$contentdir|mirrors.ustc.edu.cn/rocky|g' \
    /etc/yum.repos.d/rocky*.repo
EOF
    docker build -f $dockerfile -t ustclug/rocky:$tag .
    docker push ustclug/rocky:$tag
    rm $dockerfile
done
