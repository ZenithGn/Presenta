const fs = require('fs');
const path = require('path');

const viewsDir = path.join(__dirname, '..', '..', '..', 'views');

const newButtonHtml = `\n<button onclick="toggleLanguage()" class="lang-toggle-btn no-translate" style="background: transparent; border: 1px solid currentColor; color: inherit; padding: 4px 10px; border-radius: 20px; cursor: pointer; margin-right: 15px; font-weight: bold; white-space: nowrap;">EN/VI</button>\n`;

function processDir(dir) {
    const files = fs.readdirSync(dir);
    for (const file of files) {
        const fullPath = path.join(dir, file);
        if (fs.statSync(fullPath).isDirectory()) {
            processDir(fullPath);
        } else if (fullPath.endsWith('.jsp')) {
            processFile(fullPath);
        }
    }
}

function processFile(filePath) {
    let content = fs.readFileSync(filePath, 'utf8');
    let original = content;

    // 1. Remove the old button
    content = content.replace(/<button onclick="toggleLanguage\(\)".*?<\/button>\s*/g, '');

    // 2. Insert the new button just AFTER <div class="nav-actions">
    content = content.replace(/(<div class="nav-actions">)/g, '$1' + newButtonHtml);

    // 3. Insert the new button just AFTER <div style="display: flex; align-items: center; gap: 20px;">
    content = content.replace(/(<div style="display: flex; align-items: center; gap: 20px;">)/g, '$1' + newButtonHtml);

    if (content !== original) {
        fs.writeFileSync(filePath, content, 'utf8');
        console.log(`Moved button to left in: ${filePath}`);
    }
}

processDir(viewsDir);
console.log('Done!');
