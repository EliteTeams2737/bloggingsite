const puppeteer = require('puppeteer');
const fs = require('fs');
const path = require('path');

// Directory containing downloaded HTML
const downloadDir = './site/educationwithwork.wixsite.com/index';

// Function to process each HTML file
async function processHtmlFile(htmlFile) {
  const browser = await puppeteer.launch();
  const page = await browser.newPage();

  try {
    // Open the HTML file in a browser
    await page.goto(`file://${path.resolve(htmlFile)}`);

    // Remove the topmost element from the page
    await page.evaluate(() => {
      const topElement = document.body.firstElementChild;  // Get the topmost element
      if (topElement) {
        topElement.remove();  // Remove the element from the DOM
      }
    });

    // Change the favicon to blog.eliteteams.online
    await page.evaluate(() => {
      let favicon = document.querySelector('link[rel="icon"]');
      if (!favicon) {
        favicon = document.createElement('link');
        favicon.rel = 'icon';
        document.head.appendChild(favicon);
      }
      favicon.href = 'https://blog.eliteteams.online/favicon.ico';
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

// Function to process all HTML files in the directory
async function processAllHtmlFiles() {
  const htmlFiles = fs.readdirSync(downloadDir).filter(file => file.endsWith('.html'));

  for (const file of htmlFiles) {
    const filePath = path.join(downloadDir, file);
    await processHtmlFile(filePath);
  }

  console.log('All files processed.');
}

// Run the processing function
processAllHtmlFiles();
