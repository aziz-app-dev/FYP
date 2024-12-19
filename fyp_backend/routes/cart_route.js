const router = require("express").Router();
const cartController = require("../controllers/cart_controller");
const { verifyAndAuthorization } = require("../middlewares/varifyTokens");

router.post("/", verifyAndAuthorization, cartController.addProductToCart);
router.get("/", verifyAndAuthorization, cartController.fetchUserCart);
router.get(
  "/decrement/:id",
  verifyAndAuthorization,
  cartController.decrementProductQty
);

router.get("/count", verifyAndAuthorization, cartController.getCartCount);
router.delete(
  "/delete/:id",
  verifyAndAuthorization,
  cartController.removeProduct
);
router.delete("/clear", verifyAndAuthorization, cartController.clearUserCart);

module.exports = router;
