#!/bin/bash
source common.sh
platforms="${PLATFORMS:-linux/amd64,linux/arm64}"
docker-tags rockylinux/rockylinux |
while read tag; do
    dockerfile=$(mktemp)
    cat << EOF > $dockerfile
FROM rockylinux/rockylinux:$tag
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
    docker buildx build --platform "$platforms" -f $dockerfile \
        -t ustclug/rocky:$tag \
        -t ghcr.io/ustclug/rocky:$tag \
        --push .
    rm $dockerfile
done
