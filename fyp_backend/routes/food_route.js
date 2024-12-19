const router = require('express').Router();
const foodController = require('../controllers/food_controller');
const {verifyVendor} = require('../middlewares/varifyTokens');

router.post('/', verifyVendor, foodController.addFood);
router.post('/tag/:id', verifyVendor, foodController.addFoodTags);
router.post('/type/:id', verifyVendor, foodController.addFoodType);
router.delete('/:id', verifyVendor, foodController.deleteFoodById);
router.patch('/:id', verifyVendor, foodController.foodAvailable);

router.get('/:id', foodController.getById);
router.get('/random/:code', foodController.getRandomFoodByCode);
router.get('/random2/:code', foodController.getRandomFoodByCode2);
router.get('/all/:code', foodController.getFoodByCode);
router.get('/byRestaurant/:id', foodController.getFoodByRestaurant);
router.get('/:category/:code', foodController.getRandomByCategoryAndCode);
// router.get('/find/:search',foodController.findFoods);
router.get('/findFoods/:search', foodController.findFoods);





module.exports = router;
