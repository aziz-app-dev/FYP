const router=require('express').Router();
const ratingController = require('../controllers/rating_controller');
const { verifyAndAuthorization } = require("../middlewares/varifyTokens");


router.post('/',verifyAndAuthorization,ratingController.addRating);
router.get('/',verifyAndAuthorization,ratingController.checkRating);
router.get('/find/:search',ratingController.findFoods);



module.exports = router;