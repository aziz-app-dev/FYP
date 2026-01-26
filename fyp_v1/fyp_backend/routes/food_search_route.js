const router=require('express').Router();
const foodSearch = require('../controllers/search_food_controller');



router.get('/find/:search',foodSearch.findFoods);



module.exports = router;