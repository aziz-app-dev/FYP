const mongoose = require("mongoose");

const RatingSchema = new mongoose.Schema(
  {
    userId: { type: String, required: true },
    username: { type: String, default: "" },
    userPhoto: { type: String, default: "" },
    ratingType: {
      type: String,
      required: true,
      enum: ["Restaurant", "Driver", "Food"],
    },
    product: { type: String, required: true },
    rating: {
      type: Number,
      min: 1,
      max: 5,
      required: true,
    },
    comment: { type: String, default: "" },
  },
  { timestamps: true }
);

module.exports = mongoose.model("Rating", RatingSchema);
