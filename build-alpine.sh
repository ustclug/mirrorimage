#!/bin/bash
source common.sh
platforms="${PLATFORMS:-linux/amd64,linux/arm64}"
docker-tags alpine |
while read tag; do
    dockerfile=$(mktemp)
    cat << EOF > $dockerfile
FROM alpine:$tag
RUN sed -i \
    -e 's/dl-.*.alpinelinux.org/mirrors.ustc.edu.cn/g' \
    /etc/apk/repositories
EOF
    docker buildx build --platform "$platforms" -f $dockerfile \
        -t ustclug/alpine:$tag \
        -t ghcr.io/ustclug/alpine:$tag \
        --push .
    rm $dockerfile
done
