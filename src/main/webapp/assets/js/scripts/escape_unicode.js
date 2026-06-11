const fs = require('fs');
const path = require('path');

const langPath = path.join(__dirname, '..', 'lang.js');
let content = fs.readFileSync(langPath, 'utf8');

// Replace all non-ASCII characters with \uXXXX escapes
content = content.replace(/[^\x00-\x7F]/g, function(ch) {
    return '\\u' + ('0000' + ch.charCodeAt(0).toString(16)).slice(-4);
});

fs.writeFileSync(langPath, content, 'utf8');
console.log("Escaped all Unicode characters in lang.js.");
