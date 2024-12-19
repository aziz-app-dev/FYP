const router=require('express').Router();
const userController=require('../controllers/user_controller');
const {verifyAndAuthorization}=require('../middlewares/varifyTokens')

router.get('/',verifyAndAuthorization,userController.getUser);
router.delete('/',verifyAndAuthorization,userController.deleteUser);
router.put('/',verifyAndAuthorization,userController.updateUser);
router.get('/varify/:otp',verifyAndAuthorization,userController.verifyAccount);
router.get('/varify-phone/:phone',verifyAndAuthorization,userController.verifyPhone);


module.exports = router;