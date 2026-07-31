const router = require('express').Router();
const orderController = require('../controllers/order_controller');
const {verifyAndAuthorization, verifyVendor, verifyAdmin} = require('../middlewares/varifyTokens');

router.post('/', verifyAndAuthorization, orderController.placeOrder);
router.get('/', verifyAndAuthorization, orderController.getUserOrders);
router.get('/vendor', verifyVendor, orderController.getVendorOrders);
router.get('/admin', verifyAdmin, orderController.getAdminOrders);
router.get('/admin/stats', verifyAdmin, orderController.getAdminStats);
router.put('/:id', verifyAndAuthorization, orderController.updateOrderStatus);


module.exports = router;
