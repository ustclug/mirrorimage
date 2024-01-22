#!/bin/bash

one_year_ago="$(date -d "1 year ago" +%s)"
parse_tags_js() {
    is_empty=true
    page_url="$(jq -r '.next' <<< "$tags_js")"
    for result in $(jq -c '.results[]' <<< "$tags_js"); do
        if ! date="$(date -d "$(jq -r '.last_updated' <<< "$result")" +%s)"; then
            return 1
        fi
        if ! name="$(jq -r '.name' <<< "$result")"; then
            return 1
        fi
        if (( date > one_year_ago )); then
            echo "$name"
            is_empty=false
        fi
    done
}
docker-tags(){
    image="library/$1"
    page_url="https://registry.hub.docker.com/v2/repositories/${image}/tags/"
    while [[ -n "$page_url" && "$page_url" != "null" && "$is_empty" != "true" ]]
    do
        if ! tags_js="$(curl -fsSL "$page_url")"; then
            echo "curl $page_url failed" >&2
            return 1
        fi
        if ! parse_tags_js; then
            echo "parse json failed" >&2
            return 1
        fi
    done
}