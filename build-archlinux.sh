#!/bin/bash
platforms="${PLATFORMS:-linux/amd64}"
dockerfile=$(mktemp)
cat << EOF > "$dockerfile"
FROM archlinux:latest
RUN printf 'Server = https://mirrors.ustc.edu.cn/archlinux/\$repo/os/\$arch\n' \
    > /etc/pacman.d/mirrorlist
EOF
docker buildx build --platform "$platforms" -f "$dockerfile" \
    -t ustclug/archlinux:latest \
    -t ghcr.io/ustclug/archlinux:latest \
    --push .
rm "$dockerfile"
