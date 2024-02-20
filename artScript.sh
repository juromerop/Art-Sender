#! /usr/bin/bash

search=""
fields=""
artworks=""
mailTo=""

while getopts "s:f:a:m:" opt; do
    case $opt in
        s) search=$OPTARG;;
        f) fields=$OPTARG;;
        a) artworks=$OPTARG;;
        m) mailTo=$OPTARG;;
    esac
done

if [ -z "$fields" ] && [ -n "$search" ] && [ -z "$artworks" ]; then
    echo "Searching for $search"
    curl -X GET "https://api.artic.edu/api/v1/artworks/search?q=$search" | jq '.data' > art.json
    elif [ -n "$fields" ] && [ -z "$search" ] && [ -z "$artworks" ]; then
        echo "Fields for $fields"
        curl -X GET "https://api.artic.edu/api/v1/artworks?fields=$fields" | jq '.data' > art.json
    elif [ -z "$fields" ] && [ -z "$search" ] && [ -n "$artworks" ]; then
        echo "Limit for $artworks"
        curl -X GET "https://api.artic.edu/api/v1/artworks?limit=$artworks" | jq '.data' > art.json
    elif [ -z "$fields" ] && [ -n "$search" ] && [ -n "$artworks" ]; then
        echo "Searching for $search and limiting to $artworks"
        curl -X GET "https://api.artic.edu/api/v1/artworks/search?q=$search&limit=$artworks" | jq '.data' > art.json
    elif [ -n "$fields" ] && [ -n "$search" ] && [ -z "$artworks" ]; then
        echo "Fields for $fields and searching for $search"
        curl -X GET "https://api.artic.edu/api/v1/artworks/search?q=$search&fields=$fields" | jq '.data' > art.json
    elif [ -n "$fields" ] && [ -z "$search" ] && [ -n "$artworks" ]; then
        echo "Fields for $fields and limiting to $artworks"
        curl -X GET "https://api.artic.edu/api/v1/artworks?fields=$fields&limit=$artworks" | jq '.data' > art.json
    elif [ -n "$fields" ] && [ -n "$search" ] && [ -n "$artworks" ]; then
        echo "Fields for $fields, searching for $search, and limiting to $artworks"
        curl -X GET "https://api.artic.edu/api/v1/artworks/search?q=$search&fields=$fields&limit=$artworks" | jq '.data' > art.json
    else
        echo "Pulling all artwork data"
        curl -X GET "https://api.artic.edu/api/v1/artworks" | jq '.data' > art.json
fi

echo "Artwork data saved to art.json"

output_pdf="output.pdf"

image_urls=$(jq -r '.[].thumbnail.lqip' art.json | sed 's/data:image\/[^;]*;base64,//')

echo "$image_urls" | while read -r url; do
    echo "<img src='data:image/jpeg;base64,$url' />" >> images.html
done

wkhtmltopdf images.html "$output_pdf"

if [ -n "$mailTo" ]; then
    echo "Sending email to $mailTo"
    subject="The artwork data you requested."
    message="Here is the artwork data you requested :)"
    echo "$message" | mail -s "$subject" "$mailTo" -A art.json -A $output_pdf
fi

rm images.html
rm art.json