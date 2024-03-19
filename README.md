# Art Institute of Chicago API Artworks Fetcher

This script (`artScript.sh`) allows you to fetch artworks from the Art Institute of Chicago's public API. It provides options for searching, specifying fields, limiting the number of artworks, and sending the results via email.

## Usage

1. **Run the Script**: Open a terminal in the directory containing the script (`artScript.sh`) and execute the following command to run the script with default values:
   ```bash
   ./artScript.sh
   ```

2. **Command-Line Flags**: Use the following flags to customize the search:
   - `-s <search_query>`: Search for artworks based on a specific word or phrase.
   - `-f <fields>`: Specify the fields to include in the JSON output (separate multiple fields with commas).
   - `-a <artworks>`: Limit the number of artworks to fetch.
   - `-m <email_recipient>`: Specify the email address to send the results (bonus feature).

3. **Email Configuration**: Before using the email feature, ensure that `mailutils` and `ssmtp` are installed. Configure the `ssmtp.conf` file (`/etc/ssmtp/ssmtp.conf`) with the necessary SMTP server details for sending emails.

## Example

To search for artworks related to "nature," specify the fields "title" and "artist_title," limit the results to 10 artworks, and send the results to an email address, use the following command:
```bash
./artScript.sh -s nature -f title,artist_title -a 10 -m example@example.com
```

This will fetch the artwork data, save it to a JSON file (`art.json`), convert the image URLs to an HTML file, and then convert the HTML file to a PDF (`output.pdf`) before sending it as an email attachment.

---
