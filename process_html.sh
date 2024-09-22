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

  # Remove the topmost element (first HTML tag)
  sed -i '0,/<[^>]*>/d' "$html_file"

  # Change the favicon to blog.eliteteams.online
  # Remove existing favicon link, if any
  sed -i '/<link[^>]*rel="icon"[^>]*>/d' "$html_file"
  
  # Insert the new favicon link before the closing </head> tag
  sed -i '/<\/head>/i <link rel="icon" href="https://blog.eliteteams.online/favicon.ico">' "$html_file"

done

echo "All files processed."
