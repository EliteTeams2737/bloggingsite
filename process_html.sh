#!/bin/bash
# Directory containing downloaded HTML
download_dir="./site/educationwithwork.wixsite.com/index"

# Loop through all HTML files in the directory and subdirectories
find "$download_dir" -name "*.html" | while read -r html_file; do

  # Extract and log important SEO elements
  echo "Processing SEO tags in $html_file"
  title=$(grep -oP '(?<=<title>).*?(?=</title>)' "$html_file" || echo "No Title")
  meta_desc=$(grep -oP '(?<=<meta name="description" content=").*?(?=")' "$html_file" || echo "No Meta Description")
  echo "Title: $title" >> seo_report.txt
  echo "Meta Description: $meta_desc" >> seo_report.txt
  echo "----" >> seo_report.txt

  # Safely remove the noindex tag
  sed -i '/<meta[^>]*noindex[^>]*>/d' "$html_file"

  # Remove the specific Wix advertisement link
  sed -i '/<a data-testid="linkElement" href="http:\/\/www.wix.com\/lpviral\/enviral\?utm_campaign=vir_wixad_live&amp;adsVersion=white&amp;orig_msid=a0039aa9-b40e-4e53-bbe6-f3283196775e" target="_blank" rel="nofollow" class="Oxzvyr YD5pSO has-custom-focus"><span class="aGHwBE"><span data-hook="freemium-text" class="areOb6">This site was designed with the <div data-testid="bannerLogo" class="dTTUA9"><div><svg class="_4i7Zy" viewBox="0 0 28 10.89" aria-label="wix"><path d="M16.02.2c-.55.3-.76.78-.76 2.14a2.17 2.17 0 0 1 .7-.42 3 3 0 0 0 .7-.4A1.62 1.62 0 0 0 17.22 0a3 3 0 0 0-1.18.2z" class="o4sLYL"><\/path><path d="M12.77.52a2.12 2.12 0 0 0-.58 1l-1.5 5.8-1.3-4.75a4.06 4.06 0 0 0-.7-1.55 2.08 2.08 0 0 0-2.9 0 4.06 4.06 0 0 0-.7 1.55L3.9 7.32l-1.5-5.8a2.12 2.12 0 0 0-.6-1A2.6 2.6 0 0 0 0 .02l2.9 10.83a3.53 3.53 0 0 0 1.42-.17c.62-.33.92-.57 1.3-2 .33-1.33 1.26-5.2 1.35-5.47a.5.5 0 0 1 .34-.4.5.5 0 0 1 .4.5c.1.3 1 4.2 1.4 5.5.4 1.5.7 1.7 1.3 2a3.53 3.53 0 0 0 1.4.2l2.8-11a2.6 2.6 0 0 0-1.82.53zm4.43 1.26a1.76 1.76 0 0 1-.58.5c-.26.16-.52.26-.8.4a.82.82 0 0 0-.57.82v7.36a2.47 2.47 0 0 0 1.2-.15c.6-.3.75-.6.75-2V1.8zm7.16 3.68L28 .06a3.22 3.22 0 0 0-2.3.42 8.67 8.67 0 0 0-1 1.24l-1.34 1.93a.3.3 0 0 1-.57 0l-1.4-1.93a8.67 8.67 0 0 0-1-1.24 3.22 3.22 0 0 0-2.3-.43l3.6 5.4-3.7 5.4a3.54 3.54 0 0 0 2.32-.48 7.22 7.22 0 0 0 1-1.16l1.33-1.9a.3.3 0 0 1 .57 0l1.37 2a8.2 8.2 0 0 0 1 1.2 3.47 3.47 0 0 0 2.33.5z"><\/path><\/svg><\/div><div class="uJDaUS">.com<\/div><\/div> website builder. Create your website today.<\/span><span data-hook="freemium-button" class="O0tKs2 Oxzvyr">Start Now<\/span><\/span><\/a>/d' "$html_file"

  # Replace favicon with blog.eliteteams.online/main.jpg
  sed -i 's#https://www.wix.com/favicon.ico#https://blog.eliteteams.online/main.jpg#g' "$html_file"

done

echo "All files processed."
