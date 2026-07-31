const express = require("express");
const { PORT } = require("./config/index");
const dbConnect = require("./database/index");
const bodyParser = require("body-parser");
// const admin = require("firebase-admin");
// const serviceAccount = require("./flp-htb-firebase-adminsdk-xa2ep-054874fe85.json");
const authRouter = require("./routes/auth_route");
const userRouter = require("./routes/user_route");
const restaurantRouter = require("./routes/restaurant_route");
const categoryRouter = require("./routes/category_route");
const foodRouter = require("./routes/food_route");
const cartRouter = require("./routes/cart_route");
const addressRouter = require("./routes/address_route");
const ratingRouter = require("./routes/rating_router");
const orderRouter = require("./routes/order_route");
const foodSearchRouter = require("./routes/food_search_route");
const settingsRouter = require("./routes/settings_route");
const homeRouter = require("./routes/home_route");

// const generateOtp =require("./utils/utls")
// const sendEmail =require("./utils/smtp_function")


const app = express();

dbConnect();
// admin.initializeApp({
//   credential: admin.credential.cert(serviceAccount),
// });

// const otp= generateOtp();
// sendEmail('abdulrehmang220@gmail.com', otp);

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
// CORS — lets the Flutter web builds (admin dashboard) call the API
app.use((req, res, next) => {
  res.header("Access-Control-Allow-Origin", "*");
  res.header(
    "Access-Control-Allow-Headers",
    "Origin, X-Requested-With, Content-Type, Accept, Authorization"
  );
  res.header(
    "Access-Control-Allow-Methods",
    "GET, POST, PUT, PATCH, DELETE, OPTIONS"
  );
  if (req.method === "OPTIONS") return res.sendStatus(204);
  next();
});
app.use("/", authRouter);
app.use("/api/user/", userRouter);
app.use("/api/restaurant/", restaurantRouter);
app.use("/api/category/", categoryRouter);
app.use("/api/foods/", foodRouter);
app.use("/api/cart/", cartRouter);
app.use("/api/address/", addressRouter);
app.use("/api/rating/", ratingRouter);
app.use("/api/foodSearch/", foodSearchRouter);
app.use("/api/order/", orderRouter);
app.use("/api/settings/", settingsRouter);
app.use("/api/home/", homeRouter);

app.get("/", (req, res) => res.send("Hello->Aziz"));
app.listen(PORT || 3000, () =>
  console.log(`Example app listening on port: ${PORT}!`)
);
