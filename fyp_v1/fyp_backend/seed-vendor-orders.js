/**
 * Seed varied orders for a specific vendor restaurant so the vendor
 * dashboard has real data to show: status tabs, sales chart, KPIs,
 * and end-to-end status-change testing.
 *
 * Usage:
 *   cd fyp_backend
 *   node seed-vendor-orders.js
 */
const mongoose = require("mongoose");
const bcrypt = require("crypto-js");
const { MONGO_URL, SECRET } = require("./config/index");

const Order = require("./models/order");
const Food = require("./models/food");
const Restaurantes = require("./models/restaurant");
const User = require("./models/user");
const Address = require("./models/address");

// The target restaurant + owner from the user's message.
const RESTAURANT_ID = "69e6707c36d05de27f98c6ed";
const OWNER_ID = "69de6d12a1629ead9e1fa241";

async function seed() {
  try {
    await mongoose.connect(MONGO_URL);
    console.log("Connected to:", mongoose.connection.host, "/", mongoose.connection.name);

    // 1. Confirm the restaurant exists
    const restaurant = await Restaurantes.findById(RESTAURANT_ID);
    if (!restaurant) {
      console.error(`❌ Restaurant ${RESTAURANT_ID} not found.`);
      process.exit(1);
    }
    console.log(`✅ Restaurant found: ${restaurant.title}`);

    // 2. Make sure there are at least 3 foods under this restaurant.
    let foods = await Food.find({ restaurant: RESTAURANT_ID });
    if (foods.length === 0) {
      console.log("Seeding sample foods under this restaurant…");
      const inserted = await Food.insertMany([
        {
          title: "Signature Burger",
          time: "20 min",
          description: "House special beef burger with caramelized onions.",
          foodTags: ["burger", "beef"],
          foodType: ["non-veg"],
          category: "burger",
          code: restaurant.code || "lahr",
          isAvailable: true,
          restaurant: RESTAURANT_ID,
          rating: 4.5,
          ratingCount: "42",
          price: 750,
          additives: [{ id: 1, title: "Extra cheese", price: "100" }],
          imageUrl: [
            "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=800",
          ],
        },
        {
          title: "Stone-fired Pizza",
          time: "25 min",
          description: "12-inch pizza with fresh basil and mozzarella.",
          foodTags: ["pizza", "italian"],
          foodType: ["veg"],
          category: "pizza",
          code: restaurant.code || "lahr",
          isAvailable: true,
          restaurant: RESTAURANT_ID,
          rating: 4.6,
          ratingCount: "98",
          price: 1200,
          additives: [{ id: 1, title: "Olives", price: "60" }],
          imageUrl: [
            "https://images.unsplash.com/photo-1604068549290-dea0e4a305ca?w=800",
          ],
        },
        {
          title: "Chicken Tikka Platter",
          time: "30 min",
          description: "Grilled chicken tikka with naan and raita.",
          foodTags: ["bbq", "chicken"],
          foodType: ["non-veg"],
          category: "bbq",
          code: restaurant.code || "lahr",
          isAvailable: true,
          restaurant: RESTAURANT_ID,
          rating: 4.8,
          ratingCount: "210",
          price: 1450,
          additives: [{ id: 1, title: "Extra naan", price: "80" }],
          imageUrl: [
            "https://images.unsplash.com/photo-1544025162-d76694265947?w=800",
          ],
        },
      ]);
      foods = inserted;
      console.log(`   Inserted ${foods.length} foods.`);
    } else {
      console.log(`✅ Found ${foods.length} existing foods.`);
    }

    // 3. Make sure we have a customer to attribute orders to.
    let customer = await User.findOne({ email: "customer@test.com" });
    if (!customer) {
      console.log("Creating test customer…");
      customer = await User.create({
        username: "customer",
        email: "customer@test.com",
        password: bcrypt.AES.encrypt("password123", SECRET).toString(),
        phone: "03331112222",
        phoneVerification: true,
        verification: true,
        userType: "Client",
      });
    }

    // 4. Ensure the customer has an address (required by order schema).
    let address = await Address.findOne({ userId: customer._id.toString() });
    if (!address) {
      address = await Address.create({
        userId: customer._id.toString(),
        addressLine1: "House 45, Street 9",
        postalCode: "54000",
        city: "Lahore",
        district: "Lahore",
        province: "Punjab",
        country: "Pakistan",
        latitude: 31.5204,
        longitude: 74.3587,
        instruction: "Leave at door",
        default: true,
      });
    }

    // 5. Clear any previous seeded orders for this restaurant (clean slate).
    const deletedOrders = await Order.deleteMany({
      restaurantId: RESTAURANT_ID,
    });
    console.log(`Cleared ${deletedOrders.deletedCount} existing orders.`);

    // 6. Build varied orders with mixed statuses + dates across last 7 days.
    const now = new Date();
    const makeOrder = ({
      foodIdx,
      qty,
      status,
      daysAgo,
      paymentStatus = "Pending",
    }) => {
      const food = foods[foodIdx % foods.length];
      const itemTotal = food.price * qty;
      const deliveryFee = 80;
      const created = new Date(now.getTime() - daysAgo * 24 * 60 * 60 * 1000);
      return {
        userId: customer._id,
        orderItems: [
          {
            foodId: food._id,
            quantity: qty,
            price: itemTotal,
            additives: ["Extra cheese"],
            instruction: "Make it spicy",
          },
        ],
        orderTotal: itemTotal,
        deliveryFee,
        grandTotal: itemTotal + deliveryFee,
        deliveryAddress: address._id,
        restaurantAddress:
          restaurant.coords?.address || "Restaurant address",
        restaurantCoords: [
          restaurant.coords?.latitude || 31.52,
          restaurant.coords?.longitude || 74.35,
        ],
        recipientCoords: [address.latitude, address.longitude],
        paymentMethod: "Cash",
        paymentStatus,
        orderStatus: status,
        restaurantId: RESTAURANT_ID,
        rating: 4,
        createdAt: created,
        orderDate: created,
      };
    };

    // A mix: some in every vendor-tab so the dashboard is populated.
    // Spread across the last 7 days for the bar chart.
    const orders = [
      // New Orders tab → Pending
      makeOrder({ foodIdx: 0, qty: 2, status: "Pending", daysAgo: 0 }),
      makeOrder({ foodIdx: 1, qty: 1, status: "Pending", daysAgo: 0 }),

      // Preparing
      makeOrder({ foodIdx: 2, qty: 3, status: "Preparing", daysAgo: 0 }),

      // Ready
      makeOrder({ foodIdx: 0, qty: 1, status: "Ready", daysAgo: 0 }),

      // Out For Delivery (Picked Up tab)
      makeOrder({ foodIdx: 1, qty: 2, status: "Out For Delivery", daysAgo: 1 }),

      // Delivering (Self-Deliveries tab)
      makeOrder({ foodIdx: 2, qty: 1, status: "Delivering", daysAgo: 1 }),

      // Delivered — spread across the week to make the bar chart interesting
      makeOrder({
        foodIdx: 0,
        qty: 2,
        status: "Delivered",
        daysAgo: 0,
        paymentStatus: "Completed",
      }),
      makeOrder({
        foodIdx: 1,
        qty: 1,
        status: "Delivered",
        daysAgo: 1,
        paymentStatus: "Completed",
      }),
      makeOrder({
        foodIdx: 2,
        qty: 1,
        status: "Delivered",
        daysAgo: 2,
        paymentStatus: "Completed",
      }),
      makeOrder({
        foodIdx: 0,
        qty: 3,
        status: "Delivered",
        daysAgo: 3,
        paymentStatus: "Completed",
      }),
      makeOrder({
        foodIdx: 1,
        qty: 2,
        status: "Delivered",
        daysAgo: 4,
        paymentStatus: "Completed",
      }),
      makeOrder({
        foodIdx: 2,
        qty: 1,
        status: "Delivered",
        daysAgo: 5,
        paymentStatus: "Completed",
      }),
      makeOrder({
        foodIdx: 0,
        qty: 2,
        status: "Delivered",
        daysAgo: 6,
        paymentStatus: "Completed",
      }),

      // Cancelled
      makeOrder({ foodIdx: 1, qty: 1, status: "Cancelled", daysAgo: 2 }),
      makeOrder({ foodIdx: 2, qty: 1, status: "Cancelled", daysAgo: 4 }),
    ];

    // insertMany respects createdAt when {timestamps: true} only if we
    // pass the raw _id override — for simple cases Mongoose will still
    // use the provided createdAt field if we pass {rawResult: false, ordered: true}.
    // Easier: insert one-by-one so createdAt sticks.
    for (const o of orders) {
      const doc = new Order(o);
      doc.set("createdAt", o.createdAt);
      await doc.save({ validateBeforeSave: true });
    }

    // Fix createdAt explicitly (Mongoose overwrites on save):
    for (const o of orders) {
      await Order.updateOne(
        {
          restaurantId: RESTAURANT_ID,
          orderStatus: o.orderStatus,
          grandTotal: o.grandTotal,
          createdAt: { $gte: new Date(Date.now() - 60 * 1000) }, // just saved
        },
        { $set: { createdAt: o.createdAt, updatedAt: o.createdAt } }
      );
    }

    console.log(`\n✅ Seeded ${orders.length} orders for restaurant ${restaurant.title}`);
    console.log(`   Mix: 2 Pending · 1 Preparing · 1 Ready · 1 Out For Delivery`);
    console.log(`        1 Delivering · 7 Delivered (across last 7 days) · 2 Cancelled`);
    console.log(`   Customer: customer@test.com / password123`);
    await mongoose.disconnect();
    process.exit(0);
  } catch (err) {
    console.error("❌ Seed failed:", err);
    process.exit(1);
  }
}

seed();
