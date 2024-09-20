#!/bin/bash
# Directory containing downloaded HTML
download_dir="./site/educationwithwork.wixsite.com/index"

# Loop through all HTML files in the directory and subdirectories
find "$download_dir" -name "*.html" | while read html_file; do

  # Extract and log important SEO elements
  echo "Processing SEO tags in $html_file"
  title=$(grep -oP '(?<=<title>).*?(?=</title>)' "$html_file" || echo "No Title")
  meta_desc=$(grep -oP '(?<=<meta name="description" content=").*?(?=")' "$html_file" || echo "No Meta Description")
  echo "Title: $title" >> seo_report.txt
  echo "Meta Description: $meta_desc" >> seo_report.txt
  echo "----" >> seo_report.txt

  # Safely remove the noindex tag
  sed -i '/<meta[^>]*noindex[^>]*>/d' "$html_file"

  # Safely remove the Wix advertisement link (including nested content)
  sed -i '/<a[^>]*href="http:\/\/www.wix.com\/lpviral\/enviral\?utm_campaign=vir_wixad_live.*<\/a>/d' "$html_file"

  # Replace favicon with blog.eliteteams.online/main.jpg
  sed -i 's#https://www.wix.com/favicon.ico#https://blog.eliteteams.online/main.jpg#g' "$html_file"

done

echo "All files processed."
