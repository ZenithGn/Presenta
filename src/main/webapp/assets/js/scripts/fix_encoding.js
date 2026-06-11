const fs = require('fs');
const path = require('path');

const viewsDir = path.join(__dirname, 'src', 'main', 'webapp', 'views');

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

    // Replace the script tag to include charset="UTF-8"
    content = content.replace(
        /<script src="\$\{pageContext\.request\.contextPath\}\/assets\/js\/lang\.js"><\/script>/g,
        '<script src="${pageContext.request.contextPath}/assets/js/lang.js" charset="UTF-8"></script>'
    );

    if (content !== original) {
        fs.writeFileSync(filePath, content, 'utf8');
        console.log(`Added UTF-8 charset to: ${filePath}`);
    }
}

processDir(viewsDir);
console.log('Done!');
