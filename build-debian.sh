#!/bin/bash
source common.sh
docker-tags debian |
while read tag; do
    unset backports_list
    echo $tag | grep -qP -- '-\d{8}' && continue
    echo $tag | grep backports && backports_list=/etc/apt/sources.list.d/backports.list
    dockerfile=$(mktemp)
    cat << EOF > $dockerfile
FROM debian:$tag
RUN sed -i \
    -e 's/deb.debian.org/mirrors.ustc.edu.cn/g' \
    -e 's/security.debian.org/mirrors.ustc.edu.cn/g' \
    /etc/apt/sources.list $backports_list || \
    sed -i \
    -e 's/deb.debian.org/mirrors.ustc.edu.cn/g' \
    -e 's/security.debian.org/mirrors.ustc.edu.cn/g' \
    /etc/apt/sources.list.d/debian.sources $backports_list
EOF
    docker build -f $dockerfile -t ustclug/debian:$tag .
    docker tag ustclug/debian:$tag ghcr.io/ustclug/debian:$tag
    docker push ustclug/debian:$tag
    docker push ghcr.io/ustclug/debian:$tag
    rm $dockerfile
done
