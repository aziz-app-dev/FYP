const jwt = require("jsonwebtoken");
const { JWT_SEC } = require("../config/index");

const verifyToken = (req, res, next) => {
  const authHeader = req.headers.authorization;

  if (authHeader) {
    const token = authHeader.split(" ")[1];

    jwt.verify(token, JWT_SEC, (error, user) => {
      if (error) {
        return res.status(403).json({ status: false, message: "Invalid token" });
      }
      req.user = user;
      next();
    });
  } else {
    return res.status(401).json({ status: false, message: "No token provided" });
  }
};

const verifyAndAuthorization = (req, res, next) => {
  verifyToken(req, res, () => {
    if (
      req.user.userType === "Client" ||
      req.user.userType === "Driver" ||
      req.user.userType === "Vendor" ||
      req.user.userType === "Admin"
    ) {
      next();
    } else {
      res.status(401).json({ status: false, message: "You are not authorized" });
    }
  });
};

const verifyVendor = (req, res, next) => {
  verifyToken(req, res, () => {
    if (req.user.userType === "Vendor" || req.user.userType === "Admin") {
      next();
    } else {
      res.status(403).json({ status: false, message: "You are not authorized" });
    }
  });
};

const verifyAdmin = (req, res, next) => {
  verifyToken(req, res, () => {
    if (req.user.userType === "Admin") {
      next();
    } else {
      res.status(403).json({ status: false, message: "You are not authorized" });
    }
  });
};

const verifyDriver = (req, res, next) => {
  verifyToken(req, res, () => {
    if (req.user.userType === "Driver" || req.user.userType === "Admin") {
      next();
    } else {
      res.status(403).json({ status: false, message: "You are not authorized" });
    }
  });
};

module.exports = {
  verifyToken,
  verifyAndAuthorization,
  verifyVendor,
  verifyAdmin,
  verifyDriver,
};
