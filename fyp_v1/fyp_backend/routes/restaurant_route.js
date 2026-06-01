const router=require('express').Router();
const restaurantController=require('../controllers/restaurant_controller');
const {verifyAndAuthorization,verifyVendor,verifyAdmin} = require('../middlewares/varifyTokens')

router.post('/',verifyAndAuthorization,restaurantController.addRestaurant);
router.get('/default',restaurantController.getDefaultRestaurant);
router.get('/mine',verifyVendor,restaurantController.getMyRestaurants);
router.get('/admin/all',verifyAdmin,restaurantController.getAllRestaurantsAdmin);
router.get('/byId/:id',restaurantController.getRestaurantById);
router.get('/:code',restaurantController.getRandomRestaurant);
router.get('/all/:code',restaurantController.getAllNearByRestaurant);
router.delete('/:id',verifyVendor,restaurantController.deleteRestaurant);
router.patch('/:id',verifyVendor,restaurantController.restaurantAvailability);
router.put('/:id',verifyVendor,restaurantController.updateRestaurant);
router.patch('/verify/:id',verifyAdmin,restaurantController.setVerificationStatus);

module.exports= router;