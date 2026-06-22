const fs = require('fs');
const content = `import React from 'react';
const OrderTracking = () => <div>Order Tracking</div>;
export default OrderTracking;`;
fs.writeFileSync('src/pages/OrderTracking.tsx', content);
console.log('Restored OrderTracking.tsx');
