const fs = require('fs');
const path = require('path');
const files = {
};
Object.keys(files).forEach(f => { fs.writeFileSync(f, files[f]); console.log('Restored ' + f); });
