// const mongoose = require("mongoose");

// const RestaurantsSchema = mongoose.Schema(
//   {
//     title: { type: String, required: true },
//     time: { type: String, required: true },
//     imageUrl: { type: String, required: true },
//     food: { type: Array },
//     pickup: { type: Boolean, required: false, default: true },
//     delivery: { type: Boolean, required: false, default: true },
//     owner: { type: String, required: true },
//     isAvailable: { type: Boolean, default: true },
//     code: { type: String, required: true },
//     logoUrl: {
//       type: String,
//       require: true,
//       default:
//         "https://assets.dryicons.com/uploads/icon/svg/5638/3b786101-e336-4e3d-96bb-a73d2227b8d2.svghttps://assets.dryicons.com/uploads/icon/svg/5638/3b786101-e336-4e3d-96bb-a73d2227b8d2.svg",
//     },
//     imageUrl: {
//       type: String,
//       require: true,
//       default:
//         "https://assets.dryicons.com/uploads/icon/svg/5638/3b786101-e336-4e3d-96bb-a73d2227b8d2.svghttps://assets.dryicons.com/uploads/icon/svg/5638/3b786101-e336-4e3d-96bb-a73d2227b8d2.svg",
//     },
//     rating: { type: Number, min: 1, max: 5 },
//     ratingCount: { type: String },
//     code: { type: String, required: true },
//     coords: {
//       id: { type: String, required: true },
//       latitude: { type: Number, required: true },
//       longitude: { type: Number, required: true },
//       longitudeDelta: { type: Number, required: true , default:0.0221},
//       latitudeDelta: { type: Number, required: true, default:0.0221 },
//       address: { type: String, required: true },
//       title: { type: String, required: true },
//     },
//   },
//   { timestamps: true }
// );

// module.exports=mongoose.model('Restaurants',RestaurantsSchema);

const mongoose = require("mongoose");

const RestaurantesSchema = new mongoose.Schema(
  {
    title: { type: String, required: true },
    time: { type: String, required: true },
    imageUrl: { type: String, required: true },
    food: { type: Array,default:[] },
    pickup: { type: Boolean, required: false, default: true },
    delivery: { type: Boolean, required: false, default: true },
    owner: { type: String, required: true },
    isAvailable: { type: Boolean, default: true },
    code: { type: String, required: true },
    rating: { type: Number, min: 1, max: 5 },
    ratingCount: { type: String },
    verification: {type: String, default: "Pending", enum:["Pending", "Verified", "Rejected"]},
    verificationMessage:{type:String, default:"Your restaurant is under review. We well notify you once it is verified"},
    logoUrl: {
      type: String,
      require: true,
      default:
        "https://assets.dryicons.com/uploads/icon/svg/5638/3b786101-e336-4e3d-96bb-a73d2227b8d2.svghttps://assets.dryicons.com/uploads/icon/svg/5638/3b786101-e336-4e3d-96bb-a73d2227b8d2.svg",
    },
    imageUrl: {
      type: String,
      require: true,
      default:
        "https://assets.dryicons.com/uploads/icon/svg/5638/3b786101-e336-4e3d-96bb-a73d2227b8d2.svghttps://assets.dryicons.com/uploads/icon/svg/5638/3b786101-e336-4e3d-96bb-a73d2227b8d2.svg",
    },
    // code: { type: String, required: true },
    coords: {
      id: { type: String, required: true },
      latitude: { type: Number, required: true },
      longitude: { type: Number, required: true },
      longitudeDelta: { type: Number, required: true, default: 0.0221 },
      latitudeDelta: { type: Number, required: true, default: 0.0221 },
      address: { type: String, required: true },
      title: { type: String, required: true },
    },
  },
  { timestamps: true }
);

// Keep the verificationMessage in sync with the verification state so
// stale "under review" text never lingers on an already-verified
// restaurant. Runs on every save.
RestaurantesSchema.pre("save", function (next) {
  if (this.isModified("verification")) {
    if (this.verification === "Verified") {
      this.verificationMessage = "Your restaurant is live.";
    } else if (this.verification === "Rejected") {
      this.verificationMessage = "Your application was rejected.";
    } else {
      this.verificationMessage =
        "Your restaurant is under review. We will notify you once it is verified.";
    }
  }
  next();
});

module.exports = mongoose.model("Restaurantes", RestaurantesSchema);
