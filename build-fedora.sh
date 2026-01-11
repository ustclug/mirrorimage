#!/bin/bash
source common.sh
platforms="${PLATFORMS:-linux/amd64,linux/arm64}"
docker-tags fedora |
while read tag; do
    dockerfile=$(mktemp)
    sedcommand="sed -e 's|^metalink=|#metalink=|g' \
        -e 's|^#baseurl=http://download.example/pub/fedora/linux|baseurl=https://mirrors.ustc.edu.cn/fedora|g' \
        -i.bak "
    cat << EOF > $dockerfile
FROM fedora:$tag
RUN $sedcommand /etc/yum.repos.d/fedora-modular.repo /etc/yum.repos.d/fedora-updates-modular.repo || true \
    && $sedcommand /etc/yum.repos.d/fedora.repo /etc/yum.repos.d/fedora-updates.repo     
EOF
    docker buildx build --platform "$platforms" -f $dockerfile \
        -t ustclug/fedora:$tag \
        -t ghcr.io/ustclug/fedora:$tag \
        --push .
    rm $dockerfile
done
