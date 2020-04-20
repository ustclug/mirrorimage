#!/bin/bash
source common.sh
docker-tags fedora |
while read tag; do
    dockerfile=$(mktemp)
    cat << EOF > $dockerfile
FROM fedora:$tag
RUN sed -i \
    -e 's/metalink/#metalink/g' \
    -e 's/#baseurl/baseurl/g' \
    -e 's|download.fedoraproject.org/pub/fedora/linux|mirrors.ustc.edu.cn/fedora|g' \
    /etc/yum.repos.d/fedora.repo /etc/yum.repos.d/fedora-updates.repo
EOF
    docker build -f $dockerfile -t ustclug/fedora:$tag .
    docker push ustclug/fedora:$tag
    rm $dockerfile
done
