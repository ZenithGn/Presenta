const fs = require('fs');
const path = require('path');

const viewsDir = path.join(__dirname, '..', '..', '..', 'views');

const newToggleHtml = `
<div onclick="toggleLanguage()" class="lang-toggle-switch no-translate" style="position: relative; display: flex; align-items: center; width: 64px; height: 28px; border: 1px solid currentColor; border-radius: 20px; cursor: pointer; margin-right: 15px; color: inherit;">
    <div class="lang-slider" style="position: absolute; top: 2px; left: 2px; width: 28px; height: 22px; background: currentColor; opacity: 0.2; border-radius: 14px; transition: transform 0.3s cubic-bezier(0.4, 0.0, 0.2, 1); z-index: 1;"></div>
    <span style="flex: 1; text-align: center; font-size: 11px; font-weight: bold; z-index: 2; pointer-events: none;">EN</span>
    <span style="flex: 1; text-align: center; font-size: 11px; font-weight: bold; z-index: 2; pointer-events: none;">VI</span>
</div>
`.trim();

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

    // Find the old button and replace it
    // The old button is: <button onclick="toggleLanguage()" class="lang-toggle-btn no-translate"...>EN/VI</button>
    content = content.replace(/<button onclick="toggleLanguage\(\)".*?<\/button>/g, newToggleHtml);

    if (content !== original) {
        fs.writeFileSync(filePath, content, 'utf8');
        console.log(`Replaced with switch in: ${filePath}`);
    }
}

processDir(viewsDir);
console.log('Done!');
