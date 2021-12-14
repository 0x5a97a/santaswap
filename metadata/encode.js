const fs = require('fs');

function encodeMetadata() {
    const svg = fs.readFileSync('./santaswap.svg', {encoding: 'base64'});
    const metadata = JSON.parse(fs.readFileSync('./metadata.json'));
    const encodedImg = `data:image/svg+xml;base64,${svg}`;
    metadata.image = encodedImg;
    const encodedJSON = Buffer.from(JSON.stringify(metadata)).toString("base64");
    return `data:application/json;base64,${encodedJSON}`;
}

console.log(encodeMetadata());