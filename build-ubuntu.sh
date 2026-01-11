#!/bin/bash
source common.sh
platforms="${PLATFORMS:-linux/amd64,linux/arm64}"
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
    docker buildx build --platform "$platforms" -f $dockerfile \
        -t ustclug/ubuntu:$tag \
        -t ghcr.io/ustclug/ubuntu:$tag \
        --push .
    rm $dockerfile
done
