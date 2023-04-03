#!/bin/bash
source common.sh
docker-tags fedora |
while read tag; do
    dockerfile=$(mktemp)
    cat << EOF > $dockerfile
FROM fedora:$tag
RUN sed -e 's|^metalink=|#metalink=|g' \
        -e 's|^#baseurl=http://download.example/pub/fedora/linux|baseurl=https://mirrors.ustc.edu.cn/fedora|g' \
        -i.bak \
        /etc/yum.repos.d/fedora.repo \
        /etc/yum.repos.d/fedora-modular.repo \
        /etc/yum.repos.d/fedora-updates.repo \
        /etc/yum.repos.d/fedora-updates-modular.repo
EOF
    docker build -f $dockerfile -t ustclug/fedora:$tag .
    docker push ustclug/fedora:$tag
    rm $dockerfile
done
