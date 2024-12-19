const mongoose = require("mongoose");
// const UserSchema = new mongoose.Schema(
//   {
//     username: { type: String, require: true },
//     email: { type: String, require: true, unique: true },
//     uid: { type: String, require: true, unique: true },
//     password: { type: String, require: true },
//     address: { type: Array, require: false },
//     phone: { type: String, require: false },
//     userType: {
//       type: String,
//       require: true,
//       default: "Client",
//       enum: ["Admin", "Driver", "Client", "Vendor"],
//     },
//     profile: {
//       type: String,
//       require: true,
//       default:
//         "https://assets.dryicons.com/uploads/icon/svg/5638/3b786101-e336-4e3d-96bb-a73d2227b8d2.svghttps://assets.dryicons.com/uploads/icon/svg/5638/3b786101-e336-4e3d-96bb-a73d2227b8d2.svg",
//     },
//   },
//   { timestamps: true }
// );

// module.exports = mongoose.model("User", UserSchema);

const userSchema = new mongoose.Schema(
  {
    username: { type: String, required: true },
    email: { type: String, required: true, unique: true },
    otp: { type: String,required: false, default: "none" },
    fmc: { type: String,required: false, default: "none" },
    password: { type: String, required: true },
    verification: { type: Boolean, default: false },
    phone: { type: String, default: "0123456789" },
    phoneVerification: { type: Boolean, default: false },
    address: { type: mongoose.Schema.Types.ObjectId, ref: "Address" },
    userType: {
      type: String,
      required: true,
      default: "Client",
      enum: ["Client", "Admin", "Vendor", "Driver"],
    },
    profile: {
      type: String,
      require: true,
      default:
        "https://cdn.hero.page/pfp/bee12d5a-258d-468f-a0a7-b9d5d02c0e77-high-contrast-anime-boy-profile-anime-boy-pfp-aesthetic-in-black-4.png",
    },
  },
  { timestamps: true }
);

module.exports = mongoose.model("User", userSchema);
