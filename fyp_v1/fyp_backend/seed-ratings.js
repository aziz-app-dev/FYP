/**
 * Seed sample restaurant ratings + reviews so the vendor's Ratings
 * Details page has content to display.
 *
 * Usage:  cd fyp_backend && node seed-ratings.js
 */
const mongoose = require("mongoose");
const { MONGO_URL } = require("./config/index");

const Rating = require("./models/rating");
const Restaurantes = require("./models/restaurant");

const RESTAURANT_ID = "69e6707c36d05de27f98c6ed";

async function seed() {
  try {
    await mongoose.connect(MONGO_URL);
    console.log("Connected to:", mongoose.connection.name);

    const restaurant = await Restaurantes.findById(RESTAURANT_ID);
    if (!restaurant) {
      console.error(`❌ Restaurant ${RESTAURANT_ID} not found.`);
      process.exit(1);
    }

    await Rating.deleteMany({ product: RESTAURANT_ID, ratingType: "Restaurant" });

    const now = Date.now();
    const daysAgo = (n) => new Date(now - n * 24 * 60 * 60 * 1000);

    const sample = [
      {
        userId: "user_01",
        username: "Ahmed Khan",
        userPhoto:
          "https://randomuser.me/api/portraits/men/32.jpg",
        rating: 5,
        comment:
          "This food was so tasty and delicious. Breakfast was fast. Delivered in my place. Chef is very friendly. I'll really like this chef for home food orders. Thanks!",
        createdAt: daysAgo(1),
      },
      {
        userId: "user_02",
        username: "Sara Ali",
        userPhoto: "https://randomuser.me/api/portraits/women/44.jpg",
        rating: 4,
        comment:
          "Overall great experience, food arrived warm and packaging was neat.",
        createdAt: daysAgo(3),
      },
      {
        userId: "user_03",
        username: "Usman Tariq",
        userPhoto: "https://randomuser.me/api/portraits/men/21.jpg",
        rating: 5,
        comment: "Best burger I've had all month. Will order again!",
        createdAt: daysAgo(5),
      },
      {
        userId: "user_04",
        username: "Ayesha Noor",
        userPhoto: "https://randomuser.me/api/portraits/women/65.jpg",
        rating: 4,
        comment: "Tasty food but delivery was a bit slow.",
        createdAt: daysAgo(7),
      },
      {
        userId: "user_05",
        username: "Bilal Shah",
        userPhoto: "https://randomuser.me/api/portraits/men/12.jpg",
        rating: 5,
        comment: "Chef is very professional. Excellent service.",
        createdAt: daysAgo(10),
      },
      {
        userId: "user_06",
        username: "Maira Hussain",
        userPhoto: "https://randomuser.me/api/portraits/women/22.jpg",
        rating: 3,
        comment: "Food was okay, nothing special.",
        createdAt: daysAgo(14),
      },
      {
        userId: "user_07",
        username: "Daniyal",
        userPhoto: "",
        rating: 5,
        comment: "Quick and delicious!",
        createdAt: daysAgo(18),
      },
      {
        userId: "user_08",
        username: "Hina Javed",
        userPhoto: "https://randomuser.me/api/portraits/women/5.jpg",
        rating: 2,
        comment: "Order was cold when it arrived.",
        createdAt: daysAgo(22),
      },
    ];

    for (const s of sample) {
      const doc = new Rating({
        userId: s.userId,
        username: s.username,
        userPhoto: s.userPhoto,
        ratingType: "Restaurant",
        product: RESTAURANT_ID,
        rating: s.rating,
        comment: s.comment,
      });
      doc.set("createdAt", s.createdAt);
      await doc.save();
      await Rating.updateOne(
        { _id: doc._id },
        { $set: { createdAt: s.createdAt, updatedAt: s.createdAt } }
      );
    }

    // Push the running average onto the restaurant doc too.
    const avg =
      sample.reduce((a, b) => a + b.rating, 0) / sample.length;
    await Restaurantes.findByIdAndUpdate(RESTAURANT_ID, { rating: avg });

    console.log(
      `\n✅ Seeded ${sample.length} ratings for ${restaurant.title} (avg ${avg.toFixed(2)})`
    );
    await mongoose.disconnect();
    process.exit(0);
  } catch (err) {
    console.error("❌ Seed failed:", err);
    process.exit(1);
  }
}

seed();
