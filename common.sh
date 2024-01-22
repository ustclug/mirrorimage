#!/bin/bash

docker-tags(){
    image=library/$1
    tags_js=$(curl -sSL "https://registry.hub.docker.com/v2/repositories/${image}/tags/")
    if [ $? -ne 0 ]; then
        echo "curl $image failed" >&2
        return 1
    fi
    grep -oP '(?<="name":").+?(?=")' <(echo "$tags_js")
    while next_page=$(grep -oP '(?<="next":").+?(?=")' <(echo "$tags_js") | sed 's/\\u0026/\&/' | xargs)
    do
        if [[ -z "$next_page" || "$next_page" == "null" ]]; then
            break
        fi
        tags_js=$(curl -sSL "$next_page")
        if [ $? -ne 0 ]; then
            echo "curl $next_page failed" >&2
            return 1
        fi
        grep -oP '(?<="name":").+?(?=")' <(echo "$tags_js")
    done
}
