// Creates (or resets) the platform Super Admin account.
// Usage: node seed-admin.js [email] [password]
// Defaults: admin@fyp.com / admin12345
const mongoose = require("mongoose");
const crypto = require("crypto-js");
const { MONGO_URL, SECRET } = require("./config/index");
const User = require("./models/user");

const email = process.argv[2] || "admin@fyp.com";
const password = process.argv[3] || "admin12345";

if (password.length < 8) {
  console.error("Password must be at least 8 characters long");
  process.exit(1);
}

async function seedAdmin() {
  await mongoose.connect(MONGO_URL);

  const encryptedPassword = crypto.AES.encrypt(password, SECRET).toString();

  const admin = await User.findOneAndUpdate(
    { email },
    {
      username: "Super Admin",
      email,
      password: encryptedPassword,
      userType: "Admin",
      verification: true,
      phoneVerification: true,
      otp: "none",
    },
    { new: true, upsert: true, setDefaultsOnInsert: true }
  );

  console.log("Super Admin ready:");
  console.log(`  email:    ${admin.email}`);
  console.log(`  password: ${password}`);
  console.log(`  userType: ${admin.userType}`);

  await mongoose.disconnect();
}

seedAdmin().catch((err) => {
  console.error("Failed to seed admin:", err.message);
  process.exit(1);
});
