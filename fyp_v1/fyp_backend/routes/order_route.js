const router = require('express').Router();
const orderController = require('../controllers/order_controller');
const {verifyAndAuthorization, verifyVendor} = require('../middlewares/varifyTokens');

router.post('/', verifyAndAuthorization, orderController.placeOrder);
router.get('/', verifyAndAuthorization, orderController.getUserOrders);
router.get('/vendor', verifyVendor, orderController.getVendorOrders);
router.put('/:id', verifyAndAuthorization, orderController.updateOrderStatus);


module.exports = router;
