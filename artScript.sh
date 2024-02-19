#! /usr/bin/bash

search=""
fields=[]
artworks=5

while getopts "s:f:a:" opt; do
    case $opt in
        s) search=$OPTARG;;
        f) fields=$OPTARG;;
        a) artworks=$OPTARG;;
    esac
done

curl -X GET "https://api.artic.edu/api/v1/artworks/search?q=$search" > art.json