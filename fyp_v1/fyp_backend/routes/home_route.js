const router = require("express").Router();
const homeController = require("../controllers/home_controller");
const jwt = require("jsonwebtoken");
const { JWT_SEC } = require("../config/index");

// Optional auth middleware - attaches user if token exists, but doesn't block
const optionalAuth = (req, res, next) => {
  const authHeader = req.headers.authorization;
  if (authHeader) {
    const token = authHeader.split(" ")[1];
    jwt.verify(token, JWT_SEC, (error, user) => {
      if (!error) {
        req.user = user;
      }
      next();
    });
  } else {
    next();
  }
};

router.get("/", optionalAuth, homeController.getHomeData);

module.exports = router;
