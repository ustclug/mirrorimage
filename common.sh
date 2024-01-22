#!/bin/bash

one_year_ago=$(date -d "1 year ago" +%s)
parse_tags_js() {
    is_empty=true
    next_page=$(jq -r '.next' <(echo "$tags_js"))
    for result in $(jq -c '.results[]' <(echo "$tags_js")); do
        date=$(date -d "$(jq -r '.last_updated' <(echo "$result"))" +%s)
        name=$(jq -r '.name' <(echo "$result"))
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
    while [[ -n "$next_page" && "$next_page" != "null" && $is_empty == false ]]
    do
        tags_js=$(curl -sSL "$next_page")
        if [ $? -ne 0 ]; then
            echo "curl $next_page failed" >&2
            return 1
        fi
        parse_tags_js
    done
}