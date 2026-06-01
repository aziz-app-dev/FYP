const mongoose = require("mongoose");
const bcrypt = require("crypto-js");
const { MONGO_URL, SECRET } = require("./config/index");

const Category = require("./models/category");
const Restaurantes = require("./models/restaurant");
const Food = require("./models/food");
const User = require("./models/user");
const Address = require("./models/address");
const Cart = require("./models/cart");
const Settings = require("./models/settings");

const categories = [
  {
    title: "Pizza",
    value: "pizza",
    imageUrl: "https://cdn-icons-png.flaticon.com/512/3132/3132693.png",
  },
  {
    title: "Burger",
    value: "burger",
    imageUrl: "https://cdn-icons-png.flaticon.com/512/877/877951.png",
  },
  {
    title: "Sushi",
    value: "sushi",
    imageUrl: "https://cdn-icons-png.flaticon.com/512/2252/2252075.png",
  },
  {
    title: "Pasta",
    value: "pasta",
    imageUrl: "https://cdn-icons-png.flaticon.com/512/2515/2515263.png",
  },
  {
    title: "Desserts",
    value: "desserts",
    imageUrl: "https://cdn-icons-png.flaticon.com/512/2413/2413447.png",
  },
  {
    title: "Drinks",
    value: "drinks",
    imageUrl: "https://cdn-icons-png.flaticon.com/512/2405/2405479.png",
  },
  {
    title: "BBQ",
    value: "bbq",
    imageUrl: "https://cdn-icons-png.flaticon.com/512/1046/1046751.png",
  },
  {
    title: "More",
    value: "more",
    imageUrl: "https://cdn-icons-png.flaticon.com/512/512/512142.png",
  },
];

const restaurants = [
  {
    title: "Pizza Palace",
    time: "30 min",
    imageUrl:
      "https://images.unsplash.com/photo-1513104890138-7c749659a591?w=800",
    logoUrl:
      "https://images.unsplash.com/photo-1513104890138-7c749659a591?w=200",
    owner: "owner1",
    code: "lahr",
    rating: 4.5,
    ratingCount: "230",
    isAvailable: true,
    verification: "Verified",
    coords: {
      id: "1",
      latitude: 31.5204,
      longitude: 74.3587,
      latitudeDelta: 0.0221,
      longitudeDelta: 0.0221,
      address: "Main Boulevard, Gulberg, Lahore",
      title: "Pizza Palace Lahore",
    },
  },
  {
    title: "Burger Hub",
    time: "20 min",
    imageUrl:
      "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=800",
    logoUrl:
      "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=200",
    owner: "owner2",
    code: "lahr",
    rating: 4.2,
    ratingCount: "180",
    isAvailable: true,
    verification: "Verified",
    coords: {
      id: "2",
      latitude: 31.5497,
      longitude: 74.3436,
      latitudeDelta: 0.0221,
      longitudeDelta: 0.0221,
      address: "MM Alam Road, Lahore",
      title: "Burger Hub",
    },
  },
  {
    title: "Sushi World",
    time: "35 min",
    imageUrl:
      "https://images.unsplash.com/photo-1579871494447-9811cf80d66c?w=800",
    logoUrl:
      "https://images.unsplash.com/photo-1579871494447-9811cf80d66c?w=200",
    owner: "owner3",
    code: "lahr",
    rating: 4.8,
    ratingCount: "95",
    isAvailable: true,
    verification: "Verified",
    coords: {
      id: "3",
      latitude: 31.4826,
      longitude: 74.3293,
      latitudeDelta: 0.0221,
      longitudeDelta: 0.0221,
      address: "DHA Phase 5, Lahore",
      title: "Sushi World",
    },
  },
  {
    title: "Pasta House",
    time: "25 min",
    imageUrl:
      "https://images.unsplash.com/photo-1551183053-bf91a1d81141?w=800",
    logoUrl:
      "https://images.unsplash.com/photo-1551183053-bf91a1d81141?w=200",
    owner: "owner4",
    code: "lahr",
    rating: 4.3,
    ratingCount: "140",
    isAvailable: true,
    verification: "Verified",
    coords: {
      id: "4",
      latitude: 31.5656,
      longitude: 74.3142,
      latitudeDelta: 0.0221,
      longitudeDelta: 0.0221,
      address: "Model Town, Lahore",
      title: "Pasta House",
    },
  },
  {
    title: "Grill Master",
    time: "40 min",
    imageUrl:
      "https://images.unsplash.com/photo-1544025162-d76694265947?w=800",
    logoUrl:
      "https://images.unsplash.com/photo-1544025162-d76694265947?w=200",
    owner: "owner5",
    code: "lahr",
    rating: 4.6,
    ratingCount: "210",
    isAvailable: true,
    verification: "Verified",
    coords: {
      id: "5",
      latitude: 31.5383,
      longitude: 74.3647,
      latitudeDelta: 0.0221,
      longitudeDelta: 0.0221,
      address: "Johar Town, Lahore",
      title: "Grill Master",
    },
  },
];

const buildFoods = (restaurantIds) => [
  {
    title: "Margherita Pizza",
    time: "20 min",
    description:
      "Classic pizza with fresh tomatoes, mozzarella cheese, and basil leaves.",
    foodTags: ["pizza", "cheese", "italian"],
    foodType: ["veg"],
    category: "pizza",
    code: "123456",
    isAvailable: true,
    restaurant: restaurantIds[0],
    rating: 4.5,
    ratingCount: "120",
    price: 899,
    additives: [
      { id: 1, title: "Extra Cheese", price: "100" },
      { id: 2, title: "Olives", price: "50" },
    ],
    imageUrl: [
      "https://images.unsplash.com/photo-1604068549290-dea0e4a305ca?w=800",
    ],
  },
  {
    title: "Cheeseburger",
    time: "15 min",
    description: "Juicy beef patty with melted cheese, lettuce, and tomato.",
    foodTags: ["burger", "beef", "cheese"],
    foodType: ["non-veg"],
    category: "burger",
    code: "123456",
    isAvailable: true,
    restaurant: restaurantIds[1],
    rating: 4.3,
    ratingCount: "85",
    price: 650,
    additives: [
      { id: 1, title: "Bacon", price: "120" },
      { id: 2, title: "Extra Patty", price: "200" },
    ],
    imageUrl: [
      "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=800",
    ],
  },
  {
    title: "Salmon Sushi Roll",
    time: "25 min",
    description: "Fresh salmon rolls with avocado and cucumber.",
    foodTags: ["sushi", "salmon", "japanese"],
    foodType: ["non-veg"],
    category: "sushi",
    code: "123456",
    isAvailable: true,
    restaurant: restaurantIds[2],
    rating: 4.8,
    ratingCount: "60",
    price: 1200,
    additives: [
      { id: 1, title: "Wasabi", price: "30" },
      { id: 2, title: "Soy Sauce", price: "20" },
    ],
    imageUrl: [
      "https://images.unsplash.com/photo-1579871494447-9811cf80d66c?w=800",
    ],
  },
  {
    title: "Creamy Alfredo Pasta",
    time: "20 min",
    description: "Fettuccine pasta in creamy white sauce with grilled chicken.",
    foodTags: ["pasta", "italian", "creamy"],
    foodType: ["non-veg"],
    category: "pasta",
    code: "123456",
    isAvailable: true,
    restaurant: restaurantIds[3],
    rating: 4.4,
    ratingCount: "90",
    price: 850,
    additives: [
      { id: 1, title: "Extra Chicken", price: "150" },
      { id: 2, title: "Parmesan", price: "80" },
    ],
    imageUrl: [
      "https://images.unsplash.com/photo-1551183053-bf91a1d81141?w=800",
    ],
  },
  {
    title: "BBQ Beef Ribs",
    time: "35 min",
    description: "Tender beef ribs slow-cooked in smoky BBQ sauce.",
    foodTags: ["bbq", "beef", "grilled"],
    foodType: ["non-veg"],
    category: "bbq",
    code: "123456",
    isAvailable: true,
    restaurant: restaurantIds[4],
    rating: 4.7,
    ratingCount: "110",
    price: 1500,
    additives: [
      { id: 1, title: "Extra Sauce", price: "50" },
      { id: 2, title: "Coleslaw", price: "100" },
    ],
    imageUrl: [
      "https://images.unsplash.com/photo-1544025162-d76694265947?w=800",
    ],
  },
  {
    title: "Pepperoni Pizza",
    time: "20 min",
    description: "Loaded with pepperoni slices and mozzarella cheese.",
    foodTags: ["pizza", "pepperoni"],
    foodType: ["non-veg"],
    category: "pizza",
    code: "123456",
    isAvailable: true,
    restaurant: restaurantIds[0],
    rating: 4.6,
    ratingCount: "150",
    price: 1099,
    additives: [
      { id: 1, title: "Extra Cheese", price: "100" },
      { id: 2, title: "Jalapeños", price: "60" },
    ],
    imageUrl: [
      "https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=800",
    ],
  },
  {
    title: "Chocolate Lava Cake",
    time: "10 min",
    description: "Warm chocolate cake with a molten chocolate center.",
    foodTags: ["dessert", "chocolate"],
    foodType: ["veg"],
    category: "desserts",
    code: "123456",
    isAvailable: true,
    restaurant: restaurantIds[3],
    rating: 4.9,
    ratingCount: "75",
    price: 450,
    additives: [
      { id: 1, title: "Vanilla Ice Cream", price: "100" },
    ],
    imageUrl: [
      "https://images.unsplash.com/photo-1624353365286-3f8d62daad51?w=800",
    ],
  },
];

async function seed() {
  try {
    await mongoose.connect(MONGO_URL);
    console.log("Connected to:", mongoose.connection.host, "/", mongoose.connection.name);

    // Clear existing data
    console.log("Clearing existing data...");
    await Category.deleteMany({});
    await Restaurantes.deleteMany({});
    await Food.deleteMany({});
    await User.deleteMany({});
    await Address.deleteMany({});
    await Cart.deleteMany({});
    await Settings.deleteMany({});

    // Seed categories
    console.log("Seeding categories...");
    await Category.insertMany(categories);

    // Seed restaurants
    console.log("Seeding restaurants...");
    const insertedRestaurants = await Restaurantes.insertMany(restaurants);
    const restaurantIds = insertedRestaurants.map((r) => r._id);

    // Seed foods
    console.log("Seeding foods...");
    const foods = buildFoods(restaurantIds);
    await Food.insertMany(foods);

    // Seed a test user (password: 'password123')
    console.log("Seeding test user...");
    const hashedPassword = bcrypt.AES.encrypt("password123", SECRET).toString();
    const testUser = await User.create({
      username: "testuser",
      email: "test@test.com",
      password: hashedPassword,
      phone: "03001234567",
      phoneVerification: true,
      verification: true,
      userType: "Client",
    });

    // Seed default address for test user
    console.log("Seeding default address...");
    await Address.create({
      userId: testUser._id.toString(),
      addressLine1: "House 123, Street 4",
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

    // Seed settings (multi-vendor mode)
    console.log("Seeding settings...");
    await Settings.create({
      serviceMode: "multi-vendor",
      appName: "FYP Food Delivery",
      currency: "PKR",
      currencySymbol: "Rs",
      deliveryFee: 50,
    });

    console.log("\n✅ Seed complete!");
    console.log(`   Categories: ${categories.length}`);
    console.log(`   Restaurants: ${restaurants.length}`);
    console.log(`   Foods: ${foods.length}`);
    console.log(`   Test user email: test@test.com`);
    console.log(`   Test user password: password123`);

    await mongoose.disconnect();
    process.exit(0);
  } catch (error) {
    console.error("❌ Seed failed:", error);
    process.exit(1);
  }
}

seed();
