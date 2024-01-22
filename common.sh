#!/bin/bash

one_year_ago=$(date -d "1 year ago" +%s)
parse_tags_js() {
    is_empty=true
    local date_names=($(grep -oP '(?<="last_updated":").+?(?=")|(?<="name":").+?(?=")' <(echo "$tags_js")))
    for ((i=0; i<${#date_names[@]}/2; i++)); do
        date=$(date -d "${date_names[2*i]}" +%s)
        name=${date_names[2*i+1]}
        if (( date > one_year_ago )); then
            echo "$name"
            is_empty=false
    fi
    done
}
docker-tags(){
    image=library/$1
    tags_js=$(curl -sSL "https://registry.hub.docker.com/v2/repositories/${image}/tags/")
    if [ $? -ne 0 ]; then
        echo "curl $image failed" >&2
        return 1
    fi
    parse_tags_js
    while next_page=$(grep -oP '(?<="next":").+?(?=")' <(echo "$tags_js") | sed 's/\\u0026/\&/' | xargs)
    do
        if [[ -z "$next_page" || "$next_page" == "null" || $is_empty == true ]]; then
            break
        fi
        tags_js=$(curl -sSL "$next_page")
        if [ $? -ne 0 ]; then
            echo "curl $next_page failed" >&2
            return 1
        fi
        parse_tags_js
    done
}