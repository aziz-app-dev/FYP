const Address = require("../models/address");

module.exports = {
  // ! 1. add the address
  createAddress: async (req, res) => {
    const userId = req.user.id;
    const {
      addressLine1,
      postalCode,
      city,
      district,
      province,
      country,
      instruction,
      latitude,
      longitude,
    } = req.body;

    const newAddress = new Address({
      userId,
      addressLine1,
      postalCode,
      city,
      district,
      province,
      country,
      instruction,
      latitude,
      longitude,
      default: req.body.default,
    });

    try {
      if (req.body.default === true) {
        // Update all other addresses for this user to be non-default
        await Address.updateMany({ userId: userId }, { default: false });
      }
      newAddress.save();
      res
        .status(201)
        .json({ status: true, message: "Add Address successfully!" });
    } catch (error) {
      res.status(500).json({ status: false, message: error.message });
    }
  },

  //   ! 2. delete the address
  // deleteAddress: async (req, res) => {
  //   const addressId = req.params.id;

  //   try {
  //     const existingAddress = await Address.findOne(addressId);

  //     if (!existingAddress) {
  //       res.status(404).json({ status: false, message: "Address not found" });
  //     }
  //     await Address.findByIdAndDelete(addressId);
  //   } catch (error) {
  //     res.status(500).json({ status: false, message: error.message });
  //   }
  // },

  // // ! 3. get default the address
  // getDefaultAddress: async (req, res) => {
  //   const userId = req.user.id;

  //   try {
  //     const address = await Address.findOne({ userId: userId, default: true });
  //     if (!address) {
  //       res.status(404).json({ status: false, message: "Address not found" });
  //     }
  //     res.status(200).json(address);
  //   } catch (error) {
  //     res.status(500).json({ status: false, message: error.message });
  //   }
  // },
  deleteAddress: async (req, res) => {
    const addressId = req.params.id;

    try {
      const existingAddress = await Address.findOne(addressId);

      if (!existingAddress) {
        return res.status(404).json({ status: false, message: "Address not found" }); // Return after sending response
      }
      await Address.findByIdAndDelete(addressId);
      return res.status(200).json({ status: true, message: "Address deleted successfully" }); // Return to avoid continuing
    } catch (error) {
      return res.status(500).json({ status: false, message: error.message });
    }
  },

  getDefaultAddress: async (req, res) => {
    const userId = req.user.id;

    try {
      const address = await Address.findOne({ userId: userId, default: true });
      if (!address) {
        return res.status(404).json({ status: false, message: "Address not found" }); // Return after sending response
      }
      return res.status(200).json(address); // Return to avoid sending multiple responses
    } catch (error) {
      return res.status(500).json({ status: false, message: error.message });
    }
  },

  // ! 4. get all address
  
  getUserAddress: async (req, res) => {
    const userId = req.user.id;

    try {
      const addresses = await Address.find({ userId: userId });

      if (!addresses || addresses.length === 0) {
        res.status(404).json({ status: false, message: "Address not found" });
        return;
      }

      res.status(200).json(addresses);
    } catch (error) {
      res.status(500).json({ status: false, message: error.message });
    }
  },

  // ! 5. update the address
  updateAddress: async (req, res) => {
    const addressId = req.body.addressId;
    const userId = req.user.id;
    const {
      addressLine1,
      postalCode,
      city,
      district,
      province,
      country,
      instruction,
    } = req.body;

    try {
      const updateAddress = new Address({
        userId,
        addressLine1,
        postalCode,
        city,
        district,
        province,
        country,
        instruction,
        default: req.body.default,
      });
      existingAddress = await Address.findOne({
        userId: userId,
        _id: addressId,
      });
      if (!existingAddress) {
        res.status(404).json({ status: false, message: "Address not found" });
      }
      // If the updated address is set as default,
      // update all other addresses for the user to be non-default
      if (req.body.default) {
        await Address.updateMany({ userId: userId }, { default: false });
      }
      await Address.findByIdAndUpdate({
        addressId: addressId,
        updateAddress,
        new: true,
      });
    } catch (error) {
      res.status(500).json({ status: false, message: error.message });
    }
  },

  // ! 6. set default address
  setDefaultAddress: async (req, res) => {
    const addressId = req.params.id;
    const userId = req.user.id;

    try {
      // Find the address based on user ID and address ID
      const address = await Address.findOne({
        userId: userId,
        _id: addressId,
      });

      // Check if the address is found
      if (!address) {
        res.status(404).json({ status: false, message: "Address not found" });
      }

      // Set all addresses for the user to be non-default
      await Address.updateMany({ userId: userId }, { default: false });

      // Set the specified address as the default address
      await Address.findByIdAndUpdate(
        { userId: userId },
        { default: true },
        { new: false }
      );

      // Respond with a success message
      res
        .status(201)
        .json({ status: true, message: "Address updated successfully" });
    } catch (error) {
      // Handle any errors that may occur during the process
      res.status(500).json({ status: false, message: error.message });
    }
  },
};
