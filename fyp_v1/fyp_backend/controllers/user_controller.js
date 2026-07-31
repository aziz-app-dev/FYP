const User = require("../models/user");
const jwt = require("jsonwebtoken");
const { SECRET, JWT_SEC } = require("../config/index");
// const { SECRET, JWT_SEC } = require("../config/index");


module.exports = {
  //! ====================Get Users

  // getUser: async (req, res) => {
  //   const userId = req.user.id;
  //   try {
  //     const user = await User.findById(
  //       { _id: userId },
  //       { _v: 0, password: 0, createdAt: 0, updatedAt: 0 }
  //     );
  //     res.status(200).json(user);
  //   } catch (error) {
  //     res
  //       .status(404)
  //       .json({ message: "Error to find user.", error: error.message });
  //   }
  // },
  getUser: async (req, res) => {
    const userId = req.user.id;
    try {
      const user = await User.findById(
        userId,
        '-_v -password -createdAt -updatedAt'
      ).populate('address'); // Populate address if it is a referenced document
  
      if (!user) {
        return res.status(404).json({ message: "User not found." });
      }
  
      res.status(200).json(user);
    } catch (error) {
      res
        .status(500)
        .json({ message: "Error finding user.", error: error.message });
    }
  },
  
  //! ====================Admin: list all users (optionally filter by userType)
  getAllUsersAdmin: async (req, res) => {
    const { userType } = req.query;
    try {
      const query = {};
      if (userType) query.userType = userType;

      const users = await User.find(query, "-password -otp -__v").sort({
        createdAt: -1,
      });

      res.status(200).json({
        status: true,
        count: users.length,
        users,
      });
    } catch (error) {
      res
        .status(500)
        .json({ message: "Error fetching users.", error: error.message });
    }
  },

  // ====================Delete Users
  deleteUser: async (req, res) => {
    const userId = req.user.id;

    try {
      await User.findByIdAndDelete(userId);
      res
        .status(200)
        .json({ success: true, message: "User deleted successfully" });
    } catch (error) {
      res
        .status(500)
        .json({ message: "Error to delete user", error: error.message });
    }
  },
  //! ====================Update Users

  updateUser: async (req, res) => {
    const userId = req.user.id;
    try {
      await User.findByIdAndUpdate(
        userId,
        {
          $set: req.body,
        },
        { new: true }
      );
      res
        .status(200)
        .json({ status: true, message: "User updated successfully" });
    } catch (error) {
      res.status(500).json({ message: "Error updating user" });
    }
  },

  //! ================= verify Account User by ID
  verifyAccount: async (req, res) => {
    const userOtp = req.params.otp;
    const userId = req.user.id;

    try {
      // Find user by ID
      const user = await User.findById(userId);

      // Check if user exists
      if (!user) {
        return res.status(404).json({ message: "User not found" });
      }

      if (userOtp === user.otp) {
        user.verification = true;

        // Save user
        await user.save();

        // const { __v, password, otp, createdAt, ...userData } = user._doc;
        // return res.status(200).json(userData);
        const userToken = jwt.sign(
          { id: user._id, userType: user.userType, email: user.email },
          JWT_SEC,
          { expiresIn: "25d" }
        );

        // Exclude password and otp from the response
        const { password, otp, ...others } = user._doc;

        return res.status(200).json({ ...others, userToken });
      } else {
        return res.status(401).json({ message: "OTP verification failed" });
      }
    } catch (error) {
      return res.status(500).json({ status: false, message: error.message });
    }
  },

  //! ================= verifyPhone User by ID
  // verifyPhone: async (req, res) => {
  //   const userPhone = req.params.phone;
  //   const userId = req.user.id;

  //   try {
  //     // Find user by ID
  //     const user = await User.findById(userId);

  //     // Check if user exists
  //     if (!user) {
  //       return res.status(404).json({ message: "User not found" });
  //     }

  //     user.phoneVerification=true;
  //     user.phone=phone;

  //     await user.save();

  //     const { __v, password, otp, createdAt, ...userData } = user._doc;

  //     return res.status(200).json(userData);

  //   } catch (error) {
  //     return res.status(500).json({ status: false, message: error.message });
  //   }
  // },
  verifyPhone: async (req, res) => {
    const userPhone = req.params.phone; // Getting the phone number from request parameters
    const userId = req.user.id; // Assuming you have middleware to attach user info to the request object

    try {
      // Find user by ID
      const user = await User.findById(userId);

      // Check if user exists
      if (!user) {
        return res.status(404).json({ message: "User not found" });
      }

      // Update user phone and verification status
      user.phoneVerification = true;
      user.phone = userPhone;

      await user.save();

      // Exclude sensitive fields before sending the response
      // const { __v, password, otp, createdAt, ...userData } = user._doc;

      // return res.status(200).json(userData);
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
