#!/bin/bash
source common.sh
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
    docker build -f $dockerfile -t ustclug/fedora:$tag .
    docker push ustclug/fedora:$tag
    rm $dockerfile
done
