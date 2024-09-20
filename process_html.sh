#!/bin/bash
# Directory containing downloaded HTML
download_dir="./site/educationwithwork.wixsite.com/index"

# Create a report file if it doesn't exist
echo "SEO Report" > seo_report.txt

# Loop through all HTML files in the directory and subdirectories
find "$download_dir" -name "*.html" | while read -r html_file; do

  # Check if the file is accessible
  if [[ ! -f "$html_file" ]]; then
    echo "File not found: $html_file" >> seo_report.txt
    continue
  fi

  # Extract and log important SEO elements
  echo "Processing SEO tags in $html_file"
  title=$(grep -oP '(?<=<title>).*?(?=</title>)' "$html_file" || echo "No Title")
  meta_desc=$(grep -oP '(?<=<meta name="description" content=").*?(?=")' "$html_file" || echo "No Meta Description")
  echo "Title: $title" >> seo_report.txt
  echo "Meta Description: $meta_desc" >> seo_report.txt
  echo "----" >> seo_report.txt

  # Safely remove the noindex tag
  sed -i '/<meta[^>]*noindex[^>]*>/d' "$html_file"

  # Remove the specific Wix advertisement link (the entire block)
  sed -i '/<a data-testid="linkElement" href="http:\/\/www.wix.com\/lpviral\/enviral\?utm_campaign=vir_wixad_live&amp;adsVersion=white&amp;orig_msid=a0039aa9-b40e-4e53-bbe6-f3283196775e" target="_blank" rel="nofollow" class="Oxzvyr YD5pSO has-custom-focus">/,/<\/a>/d' "$html_file"

  # Replace favicon with blog.eliteteams.online/main.jpg
  sed -i 's#https://www.wix.com/favicon.ico#https://blog.eliteteams.online/main.jpg#g' "$html_file"

done

echo "All files processed."
