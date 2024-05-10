#!/bin/bash
source common.sh
docker-tags ubuntu |
while read tag; do
    echo $tag | grep -q '-' && continue
    dockerfile=$(mktemp)
    cat << EOF > $dockerfile
FROM ubuntu:$tag
RUN sed -i \
    -e 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' \
    -e 's/security.ubuntu.com/mirrors.ustc.edu.cn/g' \
    /etc/apt/sources.list; \
    sed -i \
    -e 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' \
    -e 's/security.ubuntu.com/mirrors.ustc.edu.cn/g' \
    /etc/apt/sources.list.d/ubuntu.sources || true
EOF
    docker build -f $dockerfile -t ustclug/ubuntu:$tag .
    docker push ustclug/ubuntu:$tag
    rm $dockerfile
done
