#! /usr/bin/bash

# Initialize variables to store user-provided parameters
search_query=""
fields=""
artworks=""
email_recipient=""

# Parse command-line arguments
while getopts "s:f:a:m:" opt; do
    case $opt in
        s) search_query=$OPTARG;;
        f) fields=$OPTARG;;
        a) artworks=$OPTARG;;
        m) email_recipient=$OPTARG;;
    esac
done

# If fields are provided, add 'image_id' to the fields list; otherwise, set fields to 'image_id'
if [ -n "$fields" ]; then
    fields+=",image_id"
    else
        fields="image_id"
fi

# Construct the API URL and fetch artwork data based on user input
if [ -z "$fields" ] && [ -n "$search_query" ] && [ -z "$artworks" ]; then
    echo "searching for $search_query"
    curl -X GET "https://api.artic.edu/api/v1/artworks/search?q=$search_query" | jq '.data' > art.json
    elif [ -n "$fields" ] && [ -z "$search_query" ] && [ -z "$artworks" ]; then
        echo "Fields for $fields"
        curl -X GET "https://api.artic.edu/api/v1/artworks?fields=$fields" | jq '.data' > art.json
    elif [ -z "$fields" ] && [ -z "$search_query" ] && [ -n "$artworks" ]; then
        echo "Limit for $artworks"
        curl -X GET "https://api.artic.edu/api/v1/artworks?limit=$artworks" | jq '.data' > art.json
    elif [ -z "$fields" ] && [ -n "$search_query" ] && [ -n "$artworks" ]; then
        echo "search_querying for $search_query and limiting to $artworks"
        curl -X GET "https://api.artic.edu/api/v1/artworks/search?q=$search_query&limit=$artworks" | jq '.data' > art.json
    elif [ -n "$fields" ] && [ -n "$search_query" ] && [ -z "$artworks" ]; then
        echo "Fields for $fields and search_querying for $search_query"
        curl -X GET "https://api.artic.edu/api/v1/artworks/search?q=$search_query&fields=$fields" | jq '.data' > art.json
    elif [ -n "$fields" ] && [ -z "$search_query" ] && [ -n "$artworks" ]; then
        echo "Fields for $fields and limiting to $artworks"
        curl -X GET "https://api.artic.edu/api/v1/artworks?fields=$fields&limit=$artworks" | jq '.data' > art.json
    elif [ -n "$fields" ] && [ -n "$search_query" ] && [ -n "$artworks" ]; then
        echo "Fields for $fields, search_querying for $search_query, and limiting to $artworks"
        curl -X GET "https://api.artic.edu/api/v1/artworks/search?q=$search_query&fields=$fields&limit=$artworks" | jq '.data' > art.json
    else
        echo "Pulling all artwork data"
        curl -X GET "https://api.artic.edu/api/v1/artworks" | jq '.data' > art.json
fi

echo "Artwork data saved to art.json"

output_pdf="output.pdf"

image_urls=$(jq -r '.[].image_id' art.json | sed 's/^/https:\/\/www.artic.edu\/iiif\/2\//; s/$/\/full\/843,/')

# Generate HTML file with image URLs
echo "$image_urls" | while read -r url; do
    echo "<img src='$url/0/default.jpg' />" >> images.html
done

# Convert HTML to PDF using wkhtmltopdf
wkhtmltopdf images.html "$output_pdf"

# If email address is provided, send the PDF as an attachment
if [ -n "$email_recipient" ]; then
    echo "Sending email to $email_recipient"
    subject="The artwork data you requested."
    message="Here is the artwork data you requested :)"
    echo "$message" | mail -s "$subject" "$email_recipient" -A $output_pdf
fi

# Clean up temporary files
rm images.html
# rm art.json