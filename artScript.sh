#! /usr/bin/bash

search=""
fields=""
artworks=""

while getopts "s:f:a:" opt; do
    case $opt in
        s) search=$OPTARG;;
        f) fields=$OPTARG;;
        a) artworks=$OPTARG;;
    esac
done

if [ -z "$fields" ] && [ -n "$search" ] && [ -z "$artworks" ]; then
    echo "Searching for $search"
    curl -X GET "https://api.artic.edu/api/v1/artworks/search?q=$search" > art.json
fi
