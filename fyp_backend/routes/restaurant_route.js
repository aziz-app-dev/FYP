const router=require('express').Router();
const restaurantController=require('../controllers/restaurant_controller');
const {verifyAndAuthorization,verifyVendor} = require('../middlewares/varifyTokens')

router.post('/',verifyAndAuthorization,restaurantController.addRestaurant);
router.get('/byId/:id',restaurantController.getRestaurantById);
router.get('/:code',restaurantController.getRandomRestaurant);
router.get('/all/:code',restaurantController.getAllNearByRestaurant);
router.delete('/:id',verifyVendor,restaurantController.deleteRestaurant);
router.patch('/:id',verifyVendor,restaurantController.restaurantAvailability);

module.exports= router;