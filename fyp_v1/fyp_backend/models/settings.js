const mongoose = require("mongoose");

const settingsSchema = new mongoose.Schema(
  {
    // Mode settings
    serviceMode: {
      type: String,
      enum: ["multi-vendor", "single"],
      default: "multi-vendor",
    },
    defaultRestaurantId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Restaurantes",
    },
    allowVendorRegistration: { type: Boolean, default: true },

    // App customization
    appName: { type: String, default: "Food Delivery" },
    currency: { type: String, default: "PKR" },
    currencySymbol: { type: String, default: "Rs" },
    deliveryFee: { type: Number, default: 50 },
    taxRate: { type: Number, default: 0 },

    // Tracking
    updatedBy: { type: mongoose.Schema.Types.ObjectId, ref: "User" },
  },
  { timestamps: true }
);

module.exports = mongoose.model("Settings", settingsSchema);
