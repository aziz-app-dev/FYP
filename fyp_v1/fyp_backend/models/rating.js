const mongoose = require("mongoose");

const RatingSchema = new mongoose.Schema({
  userId: {
    type: String,
    required: true,
  },
  ratingType: {
    type: String,
    required: true,
    enum: ["Restaurant", "Driver", "Food"],
  },
  product: {
    type: String,
    required: true,
  },
  rating: {
    type: Number,  // Ensure this is Number
    min: 1,
    max: 5,
    required: true,  // Add required to ensure this field is always provided
  },
});

module.exports = mongoose.model("Rating", RatingSchema);

//   const mongoose = require("mongoose");

// const RatingSchema = new mongoose.Schema({
//   userId: {
//     type: String,
//     required: true,
//   },
//   ratingType: {
//     type: String,
//     required: true,
//     enum: ["Restaurant", "Driver", "Food"],
//   },
//   product: {
//     type: String,
//     required: true,
//   },
//   rating: {
//     type: Number,
//     min: 1,
//     max: 5,
//   },
// });

