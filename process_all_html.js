const puppeteer = require('puppeteer');
const fs = require('fs');
const path = require('path');

// Directory containing downloaded HTML
const downloadDir = './site/educationwithwork.wixsite.com/index';

// Function to process each HTML file
async function processHtmlFile(htmlFile) {
  const browser = await puppeteer.launch({ headless: true });
  const page = await browser.newPage();

  try {
    // Open the HTML file in a browser
    await page.goto(`file://${path.resolve(htmlFile)}`);

    // Remove the topmost Wix advertisement link element
    await page.evaluate(() => {
      const wixAd = document.querySelector('a[data-testid="linkElement"]');
      if (wixAd) {
        wixAd.remove();
        console.log('Wix ad removed');
      }
    });

    // Change all favicon links
    await page.evaluate(() => {
      const faviconLink = 'https://blog.eliteteams.online/favicon.ico';

      // Update rel="icon"
      let icon = document.querySelector('link[rel="icon"]');
      if (!icon) {
        icon = document.createElement('link');
        icon.rel = 'icon';
        document.head.appendChild(icon);
      }
      icon.href = faviconLink;

      // Update rel="shortcut icon"
      let shortcutIcon = document.querySelector('link[rel="shortcut icon"]');
      if (!shortcutIcon) {
        shortcutIcon = document.createElement('link');
        shortcutIcon.rel = 'shortcut icon';
        document.head.appendChild(shortcutIcon);
      }
      shortcutIcon.href = faviconLink;

      // Update rel="apple-touch-icon"
      let appleIcon = document.querySelector('link[rel="apple-touch-icon"]');
      if (!appleIcon) {
        appleIcon = document.createElement('link');
        appleIcon.rel = 'apple-touch-icon';
        document.head.appendChild(appleIcon);
      }
      appleIcon.href = faviconLink;
    });

    // Save the modified HTML back to the file
    const content = await page.content();
    fs.writeFileSync(htmlFile, content, 'utf8');
    console.log(`Processed ${htmlFile}`);
  } catch (error) {
    console.error(`Error processing ${htmlFile}:`, error);
  } finally {
    await browser.close();
  }
}

// Function to recursively find all HTML files in a directory and subdirectories
function getAllHtmlFiles(dir, fileList = []) {
  const files = fs.readdirSync(dir);

  files.forEach((file) => {
    const filePath = path.join(dir, file);
    if (fs.statSync(filePath).isDirectory()) {
      getAllHtmlFiles(filePath, fileList); // Recursively add files from subdirectories
    } else if (file.endsWith('.html')) {
      fileList.push(filePath);
    }
  });

  return fileList;
}

// Function to process all HTML files in the directory and subdirectories
async function processAllHtmlFiles() {
  const htmlFiles = getAllHtmlFiles(downloadDir);

  for (const file of htmlFiles) {
    await processHtmlFile(file);
  }

  console.log('All files processed.');
}

// Main function to run the processing
async function main() {
  try {
    await processAllHtmlFiles();
  } catch (error) {
    console.error('Failed to process files:', error);
  }
}

// Run the main function
main();
