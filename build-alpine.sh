#!/bin/bash
source common.sh
docker-tags alpine |
while read tag; do
    dockerfile=$(mktemp)
    cat << EOF > $dockerfile
FROM alpine:$tag
RUN sed -i \
    -e 's/dl-.*.alpinelinux.org/mirrors.ustc.edu.cn/g' \
    /etc/apk/repositories
EOF
    docker build -f $dockerfile -t ustclug/alpine:$tag .
    docker tag ustclug/alpine:$tag ghcr.io/ustclug/alpine:$tag
    docker push ustclug/alpine:$tag
    docker push ghcr.io/ustclug/alpine:$tag
    rm $dockerfile
done
