const fs = require('fs');
const path = require('path');

const langPath = path.join(__dirname, '../lang.js');
const content = fs.readFileSync(langPath);

if (content[0] !== 0xEF || content[1] !== 0xBB || content[2] !== 0xBF) {
    const withBOM = Buffer.concat([Buffer.from([0xEF, 0xBB, 0xBF]), content]);
    fs.writeFileSync(langPath, withBOM);
    console.log("UTF-8 BOM added to lang.js.");
} else {
    console.log("BOM already present.");
}
