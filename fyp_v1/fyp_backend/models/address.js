const mongoose = require("mongoose");

const addressSchema = new mongoose.Schema(
  {
    userId: { type: String,required: true}, // not user mongoose object type because user data is not required only user id is required
    addressLine1: { type: String, required: true },
    postalCode: { type: String, required: true },
    city: { type: String, required: false },
    district: { type: String, required: true },
    province: { type: String, required: true },
    country: { type: String, required: false },
    latitude:{type:Number, require:false},
    longitude:{type:Number, require:false},
    instruction: { type: String, default: 'Leave at door' },
    default: { type: Boolean, default: false },
  },
  { timestamps: true }
);

module.exports = mongoose.model("Address", addressSchema);
