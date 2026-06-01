const mongoose = require("mongoose");

const orderItemSchema = new mongoose.Schema({
  foodId: { type: mongoose.Schema.Types.ObjectId, ref: "Food" },
  quantity: { type: Number, require: true },
  price: { type: Number, require: true },
  additives: { type: Array },
  instruction: { type: String, default: "" },
});

const orderSchema = new mongoose.Schema(
  {
    userId: { type: mongoose.Schema.Types.ObjectId, ref: "User" },
    orderItems: [orderItemSchema],
    orderTotal: { type: Number, required: true },
    deliveryFee: { type: Number, required: true },
    grandTotal: { type: Number, required: true },
    deliveryAddress: { type: mongoose.Schema.Types.ObjectId, ref: "Address" },
    restaurantAddress: { type: String, required: true  },
    restaurantCoords:[Number],
    recipientCoords:[Number],
    paymentMethod: {
      type: String,
      // required: true,
      default: "Cash",
      enum: ["Cash", "Card", "JazzCash"],
    },
    paymentStatus: {
      type: String,
      default: "Pending",
      enum: ["Pending", "Completed", "Failed"],
    },
    orderStatus: {
      type: String,
      default: "Pending",
      enum: [
        "Pending",
        "Placed",
        "Preparing",
        "Ready",
        "Out For Delivery",
        "Delivering",
        "Delivered",
        "Delivery",
        "Manual",
        "Cancelled",
      ],
    },
    orderDate: { type: Date, default: Date.now },
    restaurantId: { type: mongoose.Schema.Types.ObjectId, ref: "Restaurantes" },
    driverId: { type: String, default: "" },
    // driverId:{type:mongoose.Schema.Types.ObjectId,ref:"Driver"},
    rating: { type: Number, min: 1, max: 5, default: 3 },
    feedBack: { type: String },
    promoCode: { type: String },
    discountAmount: { type: Number },
    notes: { type: String },
  },
  { timestamps: true }
);

module.exports = mongoose.model("Order", orderSchema);
