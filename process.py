import os
import shutil
from bs4 import BeautifulSoup

# The favicon URL to replace in the HTML files
new_favicon_url = "https://thumbs.dreamstime.com/b/book-star-top-symbolizing-creativity-knowledge-designed-modern-logo-create-sleek-organization-promoting-315285574.jpg"

# The directory where the HTML files are located
html_dir = './site/educationwithwork.wixsite.com/index'

# Function to update favicons and remove specific <a> elements from HTML content
def process_html(file_path):
    with open(file_path, 'r', encoding='utf-8') as file:
        soup = BeautifulSoup(file, 'html.parser')

        # Update favicon link
        for link in soup.find_all('link', rel='icon'):
            link['href'] = new_favicon_url

        # Remove Wix ads (anchor tag with specific class and href)
        ad_links = soup.find_all('a', {
            'data-testid': 'linkElement', 
            'href': 'http://www.wix.com/lpviral/enviral?utm_campaign=vir_wixad_live&adsVersion=white&orig_msid=a0039aa9-b40e-4e53-bbe6-f3283196775e', 
            'class': 'Oxzvyr YD5pSO has-custom-focus'
        })
        for ad_link in ad_links:
            ad_link.decompose()  # Remove the element

        # Write the updated HTML content back to the file
        with open(file_path, 'w', encoding='utf-8') as updated_file:
            updated_file.write(str(soup))

# List all HTML files in the directory
html_files = []
for root, dirs, files in os.walk(html_dir):
    for file in files:
        if file.endswith('.html'):
            html_files.append(os.path.join(root, file))

# Process each HTML file
for html_file in html_files:
    process_html(html_file)

print("Processing completed for all HTML files.")

# Copy everything from the subdirectory to the main directory
def copy_to_main_directory(src_dir, dest_dir='./'):
    for item in os.listdir(src_dir):
        src_item = os.path.join(src_dir, item)
        dest_item = os.path.join(dest_dir, item)
        if os.path.isdir(src_item):
            if not os.path.exists(dest_item):
                shutil.copytree(src_item, dest_item)
            else:
                print(f"Directory {dest_item} already exists. Skipping.")
        else:
            shutil.copy2(src_item, dest_item)
            print(f"Copied {src_item} to {dest_item}")

# Copy all files and directories to the main directory
copy_to_main_directory(html_dir)

print("Copying completed.")
