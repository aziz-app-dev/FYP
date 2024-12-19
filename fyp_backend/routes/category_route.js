const router = require('express').Router();
const {verifyAdmin} = require('../middlewares/varifyTokens');
const CategoryController=require('../controllers/category_controller');


router.post('/',verifyAdmin,CategoryController.createCategory);
router.get('/',CategoryController.getAllCatagories);
router.get('/random',CategoryController.getRandomCategory);
router.delete('/:id',verifyAdmin,CategoryController.deleteCategory);
router.patch('/image/:id',verifyAdmin,CategoryController.patchCategoryImage);
router.put('/:id',verifyAdmin,CategoryController.updateCategory);
verifyAdmin

module.exports= router;