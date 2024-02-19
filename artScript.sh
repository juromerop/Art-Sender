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
    elif [ -n "$fields" ] && [ -z "$search" ] && [ -z "$artworks" ]; then
        echo "Fields for $fields"
        curl -X GET "https://api.artic.edu/api/v1/artworks?fields=$fields" > art.json
    elif [ -z "$fields" ] && [ -z "$search" ] && [ -n "$artworks" ]; then
        echo "Limit for $artworks"
        curl -X GET "https://api.artic.edu/api/v1/artworks?limit=$artworks" > art.json
    else
        echo "Invalid input"
        exit 1
fi

echo "Artwork data saved to art.json"