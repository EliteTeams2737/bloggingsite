import time
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options

# Set up Chrome options
options = Options()
options.add_argument('--headless')  # Run in headless mode
options.add_argument('--no-sandbox')
options.add_argument('--disable-dev-shm-usage')
service = Service('/usr/local/bin/chromedriver')

# Start the WebDriver and load the page
driver = webdriver.Chrome(service=service, options=options)
driver.get('https://educationwithwork.wixsite.com/index')

# Scroll down to load all dynamic content
last_height = driver.execute_script('return document.body.scrollHeight')
while True:
    driver.execute_script('window.scrollTo(0, document.body.scrollHeight);')
    time.sleep(2)  # Wait for the page to load
    new_height = driver.execute_script('return document.body.scrollHeight')
    if new_height == last_height:
        break
    last_height = new_height

# Save the loaded page source
with open('site/content.html', 'w', encoding='utf-8') as f:
    f.write(driver.page_source)

driver.quit()
