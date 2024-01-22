#!/bin/bash

docker-tags(){
    image=library/$1
    tags_js=$(curl -sSL "https://registry.hub.docker.com/v2/repositories/${image}/tags/")
    grep -oP '(?<="name":").+?(?=")' <(echo $tags_js)
    while next_page=$(grep -oP '(?<="next":").+?(?=")' <(echo $tags_js) | sed 's/\\u0026/\&/' )
    do
        tags_js=$(curl -sSL "$next_page")
        grep -oP '(?<="name":").+?(?=")' <(echo $tags_js)
    done
}
