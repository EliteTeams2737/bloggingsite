const fs = require('fs');
const path = require('path');

// Function to process each HTML file
async function processHtmlFile(filePath) {
    let htmlContent = fs.readFileSync(filePath, 'utf8');

    // Remove the specific <a> element
    const linkToRemove = 'http://www.wix.com/lpviral/enviral?utm_campaign=vir_wixad_live&adsVersion=white&orig_msid=a0039aa9-b40e-4e53-bbe6-f3283196775e';
    const regex = new RegExp(`<a[^>]*href=["']?${linkToRemove}["']?[^>]*>.*?</a>`, 'gs');
    htmlContent = htmlContent.replace(regex, '');

    // Update favicon links
    htmlContent = htmlContent.replace(/<link rel="icon"[^>]*href=["'][^"']*["'][^>]*>/g, '<link rel="icon" sizes="192x192" href="https://blog.eliteteams.online/favicon.ico" type="image/x-icon">');
    htmlContent = htmlContent.replace(/<link rel="shortcut icon"[^>]*href=["'][^"']*["'][^>]*>/g, '<link rel="shortcut icon" href="https://blog.eliteteams.online/favicon.ico" type="image/x-icon">');
    htmlContent = htmlContent.replace(/<link rel="apple-touch-icon"[^>]*href=["'][^"']*["'][^>]*>/g, '<link rel="apple-touch-icon" href="https://blog.eliteteams.online/favicon.ico" type="image/x-icon">');

    // Write the changes back to the file
    fs.writeFileSync(filePath, htmlContent, 'utf8');
}

// Function to process all HTML files in a directory recursively
function processAllHtmlFiles(dir) {
    fs.readdirSync(dir).forEach(file => {
        const fullPath = path.join(dir, file);
        if (fs.statSync(fullPath).isDirectory()) {
            processAllHtmlFiles(fullPath); // Recursively process subdirectories
        } else if (fullPath.endsWith('.html')) {
            processHtmlFile(fullPath);
        }
    });
}

// Specify the directory containing the HTML files
const directoryToProcess = './site/educationwithwork.wixsite.com/index';
processAllHtmlFiles(directoryToProcess);
