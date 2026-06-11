const fs = require('fs');
const path = require('path');

const viewsDir = path.join(__dirname, 'src', 'main', 'webapp', 'views');

const buttonHtml = `\n<button onclick="toggleLanguage()" class="lang-toggle-btn" style="background: transparent; border: 1px solid currentColor; color: inherit; padding: 4px 10px; border-radius: 20px; cursor: pointer; margin-left: auto; margin-right: 15px; font-weight: bold;">EN/VI</button>\n`;
const scriptHtml = `\n<script src="\${pageContext.request.contextPath}/assets/js/lang.js"></script>\n`;

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
    let modified = false;

    // Inject button before </nav>
    if (content.includes('</nav>') && !content.includes('lang-toggle-btn')) {
        content = content.replace('</nav>', buttonHtml + '</nav>');
        modified = true;
    }

    // Inject script before </body>
    if (content.includes('</body>') && !content.includes('lang.js')) {
        content = content.replace('</body>', scriptHtml + '</body>');
        modified = true;
    }

    if (modified) {
        fs.writeFileSync(filePath, content, 'utf8');
        console.log(`Updated: ${filePath}`);
    }
}

processDir(viewsDir);
console.log('Done!');
