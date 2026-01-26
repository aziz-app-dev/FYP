const User = require("../models/user");
const crypto = require("crypto-js");
const jwt = require("jsonwebtoken");
// const admin = require("firebase-admin");
const { SECRET, JWT_SEC } = require("../config/index");
const generateOtp = require("../utils/utls");
const sendEmail = require("../utils/smtp_function");
module.exports = {
  //! ================ Create Users
  createUser: async (req, res) => {
  // const user = req.body;
  const emailRegex =
    /^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$/;

  // Validate email format
  if (!emailRegex.test(req.body.email)) {
    return res
      .status(400)
      .json({ status: false, message: "Invalid email format" });
  }

  const minPasswordLength = 8;
  // Validate password length
  if (req.body.password < minPasswordLength) {
    return res.status(400).json({
      status: false,
      message: "Password must be at least 8 characters long",
    });
  }

  try {
    // Check if email already exists
    const emailExists = await User.findOne({ email: req.body.email });
    if (emailExists) {
      return res
        .status(400)
        .json({ status: false, message: "Email already exists" });
    }

    // Generate OTP
    const otp = generateOtp();

    // Encrypt password
    const encryptedPassword = crypto.AES.encrypt(
      req.body.password,
      SECRET
    ).toString();

    // Determine userType (only allow Client or Vendor during registration)
    let userType = "Client";
    if (req.body.userType === "Vendor" || req.body.userType === "Customer") {
      userType = req.body.userType === "Customer" ? "Client" : "Vendor";
    }

    // Save user
    const newUser = new User({
      username: req.body.username,
      email: req.body.email,
      password: encryptedPassword,
      userType: userType,
      otp: otp,
    });

    // save user in db
    await newUser.save();

    // send otp
    sendEmail(newUser.email, otp);
//  response
    return res
      .status(201)
      .json({ status: true, message: "User created successfully" });

  } catch (error) {
    return res.status(500).json({
      status: false,
      message: error.message,
    });
  }},

  
  //! ================= LogIn Users
  loginUser: async (req, res) => {
    const emailRegex =
      /^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$/;

    // Validate email format
    if (!emailRegex.test(req.body.email)) {
      return res
        .status(400)
        .json({ status: false, message: "Invalid email format" });
    }

    const minPasswordLength = 8;
    // Validate password length
    if (req.body.password.length < minPasswordLength) {
      return res.status(400).json({
        status: false,
        message: "Password must be at least 8 characters long",
      });
    }

    try {
      // Find user by email
      const user = await User.findOne(
        { email: req.body.email },
        { __v: 0, updatedAt: 0, createdAt: 0 }
      );

      // Check if user exists
      if (!user) {
        return res
          .status(400)
          .json({ status: false, message: "User not found" });
      }

      // Decrypt password
      const decryptPassword = crypto.AES.decrypt(user.password, SECRET);
      const decryptedPassword = decryptPassword.toString(crypto.enc.Utf8);

      // Check if password matches
      if (decryptedPassword !== req.body.password) {
        return res
          .status(401)
          .json({ status: false, message: "Wrong password" });
      }

      // Generate JWT token
      const userToken = jwt.sign(
        { id: user._id, userType: user.userType, email: user.email },
        JWT_SEC,
        { expiresIn: "25d" }
      );

      // Exclude password and otp from the response
      const { password, otp, ...others } = user._doc;

      return res.status(200).json({ ...others, userToken });
    } catch (error) {
      return res.status(500).json({ status: false, message: error.message });
    }
  },
};


//   const user = req.body;
  //   const emailRegex =
  //     /^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$/;

  //   // Validate email format
  //   if (!emailRegex.test(user.email)) {
  //     return res
  //       .status(400)
  //       .json({ status: false, message: "Invalid email format" });
  //   }

  //   const minPasswordLength = 8;
  //   // Validate password length
  //   if (user.password.length < minPasswordLength) {
  //     return res.status(400).json({
  //       status: false,
  //       message: "Password must be at least 8 characters long",
  //     });
  //   }

  //   try {
  //     // Check if email already exists
  //     const emailExists = await User.findOne({ email: req.body.email });
  //     if (emailExists) {
  //       return res
  //         .status(400)
  //         .json({ status: false, message: "Email already exists" });
  //     }

  //     // Generate OTP
  //     const otp = generateOtp();

  //     // Encrypt password
  //     const encryptedPassword = crypto.AES.encrypt(
  //       user.password,
  //       SECRET
  //     ).toString();

  //     // Save user
  //     const newUser = new User({
  //       username: user.username,
  //       email: user.email,
  //       password: encryptedPassword,
  //       // uid: user.uid, // Assuming user.uid is coming from the request body
  //       userType: "Client",
  //       otp: otp,
  //     });
  //     // save user in db
  //     await newUser.save();
  //     //  send otp
  //     sendEmail(newUser.email, otp);

  //     return res
  //       .status(201)
  //       .json({ status: true, message: "User created successfully" });
        
  //   } catch (error) {

  //     return res.status(500).json({
  //       status: false,
  //       message: error.message,
  //     });
  //   }
  // },
  